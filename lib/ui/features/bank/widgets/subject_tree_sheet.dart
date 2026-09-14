// 科目树选择面板（底部弹出）。
//
// 职责：把 domain/subject_tree.dart 的 buildTrees 结果渲染成两棵可展开的树
// （公共科目 / 专业目录），并把用户选中的节点 id 交回去。
// 不负责：树的构建（纯函数在 domain/subject_tree.dart）、条件持久化（调用方 BankFilterSheet）。
//
// 选择语义：**每个节点都可选，包括父节点**——选中"专业大类"的含义是"它下面所有课程"，
// 与 QuestionRepository 用 subtreeIds 展开的语义一致。不做"只能选叶子"的限制，
// 否则用户想按整个大类筛的时候会没有可点的东西。
//
// 返回值约定（三层）：
//   null  用户直接关掉面板 —— 保持原值不变
//   ''    点了「不限」      —— 清除科目条件
//   其他  节点 id

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/subject_tree_branch.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class SubjectTreeSheet extends StatefulWidget {
  const SubjectTreeSheet({super.key, required this.nodes, this.selectedId});

  final List<SubjectNode> nodes;

  /// 当前已选节点，用于高亮与自动展开它的祖先链。
  final String? selectedId;

  /// 底部弹出，返回见文件头注释。
  static Future<String?> show(
    BuildContext context, {
    required List<SubjectNode> nodes,
    String? selectedId,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      // 拖动提示条交给框架画，两个 sheet 的顶部形态自然一致
      showDragHandle: true,
      builder: (_) => SubjectTreeSheet(nodes: nodes, selectedId: selectedId),
    );
  }

  @override
  State<SubjectTreeSheet> createState() => _SubjectTreeSheetState();
}

class _SubjectTreeSheetState extends State<SubjectTreeSheet> {
  late final Map<String, List<TreeEntry>> _trees = buildTrees(widget.nodes);
  late final Set<String> _expanded = _ancestorsOfSelection();

  /// 默认展开已选节点的祖先链：否则重新打开面板时看不到自己选在哪。
  Set<String> _ancestorsOfSelection() {
    final byId = {for (final node in widget.nodes) node.id: node};
    final open = <String>{};
    var current = byId[widget.selectedId];
    while (current != null) {
      open.add(current.id);
      final parentId = current.parentId;
      current = parentId == null ? null : byId[parentId];
    }
    return open;
  }

  void _toggle(String nodeId) => setState(() {
    if (!_expanded.remove(nodeId)) _expanded.add(nodeId);
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
              child: Text(
                '选择科目',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle(context),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppMetrics.pagePadding.r,
                  0,
                  AppMetrics.pagePadding.r,
                  AppMetrics.gapLg.r,
                ),
                child: MaxWidthBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _row(
                        context,
                        leading: Icons.clear_all_rounded,
                        label: '不限（全部科目）',
                        selected: widget.selectedId == null,
                        onTap: () => Navigator.of(context).pop(''),
                      ),
                      SizedBox(height: AppMetrics.gapLg.r),
                      for (final scope in SubjectScope.values)
                        if (_trees[scope.wire]?.isNotEmpty ?? false) ...[
                          SectionHeader(
                            title: scope.label,
                            subtitle:
                                '共 ${countTreeNodes(_trees[scope.wire]!)} 个节点',
                          ),
                          for (final entry in _trees[scope.wire]!)
                            SubjectTreeBranch(
                              entry: entry,
                              expanded: _expanded,
                              selectedId: widget.selectedId,
                              onToggle: _toggle,
                              onPick: (id) => Navigator.of(context).pop(id),
                            ),
                          SizedBox(height: AppMetrics.gapLg.r),
                        ],
                    ],
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.all(AppMetrics.gapMd.r),
              child: Text(
                '选中一个分类 = 它下面的全部课程；父分类可以直接选。',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 「不限」与其它单行条目共用的行样式。
Widget _row(
  BuildContext context, {
  required IconData leading,
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  final scheme = Theme.of(context).colorScheme;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapSm.r,
        vertical: AppMetrics.gapMd.r,
      ),
      child: Row(
        children: [
          Icon(
            leading,
            size: 20.r,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body(context).copyWith(
                color: selected ? scheme.primary : null,
                fontWeight: selected ? FontWeight.w700 : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
