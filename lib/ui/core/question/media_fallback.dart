// 媒体块的降级占位：地址合成不出来、或图片加载失败时显示的那一条。
//
// 从 block_media_view.dart 拆出来，是因为它有两个使用方——分发器（地址无效）
// 与图片视图（加载失败）。放在同一文件里时它是私有的，拆开后必须公开。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';

class MediaFallback extends StatelessWidget {
  /// [block] 为 null 表示失败发生在加载阶段（那时只剩 reason 可讲）。
  const MediaFallback({super.key, required this.block, required this.reason});

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
          Icon(
            Icons.image_not_supported_outlined,
            size: 20.r,
            color: theme.colorScheme.onSurfaceVariant,
          ),
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
