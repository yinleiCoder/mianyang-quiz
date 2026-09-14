// 判断题的作答区：两个大按钮「正确 / 错误」。
//
// 职责：点选产出 TrueFalseAnswer；按 reveal 给按钮上色（规则与选择题**同一套**，
// 见 choice_input_view.dart 的 optionStateOf：正确答案标 correct、选错的标 wrong，
// answerOnly 只看标准答案、不显示用户的选择）。
// 不负责：判分、提交；也不负责标准答案的文字展示（AnswerSummaryView）。
//
// 为什么不用 DuoButton：DuoButton 的语气只有 primary/secondary/outline/danger，
// 表达不了「correct/wrong」这两个判定态；而判定态在刷题反馈里比语气重要。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/input/choice_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/option_tile.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class TrueFalseInputView extends StatelessWidget {
  const TrueFalseInputView({
    super.key,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  final QuestionContent content;

  /// 当前作答。非 TrueFalseAnswer（含 null）视为未作答。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final AnswerReveal reveal;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final current = answer;
    final chosen = current is TrueFalseAnswer ? current.value : null;
    final correctAnswer = content.answer;
    final correct = correctAnswer is TrueFalseServerAnswer ? correctAnswer.value : null;

    return Row(
      children: [
        Expanded(
          child: _TrueFalseButton(
            label: '正确',
            icon: Icons.check_rounded,
            state: _stateOf(true, chosen, correct),
            onTap: readOnly ? null : () => onAnswerChanged(const TrueFalseAnswer(true)),
          ),
        ),
        SizedBox(width: AppMetrics.gapMd.r),
        Expanded(
          child: _TrueFalseButton(
            label: '错误',
            icon: Icons.close_rounded,
            state: _stateOf(false, chosen, correct),
            onTap: readOnly ? null : () => onAnswerChanged(const TrueFalseAnswer(false)),
          ),
        ),
      ],
    );
  }

  OptionState _stateOf(bool value, bool? chosen, bool? correct) {
    // 标准答案缺失（脏数据）时退化成「只显示选中」：宁可不标，也不要乱标。
    if (correct == null) {
      return chosen == value ? OptionState.selected : OptionState.idle;
    }
    return optionStateOf(
      key: value ? 'true' : 'false',
      selected: chosen == value ? {value ? 'true' : 'false'} : const <String>{},
      correct: {correct ? 'true' : 'false'},
      reveal: reveal,
    );
  }
}

/// 一个大按钮：与 OptionTile 同一种视觉语言（粗描边 + 实心底），只是没有字母标记。
class _TrueFalseButton extends StatelessWidget {
  const _TrueFalseButton({
    required this.label,
    required this.icon,
    required this.state,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final OptionState state;

  /// null = 不可点（readOnly）。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (border, background, foreground) = switch (state) {
      OptionState.idle => (
        scheme.outlineVariant,
        scheme.surface,
        scheme.onSurfaceVariant,
      ),
      OptionState.selected => (
        scheme.primary,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      OptionState.correct => (
        context.semantic.success,
        context.semantic.successContainer,
        scheme.onTertiaryContainer,
      ),
      OptionState.wrong => (
        scheme.error,
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        height: AppMetrics.buttonHeight.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border, width: AppMetrics.stroke.r),
          borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22.r, color: foreground),
            SizedBox(width: AppMetrics.gapSm.r),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label(context)
                    .copyWith(color: foreground, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
