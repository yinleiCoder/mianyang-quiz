// 音视频与附件：显示成一条可点击的条目，交给系统默认程序打开。
//
// 为什么不内嵌播放器：本项目的目标平台包含 Windows，而 video_player / just_audio
// 官方都不支持 Windows，唯一跨端方案 media_kit 体量不小。
// 题库当前也没有含媒体的题目——真需要时再引入，现在不预支复杂度。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalMediaRow extends StatelessWidget {
  const ExternalMediaRow({super.key, required this.block, required this.url});

  final MediaBlock block;

  /// 已验证可用的展示地址（空值时分发器不会走到这里）。
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, label) = switch (block.kind) {
      'audio' => (Icons.headphones, '音频'),
      'video' => (Icons.movie_outlined, '视频'),
      _ => (Icons.attach_file, '附件'),
    };
    final name = block.alt?.isNotEmpty == true ? block.alt! : label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapXs),
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.gapMd,
              vertical: AppMetrics.gapSm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 20.r, color: theme.colorScheme.primary),
                const SizedBox(width: AppMetrics.gapSm),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 16.r,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    // await 之后 context 可能已经失效（用户切走了），必须先判 mounted
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开，请检查系统是否有可用的默认程序')),
      );
    }
  }
}
