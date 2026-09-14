// 一次练习会话的三个组成部分：
//   PracticeSessionSnapshot —— start_practice_session / get_practice_session 的完整返回
//   PracticeItem           —— 卷子里的一道题（**含 content 快照**，客户端无需再查题库）
//   PracticeAnswerRecord   —— 已作答的记录（续练时用来还原作答与判定）
//
// 为什么题目内容随会话返回：组卷时固定了 version_id 快照，
// 之后题目被改版或下线都不该影响本次练习——内容的权威来源是这份快照，不是题库当前版本。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';

part 'practice_session.freezed.dart';
part 'practice_session.g.dart';

@freezed
abstract class PracticeItem with _$PracticeItem {
  const factory PracticeItem({
    required int seq,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'version_id') required String versionId,
    required String qtype,
    int? difficulty,
    @JsonKey(name: 'course_node_id') String? courseNodeId,
    required QuestionContent content,
  }) = _PracticeItem;

  factory PracticeItem.fromJson(Map<String, dynamic> json) =>
      _$PracticeItemFromJson(json);
}

extension PracticeItemX on PracticeItem {
  QuestionType get type => questionTypeFrom(qtype);
}

@freezed
abstract class PracticeAnswerRecord with _$PracticeAnswerRecord {
  const factory PracticeAnswerRecord({
    @JsonKey(name: 'question_id') required String questionId,
    @Default(<String, dynamic>{}) Map<String, dynamic> answer,
    @Default('auto') String grading,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'self_mastered') bool? selfMastered,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,
  }) = _PracticeAnswerRecord;

  factory PracticeAnswerRecord.fromJson(Map<String, dynamic> json) =>
      _$PracticeAnswerRecordFromJson(json);
}

/// 会话来源。对应 RPC 的 p_source 取值。
enum PracticeSource {
  all('all', '题库'),
  wrong('wrong', '错题本'),
  favorites('favorites', '收藏');

  const PracticeSource(this.wire, this.label);
  final String wire;
  final String label;
}

@freezed
abstract class PracticeSessionSnapshot with _$PracticeSessionSnapshot {
  const factory PracticeSessionSnapshot({
    @JsonKey(name: 'session_id') required String sessionId,
    @Default('all') String source,
    @Default('active') String status,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @JsonKey(name: 'answered_count') @Default(0) int answeredCount,
    @JsonKey(name: 'correct_count') @Default(0) int correctCount,
    @Default(<PracticeItem>[]) List<PracticeItem> items,
    @Default(<PracticeAnswerRecord>[]) List<PracticeAnswerRecord> answers,
  }) = _PracticeSessionSnapshot;

  factory PracticeSessionSnapshot.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionSnapshotFromJson(json);
}

extension PracticeSessionSnapshotX on PracticeSessionSnapshot {
  bool get isActive => status == 'active';

  PracticeSource get sourceValue {
    for (final value in PracticeSource.values) {
      if (value.wire == source) return value;
    }
    return PracticeSource.all;
  }

  /// 已作答记录按 questionId 索引，便于续练时还原每题状态。
  Map<String, PracticeAnswerRecord> get answersByQuestion => {
    for (final record in answers) record.questionId: record,
  };
}
