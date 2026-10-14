// 科目与知识点标签两组字段。
//
// 从 filter_fields.dart 拆出来：它们的选项来自同一批参考数据（科目树 + 标签），
// 与"关键词/题型/难度"那三个就地可算的控件不是一类东西——
// 这两组依赖外部加载，前者不依赖。
//
// 科目是**三级级联**（专业大类 → 专业 → 课程），见 subject_cascade_field.dart。
// 这里此前是一个"只列公共学科与课程"的下拉（旧口径：只有末端能挂题），
// 挂在专业节点（如「汽修」）下的题因此在组卷页选不到。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/compose/widgets/subject_cascade_field.dart';

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
        SubjectCascadeField(
          nodes: nodes,
          selectedNodeId: selectedNodeId,
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
