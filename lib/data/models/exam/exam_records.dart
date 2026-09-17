// 「我的考试」列表的一行 + 交卷返回的这次小结。
//
// 列表行与 ExamAttempt 不同源：它来自 list_my_exam_attempts（0056），
// 多带了卷名（当前卷面上没有），少带了 objective_full_score（列表不展示它）。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';

part 'exam_records.freezed.dart';
part 'exam_records.g.dart';

@freezed
abstract class ExamAttemptRecord with _$ExamAttemptRecord {
  const factory ExamAttemptRecord({
    @JsonKey(name: 'attempt_id') required String attemptId,
    @JsonKey(name: 'paper_id') required String paperId,
    @JsonKey(name: 'paper_version_id') required String paperVersionId,

    /// 标题取自**这场考试当时用的那一版**，不是试卷的当前版。
    @Default('') String title,
    @JsonKey(name: 'exam_name') String? examName,
    @JsonKey(name: 'subject_label') String? subjectLabel,

    @Default('in_progress') String status,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'deadline_at') DateTime? deadlineAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'graded_at') DateTime? gradedAt,

    @JsonKey(name: 'total_score') @Default(0) double totalScore,
    @JsonKey(name: 'full_score') @Default(0) double fullScore,
    @JsonKey(name: 'objective_score') @Default(0) double objectiveScore,
    @JsonKey(name: 'subjective_score') @Default(0) double subjectiveScore,
    @JsonKey(name: 'pending_review_count') @Default(0) int pendingReviewCount,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
  }) = _ExamAttemptRecord;

  factory ExamAttemptRecord.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptRecordFromJson(json);
}

extension ExamAttemptRecordX on ExamAttemptRecord {
  ExamStatus get statusValue => examStatusFrom(status);

  /// 列表右侧那一列分数。**待阅卷时不给数字**——那时的 total_score 只有客观分，
  /// 显示成"42/100"会被读成"我才考了 42 分"，而它其实还没判完。
  String get scoreText => statusValue.isFinal
      ? '${Formatters.score(totalScore)} / ${Formatters.score(fullScore)}'
      : '—';
}

/// 交卷返回体。成绩单页会重新拉一次完整记录（那份才带逐题判分），
/// 这里只够弹一句"交卷成功，还有 N 道主观题待老师阅卷"。
@freezed
abstract class ExamSubmitSummary with _$ExamSubmitSummary {
  const factory ExamSubmitSummary({
    /// 本次自动判分得到的分数（主观题还没判，所以不等于最终成绩）。
    @Default(0) double total,
    @JsonKey(name: 'full_score') @Default(0) double fullScore,
    @JsonKey(name: 'objective_score') @Default(0) double objectiveScore,
    @JsonKey(name: 'pending_review_count') @Default(0) int pendingReviewCount,
  }) = _ExamSubmitSummary;

  factory ExamSubmitSummary.fromJson(Map<String, dynamic> json) =>
      _$ExamSubmitSummaryFromJson(json);
}
