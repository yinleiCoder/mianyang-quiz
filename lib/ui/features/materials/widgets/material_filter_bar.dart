// 资料列表顶部的筛选条：把已选条件显示成一行 chip + 「筛选」「清除」。
//
// 纯展示 + 几个回调，自己不持状态（条件在页面的 State 里）——
// 与 bank_filter_bar 同款分工，改了条件由页面重新取数。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/material/material_filter.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class MaterialFilterBar extends StatelessWidget {
  const MaterialFilterBar({
    super.key,
    required this.filter,
    required this.nodePath,
    required this.onOpenSheet,
    required this.onClear,
  });

  final MaterialFilter filter;

  /// 已选学科的可读名称链；空串表示没选。
  final String nodePath;
  final VoidCallback onOpenSheet;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyword = filter.keyword.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppMetrics.pagePadding.r,
        AppMetrics.gapSm.r,
        AppMetrics.pagePadding.r,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '复习资料',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onOpenSheet,
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('筛选'),
              ),
              if (filter.hasAny)
                TextButton(onPressed: onClear, child: const Text('清除')),
            ],
          ),
          // 条件为空时不占位：一行空白会把列表往下推，第一屏少看一条
          if (filter.hasAny)
            Padding(
              padding: EdgeInsets.only(bottom: AppMetrics.gapSm.r),
              child: Wrap(
                spacing: AppMetrics.gapSm.r,
                runSpacing: AppMetrics.gapSm.r,
                children: [
                  if (keyword.isNotEmpty) DuoChip(label: '“$keyword”'),
                  if (nodePath.isNotEmpty) DuoChip(label: nodePath),
                  for (final kind in filter.kinds) DuoChip(label: kind.label),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
