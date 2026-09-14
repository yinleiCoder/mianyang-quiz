// 最近作答流水。
//
// 每行显示：对错图标 + 题干摘要 + 时间。题目已下线或删除时 stem_text 为 null，
// 此时**不显示成空白行**——那看起来像加载失败，而要明确写"题目已不可用"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/stats/recent_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class RecentAnswersSection extends StatelessWidget {
  const RecentAnswersSection({super.key, required this.answers, this.limit = 5});

  final List<RecentAnswer> answers;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (answers.isEmpty) {
      return DuoCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.gapLg,
          vertical: AppMetrics.gapXl,
        ),
        child: Center(
          child: Text(
            '还没有练习记录，去做几道题吧',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final shown = answers.take(limit).toList();

    return DuoCard(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapSm),
      child: Column(
        children: [
          for (final answer in shown)
            _AnswerRow(answer: answer, isLast: answer == shown.last),
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({required this.answer, required this.isLast});

  final RecentAnswer answer;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final correct = answer.isCorrect == true;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: scheme.outlineVariant, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.gapLg,
        vertical: AppMetrics.gapMd,
      ),
      child: Row(
        children: [
          Icon(
            correct ? Icons.check_circle : Icons.cancel,
            size: 20.r,
            color: correct ? context.semantic.success : scheme.error,
          ),
          const SizedBox(width: AppMetrics.gapMd),
          Expanded(
            child: Text(
              answer.isAvailable ? answer.stemText! : '题目已不可用',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: answer.isAvailable ? null : scheme.onSurfaceVariant,
                fontStyle: answer.isAvailable ? null : FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: AppMetrics.gapSm),
          Text(
            Formatters.relative(answer.answeredAt),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
