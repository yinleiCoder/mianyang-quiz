// 科目树节点（subject_nodes 表）。
//
// 两棵树（scope）：
//   common      公共科目：discipline（公共学科，直接挂题）→ course（课程，挂题）
//   vocational  专业目录：category（专业大类）→ major（专业）→ course（课程，挂题）
//
// **可挂题的只有 discipline 与 course**，这是题库筛选与组卷树选择器的关键约束：
// 选中一个不可挂题节点时，实际含义是"它下面所有课程"（子树筛选）。

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
