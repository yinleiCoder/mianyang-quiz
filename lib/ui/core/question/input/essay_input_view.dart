// 主观题在**考试**下的作答区：一个多行输入框，产出 EssayAnswer(text)。
//
// 与 ShortAnswerInputView（练习的那一个）是两件事，所以是两个文件而不是一个带开关的文件：
// 练习的主观题没有输入框——对错由自评决定，写了也没人看；考试正好相反，
// 学生的原话要存下来交给阅卷人。把它们塞进同一个组件，按钮与输入框就会互相打架
// （自评区的「我会了」在考试里毫无意义）。
//
// 职责：输入 → onAnswerChanged(EssayAnswer)；揭示答案时把参考答案放在输入框上方。
// 不负责：提交、判分（考试的主观题一律由教师判）。
//
// 回填用「文本不同才写」的方式（同 FillBlankInputView）：每次按键都会上抛作答，
// 页面随即重建并把新的 answer 传回来，每次都写 controller 会把光标顶到末尾。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/answer_summary_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class EssayInputView extends StatefulWidget {
  const EssayInputView({
    super.key,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
  });

  final QuestionContent content;

  /// 当前作答。非 EssayAnswer（含 null）视为未作答。
  final SubmittedAnswer? answer;

  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final AnswerReveal reveal;
  final bool readOnly;

  @override
  State<EssayInputView> createState() => _EssayInputViewState();
}

class _EssayInputViewState extends State<EssayInputView> {
  late final TextEditingController _controller = TextEditingController(
    text: _externalText,
  );

  /// 外部作答里的文本；未作答为 null（与"写了空串"区分不开，两者都按未作答处理）。
  String get _externalText {
    final answer = widget.answer;
    return answer is EssayAnswer ? answer.text : '';
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_emit);
  }

  @override
  void didUpdateWidget(covariant EssayInputView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 只在文本真的不同时写：一致时写会把光标顶到末尾（见文件头）。
    // answerOnly（背题）不回填：那种场景下不该显示用户此前的作答。
    final external = widget.reveal == AnswerReveal.answerOnly ? '' : _externalText;
    if (_controller.text != external) _controller.text = external;
  }

  @override
  void dispose() {
    _controller.removeListener(_emit);
    _controller.dispose();
    super.dispose();
  }

  /// 作答一律从输入框本身取出（它就是当前输入的真值）。
  void _emit() => widget.onAnswerChanged(EssayAnswer(_controller.text));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.reveal != AnswerReveal.none) ...[
          AnswerSummaryView(content: widget.content, title: '参考答案'),
          SizedBox(height: AppMetrics.gapLg.r),
        ],
        TextField(
          controller: _controller,
          readOnly: widget.readOnly,
          // 主观题要写一段话，单行输入框在这儿是没法用的；不设 maxLines 上限，
          // 长答案让它自己长高，超出一屏时由页面负责滚动。
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: widget.readOnly ? '（未作答）' : '写下你的答案…',
            // 得分行由成绩单给，这里只说清楚老师会看——它是学生唯一的行为指引。
            helperText: widget.readOnly ? null : '本题由老师阅卷给分',
            helperStyle: AppTextStyles.caption(context).copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
