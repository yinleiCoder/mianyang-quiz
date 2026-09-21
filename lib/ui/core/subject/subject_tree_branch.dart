// 科目树的一棵子树（递归）。从 SubjectTreeSheet 拆出来只是为了单文件行数，
// 它本身没有独立语义：由面板传入展开集合、已选 id 与两个回调。
//
// 交互约定：
//   · 整行可点 = 选中该节点（父节点可选，含义是"它下面所有课程"）
//   · 有子节点时左侧多一个箭头，点箭头只展开/收起，不改变选择
//
// 不负责：树的构建（domain/subject_tree.dart）、选中结果的传递（面板 pop 出去）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class SubjectTreeBranch extends StatelessWidget {
  const SubjectTreeBranch({
    super.key,
    required this.entry,
    required this.expanded,
    required this.selectedId,
    required this.onToggle,
    required this.onPick,
    this.depth = 0,
  });

  final TreeEntry entry;

  /// 已展开的节点 id 集合（由面板持有，逐层传下来）。
  final Set<String> expanded;

  final String? selectedId;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onPick;

  /// 缩进层级，根节点为 0。
  final int depth;

  @override
  Widget build(BuildContext context) {
    final node = entry.node;
    final open = expanded.contains(node.id);
    final selected = node.id == selectedId;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => onPick(node.id),
          borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
          child: Padding(
            padding: EdgeInsets.only(
              left: (AppMetrics.gapSm + depth * AppMetrics.gapLg).r,
              right: AppMetrics.gapSm.r,
              top: AppMetrics.gapSm.r,
              bottom: AppMetrics.gapSm.r,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28.r,
                  child: entry.children.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () => onToggle(node.id),
                          iconSize: 18.r,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          tooltip: open ? '收起' : '展开',
                          icon: Icon(
                            open
                                ? Icons.expand_more_rounded
                                : Icons.chevron_right_rounded,
                          ),
                        ),
                ),
                SizedBox(width: AppMetrics.gapXs.r),
                Expanded(
                  child: Text(
                    node.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(context).copyWith(
                      color: selected ? theme.colorScheme.primary : null,
                      fontWeight: selected ? FontWeight.w700 : null,
                    ),
                  ),
                ),
                SizedBox(width: AppMetrics.gapSm.r),
                DuoChip(label: node.kindLabel, dense: true),
                if (selected) ...[
                  SizedBox(width: AppMetrics.gapXs.r),
                  Icon(
                    Icons.check_circle,
                    size: 18.r,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (open)
          for (final child in entry.children)
            SubjectTreeBranch(
              entry: child,
              depth: depth + 1,
              expanded: expanded,
              selectedId: selectedId,
              onToggle: onToggle,
              onPick: onPick,
            ),
      ],
    );
  }
}
