// 榜单上的一行、以及"我"这一行。
//
// 为什么 viewer 不放进 rows 里找我：**我的名次可能在前 200 名之外**（全市榜尤其如此），
// 服务端专门把"我"从全量排名集里单独取出来（不受 limit 截断），
// 界面因此永远能把"我的位置"钉在页面上，而不是让第 204 名的人从头翻到尾。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

/// 紧挨着我的上一名：多邻国式的"还差几分追上他"。
@freezed
abstract class LeaderboardChase with _$LeaderboardChase {
  const factory LeaderboardChase({
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @Default(0) double score,
    /// 与我相差的分数（正数 = 他比我高多少）。
    @Default(0) double gap,
  }) = _LeaderboardChase;

  factory LeaderboardChase.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardChaseFromJson(json);
}

/// 榜单里的一行。不包含任何作答内容与答案——服务端只下发这些字段（迁移 0077 的硬约束）。
@freezed
abstract class LeaderboardRow with _$LeaderboardRow {
  const factory LeaderboardRow({
    @Default(0) int order,
    @Default(0) int rank,
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'school_id') String? schoolId,
    @JsonKey(name: 'school_name') String? schoolName,
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'class_name') String? className,
    @Default(0) double score,
    @JsonKey(name: 'full_score') @Default(0) double fullScore,
    @Default(0) double percent,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'submitted_at') String? submittedAt,
    @JsonKey(name: 'is_me') @Default(false) bool isMe,
  }) = _LeaderboardRow;

  factory LeaderboardRow.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardRowFromJson(json);
}

/// 我在这场考试上的全部位置信息（三档名次一次算完，见 0077 的 window 分区）。
@freezed
abstract class LeaderboardViewer with _$LeaderboardViewer {
  const factory LeaderboardViewer({
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'class_name') String? className,
    @JsonKey(name: 'school_id') String? schoolId,
    @JsonKey(name: 'school_name') String? schoolName,
    /// 当前口径下的名次（看全班榜时就是班内名次）。
    @Default(0) int rank,
    @JsonKey(name: 'scope_total') @Default(0) int scopeTotal,
    @Default(0) double score,
    @JsonKey(name: 'full_score') @Default(0) double fullScore,
    @Default(0) double percent,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'submitted_at') String? submittedAt,
    @JsonKey(name: 'class_rank') int? classRank,
    @JsonKey(name: 'class_total') int? classTotal,
    @JsonKey(name: 'school_rank') int? schoolRank,
    @JsonKey(name: 'school_total') int? schoolTotal,
    @JsonKey(name: 'city_rank') int? cityRank,
    @JsonKey(name: 'city_total') int? cityTotal,
    /// 超过全市多少比例的人（0~1）。榜上只有我一人时是 1。
    @Default(0) double percentile,
    LeaderboardChase? chase,
  }) = _LeaderboardViewer;

  factory LeaderboardViewer.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardViewerFromJson(json);
}
