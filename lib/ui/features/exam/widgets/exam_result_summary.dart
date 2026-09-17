// 成绩单头部：得分、状态、待阅卷提示、用时。
//
// **待阅卷时不能拿总分当分子**：那时的 total_score 只有客观分（主观题还是 0），
// 显示成「42 / 100」会被读成"我才考了 42 分"。所以未出分时分母换成客观题满分，
// 并且明说"主观题待阅卷"。这是这一页唯一容易做错的地方。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class ExamResultSummary extends StatelessWidget {
  const ExamResultSummary({
    super.key,
    required this.attempt,
    required this.title,
  });

  final ExamAttempt attempt;

  /// 卷名（成绩单上没有题目列表，标题得自己带）。
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = attempt.statusValue;
    final finalScore = status.isFinal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle(context),
              ),
            ),
            SizedBox(width: AppMetrics.gapSm.r),
            DuoChip(label: status.label, tone: _toneOf(status), dense: true),
          ],
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        DuoCard(
          emphasized: finalScore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                finalScore ? '总成绩' : '客观题得分',
                style: AppTextStyles.caption(context)
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    Formatters.score(
                      finalScore ? attempt.totalScore : attempt.objectiveScore,
                    ),
                    style: AppTextStyles.number(context).copyWith(
                      fontSize: 40.sp,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    ' / ${Formatters.score(finalScore ? attempt.fullScore : attempt.objectiveFullScore)}',
                    style: AppTextStyles.body(context)
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              Text(_detail(attempt, finalScore), style: _detailStyle(context)),
              if (!finalScore && attempt.pendingReviewCount > 0) ...[
                SizedBox(height: AppMetrics.gapSm.r),
                _PendingNotice(count: attempt.pendingReviewCount),
              ],
              if (attempt.durationMs > 0) ...[
                SizedBox(height: AppMetrics.gapSm.r),
                Text(
                  '用时 ${Formatters.duration(attempt.durationMs)}',
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  TextStyle _detailStyle(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant);
  }

  static String _detail(ExamAttempt attempt, bool finalScore) {
    if (finalScore) {
      return '客观题 ${Formatters.score(attempt.objectiveScore)} 分'
          ' · 主观题 ${Formatters.score(attempt.subjectiveScore)} 分';
    }
    return '主观题还没判分，出分后这里会更新';
  }
}

/// 待阅卷提示。用警示色而不是错误色：它不是"出错了"，是"还没轮到你"。
class _PendingNotice extends StatelessWidget {
  const _PendingNotice({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semantic;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapMd.r,
        vertical: AppMetrics.gapSm.r,
      ),
      decoration: BoxDecoration(
        color: semantic.warningContainer,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_bottom,
            size: 16.r,
            color: semantic.onWarningContainer,
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(
              '还有 $count 道题等老师阅卷',
              style: AppTextStyles.caption(context)
                  .copyWith(color: semantic.onWarningContainer),
            ),
          ),
        ],
      ),
    );
  }
}

DuoChipTone _toneOf(ExamStatus status) => switch (status) {
  ExamStatus.graded => DuoChipTone.success,
  ExamStatus.submitted || ExamStatus.grading => DuoChipTone.warning,
  ExamStatus.inProgress => DuoChipTone.brand,
  _ => DuoChipTone.neutral,
};
