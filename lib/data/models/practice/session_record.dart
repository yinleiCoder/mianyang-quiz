// 练习记录列表的一行（practice_sessions 表，RLS 只放行本人的行）。
//
// 与 PracticeSessionSnapshot 的区别：这个**不含题面**，只够列表展示。
// 点进复盘时才用 get_practice_session 取完整快照——一次拉几十个会话的题面既慢又没必要。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';

part 'session_record.freezed.dart';
part 'session_record.g.dart';

/// 会话状态。数据库取值：active / submitted / abandoned。
enum SessionStatus {
  active('active', '进行中'),
  submitted('submitted', '已完成'),
  abandoned('abandoned', '已放弃');

  const SessionStatus(this.wire, this.label);
  final String wire;
  final String label;
}

@freezed
abstract class PracticeSessionRecord with _$PracticeSessionRecord {
  const factory PracticeSessionRecord({
    required String id,
    @Default('all') String source,
    @Default('active') String status,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @JsonKey(name: 'answered_count') @Default(0) int answeredCount,
    @JsonKey(name: 'correct_count') @Default(0) int correctCount,
  }) = _PracticeSessionRecord;

  factory PracticeSessionRecord.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionRecordFromJson(json);
}

extension PracticeSessionRecordX on PracticeSessionRecord {
  SessionStatus get statusValue {
    for (final value in SessionStatus.values) {
      if (value.wire == status) return value;
    }
    return SessionStatus.abandoned;
  }

  PracticeSource get sourceValue {
    for (final value in PracticeSource.values) {
      if (value.wire == source) return value;
    }
    return PracticeSource.all;
  }

  /// 正确率的分母是**总题数**（与交卷结算同口径，不同于看板的已答数）。
  double get accuracy => totalCount == 0 ? 0 : correctCount / totalCount;

  int get wrongCount => (answeredCount - correctCount).clamp(0, totalCount);

  bool get isFinished => statusValue != SessionStatus.active;
}
