// 头像选择与直传。
//
// 职责：选图 → 校验格式 → 直传 OSS → 把新的对象 key 交给页面；上传中的转圈与
// 失败文案都在这里收口（页面只决定怎么提示）。
// 不负责：写档案（update_own_profile 由页面在点保存时调）。
//
// 为什么选完就传、而不是点保存时才传：上传要几秒，塞进保存会让用户卡在
// 「点了保存却不知道在等什么」里；失败时也只需重选一张图，不必重填整张表单。
// 代价是用户中途放弃会在 OSS 留下一个没人引用的对象——它没有入库，
// 不会被任何页面显示，比让用户重填表单划算。

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/services/oss_upload_service.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:provider/provider.dart';

/// 上传成功的结果：key 是要写进档案的值，path 是本地文件（好立刻预览）。
typedef AvatarUpload = ({String key, String path});

class AvatarPickerField extends StatefulWidget {
  const AvatarPickerField({
    super.key,
    required this.initial,
    required this.onUploaded,
    this.avatarUrl,
    this.localPath,
    this.onError,
  });

  /// 姓名首字，没有头像时占位。
  final String initial;

  /// 档案里当前的头像（key 或完整 URL）。
  final String? avatarUrl;

  /// 刚选中的本地文件路径，优先于 [avatarUrl] 显示。
  final String? localPath;

  final ValueChanged<AvatarUpload> onUploaded;

  /// 失败文案（格式不对、上传失败）；页面决定用 SnackBar 还是别的方式提示。
  final ValueChanged<String>? onError;

  @override
  State<AvatarPickerField> createState() => _AvatarPickerFieldState();
}

class _AvatarPickerFieldState extends State<AvatarPickerField> {
  bool _uploading = false;

  Future<void> _pick() async {
    if (_uploading) return;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // 只限制长边与质量：头像最大也就是个方形缩略图，原图直传是浪费。
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 90,
    );
    if (picked == null) return; // 用户取消，不是错误
    if (!mounted) return;

    // 服务端只收这三种 MIME，传别的会在签名那一步被拒——先在端上挡一道。
    final contentType = _contentTypeOf(picked.path);
    if (contentType == null) {
      widget.onError?.call('只支持 PNG / JPG / WebP 图片');
      return;
    }

    setState(() => _uploading = true);
    try {
      final key = await context.read<OssUploadService>().uploadAvatar(
        filePath: picked.path,
        contentType: contentType,
      );
      if (!mounted) return;
      widget.onUploaded((key: key, path: picked.path));
    } on AppException catch (error) {
      if (!mounted) return;
      widget.onError?.call(error.message);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = OssUrl.avatar(widget.avatarUrl);
    final localPath = widget.localPath;
    final fallback = Center(
      child: Text(
        widget.initial,
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );

    final image = localPath != null
        // 本地预览必须限制解码尺寸。选图时 picker 允许到 1024×1024，
        // 不限制的话这张位图会按原尺寸进内存/显存，而这个框只有 72 逻辑像素 ——
        // 一张 4MB 的图解码出来几百 KB 到几 MB，只为显示一个头像。
        // 按设备的实际像素密度算，高分屏也不会糊。
        ? Image.file(
            File(localPath),
            fit: BoxFit.cover,
            cacheWidth: (72 * MediaQuery.devicePixelRatioOf(context)).round(),
          )
        : url.isEmpty
        ? fallback
        : CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, _) => fallback,
            errorWidget: (context, _, _) => fallback,
          );

    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 72.r,
            height: 72.r,
            child: ColoredBox(color: scheme.primaryContainer, child: image),
          ),
        ),
        SizedBox(width: AppMetrics.gapLg.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DuoButton(
                label: _uploading ? '上传中…' : '更换头像',
                icon: Icons.photo_camera_outlined,
                variant: DuoButtonVariant.outline,
                compact: true,
                expand: false,
                loading: _uploading,
                // loading 时 DuoButton 自己不响应点击，这里不必把 onPressed 置空——
                // 置空会连配色一起变成禁用态，看起来像"坏了"。
                onPressed: _pick,
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(
                'PNG / JPG / WebP，不超过 5 MB',
                style: AppTextStyles.caption(context)
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 扩展名 → MIME。取不到认识的扩展名时返回 null（调用方提示只支持三种格式）。
String? _contentTypeOf(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0) return null;
  return switch (path.substring(dot + 1).toLowerCase()) {
    'png' => 'image/png',
    'jpg' || 'jpeg' => 'image/jpeg',
    'webp' => 'image/webp',
    _ => null,
  };
}
