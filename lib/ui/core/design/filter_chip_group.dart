// 一组可选的筛选胶囊（题型、标签共用）。
//
// 职责：把「一组候选值」渲染成自动换行的 chip 群，把选中状态与点击交给调用方判断——
// 因此它同时能表达多选（题型：点一下加一个）与单选（标签：点一下换一个，再点取消）。
// 不负责：选中逻辑本身（在 BankFilterForm 的 setState 里），也不认识任何具体业务类型。
//
// 用泛型而不是为题型、标签各写一遍：两者的交互完全相同，差的只是元素类型与显示文案。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

class FilterChipGroup<T> extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.items,
    required this.labelOf,
    required this.selectedOf,
    required this.onToggle,
    this.maxHeight,
  });

  final List<T> items;

  /// 元素 → chip 上的文字。
  final String Function(T item) labelOf;

  /// 元素当前是否被选中。
  final bool Function(T item) selectedOf;

  /// 点击某个元素（加选或取消由调用方决定）。
  final ValueChanged<T> onToggle;

  /// 限高后可竖向滚动。标签动辄上百个，不限高会把面板撑成一整屏；null 表示不限。
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final wrap = Wrap(
      spacing: AppMetrics.gapSm.r,
      runSpacing: AppMetrics.gapSm.r,
      children: [
        for (final item in items)
          FilterChip(
            label: Text(labelOf(item)),
            selected: selectedOf(item),
            onSelected: (_) => onToggle(item),
          ),
      ],
    );

    if (maxHeight == null) return wrap;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight!.r),
      child: SingleChildScrollView(child: wrap),
    );
  }
}
