// 科目树纯函数：逐级取子节点（childNodes）与祖先链（ancestorChain）。
//
// 这两个是组卷页「科目 → 专业 → 课程」级联下拉的全部依据：
//   · childNodes 少算了子树展开（把孙节点也列出来）→ 下拉里混进不该出现的选项；
//   · ancestorChain 算错 → 回显时选中态对不上（或直接抛 Dropdown 断言）。
// 都不连服务、不渲染，纯函数验完即可。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/subject_tree.dart';

void main() {
  group('childNodes', () {
    test('parentId 传 null 只取根节点，且按 sort_order 再按名称排', () {
      final roots = childNodes(_tree(), null);

      expect(
        roots.map((n) => n.name),
        // 电子技术 sort_order=-1 在最前；其余同名次按名称的 UTF-16 码位排
        //（Dart 的 String.compareTo，与客户端既有排序同口径）
        ['电子技术', '数学', '汽修', '计算机', '语文'],
        reason: '公共学科与专业大类混在同一级：先 sort_order，再按名称',
      );
    });

    test('只取直接子节点，不会把孙节点一起捞出来', () {
      final majors = childNodes(_tree(), _catComputer);

      expect(majors.map((n) => n.name), ['计算机']);
      expect(
        majors.map((n) => n.id),
        isNot(contains(_courseOffice)),
        reason: '课程是孙节点，选专业时不该出现在「专业」这一级',
      );
    });

    test('课程下面没有子节点', () {
      expect(childNodes(_tree(), _courseOffice), isEmpty);
    });
  });

  group('ancestorChain', () {
    test('从根到自身，顺序是根在前', () {
      expect(ancestorChain(_tree(), _courseOffice), [
        _catComputer,
        _majorComputer,
        _courseOffice,
      ]);
    });

    test('根节点自己就是一条长度 1 的链（公共学科也一样）', () {
      expect(ancestorChain(_tree(), _catComputer), [_catComputer]);
      expect(ancestorChain(_tree(), _discChinese), [_discChinese]);
    });

    test('空值 / 不存在的 id 都给空链，不抛错', () {
      expect(ancestorChain(_tree(), null), isEmpty);
      expect(ancestorChain(_tree(), ''), isEmpty);
      expect(ancestorChain(_tree(), '不存在的 id'), isEmpty);
    });

    test('数据成环时截断（不无限循环）', () {
      final looped = [
        _node('a', 'b', '甲'),
        _node('b', 'a', '乙'),
      ];

      final chain = ancestorChain(looped, 'a');

      expect(chain.length, lessThanOrEqualTo(10), reason: '有深度上限兜底');
    });
  });
}

// ---------- 与库里同形的测试数据 ----------
// 刻意保留「汽修」既是专业大类又是专业（线上就是这么建的）：
// 两个同名节点分别落在不同级别，正是级联下拉要能分辨的场景。

const _catComputer = 'cat-computer';
const _majorComputer = 'major-computer';
const _courseOffice = 'course-office';
const _discChinese = 'disc-chinese';

List<SubjectNode> _tree() => [
  _node(_discChinese, null, '语文', kind: 'discipline', scope: 'common'),
  _node('disc-math', null, '数学', kind: 'discipline', scope: 'common', order: 0),
  _node(_catComputer, null, '计算机', kind: 'category'),
  _node(_majorComputer, _catComputer, '计算机', kind: 'major'),
  _node(_courseOffice, _majorComputer, '办公应用', order: 2),
  _node('course-it', _majorComputer, '信息技术', order: 1),
  _node('cat-electron', null, '电子技术', kind: 'category', order: -1),
  _node('major-electron', 'cat-electron', '电子', kind: 'major'),
  _node('cat-auto', null, '汽修', kind: 'category', order: 0),
  _node('major-auto', 'cat-auto', '汽修', kind: 'major'),
];

SubjectNode _node(
  String id,
  String? parentId,
  String name, {
  String kind = 'course',
  String scope = 'vocational',
  int order = 0,
}) => SubjectNode(
  id: id,
  parentId: parentId,
  scope: scope,
  kind: kind,
  name: name,
  sortOrder: order,
);
