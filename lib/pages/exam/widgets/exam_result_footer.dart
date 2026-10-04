// 成绩单页脚：交卷时间与卷面信息。
//
// 放最后是有意的——看完成绩与逐题之后，才是"这场是什么时候考的"。
// 单独一个文件：成绩单页本身已经有汇总、逐题卡片、统计接线三件事（见 exam_result_page.dart）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class ExamResultFooter extends StatelessWidget {
  const ExamResultFooter({
    super.key,
    required this.attempt,
    required this.paper,
  });

  final ExamAttempt attempt;
  final ExamPaper paper;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lines = <String>[
      if (attempt.submittedAt != null)
        '交卷时间：${Formatters.dateTime(attempt.submittedAt)}',
      if (attempt.gradedAt != null)
        '出分时间：${Formatters.dateTime(attempt.gradedAt)}',
      '科目：${paper.subjectLabel?.trim().isNotEmpty ?? false ? paper.subjectLabel! : '—'}',
      '满分：${Formatters.score(paper.totalScore)} 分 · 限时 ${paper.durationMinutes} 分钟',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Padding(
            padding: EdgeInsets.only(bottom: AppMetrics.gapXs.r),
            child: Text(
              line,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
