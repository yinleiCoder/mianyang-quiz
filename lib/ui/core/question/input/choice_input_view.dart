// 单选 / 多选的作答区（含判定后的标色）。
//
// 职责：
//   · 单选点选即替换，多选点选即增删；产出的 ChoiceAnswer.keys **只能是原始 key**。
//     显示字母 = letterOf(在 shuffledKeys 里的位置)，由 domain/option_order.dart 定义，
//     这里只消费它，绝不把显示字母写进作答（写了界面照常，服务端全判错）。
//   · 按 reveal 决定选项状态：
//       none       只用 idle / selected
//       graded     correct 标正确答案；用户选了但不是答案的标 wrong
//       answerOnly 只标正确答案，**不显示用户的选择**
//   · readOnly（或 answerOnly）时 onTap 传 null，彻底断开交互。
// 不负责：乱序的**生成**（页面算一次并物化，见 AGENTS.md）、判分、标准答案的文字展示
// （AnswerSummaryView）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/domain/option_order.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/option_tile.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class ChoiceInputView extends StatelessWidget {
  const ChoiceInputView({
    super.key,
    required this.content,
    required this.multiple,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
    this.shuffledKeys,
  });

  final QuestionContent content;

  /// 多选：形状提示与"点选增删"都不同。单选点第二个会替换第一个。
  final bool multiple;

  /// 当前作答。非 ChoiceAnswer（含 null）视为未作答。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final AnswerReveal reveal;

  /// true = 不可作答。reveal 为 answerOnly 时 QuestionView 也会把它置为 true。
  final bool readOnly;

  /// 选项显示顺序（原始 key 序列）。null = 按题目原始顺序。
  final List<String>? shuffledKeys;

  @override
  Widget build(BuildContext context) {
    final current = answer;
    final selected = current is ChoiceAnswer ? current.keys.toSet() : const <String>{};
    final correctAnswer = content.answer;
    final correct = correctAnswer is ChoiceServerAnswer
        ? correctAnswer.keys.where((key) => key.trim().isNotEmpty).toSet()
        : const <String>{};
    final options = orderedOptions(content.options, shuffledKeys);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < options.length; i++)
          OptionTile(
            // 显示字母按**位置**给：第 i 个位置永远是 letterOf(i)，与原始 key 无关。
            letter: letterOf(i),
            label: options[i].label,
            multiple: multiple,
            state: optionStateOf(
              key: options[i].key,
              selected: selected,
              correct: correct,
              reveal: reveal,
            ),
            onTap: readOnly ? null : () => _emit(options[i].key, selected),
          ),
      ],
    );
  }

  void _emit(String key, Set<String> selected) {
    final next = selected.toList();
    if (multiple) {
      next.contains(key) ? next.remove(key) : next.add(key);
    } else {
      next.clear();
      next.add(key);
    }
    onAnswerChanged(ChoiceAnswer(next));
  }
}

/// 按 shuffledKeys 的顺序取出选项实体。
///
/// 对脏数据要宽容：顺序里出现不存在的 key、重复、漏项时，一律以内容里的选项为准补齐，
/// 保证每个选项都画得出来（少画一个选项比顺序不对更严重——学生会以为题就是这样）。
List<QuestionOption> orderedOptions(
  List<QuestionOption> options,
  List<String>? shuffledKeys,
) {
  final byKey = {for (final option in options) option.key: option};
  final used = <String>{};
  final result = <QuestionOption>[];
  for (final key in shuffledKeys ?? const <String>[]) {
    final option = byKey[key];
    if (option != null && used.add(key)) result.add(option);
  }
  for (final option in options) {
    if (used.add(option.key)) result.add(option);
  }
  return result;
}

/// 单个选项的视觉状态。选择题、判断题（两个大按钮）共用同一套规则，
/// 保证「正确答案标 correct、选错的标 wrong」在全项目只有一种解释。
OptionState optionStateOf({
  required String key,
  required Set<String> selected,
  required Set<String> correct,
  required AnswerReveal reveal,
}) {
  final isSelected = selected.contains(key);
  final isCorrect = correct.contains(key);

  if (reveal == AnswerReveal.answerOnly) {
    // 背题：只看标准答案，用户此前的选择完全不显示
    return isCorrect ? OptionState.correct : OptionState.idle;
  }
  if (reveal == AnswerReveal.graded && correct.isNotEmpty) {
    // 判错的那一项如果恰好是正确答案，仍然显示 correct——它本来就是对的
    if (isCorrect) return OptionState.correct;
    return isSelected ? OptionState.wrong : OptionState.idle;
  }
  return isSelected ? OptionState.selected : OptionState.idle;
}
