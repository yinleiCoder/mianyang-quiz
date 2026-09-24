// 知识点上卷的纯逻辑（「我的处境」与班级看板共用同一条口径）。
//
// 为什么值得测：这条口径**网页端也有一份**（lib/subject-nodes.js 的 rollUpByTopNode），
// 两端对不上时，学生看到的"我的薄弱点"和老师看到的"班级薄弱点"会是两回事。
// 这里钉住三件事：归到顶层、最弱的排最前、认不出的节点不炸。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/domain/node_accuracy.dart';

SubjectNode _node(String id, String name, {String? parent}) => SubjectNode(
  id: id,
  scope: 'vocational',
  kind: parent == null ? 'category' : 'course',
  name: name,
  parentId: parent,
);

void main() {
  final tree = [
    _node('cat', '计算机类'),
    _node('major', '计算机应用', parent: 'cat'),
    _node('c1', '办公应用', parent: 'major'),
    _node('c2', '网络基础', parent: 'major'),
  ];

  test('课程层的统计归到顶层节点，最弱的排最前', () {
    final rolled = rollUpByTopNode(const [
      NodeAccuracy(nodeId: 'c1', attempts: 10, correct: 9), // 90%
      NodeAccuracy(nodeId: 'c2', attempts: 10, correct: 2), // 20%
    ], tree);

    // 两门课都挂在同一个大类下 → 归并成一条
    expect(rolled.length, 1);
    expect(rolled.first.name, '计算机类');
    expect(rolled.first.attempts, 20);
    expect(rolled.first.correct, 11);
    expect(rolled.first.accuracy, closeTo(0.55, 0.001));
  });

  test('不同顶层节点的分开算，最弱的在前', () {
    final two = [
      ...tree,
      _node('cat2', '财经类'),
      _node('c3', '会计基础', parent: 'cat2'),
    ];
    final rolled = rollUpByTopNode(const [
      NodeAccuracy(nodeId: 'c1', attempts: 10, correct: 9),
      NodeAccuracy(nodeId: 'c3', attempts: 10, correct: 1),
    ], two);

    expect(rolled.map((n) => n.name).toList(), ['财经类', '计算机类']);
  });

  test('认不出的节点不炸：名字给占位，计数照常计入', () {
    final rolled = rollUpByTopNode(const [
      NodeAccuracy(nodeId: 'gone', attempts: 4, correct: 1),
    ], tree);

    expect(rolled.single.name, '未选节点');
    expect(rolled.single.attempts, 4);
  });

  test('0 次作答的行不会出现在结果里（0 次 ≠ 全错）', () {
    final rolled = rollUpByTopNode(const [
      NodeAccuracy(nodeId: 'c1', attempts: 0, correct: 0),
    ], tree);

    expect(rolled, isEmpty);
  });
}
