// 用户档案（profiles 表）。
//
// 字段与网页端 lib/auth.js 的 getAuthContext 对齐：
//   identity 三态见 core/constants/identity_meta.dart
//   is_admin 由数据库保证全局至多一人（唯一索引）
//   就学年份/专业/班级是 0032 迁移加的学生字段
//
// 注意：档案里**没有**角色列表。教研组长/市级专家身份落在 approver_assignments，
// 学校管理员落在 user_roles——需要时另查（见 profile_repository）。
// 客户端的刷题功能不需要这些身份，所以不默认加载。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @Default('') String email,
    @JsonKey(name: 'school_id') String? schoolId,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? identity,
    @JsonKey(name: 'enroll_year') int? enrollYear,
    @JsonKey(name: 'major_category') String? majorCategory,
    String? major,
    @JsonKey(name: 'class_name') String? className,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

extension ProfileX on Profile {
  /// 缺列的历史数据按 teacher 兼容（与网页端同口径）。
  Identity get identityValue => identityFrom(identity);

  bool get isTeacher => isTeacherIdentity(identityValue, isAdmin: isAdmin);

  /// 是否填过就读信息（学生首页用来提示"去完善"）。
  bool get hasEnrollment =>
      enrollYear != null ||
      (majorCategory?.isNotEmpty ?? false) ||
      (major?.isNotEmpty ?? false) ||
      (className?.isNotEmpty ?? false);

  /// 姓名首字，用作头像占位。
  String get initial => name.isEmpty ? '?' : name.substring(0, 1);
}
