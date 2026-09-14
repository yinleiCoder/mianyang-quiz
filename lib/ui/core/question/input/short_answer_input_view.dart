// 主观题的作答区：**没有输入框**，只有自评区的两个按钮。
//
// 为什么没有输入框：服务端契约里主观题的作答形状是 {"type":"text"}——不带内容，
// 对错完全由自评决定（submit_practice_answer 的 p_self_mastered）。让学生敲一段
// 谁都不会看的文字只会增加负担，也不进统计。所以本题型产出的作答**只有 TextAnswer**
// 这一种形状，它只是个「已作答」的标记。
//
// 职责：点「我会了 / 没掌握」→ onAnswerChanged(TextAnswer()) + onSelfAssessed(bool)；
// 揭示答案（graded / answerOnly）时把参考答案放在按钮上方——自评必须对着答案做，
// 否则「我会了」只是凭感觉。
// 不负责：提交（页面收到自评后自己调 RPC）、判定对错、拼作答 JSON。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/question/answer_summary_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class ShortAnswerInputView extends StatelessWidget {
  const ShortAnswerInputView({
    super.key,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.onSelfAssessed,
    this.selfMastered,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  final QuestionContent content;

  /// 当前作答。非 null 即视为已自评过（页面通常只存 TextAnswer 作标记）。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;

  /// 自评结果。页面据此传 submit_practice_answer 的 p_self_mastered。
  final ValueChanged<bool>? onSelfAssessed;

  /// 外部传入的自评结果（null = 尚未自评）。
  final bool? selfMastered;

  final AnswerReveal reveal;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reveal != AnswerReveal.none) ...[
          AnswerSummaryView(content: content, title: '参考答案'),
          SizedBox(height: AppMetrics.gapLg.r),
        ],
        Text(
          '本题不计对错，请对照参考答案自评：',
          style: AppTextStyles.caption(context)
              .copyWith(color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        Row(
          children: [
            Expanded(
              child: DuoButton(
                label: '我会了',
                icon: Icons.check_rounded,
                variant: selfMastered == true
                    ? DuoButtonVariant.primary
                    : DuoButtonVariant.outline,
                onPressed: readOnly ? null : () => _assess(true),
              ),
            ),
            SizedBox(width: AppMetrics.gapMd.r),
            Expanded(
              child: DuoButton(
                label: '没掌握',
                icon: Icons.replay_rounded,
                variant: selfMastered == false
                    ? DuoButtonVariant.danger
                    : DuoButtonVariant.outline,
                onPressed: readOnly ? null : () => _assess(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _assess(bool mastered) {
    // 先补「已作答」标记：没有它，刷题页会认为本题还没作答、提交按钮一直是灰的。
    onAnswerChanged(const TextAnswer());
    onSelfAssessed?.call(mastered);
  }
}
