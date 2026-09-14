// 解析 + 标准答案：「对完答案再看一遍」的那一块。题目详情、背题、复盘共用。
//
// 职责：把 content.analysis 的块数组渲染成一段正文，并给出标准答案（AnswerSummaryView）。
// 不负责：作答交互（QuestionView）、取数、判分。解析为空时不渲染标题，不留一个空标题。
//
// 与 QuestionView 的 reveal 有重叠：reveal 为 graded/answerOnly 时，输入视图自己也会
// 在控件上标出答案（填空逐空给正确答案、主观题给参考答案）。页面若两处都展示会重复一次，
// 这种情况传 showAnswer: false，只取解析。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/core/question/answer_summary_view.dart';
import 'package:mianyang_quiz/ui/core/question/block_list_view.dart';

class AnalysisView extends StatelessWidget {
  const AnalysisView({
    super.key,
    required this.content,
    this.optionOrder,
    this.showAnswer = true,
    this.answerTitle,
  });

  final QuestionContent content;

  /// 选项显示顺序（原始 key 序列），用于把答案里的原始 key 折算成显示字母。
  final List<String>? optionOrder;

  /// 是否展示标准答案。页面已在 QuestionView 上揭示过答案时传 false，避免重复。
  final bool showAnswer;

  /// 覆盖答案标题；null 时按答案类型自动取「正确答案」/「参考答案」。
  final String? answerTitle;

  @override
  Widget build(BuildContext context) {
    final hasAnalysis = content.analysis.isNotEmpty;
    if (!showAnswer && !hasAnalysis) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showAnswer)
          AnswerSummaryView(
            content: content,
            optionOrder: optionOrder,
            title: answerTitle,
          ),
        if (showAnswer && hasAnalysis) SizedBox(height: AppMetrics.gapLg.r),
        if (hasAnalysis) ...[
          const SectionHeader(title: '解析'),
          BlockListView(
            blocks: content.analysis,
            textStyle: AppTextStyles.body(context),
            placeholder: '（本题没有解析）',
          ),
        ],
      ],
    );
  }
}
