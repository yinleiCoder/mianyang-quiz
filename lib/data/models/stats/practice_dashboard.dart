// 学情看板（practice_dashboard RPC 一次取全）。
//
// 这里的数据全部**有真实出处**，界面不编造任何数字：
//   daily       近 14 天，数据库已补零并升序排列，图表直接用
//   streakDays  连续练习天数（以最后一次练习向前数）
//   qtypeStats  题型分布
// 没有 XP、等级、红心这类后端不支持的东西——游戏化只做有数据支撑的部分。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/stats/recent_answer.dart';

part 'practice_dashboard.freezed.dart';
part 'practice_dashboard.g.dart';

@freezed
abstract class DailyStat with _$DailyStat {
  const factory DailyStat({
    required String date,
    @Default(0) int count,
    @Default(0) int correct,
  }) = _DailyStat;

  factory DailyStat.fromJson(Map<String, dynamic> json) => _$DailyStatFromJson(json);
}

extension DailyStatX on DailyStat {
  /// 当天的正确率。没答过题时返回 0（图表上表现为空柱，不是 100%）。
  double get accuracy => count == 0 ? 0 : correct / count;
}

@freezed
abstract class QtypeStat with _$QtypeStat {
  const factory QtypeStat({
    required String qtype,
    @Default(0) int count,
    @Default(0) int correct,
  }) = _QtypeStat;

  factory QtypeStat.fromJson(Map<String, dynamic> json) => _$QtypeStatFromJson(json);
}

@freezed
abstract class PracticeDashboard with _$PracticeDashboard {
  const factory PracticeDashboard({
    @JsonKey(name: 'total_answers') @Default(0) int totalAnswers,
    @JsonKey(name: 'correct_answers') @Default(0) int correctAnswers,

    /// 累计正确率 = correct_answers / **total_answers**（已答数，与交卷结算的分母不同）。
    @Default(0) double accuracy,
    @JsonKey(name: 'today_answers') @Default(0) int todayAnswers,
    @JsonKey(name: 'total_duration_ms') @Default(0) int totalDurationMs,

    /// 错题数：最近一次作答为错、且题目当前仍在线。
    @JsonKey(name: 'wrong_count') @Default(0) int wrongCount,
    @JsonKey(name: 'favorite_count') @Default(0) int favoriteCount,
    @JsonKey(name: 'week_answers') @Default(0) int weekAnswers,
    @JsonKey(name: 'prev_week_answers') @Default(0) int prevWeekAnswers,
    @JsonKey(name: 'streak_days') @Default(0) int streakDays,
    @JsonKey(name: 'last_practice_day') String? lastPracticeDay,

    /// 热力图逐日答题数（**近 20 周**）。只含有作答的日子，没作答的那天客户端按 0 处理。
    /// 与 [daily] 的区别：daily 是近 14 天且补过零（趋势图要连续），这个是 140 天、只给有数据的。
    @JsonKey(name: 'heatmap_daily') @Default(<DailyStat>[]) List<DailyStat> heatmapDaily,

    /// 热力图窗口的起止（`YYYY-MM-DD`，含两端）。服务端按**服务器时区**算，
    /// 客户端不自己推——本机时区与服务器差一天时，两边各算一次就会错位。
    @JsonKey(name: 'heatmap_from') String? heatmapFrom,
    @JsonKey(name: 'heatmap_to') String? heatmapTo,

    /// 进行中的会话；非空时首页显示「继续练习」。
    /// **注意**：开始新练习会静默作废它，所以入口处要先问用户。
    @JsonKey(name: 'active_session') ActiveSessionBrief? activeSession,

    @Default(<DailyStat>[]) List<DailyStat> daily,
    @JsonKey(name: 'qtype_stats') @Default(<QtypeStat>[]) List<QtypeStat> qtypeStats,
    @Default(<RecentAnswer>[]) List<RecentAnswer> recent,
  }) = _PracticeDashboard;

  factory PracticeDashboard.fromJson(Map<String, dynamic> json) =>
      _$PracticeDashboardFromJson(json);
}

extension PracticeDashboardX on PracticeDashboard {
  bool get hasActiveSession => activeSession != null;

  bool get isEmpty => totalAnswers == 0 && !hasActiveSession;

  /// 本周相比上周的增减，用于看板上的趋势提示。上周为 0 时返回 null（没有可比基数）。
  int? get weekDelta =>
      prevWeekAnswers == 0 ? null : weekAnswers - prevWeekAnswers;
}
