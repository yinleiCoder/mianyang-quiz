// 大题抬头：「一、单项选择题　本大题共 10 小题，每题 2 分」。
//
// 每到大题的第一题印一次（由答题区决定什么时候显示）。它是卷面的一部分而不是装饰：
// 学生靠它知道这一部分有几道题、每题多少分，才知道该在这部分花多少时间。
//
// 给分口径（"每题 2 分"）由服务端给的两件事拼出来：大题总分 ÷ 题数。
// 除不尽就不说"每题多少分"——宁可只说总分，也不要印一个错的口径。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';

class ExamSectionHeading extends StatelessWidget {
  const ExamSectionHeading({super.key, required this.section});

  final ExamSection section;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final count = section.items.length;

    return Container(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.heading, style: AppTextStyles.sectionTitle(context)),
          if (count > 0) ...[
            SizedBox(height: AppMetrics.gapXs.r),
            Text(
              _meta(section, count),
              style: AppTextStyles.caption(context)
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
          if (section.instruction != null &&
              section.instruction!.trim().isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapSm.r),
            Text(
              section.instruction!.trim(),
              style: AppTextStyles.body(context)
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

String _meta(ExamSection section, int count) {
  final perItem = section.sectionScore / count;
  final even = (perItem - perItem.roundToDouble()).abs() < 0.001;
  return [
    '本大题共 $count 小题',
    if (even && perItem > 0) '每题 ${Formatters.score(perItem)} 分',
    '共 ${Formatters.score(section.sectionScore)} 分',
  ].join(' · ');
}
