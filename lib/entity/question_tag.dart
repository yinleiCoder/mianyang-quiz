// 知识点标签（tags 表）。
//
// name 在数据库里是 citext（忽略大小写），所以「安全用电」与「安全用电」
// 的不同大小写写法是同一个知识点。客户端比较时也应忽略大小写（用 name.toLowerCase()）。
//
// **唯一性自 0096 起是"同一学科 + 同一父级下"**，不再是全库唯一——
// 也就是说两个学科下可以各有一个同名的「安全用电」，客户端别拿 name 当主键。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_tag.freezed.dart';
part 'question_tag.g.dart';

@freezed
abstract class QuestionTag with _$QuestionTag {
  const factory QuestionTag({
    required String id,
    required String name,

    /// 这个知识点属于哪个科目节点（任意层级）。null = 未归类，
    /// **未归类的不该出现在按学科筛选的候选里**（0096）。
    @JsonKey(name: 'subject_node_id') String? subjectNodeId,

    /// 父知识点，自引用成树。null = 顶层。
    @JsonKey(name: 'parent_id') String? parentId,

    /// 同层排序，小的在前。
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _QuestionTag;

  factory QuestionTag.fromJson(Map<String, dynamic> json) =>
      _$QuestionTagFromJson(json);
}

extension QuestionTagX on QuestionTag {
  /// 客户端查重用的归一化键（与数据库 citext 的忽略大小写语义一致）。
  ///
  /// **只在同一个学科内可比**：跨学科同名是不同的知识点（见文件头）。
  String get normalized => name.trim().toLowerCase();

  bool get isTopLevel => parentId == null;
}
