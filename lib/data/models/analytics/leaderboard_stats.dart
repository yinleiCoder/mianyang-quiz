// 榜单的统计块。
//
// 两个"为什么榜上是空的"必须由这里解释清楚，否则老师会以为功能坏了（迁移 0077 的注释）：
//   ungarded       有主观题时，判完出分才进榜 —— 全班可能一个都还没上
//   otherVersionSkipped  考的是旧版卷面（改版前），不计入当前这一榜
//
// 得分率一律是 totalScore / fullScore 的口径：同卷不同人满分一致，比原始分直观且不会读错。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_stats.freezed.dart';
part 'leaderboard_stats.g.dart';

@freezed
abstract class LeaderboardStats with _$LeaderboardStats {
  const factory LeaderboardStats({
    /// 当前口径下上榜人数。
    @Default(0) int total,
    @Default(0) int graded,
    /// 已交卷但还没判完（主观题）的人数。
    @Default(0) int ungraded,
    /// 考的是旧版卷面、因此不计入本榜的场次。
    @JsonKey(name: 'other_version_skipped') @Default(0) int otherVersionSkipped,
    @JsonKey(name: 'avg_score') double? avgScore,
    @JsonKey(name: 'avg_percent') double? avgPercent,
    @JsonKey(name: 'max_score') double? maxScore,
    @JsonKey(name: 'min_score') double? minScore,
    @JsonKey(name: 'median_percent') double? medianPercent,
    @JsonKey(name: 'p25_percent') double? p25Percent,
    @JsonKey(name: 'p75_percent') double? p75Percent,
  }) = _LeaderboardStats;

  factory LeaderboardStats.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardStatsFromJson(json);
}
