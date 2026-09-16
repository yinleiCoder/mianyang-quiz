// 用户头像：有图显示图，没有（或加载失败）用姓名首字占位。
//
// 职责：把档案里的头像渲染成圆形头像，并**把所有异常情况都收口到首字占位**——
// 没填过头像、key 拼不出地址、图片 404、网络断了，用户看到的都应该是那个字，
// 而不是一个空洞或破图（头像加载失败不该像页面坏了）。
// 不负责：选图与上传（编辑页的 AvatarPickerField 管）、尺寸以外的样式。
//
// 放在 ui/core 而不是某个 feature 下：个人档案页与题库的署名 chip 都要用，
// 跨 feature 复用必须上提（AGENTS.md 分层）。参数只有数据，没有 store/session。

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.initial,
    this.avatarUrl,
    this.size = 64,
  });

  /// 姓名首字（`Profile.initial`）。
  final String initial;

  /// 档案里的头像 key 或完整 URL；null/空 都按「没有头像」处理。
  final String? avatarUrl;

  /// 直径。圆角与图标大小都由它派生，所以只需要改这一个数。
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = OssUrl.avatar(avatarUrl);
    final fallback = Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.44.sp,
          fontWeight: FontWeight.w700,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );

    return ClipOval(
      child: SizedBox(
        width: size.r,
        height: size.r,
        child: ColoredBox(
          color: scheme.primaryContainer,
          child: url.isEmpty
              ? fallback
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => fallback,
                  errorWidget: (context, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}
