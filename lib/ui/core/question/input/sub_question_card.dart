// 复合题里的一张子题卡：序号 + 题型标签 + 子题干 + 子题作答区。
//
// 职责：把 SubQuestion 适配成 QuestionView 能吃的 QuestionContent，并做**作答形状的翻译**：
//   · 客观子题：作答原样透传（ChoiceAnswer / TrueFalseAnswer / BlankAnswer）。
//   · 主观子题：作答是 SubMasteredAnswer(mastered)，**没有 type 键**——这是 SQL 里
//     `p_answer->'subs'->i->>'mastered'` 的约定。写错的表现是"提交成功但永远判错"，
//     而且界面上完全看不出来。
// 子题不能是复合题（数据库约束），所以这里不会递归出第二层卡片。
// 不负责：整题的提交与判分、子题之间的顺序（由 CompositeInputView 保证）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/sub_question.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class SubQuestionCard extends StatelessWidget {
  const SubQuestionCard({
    super.key,
    required this.index,
    required this.sub,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  /// 子题在 content.sub 里的下标（0 起），决定「第 N 题」的序号。
  final int index;

  final SubQuestion sub;

  /// 该子题当前的作答（CompositeAnswer.subs[index]），未作答为 null。
  final SubmittedAnswer? answer;

  /// 该子题作答变化。主观子题送出的**一定是 SubMasteredAnswer**。
  final ValueChanged<SubmittedAnswer> onAnswerChanged;

  final AnswerReveal reveal;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final current = answer;
    final isSelfAssessed = questionTypeFrom(sub.type).isSelfAssessed;
    final mastered = current is SubMasteredAnswer ? current.mastered : null;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '第 ${index + 1} 题',
                style: AppTextStyles.sectionTitle(context),
              ),
              const Spacer(),
              DuoChip(
                label: questionTypeFrom(sub.type).label,
                tone: DuoChipTone.neutral,
                dense: true,
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          QuestionView(
            qtype: sub.type,
            content: _asContent(sub),
            // 主观子题没有 TextAnswer 这一说：已自评 = mastered 有值。
            answer: isSelfAssessed
                ? (mastered == null ? null : const TextAnswer())
                : current,
            // 主观子题会先回一个 TextAnswer（「已作答」标记），这里必须丢掉：
            // 子题位置上的主观作答只能是 SubMasteredAnswer。
            onAnswerChanged: isSelfAssessed ? _ignoreAnswer : onAnswerChanged,
            onSelfAssessed: isSelfAssessed
                ? (mastered) => onAnswerChanged(SubMasteredAnswer(mastered))
                : null,
            selfMastered: mastered,
            reveal: reveal,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }
}

void _ignoreAnswer(SubmittedAnswer answer) {}

/// 子题 → QuestionView 能吃的 QuestionContent。
/// 子题没有解析、也不能再套子题，所以这两个字段留空即可。
QuestionContent _asContent(SubQuestion sub) => QuestionContent(
  formatVersion: sub.formatVersion,
  stem: sub.stem,
  options: sub.options,
  answer: sub.answer,
);
