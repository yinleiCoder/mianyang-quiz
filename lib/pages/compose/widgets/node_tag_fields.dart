// 科目与知识点标签两个下拉。
//
// 从 filter_fields.dart 拆出来：它们的选项来自同一批参考数据（科目树 + 标签），
// 与"关键词/题型/难度"那三个就地可算的控件不是一类东西——
// 这两个依赖外部加载，前者不依赖。
//
// 科目用带完整路径的下拉而不是树形弹层：树形选择器在 features/bank 下，
// 跨 feature 引用被架构守卫禁止；而「专业目录 / 装备制造类 / 汽车运用」
// 这样的路径文本在下拉里本来就看得很清楚。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';

class NodeTagFields extends StatelessWidget {
  const NodeTagFields({
    super.key,
    required this.nodes,
    required this.tags,
    required this.selectedNodeId,
    required this.selectedTagId,
    required this.onNodeChanged,
    required this.onTagChanged,
  });

  final List<SubjectNode> nodes;
  final List<QuestionTag> tags;
  final String? selectedNodeId;
  final String? selectedTagId;
  final ValueChanged<String?> onNodeChanged;
  final ValueChanged<String?> onTagChanged;

  @override
  Widget build(BuildContext context) {
    final pathOf = buildNodeIndex(nodes);
    // 只列可挂题的节点（学科与课程）。冻结的节点**仍然列出**——
    // 它只是不能再挂新题，已有题目还在线，不列会让人以为题目消失了。
    final selectable = nodes.where(
      (n) => n.kind == SubjectKind.discipline.wire || n.kind == SubjectKind.course.wire,
    );
    // 知识点跟着**已选科目**收口（0096）：选了「办公应用」就不该挑到别学科的知识点。
    // 没选科目时不过滤——那时连属于哪个学科都还没定。
    final scopedTags = tagsInScope(tags, selectedNodeId, nodes);
    final tagPathOf = TagIndex(tags).ancestorPathOf;
    // 已选的知识点若不在收口范围内（用户先挑了标签、又改了科目），**仍要留在列表里**：
    // DropdownButtonFormField 找不到与 initialValue 匹配的项会直接抛断言。
    // 它排在第一位，用户一眼能看到"这个选项已经不属于当前科目了"。
    final selected = tags.where((t) => t.id == selectedTagId).firstOrNull;
    final tagItems = [
      if (selected != null && !scopedTags.any((t) => t.id == selected.id)) selected,
      ...scopedTags,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('科目'),
        DropdownButtonFormField<String?>(
          // 注意参数名是 initialValue 不是 value（后者已废弃），
          // 且它是 FormField——挂载后只读一次初值，选中值必须由调用方 State 持有
          initialValue: selectedNodeId,
          isExpanded: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          hint: const Text('不限'),
          items: [
            const DropdownMenuItem(value: null, child: Text('不限')),
            for (final node in selectable)
              DropdownMenuItem(
                value: node.id,
                child: Text(
                  pathOf(node.id),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onNodeChanged,
        ),
        const SizedBox(height: AppMetrics.gapLg),
        const _FieldLabel('知识点'),
        DropdownButtonFormField<String?>(
          initialValue: selectedTagId,
          isExpanded: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          hint: const Text('不限'),
          items: [
            const DropdownMenuItem(value: null, child: Text('不限')),
            // 与筛选面板同一口径：按已选科目收口，并显示祖先链
            // （见 utils/tag_tree.dart；两边都改才算改）
            for (final tag in tagItems)
              DropdownMenuItem(
                value: tag.id,
                child: Text(
                  _tagLabel(tag, tagPathOf),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onTagChanged,
        ),
      ],
    );
  }
}

/// 下拉里的标签文案：有父级的带上祖先链（"办公应用 / excel"）。
/// 光看 "excel" 分不出它是顶层知识点还是某一支下面的子项。
String _tagLabel(QuestionTag tag, String Function(String?) ancestorPathOf) {
  final path = ancestorPathOf(tag.id);
  return path.isEmpty ? tag.name : '$path / ${tag.name}';
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppMetrics.gapSm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
