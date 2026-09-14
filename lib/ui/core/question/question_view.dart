// 题目渲染的**唯一 qtype 分发点**：刷题、背题、题目详情、复盘都从这里进。
//
// 职责：读线格式题型字符串（single_choice…）→ 选一个作答视图；题干也在这里渲染。
// 不负责：解析与标准答案的文字展示（AnalysisView / AnswerSummaryView）、判分
// （domain/answer_grader）、选项乱序的生成（只接收算好的 shuffledKeys）、取数与提交。
// 本组件是**纯受控**的：不查库、不调 RPC、不导航、不认识 sessionId，只收数据与回调。
//
// 关于乱序（见 domain/option_order.dart）：shuffledKeys 是「原始 key 的显示顺序」——
// 屏幕上第 i 个选项的显示字母是 letterOf(i)，它携带的原始 key 是 shuffledKeys[i]；
// 写回作答时只能送原始 key。乱序结果必须由页面算一次并物化，不能在 build 里现算。
//
// 注意：本文件与 input/* 之间存在**有意的循环 import**——AnswerReveal 是与作答视图
// 共享的词汇表，放在分发点这里最容易被找到；Dart 的库循环是合法的，不构成问题。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/input/choice_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/composite_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/fill_blank_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/short_answer_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/true_false_input_view.dart';
import 'package:mianyang_quiz/ui/core/question/stem_view.dart';

/// 答案揭示程度。一个枚举覆盖四种使用场景。
enum AnswerReveal {
  /// 刷题未判定：不显示任何对错，选项只用 idle / selected。
  none,

  /// 已判定：标出所答的对错（正确答案标 correct、选错的标 wrong），并标出标准答案。
  graded,

  /// 背题 / 题目详情：只标标准答案，**不显示用户的选择**，且不可作答。
  answerOnly,
}

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.qtype,
    required this.content,
    required this.answer,
    required this.onAnswerChanged,
    this.reveal = AnswerReveal.none,
    this.readOnly = false,
    this.shuffledKeys,
    this.onSelfAssessed,
    this.selfMastered,
  });

  /// 线格式题型字符串（single_choice / multiple_choice / true_false /
  /// fill_blank / short_answer / composite）。未知取值降级为「暂不支持」，不抛异常。
  final String qtype;

  final QuestionContent content;

  /// 当前作答；未作答为 null。
  final SubmittedAnswer? answer;

  /// 作答变化。复合题产出 CompositeAnswer，其 subs 与 content.sub **同序**。
  final ValueChanged<SubmittedAnswer> onAnswerChanged;

  final AnswerReveal reveal;

  /// 禁止作答交互。reveal 为 answerOnly 时即使传 false 也按 true 处理
  /// （「背题」的语义就是只看不做）。
  final bool readOnly;

  /// 选项显示顺序（原始 key 序列）。仅单选题/多选题使用。
  final List<String>? shuffledKeys;

  /// 主观题自评回调（「我会了 / 没掌握」）。只有主观题会用到。
  final ValueChanged<bool>? onSelfAssessed;

  /// 外部传入的自评结果（null = 尚未自评）。
  final bool? selfMastered;

  @override
  Widget build(BuildContext context) {
    final type = questionTypeFrom(qtype);
    // answerOnly 一律不可作答；readOnly 由页面显式指定。两者合成一个开关往下传。
    final locked = readOnly || reveal == AnswerReveal.answerOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StemView(
          blocks: content.stem,
          // 复合题的根题干是**材料**，与子题题干区分开：不然学生会以为材料本身也要作答。
          label: content.isComposite ? '材料' : null,
          placeholder: content.isComposite ? null : '（题干为空）',
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _input(type, locked),
      ],
    );
  }

  Widget _input(QuestionType type, bool locked) {
    switch (type) {
      case QuestionType.singleChoice:
      case QuestionType.multipleChoice:
        return ChoiceInputView(
          content: content,
          multiple: type == QuestionType.multipleChoice,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
          reveal: reveal,
          readOnly: locked,
          shuffledKeys: shuffledKeys,
        );
      case QuestionType.trueFalse:
        return TrueFalseInputView(
          content: content,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
          reveal: reveal,
          readOnly: locked,
        );
      case QuestionType.fillBlank:
        return FillBlankInputView(
          content: content,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
          reveal: reveal,
          readOnly: locked,
        );
      case QuestionType.shortAnswer:
        return ShortAnswerInputView(
          content: content,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
          onSelfAssessed: onSelfAssessed,
          selfMastered: selfMastered,
          reveal: reveal,
          readOnly: locked,
        );
      case QuestionType.composite:
        return CompositeInputView(
          content: content,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
          reveal: reveal,
          readOnly: locked,
        );
      case QuestionType.unknown:
        return _UnsupportedTypeView(wire: qtype);
    }
  }
}

/// 未知题型：旧客户端遇到将来新增的题型时，显示一句可读的话而不是崩溃或空白。
class _UnsupportedTypeView extends StatelessWidget {
  const _UnsupportedTypeView({required this.wire});

  final String wire;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
      ),
      child: Text(
        '暂不支持该题型（$wire），请升级客户端',
        style: AppTextStyles.body(context)
            .copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
