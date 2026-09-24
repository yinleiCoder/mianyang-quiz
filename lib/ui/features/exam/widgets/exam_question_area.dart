// 考试答题区：大题抬头 + 题号/题型/分值 + 题目本身（可滚动）。
//
// 与练习的答题区有三处刻意的不同：
//   · **选项不乱序**。练习乱序是为了防止"记住 A 是对的"，考试要跟印出来的卷子对得上，
//     乱序会让同一考场的两个人看到的选项顺序不同。
//   · **不揭示任何对错**（reveal 恒为 none）：交卷前谁都不知道判成什么样。
//   · **主观题是手写输入**（shortAnswerMode: essay），不是自评按钮——见 EssayInputView。
//
// 每到大题的第一题，先把大题名与给分口径印出来（"一、单项选择题　本大题共 10 小题"），
// 学生才知道这一部分的计分方式——这是卷面的一部分，不是装饰。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:mianyang_quiz/ui/core/question/input/short_answer_mode.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_section_heading.dart';

class ExamQuestionArea extends StatelessWidget {
  const ExamQuestionArea({
    super.key,
    required this.runner,
    required this.onAnswerChanged,
  });

  final ExamRunner runner;
  final ValueChanged<SubmittedAnswer> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    final index = runner.index;
    final item = runner.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.pagePadding,
        vertical: AppMetrics.gapLg,
      ),
      // 限宽随可用宽度走：手机（可用 < 640）与今天完全一样；宽屏一路放到 1080 为止，
      // 中间不设断点——窗口从 1200 拖到 1600 时题面是连续变宽的，不会有"跳一下"。
      child: LayoutBuilder(
        builder: (context, constraints) => MaxWidthBox(
          maxWidth: constraints.maxWidth
              .clamp(AppMetrics.pageMaxWidth, AppMetrics.pageWideMaxWidth)
              .toDouble(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            // key 必须给 child（理由见 PracticeQuestionArea）：用题号做 key，
            // 切题时整块重建，上一题的输入焦点不会残留到下一题。
            child: Column(
              key: ValueKey('$index-${item.id}'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (runner.startsSection(index)) ...[
                  ExamSectionHeading(section: runner.sectionAt(index)),
                  SizedBox(height: AppMetrics.gapLg.r),
                ],
                _ItemHeader(number: index + 1, item: item),
                SizedBox(height: AppMetrics.gapMd.r),
                QuestionView(
                  qtype: item.qtype,
                  content: item.content,
                  answer: runner.draftAt(index),
                  onAnswerChanged: onAnswerChanged,
                  shortAnswerMode: ShortAnswerMode.essay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 「第 7 题」+ 题型 + 满分。分值必须露出来：它决定了这道题值不值得多花时间。
class _ItemHeader extends StatelessWidget {
  const _ItemHeader({required this.number, required this.item});

  final int number;
  final ExamItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('第 $number 题', style: AppTextStyles.sectionTitle(context)),
        const Spacer(),
        DuoChip(label: item.type.label, tone: DuoChipTone.neutral, dense: true),
        SizedBox(width: AppMetrics.gapXs.r),
        DuoChip(
          label: '${Formatters.score(item.score)} 分',
          tone: DuoChipTone.brand,
          dense: true,
        ),
      ],
    );
  }
}
