// 知识点标签（0096 起有学科与层级）的纯函数：范围过滤与路径合成。
//
// 与 subject_tree.dart 是**姊妹**：科目树与知识点树都是任意深度的树，
// 子树展开、防环、路径合成的写法只该有一套（0035 起 agent 侧也是这么分的）。
//
// 两者的区别在语义，不在结构：
//   · 科目树是题库的组织骨架——一道题**属于**一个科目；
//   · 知识点是打在题上的标签——一道题可以有多个，且必须与题所属的学科对得上。
//
// 纯函数，无 Flutter 依赖，可独立单测。

import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/subject_tree.dart';

/// 某个科目节点（含其子树）下可见的知识点。
///
/// 三条规则，少一条"学科隔离"就漏：
///   · **没给学科上下文**（subjectNodeId 为 null）→ 不过滤，返回全部。
///     调用方还没选科目时硬按 null 筛会把列表清空，那是坏掉不是隔离。
///   · **未归类**的知识点（subjectNodeId 为 null）→ 不返回。
///     未归类是"等管理员指派"的中间态，让它出现在某个学科的题上，
///     等于隔离还没建立就先漏了；它在管理端可见、可指派。
///   · 其余按知识点所属学科是否落在这个节点的子树里判断。
///
/// 与服务端 0096 的口径一致；两边都改才算改（同 accuracy_meta 的跨端约定）。
List<QuestionTag> tagsInScope(
  List<QuestionTag> tags,
  String? subjectNodeId,
  List<SubjectNode> nodes,
) {
  if (subjectNodeId == null) return tags;
  final allowed = subtreeIds(nodes, subjectNodeId).toSet();
  return tags
      .where(
        (t) => t.subjectNodeId != null && allowed.contains(t.subjectNodeId),
      )
      .toList();
}

/// 换了科目之后，原来选中的知识点该不该留着？
///
/// 不在范围内就返回 null（调用方据此清掉）。**必须清**：否则会出现"筛选里带着一个
/// 看不见的知识点"——芯片不显示、条件却还在生效，比直接清掉难查得多（0096）。
String? keepTagIfInScope(
  List<QuestionTag> tags,
  String? tagId,
  String? subjectNodeId,
  List<SubjectNode> nodes,
) {
  if (tagId == null) return null;
  final stillValid = tagsInScope(
    tags,
    subjectNodeId,
    nodes,
  ).any((t) => t.id == tagId);
  return stillValid ? tagId : null;
}

/// 知识点树的索引：id → 名称链。
///
/// 返回类而不是两个闭包：调用点要同时用"全路径"（详情/标签）与"祖先段"
/// （下拉里自己已经写在左边了），拆成两个函数迟早有人只改一个。
class TagIndex {
  TagIndex(List<QuestionTag> tags) {
    for (final tag in tags) {
      _byId[tag.id] = tag;
    }
  }

  final Map<String, QuestionTag> _byId = {};
  final Map<String, List<String>> _cache = {};

  /// 防御脏数据成环；正常知识点树深度远小于此。
  static const _maxDepth = 10;

  /// "根 / … / 自身"。id 不存在或是空时返回空串。
  String pathOf(String? id) => _chainOf(id).join(' / ');

  /// 只要祖先那段（"根 / … / 父"），不含自己。顶层或找不到父级时返回空串。
  String ancestorPathOf(String? id) {
    final chain = _chainOf(id);
    return chain.length <= 1 ? '' : chain.sublist(0, chain.length - 1).join(' / ');
  }

  List<String> _chainOf(String? id) {
    if (id == null) return const [];
    final cached = _cache[id];
    if (cached != null) return cached;

    final parts = <String>[];
    var current = _byId[id];
    var depth = 0;
    while (current != null && depth++ < _maxDepth) {
      parts.insert(0, current.name);
      final parentId = current.parentId;
      current = parentId == null ? null : _byId[parentId];
    }
    _cache[id] = parts;
    return parts;
  }
}
