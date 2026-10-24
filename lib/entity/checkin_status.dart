// 今日打卡状态（record_daily_checkin 的返回，迁移 0107）。
//
// 纯数据，不放 Store：它要能在纯 Dart 测试里构造与断言（与 entity 层其他模型一致）。
// 字段名与 RPC 的 jsonb 键逐字对应，别顺手改成驼峰。

class CheckinStatus {
  const CheckinStatus({
    this.day = '',
    this.streakDays = 0,
    this.totalDays = 0,
    this.dailyGoal = 20,
  });

  /// 打卡日（北京时间，`YYYY-MM-DD`）。空串表示还没成功记录过。
  final String day;

  /// 连续打卡天数（含今天）。
  final int streakDays;

  /// 累计打卡天数。
  final int totalDays;

  /// 今日目标题数。**默认 20**（用户 2026-10-24 定的口径，原先是 10）。
  final int dailyGoal;

  factory CheckinStatus.fromJson(Map<String, dynamic> json) => CheckinStatus(
    day: json['day'] as String? ?? '',
    streakDays: (json['streak_days'] as num?)?.toInt() ?? 0,
    totalDays: (json['total_days'] as num?)?.toInt() ?? 0,
    dailyGoal: (json['daily_goal'] as num?)?.toInt() ?? 20,
  );

  CheckinStatus copyWith({
    String? day,
    int? streakDays,
    int? totalDays,
    int? dailyGoal,
  }) => CheckinStatus(
    day: day ?? this.day,
    streakDays: streakDays ?? this.streakDays,
    totalDays: totalDays ?? this.totalDays,
    dailyGoal: dailyGoal ?? this.dailyGoal,
  );
}
