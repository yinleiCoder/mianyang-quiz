// 填空题的作答区：逐空一个输入框，产出 BlankAnswer(values)。
//
// 两条必须做对的规则：
//   1. **输入框数量以题干里的空位数为准**（连续 3 个以上下划线，见 countBlanks），
//      不是标准答案数组的长度。脏数据下两者会不一致：答案不足处留空，
//      多出来的答案值直接忽略——学生看到的是题干，作答框就得跟题干对齐。
//   2. 空位序号显示在输入框旁，否则学生没法把答案和空位对应起来。
// 不负责：判分、提交；标准答案的整段文字展示由 AnswerSummaryView 负责——
// 这里只在该空旁边给出它自己的正确答案（离开具体空位，答案就没法读）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/domain/answer_grader.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class FillBlankInputView extends StatefulWidget {
  const FillBlankInputView({
    super.key,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  final QuestionContent content;

  /// 当前作答。非 BlankAnswer（含 null）视为未作答。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final AnswerReveal reveal;
  final bool readOnly;

  @override
  State<FillBlankInputView> createState() => _FillBlankInputViewState();
}

class _FillBlankInputViewState extends State<FillBlankInputView> {
  late List<TextEditingController> _controllers;

  /// 空位数以**题干**为准。题干一个空位都没有属于脏数据，此时仍给一个输入框：
  /// 否则学生无从作答、整页卡死在本题上。
  int get _count {
    final blanks = widget.content.blankCount;
    return blanks > 0 ? blanks : 1;
  }

  List<String> get _values {
    final answer = widget.answer;
    return answer is BlankAnswer ? answer.values : const <String>[];
  }

  List<String> get _correctValues {
    final answer = widget.content.answer;
    return answer is BlankServerAnswer ? answer.values : const <String>[];
  }

  @override
  void initState() {
    super.initState();
    _controllers = _make(_count);
    _syncFromAnswer();
  }

  @override
  void didUpdateWidget(covariant FillBlankInputView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controllers.length != _count) {
      for (final controller in _controllers) {
        controller.dispose();
      }
      _controllers = _make(_count);
    }
    _syncFromAnswer();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<TextEditingController> _make(int count) =>
      List.generate(count, (_) => TextEditingController());

  /// 外部作答 → 输入框。只在文本真的不同时写：每次都写会把光标顶到末尾。
  /// answerOnly（背题）不回填：那种场景下不该显示用户此前的作答。
  void _syncFromAnswer() {
    final values =
        widget.reveal == AnswerReveal.answerOnly ? const <String>[] : _values;
    for (var i = 0; i < _controllers.length; i++) {
      final text = i < values.length ? values[i] : '';
      if (_controllers[i].text != text) _controllers[i].text = text;
    }
  }

  /// 作答一律从输入框本身取出（它就是当前输入的真值），不拼 _values。
  void _emit() =>
      widget.onAnswerChanged(BlankAnswer([for (final c in _controllers) c.text]));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _controllers.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // 与输入框里的第一行文字对齐：框内边距 + 描边
                  padding: EdgeInsets.only(
                    top: AppMetrics.gapMd.r + AppMetrics.hairline.r,
                  ),
                  child: Text(
                    '第 ${i + 1} 空',
                    style: AppTextStyles.caption(context)
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                SizedBox(width: AppMetrics.gapSm.r),
                Expanded(
                  child: TextField(
                    controller: _controllers[i],
                    readOnly: widget.readOnly,
                    onChanged: (_) {
                      setState(() {});
                      _emit();
                    },
                    decoration: _decoration(context, i),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context, int index) {
    final scheme = Theme.of(context).colorScheme;
    final correct = _correctValues;
    final expected = index < correct.length ? correct[index].trim() : '';
    final typed = _controllers[index].text;

    // 逐空的对错：用与判分同一套归一化（normAnswerText），否则「100 」会被标成错。
    // 整体作答为 null（复盘只回放题面、没带作答）时不标错，只给出标准答案。
    Widget? suffix;
    if (widget.reveal == AnswerReveal.graded &&
        widget.answer != null &&
        expected.isNotEmpty) {
      final ok = typed.trim().isNotEmpty &&
          normAnswerText(typed) == normAnswerText(expected);
      suffix = Icon(
        ok ? Icons.check_circle_outline : Icons.cancel_outlined,
        size: 18.r,
        color: ok ? context.semantic.success : scheme.error,
      );
    }

    return InputDecoration(
      hintText: '填写第 ${index + 1} 空',
      suffixIcon: suffix,
      // 揭示答案时把该空的标准答案贴在输入框下方：填空的答案离开空位就没法读。
      helperText: widget.reveal == AnswerReveal.none || expected.isEmpty
          ? null
          : '正确答案：$expected',
      helperStyle: AppTextStyles.caption(context).copyWith(color: context.semantic.success),
    );
  }
}
