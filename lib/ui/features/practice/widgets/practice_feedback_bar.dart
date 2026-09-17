// 即时模式的底部反馈条：判定之后从底部升起的作答结果。
//
// 学多邻国：整条底色随对错变化（浅绿/浅红），左边一个大图标，
// 中间一句话 + 正误说明，右边一个主按钮。
//
// 按钮是「继续」（末题是「完成」）——**不做自动跳题倒计时**：判完还要看解析，
// 自动跳会把它抢走（见 practice_mode.dart 的说明）。
//
// 只做展示与回调，不判分、不提交——判定结果由 PracticeRunner 给出。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class PracticeFeedbackBar extends StatelessWidget {
  const PracticeFeedbackBar({
    super.key,
    required this.correct,
    required this.onContinue,
    this.summary,
    this.isLast = false,
    this.onToggleFavorite,
    this.isFavorite = false,
  });

  final bool correct;

  /// 一句话说明（如「正确答案：B」或主观题的提示）。可为空。
  final String? summary;

  final bool isLast;

  final VoidCallback onContinue;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    // M3 没有"成功"角色，用主题的 SemanticColors；错误用 error。
    final background = correct ? semantic.successContainer : scheme.errorContainer;
    final foreground = correct ? semantic.onSuccessContainer : scheme.onErrorContainer;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      offset: Offset.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppMetrics.radiusCard.r),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppMetrics.gapLg,
          AppMetrics.gapLg,
          AppMetrics.gapLg,
          AppMetrics.gapLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  size: 28.r,
                  color: foreground,
                ),
                const SizedBox(width: AppMetrics.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        correct ? '答对了' : '答错了',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (summary != null && summary!.isNotEmpty) ...[
                        SizedBox(height: 4.r),
                        Text(
                          summary!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onToggleFavorite != null)
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: foreground,
                      size: 24.r,
                    ),
                    tooltip: isFavorite ? '取消收藏' : '收藏本题',
                  ),
              ],
            ),
            const SizedBox(height: AppMetrics.gapLg),
            DuoButton(
              label: isLast ? '完成' : '继续',
              onPressed: onContinue,
              icon: isLast ? Icons.flag_outlined : Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
