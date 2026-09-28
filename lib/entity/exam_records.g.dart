// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_records.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamAttemptRecord _$ExamAttemptRecordFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_ExamAttemptRecord',
  json,
  ($checkedConvert) {
    final val = _ExamAttemptRecord(
      attemptId: $checkedConvert('attempt_id', (v) => v as String),
      paperId: $checkedConvert('paper_id', (v) => v as String),
      paperVersionId: $checkedConvert('paper_version_id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String? ?? ''),
      examName: $checkedConvert('exam_name', (v) => v as String?),
      subjectLabel: $checkedConvert('subject_label', (v) => v as String?),
      status: $checkedConvert('status', (v) => v as String? ?? 'in_progress'),
      startedAt: $checkedConvert(
        'started_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      deadlineAt: $checkedConvert(
        'deadline_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      submittedAt: $checkedConvert(
        'submitted_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      gradedAt: $checkedConvert(
        'graded_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      totalScore: $checkedConvert(
        'total_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      fullScore: $checkedConvert(
        'full_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      objectiveScore: $checkedConvert(
        'objective_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      subjectiveScore: $checkedConvert(
        'subjective_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      pendingReviewCount: $checkedConvert(
        'pending_review_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      durationMs: $checkedConvert(
        'duration_ms',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      itemCount: $checkedConvert(
        'item_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      isOfficial: $checkedConvert('is_official', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'attemptId': 'attempt_id',
    'paperId': 'paper_id',
    'paperVersionId': 'paper_version_id',
    'examName': 'exam_name',
    'subjectLabel': 'subject_label',
    'startedAt': 'started_at',
    'deadlineAt': 'deadline_at',
    'submittedAt': 'submitted_at',
    'gradedAt': 'graded_at',
    'totalScore': 'total_score',
    'fullScore': 'full_score',
    'objectiveScore': 'objective_score',
    'subjectiveScore': 'subjective_score',
    'pendingReviewCount': 'pending_review_count',
    'durationMs': 'duration_ms',
    'itemCount': 'item_count',
    'isOfficial': 'is_official',
  },
);

Map<String, dynamic> _$ExamAttemptRecordToJson(_ExamAttemptRecord instance) =>
    <String, dynamic>{
      'attempt_id': instance.attemptId,
      'paper_id': instance.paperId,
      'paper_version_id': instance.paperVersionId,
      'title': instance.title,
      'exam_name': instance.examName,
      'subject_label': instance.subjectLabel,
      'status': instance.status,
      'started_at': instance.startedAt?.toIso8601String(),
      'deadline_at': instance.deadlineAt?.toIso8601String(),
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'graded_at': instance.gradedAt?.toIso8601String(),
      'total_score': instance.totalScore,
      'full_score': instance.fullScore,
      'objective_score': instance.objectiveScore,
      'subjective_score': instance.subjectiveScore,
      'pending_review_count': instance.pendingReviewCount,
      'duration_ms': instance.durationMs,
      'item_count': instance.itemCount,
      'is_official': instance.isOfficial,
    };

_ExamSubmitSummary _$ExamSubmitSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_ExamSubmitSummary',
      json,
      ($checkedConvert) {
        final val = _ExamSubmitSummary(
          total: $checkedConvert('total', (v) => (v as num?)?.toDouble() ?? 0),
          fullScore: $checkedConvert(
            'full_score',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          objectiveScore: $checkedConvert(
            'objective_score',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          pendingReviewCount: $checkedConvert(
            'pending_review_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'fullScore': 'full_score',
        'objectiveScore': 'objective_score',
        'pendingReviewCount': 'pending_review_count',
      },
    );

Map<String, dynamic> _$ExamSubmitSummaryToJson(_ExamSubmitSummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'full_score': instance.fullScore,
      'objective_score': instance.objectiveScore,
      'pending_review_count': instance.pendingReviewCount,
    };
