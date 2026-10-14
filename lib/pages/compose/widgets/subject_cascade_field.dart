// 科目三级级联：专业大类 → 专业 → 课程（公共科目只有两级：学科 → 课程）。
//
// 为什么要有它：2026-09-24 起题目可以挂在**任意层级**的科目节点上（服务端 0075，
// 与网页端 lib/subject-nodes.js 的 isAttachable 同口径）。而组卷页此前只列
// 「公共学科 + 课程」（旧口径：只有末端能挂题），于是挂在「汽修」这种专业节点下、
// 下面还没有课程的题**在这里根本选不到**，也就刷不到。
//
// 语义：**筛选值 = 最深的那个已选节点**。服务端会按子树展开（选中父节点 = 它连同
// 它下面的全部），所以「不选专业或课程」不是特例：一级选了「汽修」、二级不选，
// 练的就是整个汽修；一级也不选 = 全部科目（nodeId 置空）。
//
// 各级的选中态**由 nodeId 在树里的祖先链推出来**，不另存三个状态：
// 筛选项里只有一个 nodeId，两个真源迟早会漂移（例如「清除筛选」只清了其中一个）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';

class SubjectCascadeField extends StatelessWidget {
  const SubjectCascadeField({
    super.key,
    required this.nodes,
    required this.selectedNodeId,
    required this.onChanged,
  });

  final List<SubjectNode> nodes;

  /// 当前筛选的科目节点。空 = 全部科目。
  final String? selectedNodeId;

  /// 交回**最深的已选节点**；一级选「不限」时交回 null。
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final chain = ancestorChain(nodes, selectedNodeId);
    final picked1 = chain.isNotEmpty ? chain[0] : null;
    final picked2 = chain.length > 1 ? chain[1] : null;
    final picked3 = chain.length > 2 ? chain[2] : null;

    // 顶级是两棵树的根混在一起：公共学科（语文…）与专业大类（汽修…）。
    // 它们分得清是因为下一级的标题会跟着数据变成「课程」或「专业」。
    final level1 = childNodes(nodes, null);
    final level2 = picked1 == null
        ? const <SubjectNode>[]
        : childNodes(nodes, picked1);
    final level3 = picked2 == null
        ? const <SubjectNode>[]
        : childNodes(nodes, picked2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('科目'),
        _LevelDropdown(nodes: level1, value: picked1, onChanged: onChanged),
        if (level2.isNotEmpty) ...[
          const SizedBox(height: AppMetrics.gapLg),
          _Label(_kindLabelOf(level2, '专业')),
          // 「不限」= 停在上一级：选了大类不选专业，就是整个大类
          _LevelDropdown(
            nodes: level2,
            value: picked2,
            onChanged: (id) => onChanged(id ?? picked1),
          ),
        ],
        if (level3.isNotEmpty) ...[
          const SizedBox(height: AppMetrics.gapLg),
          _Label(_kindLabelOf(level3, '课程')),
          _LevelDropdown(
            nodes: level3,
            value: picked3,
            onChanged: (id) => onChanged(id ?? picked2),
          ),
        ],
      ],
    );
  }
}

/// 这一级的选项是什么类型（专业 / 课程）。
///
/// **跟着数据走，不写死**：公共科目树只有两级（学科 → 课程），专业目录是三级；
/// 写死"专业"会在公共科目上撒谎。同级混了多种类型（脏数据）时才退回默认词。
String _kindLabelOf(List<SubjectNode> children, String fallback) {
  final kinds = {for (final node in children) node.kindLabel};
  return kinds.length == 1 ? kinds.first : fallback;
}

/// 一级下拉。选项只显示节点名：同一个父节点下不会有重名（服务端建节点时校验），
/// 所以不必像之前那个平铺下拉那样把整条路径都印出来。
class _LevelDropdown extends StatelessWidget {
  const _LevelDropdown({
    required this.nodes,
    required this.value,
    required this.onChanged,
  });

  final List<SubjectNode> nodes;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String?>(
    // 参数名是 initialValue（value 已废弃）。它**会**跟着 initialValue 走
    // （_DropdownButtonFormFieldState.didUpdateWidget → setValue），
    // 所以上面改了级联、这一级的显示就跟着重算。
    initialValue: value,
    isExpanded: true,
    decoration: const InputDecoration(border: OutlineInputBorder()),
    hint: const Text('不限'),
    items: [
      const DropdownMenuItem(value: null, child: Text('不限')),
      for (final node in nodes)
        DropdownMenuItem(
          value: node.id,
          child: Text(
            node.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ],
    onChanged: onChanged,
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppMetrics.gapSm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
