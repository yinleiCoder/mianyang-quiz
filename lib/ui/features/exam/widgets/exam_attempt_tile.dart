// 我的考试的一行：卷名 + 状态 + 得分 + 时间。
//
// 两种点法（由调用方决定行为）：
//   · 进行中 → 「继续答题」，回到答题页接着写；
//   · 其余 → 看成绩单（待阅卷时看到的是"客观分 + 待阅卷提示"，不是最终分）。
//
// **分数在待阅卷时故意显示为「—」**：那时的 total_score 只有客观分，
// 写成「42/100」会被读成"我才考了 42 分"，而它其实还没判完。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class ExamAttemptTile extends StatelessWidget {
  const ExamAttemptTile({super.key, required this.record, required this.onTap});

  final ExamAttemptRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final status = record.statusValue;

    return DuoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle(context),
                ),
              ),
              SizedBox(width: AppMetrics.gapMd.r),
              Text(
                record.scoreText,
                style: AppTextStyles.label(context).copyWith(
                  color: scheme.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Row(
            children: [
              DuoChip(
                label: status.label,
                tone: _toneOf(status),
                dense: true,
              ),
              // 重做的场次标出来：同一份卷只有**第一次**交卷进排行榜，
              // 不标的话学生会以为重做把之前的名次覆盖了（也更可能去刷分）
              if (!record.isOfficial &&
                  (status.isFinal || status == ExamStatus.submitted || status == ExamStatus.grading)) ...[
                SizedBox(width: AppMetrics.gapXs.r),
                const DuoChip(label: '自主练习 · 不计入排行', tone: DuoChipTone.neutral, dense: true),
              ],
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: Text(
                  [
                    if (record.itemCount > 0) '${record.itemCount} 题',
                    if (status.isFinal && record.durationMs > 0)
                      '用时 ${Formatters.duration(record.durationMs)}',
                    if (record.pendingReviewCount > 0)
                      '${record.pendingReviewCount} 题待阅卷',
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            // 进行中看的是"开始于"（它决定倒计时还剩多少），其余看交卷时间
            status.isOpen
                ? '开始于 ${Formatters.dateTime(record.startedAt)}'
                : Formatters.relative(record.submittedAt ?? record.startedAt),
            style: AppTextStyles.caption(context)
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

DuoChipTone _toneOf(ExamStatus status) => switch (status) {
  ExamStatus.inProgress => DuoChipTone.brand,
  ExamStatus.submitted || ExamStatus.grading => DuoChipTone.warning,
  ExamStatus.graded => DuoChipTone.success,
  // 放弃/超时/未知：中性灰，不额外强调——它们是历史，不是当前要处理的事
  _ => DuoChipTone.neutral,
};
