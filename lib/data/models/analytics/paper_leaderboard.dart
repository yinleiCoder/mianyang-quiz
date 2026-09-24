// 试卷成绩榜（paper_leaderboard RPC 一次取全，见迁移 0077）。
//
// 三个口径都来自服务端，客户端**不自己算名次**：
//   · 只统计官方成绩（同一份卷面只有第一次交卷计入，重做是自主练习）；
//   · 只统计已出分的（有主观题时，老师判完才进榜）；
//   · 只看当前入库版本，旧版场次由 stats.otherVersionSkipped 计数。
//
// 泄漏面是刻意钉死的：返回体只有姓名/学校/班级/分数/用时，没有任何作答内容或标准答案。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_entry.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_stats.dart';

part 'paper_leaderboard.freezed.dart';
part 'paper_leaderboard.g.dart';

/// 这一榜是给谁看的、看的哪一档。label 由服务端给（全班时是班级名，全校时是学校名）。
@freezed
abstract class LeaderboardScope with _$LeaderboardScope {
  const factory LeaderboardScope({
    @Default('class') String key,
    @Default('全班') String label,
    @JsonKey(name: 'class_id') String? classId,
    @JsonKey(name: 'school_id') String? schoolId,
    @JsonKey(name: 'is_staff') @Default(false) bool isStaff,
    /// 学生没分班时是 not_in_class —— 界面据此提示"先看全校/全市"。
    String? note,
  }) = _LeaderboardScope;

  factory LeaderboardScope.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardScopeFromJson(json);
}

/// 卷子本身的信息（标题、满分、版本）。
@freezed
abstract class LeaderboardPaper with _$LeaderboardPaper {
  const factory LeaderboardPaper({
    required String id,
    @Default('') String title,
    @JsonKey(name: 'exam_name') String? examName,
    @JsonKey(name: 'subject_label') String? subjectLabel,
    @JsonKey(name: 'version_id') String? versionId,
    @JsonKey(name: 'version_no') int? versionNo,
    @JsonKey(name: 'full_score') @Default(0) double fullScore,
    @JsonKey(name: 'published_at') String? publishedAt,
    @JsonKey(name: 'school_id') String? schoolId,
    @JsonKey(name: 'school_name') String? schoolName,
  }) = _LeaderboardPaper;

  factory LeaderboardPaper.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardPaperFromJson(json);
}

/// 一次 leaderboard 请求的完整结果。
@freezed
abstract class PaperLeaderboard with _$PaperLeaderboard {
  const factory PaperLeaderboard({
    required LeaderboardPaper paper,
    required LeaderboardScope scope,
    /// 榜单（已按名次排序，最多 limit 条）。
    @Default(<LeaderboardRow>[]) List<LeaderboardRow> rows,
    /// 我附近的几名（我不在前 limit 名时，界面用它把我钉在表尾）。
    @Default(<LeaderboardRow>[]) List<LeaderboardRow> nearby,
    /// 我这一场。为 null = 不在榜上，原因看 viewerNote。
    LeaderboardViewer? viewer,
    @JsonKey(name: 'viewer_note') String? viewerNote,
    required LeaderboardStats stats,
    @Default(200) int limit,
    @Default(false) bool truncated,
  }) = _PaperLeaderboard;

  factory PaperLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$PaperLeaderboardFromJson(json);
}
