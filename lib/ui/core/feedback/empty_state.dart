// 空状态：没有数据时的整屏占位。
//
// 职责：图标 + 一句话 + 一个可选动作，回答「这里为什么空、下一步能做什么」。
// 不负责：出错（ErrorState）与加载中（LoadingState），也刻意不管滚动——
// 它只占满父级给的空间，放进 ListView 还是 Column 都能用。
//
// 文案要求：与其写「暂无数据」，不如写「做完第一套题，错题会自动收进这里」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
  });

  final String title;

  /// 补充说明，建议写清"怎么让它不空"。
  final String? message;

  /// 图标，可选；建议用 64 尺寸的中性徽章。
  final IconData? icon;

  /// 推荐动作（如「去练习」），可选。
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = AppTextStyles.body(context)
        .copyWith(color: scheme.onSurfaceVariant);

    return Center(
      child: MaxWidthBox(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(AppMetrics.gapXl.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                DuoIconBadge(
                  icon: icon!,
                  tone: DuoIconBadgeTone.neutral,
                  size: 64,
                ),
                SizedBox(height: AppMetrics.gapLg.r),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle(context),
              ),
              if (message != null) ...[
                SizedBox(height: AppMetrics.gapSm.r),
                Text(message!, textAlign: TextAlign.center, style: body),
              ],
              if (action != null) ...[
                SizedBox(height: AppMetrics.gapXl.r),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
