// 复合题的作答区：每个子题一张 SubQuestionCard。
//
// 契约要点（错一个就静默判错）：
//   · subs 与 content.sub **同序**，不能重排、不能丢项——服务端按 subs[i] 逐位比对，
//     位次错了就是"看着答对了、提交判错"。
//   · 主观子题的作答形状是 {"mastered": bool}（**没有 type 键**），由 SubQuestionCard 翻译；
//     本文件只按位置替换，不关心形状。
//   · 未作答的子题用 UnknownAnswer 占位：服务端一样判错，但比缺项更如实，
//     页面也能据它提示「还有子题没做」。
// 不负责：整题的判分与提交。shuffledKeys 是**单题**的参数（复合题根节点没有选项），
// 所以这里不接收它；各子题按自己的原始顺序展示。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/input/sub_question_card.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class CompositeInputView extends StatelessWidget {
  const CompositeInputView({
    super.key,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  final QuestionContent content;

  /// 当前作答。非 CompositeAnswer（含 null）视为全部未作答。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final AnswerReveal reveal;
  final bool readOnly;

  List<SubmittedAnswer> get _subs {
    final current = answer;
    return current is CompositeAnswer ? current.subs : const <SubmittedAnswer>[];
  }

  /// 只替换第 [index] 个子作答，其余保持原位——顺序即契约。
  void _replaceAt(int index, SubmittedAnswer value) {
    final current = _subs;
    final subs = <SubmittedAnswer>[
      for (var i = 0; i < content.sub.length; i++)
        if (i == index)
          value
        else
          i < current.length
              ? current[i]
              // 缺项补 UnknownAnswer（判错但不丢位次）
              : const UnknownAnswer(),
    ];
    onAnswerChanged(CompositeAnswer(subs));
  }

  @override
  Widget build(BuildContext context) {
    final current = _subs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < content.sub.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
            child: SubQuestionCard(
              index: i,
              sub: content.sub[i],
              answer: i < current.length ? current[i] : null,
              onAnswerChanged: (value) => _replaceAt(i, value),
              reveal: reveal,
              readOnly: readOnly,
            ),
          ),
      ],
    );
  }
}
