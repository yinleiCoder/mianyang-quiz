// 单个媒体块的渲染。
//
// 四类（对应 content 里的 kind）：
//   image  内联显示，可点开缩放（题干里的示意图很常见，必须内联）
//   audio / video / file  不做内嵌播放器，改为"可打开的条目标"交给系统程序
//
// 为什么不内嵌音视频播放器：本项目的目标平台包含 Windows，而
// video_player / just_audio 官方都不支持 Windows，唯一跨端方案 media_kit 体量不小。
// 题库当前也没有含媒体的题目——真需要时再引入，现在不预支复杂度。
//
// 地址合成统一走 OssUrl（与网页端 lib/oss-url.js 同规则）。

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockMediaView extends StatelessWidget {
  const BlockMediaView({super.key, required this.block, this.compact = false});

  final MediaBlock block;

  /// 紧凑模式：用在选项等空间受限处（图片限高更小）。
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final url = OssUrl.of(block.key.isNotEmpty ? block.key : block.url);

    // 地址合成不出来（配置缺失或 key 为空）时给出可读提示，而不是 broken image
    if (url.isEmpty) {
      return _MediaFallback(block: block, reason: '媒体地址无效');
    }

    return switch (block.kind) {
      'image' => _InlineImage(url: url, compact: compact),
      _ => _ExternalMediaRow(block: block, url: url),
    };
  }
}

class _InlineImage extends StatelessWidget {
  const _InlineImage({required this.url, required this.compact});

  final String url;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final maxHeight = compact ? 120.0 : 240.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapSm),
      child: GestureDetector(
        // 题干里的示意图常常有细节，点开全屏看
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => Dialog(
            insetPadding: const EdgeInsets.all(AppMetrics.gapXl),
            child: InteractiveViewer(
              child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
            ),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight.r),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, _) => SizedBox(
              height: 80.r,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, _, _) => const _MediaFallback(
              block: null,
              reason: '图片加载失败',
            ),
          ),
        ),
      ),
    );
  }
}

/// 音视频与附件：显示成一条可点击的条目，交给系统默认程序打开。
class _ExternalMediaRow extends StatelessWidget {
  const _ExternalMediaRow({required this.block, required this.url});

  final MediaBlock block;
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
          onTap: () async {
            final uri = Uri.tryParse(url);
            if (uri == null) return;
            final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (!ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('无法打开，请检查系统是否有可用的默认程序')),
              );
            }
          },
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
}

class _MediaFallback extends StatelessWidget {
  const _MediaFallback({required this.block, required this.reason});

  final MediaBlock? block;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alt = block?.alt;
    return Container(
      padding: const EdgeInsets.all(AppMetrics.gapMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
      ),
      child: Row(
        children: [
          Icon(Icons.image_not_supported_outlined,
              size: 20.r, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppMetrics.gapSm),
          Expanded(
            child: Text(
              alt?.isNotEmpty == true ? '$reason（$alt）' : reason,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
