// 知识点掌握度：原始行 + 上卷到顶层的纯函数。
//
// 与网页端 lib/subject-nodes.js 的 rollUpByTopNode **同口径**（两端各自实现，
// 判据必须一致：一路走到没有父节点为止；最弱的排最前）。两边对不上的话，
// 学生看到的"我的薄弱点"和老师看到的"班级薄弱点"会是两回事。
//
// 纯 Dart、无 Flutter 依赖，可独立单测。

import 'package:mianyang_quiz/data/models/bank/subject_node.dart';

/// 一个节点上的作答统计（服务端 my_node_accuracy 的原始粒度：课程层）。
class NodeAccuracy {
  const NodeAccuracy({
    required this.nodeId,
    required this.attempts,
    required this.correct,
    this.name = '',
  });

  factory NodeAccuracy.fromJson(Map<String, dynamic> json) => NodeAccuracy(
    nodeId: json['node_id'] as String,
    attempts: (json['attempts'] as num?)?.toInt() ?? 0,
    correct: (json['correct'] as num?)?.toInt() ?? 0,
  );

  final String nodeId;
  final int attempts;
  final int correct;

  /// 节点名（上卷后才填得上；原始行不知道名字）。
  final String name;

  /// attempts == 0 时返回 0——调用方要先判 attempts，别把这个 0 当成"全错"
  /// （与网页端「0 次作答 ≠ 0%」同一条规矩）。
  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// 把课程层的统计归到**顶层节点**上，最弱的排最前（先看要补什么）。
List<NodeAccuracy> rollUpByTopNode(List<NodeAccuracy> rows, List<SubjectNode> nodes) {
  final byId = {for (final node in nodes) node.id: node};
  final grouped = <String, NodeAccuracy>{};

  for (final row in rows) {
    final top = _topAncestor(byId, row.nodeId);
    final cur = grouped[top.id];
    grouped[top.id] = NodeAccuracy(
      nodeId: top.id,
      name: top.name,
      attempts: (cur?.attempts ?? 0) + row.attempts,
      correct: (cur?.correct ?? 0) + row.correct,
    );
  }

  final list = grouped.values.where((g) => g.attempts > 0).toList()
    ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
  return list;
}

SubjectNode _topAncestor(Map<String, SubjectNode> byId, String nodeId) {
  var cur = byId[nodeId];
  if (cur == null) return SubjectNode(id: nodeId, scope: '', kind: '', name: '未选节点');
  // 树最多三层，直接往上走到顶；父节点查不到（数据被删）时就停在当前层
  var guard = 0;
  while (cur!.parentId != null && byId[cur.parentId] != null && guard++ < 10) {
    cur = byId[cur.parentId];
  }
  return cur;
}
