// 组卷的筛选条件：关键词、科目、题型、难度、标签。
//
// 与题库列表的筛选维度**刻意保持一致**——两处能选的东西不同会让人困惑
// （"为什么这里能按标签筛、组卷不能？"）。共用的值对象是 QuestionFilter，
// 参数映射由它的 toRpcParams() 负责，本组件只管收集。
//
// 科目在这里是**三级级联下拉**（大类 → 专业 → 课程），题库那边是树形弹层：
// 两个控件的筛选语义完全一致（都交回一个节点 id，服务端按子树展开），
// 只是组卷页是一张紧凑的表单卡片，逐级下拉比弹一整棵树更顺手。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/compose/widgets/node_tag_fields.dart';
import 'package:provider/provider.dart';

/// 参考数据（科目树与标签）的加载结果，两处下拉共用。
typedef _Reference = ({List<SubjectNode> nodes, List<QuestionTag> tags});

class FilterFields extends StatefulWidget {
  const FilterFields({super.key, required this.value, required this.onChanged});

  final QuestionFilter value;
  final ValueChanged<QuestionFilter> onChanged;

  @override
  State<FilterFields> createState() => _FilterFieldsState();
}

class _FilterFieldsState extends State<FilterFields> {
  late final TextEditingController _keyword =
      TextEditingController(text: widget.value.keyword);
  AsyncValue<_Reference> _reference = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _loadReference();
  }

  @override
  void dispose() {
    _keyword.dispose();
    super.dispose();
  }

  Future<void> _loadReference() async {
    setState(() => _reference = const AsyncLoading());
    try {
      final repo = context.read<SubjectRepository>();
      final nodes = await repo.fetchNodes();
      final tags = await repo.fetchTags();
      if (!mounted) return;
      setState(() => _reference = AsyncData((nodes: nodes, tags: tags)));
    } catch (error) {
      if (!mounted) return;
      setState(() => _reference = const AsyncData((nodes: [], tags: [])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;

    return DuoCard(
      padding: const EdgeInsets.all(AppMetrics.gapLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _keyword,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              labelText: '题干关键词',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onSubmitted: (text) =>
                widget.onChanged(value.copyWith(keyword: text)),
          ),
          const SizedBox(height: AppMetrics.gapLg),
          const _Label('题型'),
          _QtypeChips(
            selected: value.qtypes,
            onToggle: (type) {
              final next = Set<QuestionType>.of(value.qtypes);
              if (!next.remove(type)) next.add(type);
              widget.onChanged(value.copyWith(qtypes: next));
            },
          ),
          const SizedBox(height: AppMetrics.gapLg),
          const _Label('难度'),
          // 多选，与上面的题型同一个控件（题库筛选面板里也是它）：
          // 单选时想练"易 + 中"只能开两场，而题型一直是多选，两处口径不该不一样。
          FilterChipGroup<int>(
            items: kDifficultyValues,
            labelOf: difficultyLabel,
            selectedOf: value.difficulties.contains,
            // 再点一次即取消；一个都不选 = 不限，所以不需要额外的"清除"按钮
            onToggle: (level) {
              final next = Set<int>.of(value.difficulties);
              if (!next.remove(level)) next.add(level);
              widget.onChanged(value.copyWith(difficulties: next));
            },
          ),
          const SizedBox(height: AppMetrics.gapLg),
          switch (_reference) {
            AsyncLoading() => const LinearProgressIndicator(),
            AsyncFailure() => const LinearProgressIndicator(),
            AsyncData(:final value) => NodeTagFields(
              nodes: value.nodes,
              tags: value.tags,
              selectedNodeId: widget.value.nodeId,
              selectedTagId: widget.value.tagId,
              // freezed 的 copyWith 对可空字段传 null 即是"清空"，不需要额外标记
              onNodeChanged: (id) =>
                  widget.onChanged(widget.value.copyWith(nodeId: id)),
              onTagChanged: (id) =>
                  widget.onChanged(widget.value.copyWith(tagId: id)),
            ),
          },
        ],
      ),
    );
  }
}

class _QtypeChips extends StatelessWidget {
  const _QtypeChips({required this.selected, required this.onToggle});

  final Set<QuestionType> selected;
  final ValueChanged<QuestionType> onToggle;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppMetrics.gapSm,
    runSpacing: AppMetrics.gapSm,
    children: [
      for (final type in QuestionType.values)
        if (type != QuestionType.unknown)
          FilterChip(
            label: Text(type.label),
            selected: selected.contains(type),
            onSelected: (_) => onToggle(type),
          ),
    ],
  );
}

/// 字段标题。留在本文件：它只服务 `_QtypeChips` 这一个就地可算的控件，
/// 与迁出去的 NodeTagFields 里的同名标签是各自独立的排版细节。
/// （难度改用共用的 FilterChipGroup，标题仍走这里。）
class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppMetrics.gapSm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
