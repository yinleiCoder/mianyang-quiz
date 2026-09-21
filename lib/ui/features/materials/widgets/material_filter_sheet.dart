// 资料筛选面板：关键词 + 类型 + 学科/专业大类。
//
// **草稿模式**（与 bank_filter_sheet 同一条约定）：面板里改的是一份草稿，
// 点「查看结果」才整体 pop 回去。取消（下滑关闭 / 返回）返回 null，
// 调用方保持原条件不变 —— 这与"重置"是两回事。
//
// 为什么不在面板里边改边查：每改一次就发一次请求既费流量，又会让面板背后的列表乱跳。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/material_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/material/material_filter.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/filter_chip_group.dart';
import 'package:mianyang_quiz/ui/core/subject/subject_picker_row.dart';
import 'package:mianyang_quiz/ui/core/subject/subject_tree_sheet.dart';

class MaterialFilterSheet extends StatefulWidget {
  const MaterialFilterSheet({
    super.key,
    required this.initial,
    required this.nodes,
  });

  final MaterialFilter initial;
  final List<SubjectNode> nodes;

  /// 底部弹出；返回 null 表示用户取消（保持原条件）。
  static Future<MaterialFilter?> show(
    BuildContext context, {
    required MaterialFilter initial,
    required List<SubjectNode> nodes,
  }) {
    return showModalBottomSheet<MaterialFilter>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => MaterialFilterSheet(initial: initial, nodes: nodes),
    );
  }

  @override
  State<MaterialFilterSheet> createState() => _MaterialFilterSheetState();
}

class _MaterialFilterSheetState extends State<MaterialFilterSheet> {
  late TextEditingController _keyword;
  late Set<MaterialKind> _kinds;
  late String? _nodeId;

  @override
  void initState() {
    super.initState();
    _keyword = TextEditingController(text: widget.initial.keyword);
    _kinds = {...widget.initial.kinds};
    _nodeId = widget.initial.nodeId;
  }

  @override
  void dispose() {
    _keyword.dispose();
    super.dispose();
  }

  Future<void> _pickNode() async {
    final picked = await SubjectTreeSheet.show(
      context,
      nodes: widget.nodes,
      selectedId: _nodeId,
    );
    if (picked == null || !mounted) return;
    setState(() => _nodeId = picked);
  }

  void _apply() {
    Navigator.of(context).pop(
      MaterialFilter(
        keyword: _keyword.text.trim(),
        nodeId: _nodeId,
        kinds: _kinds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppMetrics.pagePadding,
          0,
          AppMetrics.pagePadding,
          AppMetrics.pagePadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '筛选资料',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppMetrics.gapLg.r),

              Text('关键词', style: theme.textTheme.labelLarge),
              SizedBox(height: AppMetrics.gapSm.r),
              TextField(
                controller: _keyword,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: '搜标题或简介',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _apply(),
              ),
              SizedBox(height: AppMetrics.gapLg.r),

              Text('类型', style: theme.textTheme.labelLarge),
              SizedBox(height: AppMetrics.gapSm.r),
              FilterChipGroup<MaterialKind>(
                items: MaterialKind.values.where((k) => k != MaterialKind.other).toList(),
                labelOf: (kind) => kind.label,
                selectedOf: (kind) => _kinds.contains(kind),
                onToggle: (kind) => setState(() {
                  if (!_kinds.remove(kind)) _kinds.add(kind);
                }),
              ),
              SizedBox(height: AppMetrics.gapLg.r),

              Text('学科 / 专业大类', style: theme.textTheme.labelLarge),
              SizedBox(height: AppMetrics.gapSm.r),
              SubjectPickerRow(
                // 面板每次打开都重建，索引算一次就够
                path: _nodeId == null ? '' : buildNodeIndex(widget.nodes)(_nodeId),
                onTap: _pickNode,
              ),
              SizedBox(height: AppMetrics.gapXl.r),

              DuoButton(label: '查看结果', icon: Icons.search, onPressed: _apply),
            ],
          ),
        ),
      ),
    );
  }
}
