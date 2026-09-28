// 班级（classes 表，迁移 0063）。注册选班与「修改就读信息」选班都用到。
//
// 班级是 **学校 × 专业节点 × 名称** 的实体，专业大类/专业由它派生
// （服务端同时写 profiles.major_node_id 与两列文本镜像），所以选班这一步
// 就等于把学生钉在专业树的一条链上——学生自己不再选专业。
//
// 类名不叫 Class：Dart 生态里 Class 指的是「反射意义上的类」，
// 用它命名「一个班」会让每个读到 import 的人先误会一次。故叫 SchoolClass。
//
// 表对 anon 也开了只读（0063 沿 0039 先例）：注册页在登录前就要把班级列出来。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_class.freezed.dart';
part 'school_class.g.dart';

@freezed
abstract class SchoolClass with _$SchoolClass {
  const factory SchoolClass({
    required String id,
    @JsonKey(name: 'school_id') required String schoolId,
    /// 所属专业节点：subject_nodes 里 kind 为 category（专业大类）或 major（专业）的行。
    @JsonKey(name: 'major_node_id') required String majorNodeId,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _SchoolClass;

  factory SchoolClass.fromJson(Map<String, dynamic> json) =>
      _$SchoolClassFromJson(json);
}
