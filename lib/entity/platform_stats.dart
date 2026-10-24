// 平台规模（platform_stats，迁移 0114）：学校 / 学生 / 教师 / 市区。
//
// 全局口径、四川全省共享；四个数字由 SECURITY DEFINER RPC 一次返回，
// 客户端不直查 profiles（学生看不到全省的人）。

class PlatformStats {
  const PlatformStats({
    this.schools = 0,
    this.students = 0,
    this.teachers = 0,
    this.cities = 0,
  });

  final int schools;
  final int students;
  final int teachers;
  final int cities;

  factory PlatformStats.fromJson(Map<String, dynamic> json) => PlatformStats(
    schools: (json['schools'] as num?)?.toInt() ?? 0,
    students: (json['students'] as num?)?.toInt() ?? 0,
    teachers: (json['teachers'] as num?)?.toInt() ?? 0,
    cities: (json['cities'] as num?)?.toInt() ?? 0,
  );
}
