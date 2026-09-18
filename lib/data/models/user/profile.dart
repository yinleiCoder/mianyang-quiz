// 用户档案（profiles 表）。
//
// 字段与网页端 lib/auth.js 的 getAuthContext 对齐：
//   identity 三态见 core/constants/identity_meta.dart
//   is_admin 由数据库保证全局至多一人（唯一索引）
//   就学年份/专业/班级是 0032 迁移加的学生字段
//
// 0063 起班级成了实体：class_id 是**权威**，enroll_year / major_category / major /
// class_name 四列降级成它的显示镜像（服务端维护，只为旧客户端与展示留着）。
// 所以写就读信息要走 class_id（user_repository.updateStudyInfo），
// 读的时候这五个字段都可以信——镜像与权威由数据库保证同步。
// major_node_id 则是「学生由班级派生、教师是任教专业」的那个专业节点。
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
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'major_node_id') String? majorNodeId,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}

extension ProfileX on Profile {
  /// 缺列的历史数据按 teacher 兼容（与网页端同口径）。
  Identity get identityValue => identityFrom(identity);

  bool get isTeacher => isTeacherIdentity(identityValue, isAdmin: isAdmin);

  /// 是否填过就读信息（学生首页用来提示"去完善"）。
  /// class_id 也算一项：它是权威字段，镜像列万一没跟上也不能当成"没填"。
  bool get hasEnrollment =>
      enrollYear != null ||
      (majorCategory?.isNotEmpty ?? false) ||
      (major?.isNotEmpty ?? false) ||
      (className?.isNotEmpty ?? false) ||
      classId != null;

  /// 姓名首字，用作头像占位。
  String get initial => name.isEmpty ? '?' : name.substring(0, 1);
}
