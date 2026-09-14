// 科目树纯函数：子树展开与路径合成。
//
// 两个用途：
//   1. **筛选**：选中一个父节点，实际含义是"它及其全部后代"（题库挂在学科/课程上）。
//      服务端的 start_practice_session 内部也这么做，客户端做同样的事是为了
//      题库列表与组卷的语义一致。
//   2. **展示**：节点 id → "专业目录 / 装备制造类 / 汽车运用" 这样的名称链。
//
// 纯函数，无 Flutter 依赖，可独立单测。

import 'package:mianyang_quiz/data/models/bank/subject_node.dart';

/// 节点 id → 其自身与全部后代的 id。
///
/// 防御两件事：
///   · 传入不存在的 id → 返回空列表（调用方据此短路，不必再查库）
///   · 数据成环 → 用 visited 集合截断，绝不无限循环
List<String> subtreeIds(List<SubjectNode> nodes, String rootId) {
  final childrenOf = <String?, List<String>>{};
  final exists = <String>{};
  for (final node in nodes) {
    exists.add(node.id);
    childrenOf.putIfAbsent(node.parentId, () => []).add(node.id);
  }
  if (!exists.contains(rootId)) return const [];

  final result = <String>[];
  final visited = <String>{};
  final stack = <String>[rootId];
  while (stack.isNotEmpty) {
    final id = stack.removeLast();
    if (!visited.add(id)) continue; // 成环保护
    result.add(id);
    for (final child in childrenOf[id] ?? const <String>[]) {
      stack.add(child);
    }
  }
  return result;
}

/// 生成 "根 / … / 自身" 的名称链解析器。
///
/// 返回函数而不是 Map：调用点通常是"逐行取路径"，函数内部带缓存，
/// 同一个节点不会被回溯两次。
///
/// 深度上限用于防御脏数据成环——正常科目树深度不超过 4。
String Function(String? nodeId) buildNodeIndex(List<SubjectNode> nodes) {
  const maxDepth = 10;
  final byId = {for (final node in nodes) node.id: node};
  final cache = <String, String>{};

  return (nodeId) {
    if (nodeId == null || nodeId.isEmpty) return '';
    final cached = cache[nodeId];
    if (cached != null) return cached;

    final parts = <String>[];
    SubjectNode? current = byId[nodeId];
    var depth = 0;
    while (current != null && depth++ < maxDepth) {
      parts.insert(0, current.name);
      final parentId = current.parentId;
      current = parentId == null ? null : byId[parentId];
    }

    final path = parts.join(' / ');
    cache[nodeId] = path;
    return path;
  };
}

/// 按 scope 分组的树结构，供选择器渲染。
///
/// 返回 {common: [根节点…], vocational: [根节点…]}，
/// 每个条目是 (node, children) 的递归结构——直接对应界面上的层级展开。
Map<String, List<TreeEntry>> buildTrees(List<SubjectNode> nodes) {
  final childrenOf = <String?, List<SubjectNode>>{};
  for (final node in nodes) {
    childrenOf.putIfAbsent(node.parentId, () => []).add(node);
  }
  for (final list in childrenOf.values) {
    list.sort((a, b) {
      final byOrder = a.sortOrder.compareTo(b.sortOrder);
      return byOrder != 0 ? byOrder : a.name.compareTo(b.name);
    });
  }

  List<TreeEntry> walk(String? parentId) => [
    for (final node in childrenOf[parentId] ?? const <SubjectNode>[])
      TreeEntry(node: node, children: walk(node.id)),
  ];

  return {'common': walk(null), 'vocational': walk(null)};
}

/// 树的一个条目：节点本身 + 它的子节点。
/// 用类而不是递归 record typedef——后者在 Dart 里不被允许。
class TreeEntry {
  const TreeEntry({required this.node, required this.children});

  final SubjectNode node;
  final List<TreeEntry> children;
}

/// 统计树里的节点总数（选择器上显示"共 N 个节点"）。
int countTreeNodes(List<TreeEntry> entries) {
  var total = 0;
  for (final entry in entries) {
    total += 1 + countTreeNodes(entry.children);
  }
  return total;
}
