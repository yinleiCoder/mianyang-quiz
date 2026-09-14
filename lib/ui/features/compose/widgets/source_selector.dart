// 题目来源选择：题库 / 错题本 / 收藏。
//
// 后两者服务端会自己定题、**忽略筛选条件**，所以选中它们时要明确告诉用户
// 「筛选条件不生效」——否则用户调了半天科目、结果发现筛选没起作用。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';

class SourceSelector extends StatelessWidget {
  const SourceSelector({super.key, required this.value, required this.onChanged});

  final PracticeSource value;
  final ValueChanged<PracticeSource> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final source in PracticeSource.values) ...[
              Expanded(
                child: _SourceChip(
                  label: source.label,
                  selected: source == value,
                  onTap: () => onChanged(source),
                ),
              ),
              if (source != PracticeSource.values.last)
                const SizedBox(width: AppMetrics.gapSm),
            ],
          ],
        ),
        if (value != PracticeSource.all) ...[
          const SizedBox(height: AppMetrics.gapMd),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppMetrics.gapSm),
              Expanded(
                child: Text(
                  '从${value.label}出题时，题库筛选条件不生效，题量也由系统决定',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapMd),
          decoration: BoxDecoration(
            color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? AppMetrics.stroke : AppMetrics.hairline,
            ),
            borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
