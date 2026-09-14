// 身份元数据。对应 profiles.identity（0025 迁移引入）：
//   student          学生——只能刷题，不能出题
//   teacher_pending  教师待审核——注册时选了教师，等学校管理员审核
//   teacher          教师——可出题、可参与审批
//
// 权限口径与数据库 is_teacher() 一致：teacher 或 is_admin 即视为教师。
// 历史行可能缺 identity 列，读取时按 teacher 兼容（与网页端 lib/auth.js 同口径）。

enum Identity {
  student('student', '学生', '可浏览题库、刷题练习'),
  teacherPending('teacher_pending', '教师待审核', '等待学校管理员审核，审核期间可正常刷题'),
  teacher('teacher', '教师', '可出题、参与审批');

  const Identity(this.wire, this.label, this.description);

  final String wire;
  final String label;
  final String description;
}

/// 缺列的历史数据按 teacher 兼容——与网页端 lib/auth.js 的处理保持一致。
Identity identityFrom(String? wire) {
  for (final identity in Identity.values) {
    if (identity.wire == wire) return identity;
  }
  return Identity.teacher;
}

/// 是否具备教师权限（与数据库 is_teacher() 同义）。
bool isTeacherIdentity(Identity identity, {required bool isAdmin}) =>
    identity == Identity.teacher || isAdmin;
