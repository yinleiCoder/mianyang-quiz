// 一场考试：考试记录本身 + 开考/续考/查成绩共用的那个信封。
//
// 三处服务端函数返回**同一个形状**（attempt / paper / answers）：
// start_exam_attempt（开考或续考）、get_my_exam_attempt（查成绩）。
// 所以客户端只需要一个 ExamSnapshot，答题页与成绩单页吃的是同一种数据。
//
// 分数全部是**快照**：full_score 在起考那一刻冻结，试卷日后改版不影响历史成绩的分母。
// 客户端不要去"用当前卷面的总分覆盖它"。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/exam/exam_answer.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';

part 'exam_attempt.freezed.dart';
part 'exam_attempt.g.dart';

/// 考试状态。线格式与 exam_attempts.status 的 check 约束逐字一致。
enum ExamStatus {
  inProgress('in_progress', '进行中'),
  submitted('submitted', '待阅卷'),
  grading('grading', '阅卷中'),
  graded('graded', '已出分'),
  abandoned('abandoned', '已放弃'),
  expired('expired', '已超时'),
  unknown('unknown', '未知状态');

  const ExamStatus(this.wire, this.label);

  final String wire;
  final String label;

  /// 还要不要学生继续答。
  bool get isOpen => this == ExamStatus.inProgress;

  /// 分数是不是最终的了。待阅卷（还有主观题没判）时不是。
  bool get isFinal => this == ExamStatus.graded;
}

ExamStatus examStatusFrom(String? wire) {
  for (final status in ExamStatus.values) {
    if (status.wire == wire) return status;
  }
  return ExamStatus.unknown;
}

@freezed
abstract class ExamAttempt with _$ExamAttempt {
  const factory ExamAttempt({
    required String id,
    @JsonKey(name: 'paper_id') required String paperId,
    @JsonKey(name: 'paper_version_id') required String paperVersionId,
    @Default('in_progress') String status,
    @JsonKey(name: 'started_at') DateTime? startedAt,

    /// 截止时刻，服务端在起考时算好（now + duration_minutes）。
    /// **客户端只读**：倒计时以它为准，改本机时间续不了命（也骗不了自己）。
    @JsonKey(name: 'deadline_at') DateTime? deadlineAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'graded_at') DateTime? gradedAt,

    /// 起考时冻结的满分（含主观题）。
    @JsonKey(name: 'full_score') @Default(0) double fullScore,

    /// 其中客观题占多少分——待阅卷时学生看到的"满分"只能是这个数，
    /// 拿 fullScore 当分母会显示成"得了 40/100"，看起来像考砸了。
    @JsonKey(name: 'objective_full_score') @Default(0) double objectiveFullScore,
    @JsonKey(name: 'objective_score') @Default(0) double objectiveScore,
    @JsonKey(name: 'subjective_score') @Default(0) double subjectiveScore,
    @JsonKey(name: 'total_score') @Default(0) double totalScore,
    @JsonKey(name: 'pending_review_count') @Default(0) int pendingReviewCount,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
  }) = _ExamAttempt;

  factory ExamAttempt.fromJson(Map<String, dynamic> json) =>
      _$ExamAttemptFromJson(json);
}

extension ExamAttemptX on ExamAttempt {
  ExamStatus get statusValue => examStatusFrom(status);

  /// 还剩多久。截止时刻缺失（脏数据）时返回 null，调用方按"不限时"处理。
  /// 已过截止时刻返回 Duration.zero，不会是负数。
  Duration? remainingFrom(DateTime now) {
    final deadline = deadlineAt;
    if (deadline == null) return null;
    final left = deadline.difference(now);
    return left.isNegative ? Duration.zero : left;
  }
}

/// 开考 / 续考 / 查成绩的统一返回体。
@freezed
abstract class ExamSnapshot with _$ExamSnapshot {
  const factory ExamSnapshot({
    required ExamAttempt attempt,
    required ExamPaper paper,

    /// 已作答的记录。开考那次是**瘦对象**（只有 paper_item_id / seq / answer），
    /// 查成绩那次还带判分字段（units / score / grading）——缺字段按默认值解析。
    @Default(<ExamAnswerRecord>[]) List<ExamAnswerRecord> answers,
  }) = _ExamSnapshot;

  factory ExamSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ExamSnapshotFromJson(json);
}

extension ExamSnapshotX on ExamSnapshot {
  /// 已作答记录按题项 id 索引，用于续考回填与答题卡状态。
  Map<String, ExamAnswerRecord> get answersByItem => {
    for (final record in answers) record.paperItemId: record,
  };
}
