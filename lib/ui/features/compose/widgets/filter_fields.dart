// 组卷的筛选条件：关键词、科目、题型、难度、标签。
//
// 与题库列表的筛选维度**刻意保持一致**——两处能选的东西不同会让人困惑
// （"为什么这里能按标签筛、组卷不能？"）。共用的值对象是 QuestionFilter，
// 参数映射由它的 toRpcParams() 负责，本组件只管收集。
//
// 科目用带完整路径的下拉而不是树形弹层：树形选择器在 features/bank 下，
// 跨 feature 引用被架构守卫禁止；而"专业目录 / 装备制造类 / 汽车运用"这样的
// 路径文本在下拉里本来就看得很清楚。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/node_tag_fields.dart';
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
          _DifficultyChips(
            selected: value.difficulty,
            // 再点一次即取消（回到不限），不必额外给"清除"按钮
            onSelected: (level) => widget.onChanged(
              value.copyWith(difficulty: value.difficulty == level ? null : level),
            ),
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

class _DifficultyChips extends StatelessWidget {
  const _DifficultyChips({required this.selected, required this.onSelected});

  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppMetrics.gapSm,
    children: [
      for (final level in kDifficultyValues)
        ChoiceChip(
          label: Text(difficultyLabel(level)),
          selected: selected == level,
          onSelected: (_) => onSelected(level),
        ),
    ],
  );
}

/// 字段标题。留在本文件：它只服务这两个就地可算的控件，
/// 与迁出去的 NodeTagFields 里的同名标签是各自独立的排版细节。
class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppMetrics.gapSm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
