// 科目树节点（subject_nodes 表）。
//
// 两棵树（scope）：
//   common      公共科目：discipline（公共学科）→ course（课程）
//   vocational  专业目录：category（专业大类）→ major（专业）→ course（课程）
//
// **四层都能直接挂题**（2026-09-24 起，服务端 0075）：想按「计算机类」这种
// 专业大类组织题库的人，不该被逼着先建一门不存在的课程。
// 所以筛选时选中任一节点，含义都是"它连同它下面的全部"（子树展开）。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_node.freezed.dart';
part 'subject_node.g.dart';

enum SubjectScope {
  common('common', '公共科目'),
  vocational('vocational', '专业目录');

  const SubjectScope(this.wire, this.label);
  final String wire;
  final String label;
}

enum SubjectKind {
  discipline('discipline', '公共学科'),
  category('category', '专业大类'),
  major('major', '专业'),
  course('course', '课程');

  const SubjectKind(this.wire, this.label);
  final String wire;
  final String label;
}

@freezed
abstract class SubjectNode with _$SubjectNode {
  const factory SubjectNode({
    required String id,
    @JsonKey(name: 'parent_id') String? parentId,
    required String scope,
    required String kind,
    required String name,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_frozen') @Default(false) bool isFrozen,
  }) = _SubjectNode;

  factory SubjectNode.fromJson(Map<String, dynamic> json) =>
      _$SubjectNodeFromJson(json);
}

extension SubjectNodeX on SubjectNode {
  SubjectScope? get scopeValue {
    for (final value in SubjectScope.values) {
      if (value.wire == scope) return value;
    }
    return null;
  }

  SubjectKind? get kindValue {
    for (final value in SubjectKind.values) {
      if (value.wire == kind) return value;
    }
    return null;
  }

  /// 能否直接挂题。**任意层级都可以**（2026-09-24 起：公共学科、专业大类、专业、课程），
  /// 与服务端 0075 及网页端 lib/subject-nodes.js 的 isAttachable 同口径。
  /// 冻结的节点不能挂新题，但已挂的题仍在（冻结不改变在库题目）。
  bool get isAttachable =>
      kindValue != null &&
      !isFrozen;

  String get scopeLabel => scopeValue?.label ?? scope;

  String get kindLabel => kindValue?.label ?? kind;
}
