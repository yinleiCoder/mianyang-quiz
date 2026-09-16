// 答题卡：按题型分组，一格一道题，点击跳题。
//
// 职责：把整卷的"位置 + 状态"画出来（当前题 / 已答对 / 已答错 / 已作答未判 / 未作答），
// 并把点击转成 onJump(题号索引)。
// 不负责：跳题本身（PracticeRunner.jumpTo）、宽窄屏怎么摆（PracticeLayout 决定：
// 宽屏常驻右侧、窄屏进 bottom sheet）。
//
// 分组口径：按**题型**（单选/多选/判断/填空/主观/复合），不按难度或页码——
// 用户找题时的心理单位是"那道选择题"，题号在组内连续，扫一眼就能定位。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';

/// 一格的状态。判定优先级：当前题 > 判过 > 答过 > 没答。
enum _CellState { current, correct, wrong, answered, untouched }

class AnswerSheet extends StatelessWidget {
  const AnswerSheet({super.key, required this.runner, required this.onJump});

  final PracticeRunner runner;

  /// 参数是**题目索引**（从 0 开始，与 runner.jumpTo 同口径）。
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = _groups();

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        Text(
          '答题卡',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          '已作答 ${runner.answeredCount}/${runner.total}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        for (final group in groups) ...[
          const SizedBox(height: AppMetrics.gapLg),
          _GroupHeader(label: group.label, count: group.indices.length),
          const SizedBox(height: AppMetrics.gapSm),
          Wrap(
            spacing: AppMetrics.gapSm.r,
            runSpacing: AppMetrics.gapSm.r,
            children: [
              for (final index in group.indices)
                _Cell(
                  number: index + 1,
                  state: _stateOf(index),
                  onTap: () => onJump(index),
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// 按题型分组，组间保持"首次出现的顺序"（题目顺序即试卷顺序，不重排）。
  List<({String label, List<int> indices})> _groups() {
    final byType = <QuestionType, List<int>>{};
    for (var i = 0; i < runner.total; i++) {
      byType
          .putIfAbsent(runner.itemAt(i).type, () => [])
          .add(i);
    }
    return [
      for (final entry in byType.entries)
        (label: entry.key.label, indices: entry.value),
    ];
  }

  _CellState _stateOf(int index) {
    final runtime = runner.runtimeAt(index);
    if (index == runner.index) return _CellState.current;
    if (runtime.verdict == true || runtime.selfMastered == true) {
      return _CellState.correct;
    }
    if (runtime.verdict == false || runtime.selfMastered == false) {
      return _CellState.wrong;
    }
    return runtime.isAnswered ? _CellState.answered : _CellState.untouched;
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
  final _CellState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final (background, foreground, border) = switch (state) {
      // 当前题：实心主色，一眼看到"我在哪"
      _CellState.current => (scheme.primary, scheme.onPrimary, scheme.primary),
      _CellState.correct => (
        semantic.successContainer,
        semantic.onSuccessContainer,
        semantic.success,
      ),
      _CellState.wrong => (scheme.errorContainer, scheme.onErrorContainer, scheme.error),
      // 答了但还没判（批量模式）：主色浅底，表示"已完成但还不知道对错"
      _CellState.answered => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        scheme.primary,
      ),
      _CellState.untouched => (
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
