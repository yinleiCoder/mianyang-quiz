// 统计卡：学情看板上「一个数字 + 一句说明」的小方块。
//
// 职责：把 label / value / caption / icon 排成固定版式，一屏多个统计卡才会互相对齐。
// 不负责：数据获取与聚合（数字由调用方算好并格式化）、也不负责点击跳转——
// 它刻意不是按钮，需要可点时请由外层的 DuoCard(onTap:) 承担。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';

class DuoStatTile extends StatelessWidget {
  const DuoStatTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.tone,
  });

  /// 指标名（如「累计答题」）。
  final String label;

  /// 指标值，已格式化好的字符串（如「1280」/「86%」）。
  final String value;

  /// 补充说明（如「较上周 +12」）。
  final String? caption;

  /// 右上角图标，可选。
  final IconData? icon;

  /// 图标语气，不传即品牌色。
  final DuoIconBadgeTone? tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final captionStyle = AppTextStyles.caption(context)
        .copyWith(color: scheme.onSurfaceVariant);

    return DuoCard(
      padding: EdgeInsets.all(AppMetrics.gapLg.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: captionStyle,
                ),
                SizedBox(height: AppMetrics.gapXs.r),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.number(context),
                ),
                if (caption != null) ...[
                  SizedBox(height: AppMetrics.gapXs.r),
                  Text(caption!, maxLines: 2, style: captionStyle),
                ],
              ],
            ),
          ),
          if (icon != null) ...[
            SizedBox(width: AppMetrics.gapMd.r),
            DuoIconBadge(
              icon: icon!,
              tone: tone ?? DuoIconBadgeTone.brand,
              size: 44,
            ),
          ],
        ],
      ),
    );
  }
}
