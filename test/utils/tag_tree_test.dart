// 知识点范围过滤与路径合成（0096）。
//
// 为什么值得测：这套规则是"学科隔离"在客户端的全部实现，而它的错法全是**静默**的——
// 漏掉"未归类不外泄"这条，某个学科的题就会挑到别的学科的知识点，界面上一点异常都没有；
// 漏掉"没选科目就不过滤"这条，则会把候选清空，看起来像"题库坏了"。
// 服务端 0096 的口径与这里必须一致，改一边就得改另一边。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';

SubjectNode _node(String id, {String? parent, String name = '节点'}) => SubjectNode(
  id: id,
  parentId: parent,
  scope: 'vocational',
  kind: 'course',
  name: name,
);

QuestionTag _tag(String id, {String? subject, String? parent, String name = '知识点'}) =>
    QuestionTag(
      id: id,
      name: name,
      subjectNodeId: subject,
      parentId: parent,
    );

void main() {
  // 计算机(大类) → 计算机(专业) → 办公应用(课程)
  //                           → 网络技术(课程)
  final nodes = [
    _node('cat', name: '计算机'),
    _node('major', parent: 'cat', name: '计算机'),
    _node('office', parent: 'major', name: '办公应用'),
    _node('net', parent: 'major', name: '网络技术'),
  ];

  group('tagsInScope：学科隔离', () {
    test('没给学科上下文就不过滤（还谈不上属于哪个学科）', () {
      final tags = [
        _tag('t1', subject: 'office', name: 'excel'),
        _tag('t2', subject: null, name: '计算机'),
      ];
      expect(tagsInScope(tags, null, nodes).length, 2);
    });

    test('只出该节点子树下的知识点', () {
      final tags = [
        _tag('t1', subject: 'office', name: 'excel'),
        _tag('t2', subject: 'net', name: '路由'),
      ];
      final scoped = tagsInScope(tags, 'office', nodes);
      expect(scoped.map((t) => t.name), ['excel']);
    });

    test('选父级节点时，子节点上的知识点也算（子树口径）', () {
      final tags = [
        _tag('t1', subject: 'office', name: 'excel'),
        _tag('t2', subject: 'net', name: '路由'),
      ];
      // 选中「计算机」专业 → 它下面两门课的知识点都该出现
      expect(tagsInScope(tags, 'major', nodes).length, 2);
      // 选中「计算机」大类 → 同理
      expect(tagsInScope(tags, 'cat', nodes).length, 2);
    });

    test('未归类的知识点**不外泄**到任何学科下', () {
      final tags = [
        _tag('t1', subject: null, name: '计算机'),
        _tag('t2', subject: null, name: '信息技术'),
      ];
      // 未归类是"等管理员指派"的中间态；让它出现在某个学科下等于隔离还没建立就先漏了
      expect(tagsInScope(tags, 'office', nodes), isEmpty);
    });

    test('认不出的科目节点 → 空列表（不炸，也不当成"不过滤"）', () {
      final tags = [_tag('t1', subject: 'office', name: 'excel')];
      expect(tagsInScope(tags, '不存在的节点', nodes), isEmpty);
    });
  });

  group('TagIndex：层级路径', () {
    test('多级路径拼成"根 / … / 自身"', () {
      final tags = [
        _tag('a', subject: 'office', name: '办公软件'),
        _tag('b', subject: 'office', parent: 'a', name: 'excel'),
        _tag('c', subject: 'office', parent: 'b', name: '函数'),
      ];
      final index = TagIndex(tags);

      expect(index.pathOf('a'), '办公软件');
      expect(index.pathOf('b'), '办公软件 / excel');
      expect(index.pathOf('c'), '办公软件 / excel / 函数');
    });

    test('ancestorPathOf 不含自己（顶层为空串）', () {
      final tags = [
        _tag('a', subject: 'office', name: '办公软件'),
        _tag('b', subject: 'office', parent: 'a', name: 'excel'),
      ];
      final index = TagIndex(tags);

      expect(index.ancestorPathOf('a'), '');
      expect(index.ancestorPathOf('b'), '办公软件');
    });

    test('不存在的 id 与 null 都返回空串，不抛异常', () {
      final index = TagIndex(const []);
      expect(index.pathOf('nope'), '');
      expect(index.pathOf(null), '');
      expect(index.ancestorPathOf('nope'), '');
    });

    test('数据成环时截断，不无限循环', () {
      // 脏数据：a 的父是 b，b 的父是 a
      final tags = [
        _tag('a', subject: 'office', parent: 'b', name: '甲'),
        _tag('b', subject: 'office', parent: 'a', name: '乙'),
      ];
      final index = TagIndex(tags);
      // 只要不挂死、能返回一条有限长度的链即可
      expect(index.pathOf('a').split(' / ').length, lessThanOrEqualTo(10));
    });
  });
}
