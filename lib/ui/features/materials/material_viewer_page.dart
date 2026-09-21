// 看一份复习资料：PDF 内嵌阅读、图片全屏、其余交给系统程序。
//
// 三条出路（顶栏与正文里都有）：
//   · 保存到本地 —— Windows 写系统下载目录；Android 弹系统分享面板（学生选"保存到文件"）。
//     只有这一个动作会 +1 下载次数（用户要的是"下载次数"，不是浏览数）。
//   · 分享 —— 分享的是文件本体（已下载过就带上文件，否则给 OSS 链接）。
//   · 用其他程序打开 —— Office / 音视频走这条，**给的是 https 链接而不是本地文件路径**：
//     Android 上把 file:// 交给别的应用会直接抛 FileUriExposedException，
//     而 https 链接由系统浏览器接住、再交给 WPS/播放器，这条路在两端都通
//    （题库里的附件就是这么打开的，见 ui/core/question/external_media_row.dart）。
//
// 为什么不把所有格式都塞进 WebView：Android 的系统 WebView **没有内置 PDF 阅读器**，
// 拿它开 PDF 只会白屏；Office 与音视频在 Flutter 上更没有可靠的跨端渲染方案。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/data/repositories/material_repository.dart';
import 'package:mianyang_quiz/data/services/material_download_service.dart';
import 'package:mianyang_quiz/ui/features/materials/widgets/material_external_body.dart';
import 'package:mianyang_quiz/ui/features/materials/widgets/material_inline_body.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialViewerPage extends StatefulWidget {
  const MaterialViewerPage({super.key, required this.material});

  final MaterialBrief material;

  @override
  State<MaterialViewerPage> createState() => _MaterialViewerPageState();
}

class _MaterialViewerPageState extends State<MaterialViewerPage> {
  bool _busy = false;

  MaterialBrief get _material => widget.material;

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 保存到本地。成功之后才计一次下载——计数是"这份资料被拿走了几次"的凭据，
  /// 老师看的就是这个数字（用户原话：以此尊重教师的付出）。
  Future<void> _save() async {
    // 先取好依赖再 await：跨 await 用 context.read 会被 lint 拦（而且页面可能已经没了）
    final downloads = context.read<MaterialDownloadService>();
    final repository = context.read<MaterialRepository>();

    setState(() => _busy = true);
    try {
      final outcome = await downloads.saveToDevice(_material);
      // 计数失败不打扰用户（仓储内部已经吞掉异常）
      unawaited(repository.countDownload(_material.id));
      if (!mounted) return;
      _snack(switch (outcome.target) {
        SaveTarget.downloadsFolder => '已保存到 ${outcome.path}',
        SaveTarget.shareSheet => '已下载。在分享面板里选「保存到文件」就能存进手机',
      });
    } catch (error) {
      if (mounted) _snack(mapError(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    try {
      await context.read<MaterialDownloadService>().shareLink(_material);
    } catch (error) {
      // 桌面端没有系统分享面板时会抛（与 share_question_sheet 同款兜底）
      if (mounted) _snack('这台设备没有可用的分享方式，可以改用「保存到本地」');
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.tryParse(_material.fileUrl);
    if (uri == null || uri.toString().isEmpty) {
      _snack('这份资料没有可用的地址');
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      _snack('无法打开，请检查系统里有没有能打开 ${_material.type.label} 的程序');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_material.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: _busy ? null : _share,
            tooltip: '分享',
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: _busy ? null : _save,
            tooltip: '保存到本地',
            icon: _busy
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_outlined),
          ),
        ],
      ),
      // 能内嵌的（PDF / 图片）与不能内嵌的（Office / 音视频）分成两块，
      // 各自在 widgets/ 里实现——本页只管动作（保存 / 分享 / 外部打开）与署名底栏。
      body: _material.type.opensInline
          ? MaterialInlineBody(material: _material)
          : MaterialExternalBody(
              material: _material,
              onOpen: _openExternally,
              onSave: _busy ? null : _save,
            ),
      bottomNavigationBar: _buildFooter(theme),
    );
  }

  /// 底栏：署名 + 下载次数。**这两项是刻意常驻的**（用户要求"标注上传人是谁、
  /// 所处的学校、下载次数，以此尊重教师的付出"），不折叠、不进二级页面。
  Widget _buildFooter(ThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.pagePadding,
          vertical: AppMetrics.gapSm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${_material.creatorName ?? '上传人已注销'}'
                '${_material.schoolName == null ? '' : ' · ${_material.schoolName}'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppMetrics.gapSm.r),
            Icon(
              Icons.download_outlined,
              size: 14.r,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 4.r),
            Text(
              '下载 ${_material.downloadCount} 次',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
