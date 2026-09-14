// 标准答案的**只读**展示：「正确答案：A、C」。
//
// 职责：把答案渲染成一行可读文字。
//   · 选择题的 key 会按 optionOrder 折算成**显示字母**——乱序后屏幕上的 A 可能对应原始 C，
//     直接印原始 key 会与用户眼前的选项对不上。
//   · 复合题**逐子题**渲染：根节点没有 answer，答案在各 sub[i].answer 里。
//     服务端 submit_practice_answer 返回的 correctAnswer 对复合题同样是 null，
//     所以只读顶层会显示成一片空白——这是本组件最容易做错的地方。
// 不负责：判定对错、作答交互（那是输入视图的事）、解析正文（AnalysisView）。
// 颜色取主题的语义绿（context.semantic.success），与 OptionTile 的「对」保持同一口径。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/domain/option_order.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class AnswerSummaryView extends StatelessWidget {
  const AnswerSummaryView({
    super.key,
    required this.content,
    this.optionOrder,
    this.title,
  });

  /// 整题内容。复合题传根节点，本组件自己逐子题展开。
  final QuestionContent content;

  /// 选项显示顺序（原始 key 序列），与 QuestionView.shuffledKeys 传同一个值。
  final List<String>? optionOrder;

  /// 覆盖标题；null 时按答案类型自动取「正确答案」/「参考答案」。
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (content.isComposite) {
      // 子题各自带 answer；根节点没有，不能只看顶层。
      // 子题不可能是复合题（数据库约束），所以这里不需要递归。
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < content.sub.length; i++) ...[
            if (i > 0) SizedBox(height: AppMetrics.gapSm.r),
            _SubAnswer(index: i, answer: content.sub[i].answer, title: title),
          ],
        ],
      );
    }

    final answer = content.answer;
    final text = answerSummaryText(answer, optionOrder);
    if (text.isEmpty) {
      return Text(
        '（本题没有标准答案）',
        style: AppTextStyles.caption(context)
            .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
    }
    return _AnswerLine(title: title ?? _defaultTitle(answer), text: text);
  }
}

/// 答案的纯文本形式。公开：刷题反馈条等只需要一句文本的地方直接用，
/// 免得又造一套「A、C」的拼法。空串表示没有可展示的答案（调用方决定怎么提示）。
String answerSummaryText(ServerAnswer? answer, List<String>? optionOrder) {
  switch (answer) {
    case null:
      return '';
    case ChoiceServerAnswer(:final keys):
      final letters = keys
          .where((key) => key.trim().isNotEmpty)
          .map((key) => _displayLetter(key, optionOrder));
      return letters.join('、');
    case TrueFalseServerAnswer(:final value):
      return value ? '正确' : '错误';
    case BlankServerAnswer(:final values):
      final filled = <String>[];
      for (var i = 0; i < values.length; i++) {
        final value = values[i].trim();
        if (value.isEmpty) continue;
        // 多个空时标上空位序号，否则一串答案看不出谁对应哪个空
        filled.add(values.length > 1 ? '第 ${i + 1} 空 $value' : value);
      }
      return filled.join('；');
    case TextServerAnswer(:final samples):
      return samples
          .map((sample) => sample.trim())
          .where((sample) => sample.isNotEmpty)
          .join('\n');
  }
}

/// 原始 key → 屏幕上的显示字母。不在显示顺序里（脏数据）时退回原始 key，
/// 宁可显示得古怪，也不要凭空显示一个不存在的字母。
String _displayLetter(String key, List<String>? optionOrder) {
  final index = optionOrder?.indexOf(key.trim()) ?? -1;
  return index >= 0 ? letterOf(index) : key.trim();
}

String _defaultTitle(ServerAnswer? answer) =>
    answer is TextServerAnswer ? '参考答案' : '正确答案';

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title：',
          style: AppTextStyles.label(context).copyWith(color: context.semantic.success),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body(context).copyWith(color: context.semantic.success),
          ),
        ),
      ],
    );
  }
}

/// 复合题的一个子题答案：序号 + 该子题自己那一行答案。
class _SubAnswer extends StatelessWidget {
  const _SubAnswer({
    required this.index,
    required this.answer,
    required this.title,
  });

  final int index;
  final ServerAnswer? answer;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = answerSummaryText(answer, null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '第 ${index + 1} 题',
          style: AppTextStyles.caption(context)
              .copyWith(color: scheme.onSurfaceVariant),
        ),
        SizedBox(height: AppMetrics.gapXs.r),
        if (text.isEmpty)
          Text(
            '（本小题没有标准答案）',
            style: AppTextStyles.caption(context)
                .copyWith(color: scheme.onSurfaceVariant),
          )
        else
          _AnswerLine(title: title ?? _defaultTitle(answer), text: text),
      ],
    );
  }
}
