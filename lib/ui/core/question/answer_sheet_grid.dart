// 答题卡：按题型分组，一格一道题，点击跳题。
//
// 练习与考试都要它，两边的差别**只有格子有哪些状态**（练习判过对错，考试在交卷前
// 谁都不知道对错）。所以格子的状态由调用方算好喂进来——这正是 ui/core 的规矩：
// 只收数据与回调，不认识 runner、sessionId、仓储。数据形状与分组口径见
// answer_sheet_data.dart。
//
// 抄第二份的代价不是多几十行，而是**两边的边界行为会漂移**：改了一处没改另一处，
// 表现是"练习的答题卡能跳、考试的跳错一格"，而且没有编译错误能发现它。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/ui/core/question/answer_sheet_data.dart';

class AnswerSheetGrid extends StatelessWidget {
  const AnswerSheetGrid({
    super.key,
    required this.groups,
    required this.onJump,
    required this.typeLabel,
    this.summary,
  });

  final List<AnswerSheetGroup> groups;

  /// 点了某一格。参数是**题目下标**（0 起），不是显示出来的题号。
  final ValueChanged<int> onJump;

  /// 线格式题型 → 中文组名（core 不引 feature 的映射表，由调用方给）。
  final String Function(String qtypeWire) typeLabel;

  /// 「已作答 3/20」那一行；不传就不显示（考试用它，练习也用）。
  final String? summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        Text(
          '答题卡',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (summary != null)
          Text(
            summary!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        for (final group in groups) ...[
          const SizedBox(height: AppMetrics.gapLg),
          _GroupHeader(
            label: typeLabel(group.label),
            count: group.cells.length,
          ),
          const SizedBox(height: AppMetrics.gapSm),
          Wrap(
            spacing: AppMetrics.gapSm.r,
            runSpacing: AppMetrics.gapSm.r,
            children: [
              for (final cell in group.cells)
                _Cell(
                  number: cell.index + 1,
                  state: cell.state,
                  onTap: () => onJump(cell.index),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: AppMetrics.gapXs),
        Text(
          '$count 题',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.number, required this.state, required this.onTap});

  final int number;
  final AnswerSheetCellState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final (background, foreground, border) = switch (state) {
      // 当前题：实心主色，一眼看到"我在哪"
      AnswerSheetCellState.current => (scheme.primary, scheme.onPrimary, scheme.primary),
      AnswerSheetCellState.correct => (
        semantic.successContainer,
        semantic.onSuccessContainer,
        semantic.success,
      ),
      AnswerSheetCellState.wrong => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        scheme.error,
      ),
      // 答了但还没判（批量练习、考试交卷前）：主色浅底，表示"已完成但还不知道对错"
      AnswerSheetCellState.answered => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        scheme.primary,
      ),
      AnswerSheetCellState.untouched => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        scheme.outlineVariant,
      ),
    };

    return Semantics(
      button: true,
      label: '第 $number 题',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
          ),
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}
