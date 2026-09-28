// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamAttempt _$ExamAttemptFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ExamAttempt',
  json,
  ($checkedConvert) {
    final val = _ExamAttempt(
      id: $checkedConvert('id', (v) => v as String),
      paperId: $checkedConvert('paper_id', (v) => v as String),
      paperVersionId: $checkedConvert('paper_version_id', (v) => v as String),
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
      fullScore: $checkedConvert(
        'full_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      objectiveFullScore: $checkedConvert(
        'objective_full_score',
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
      totalScore: $checkedConvert(
        'total_score',
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
    );
    return val;
  },
  fieldKeyMap: const {
    'paperId': 'paper_id',
    'paperVersionId': 'paper_version_id',
    'startedAt': 'started_at',
    'deadlineAt': 'deadline_at',
    'submittedAt': 'submitted_at',
    'gradedAt': 'graded_at',
    'fullScore': 'full_score',
    'objectiveFullScore': 'objective_full_score',
    'objectiveScore': 'objective_score',
    'subjectiveScore': 'subjective_score',
    'totalScore': 'total_score',
    'pendingReviewCount': 'pending_review_count',
    'durationMs': 'duration_ms',
  },
);

Map<String, dynamic> _$ExamAttemptToJson(_ExamAttempt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paper_id': instance.paperId,
      'paper_version_id': instance.paperVersionId,
      'status': instance.status,
      'started_at': instance.startedAt?.toIso8601String(),
      'deadline_at': instance.deadlineAt?.toIso8601String(),
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'graded_at': instance.gradedAt?.toIso8601String(),
      'full_score': instance.fullScore,
      'objective_full_score': instance.objectiveFullScore,
      'objective_score': instance.objectiveScore,
      'subjective_score': instance.subjectiveScore,
      'total_score': instance.totalScore,
      'pending_review_count': instance.pendingReviewCount,
      'duration_ms': instance.durationMs,
    };

_ExamSnapshot _$ExamSnapshotFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ExamSnapshot', json, ($checkedConvert) {
      final val = _ExamSnapshot(
        attempt: $checkedConvert(
          'attempt',
          (v) => ExamAttempt.fromJson(v as Map<String, dynamic>),
        ),
        paper: $checkedConvert(
          'paper',
          (v) => ExamPaper.fromJson(v as Map<String, dynamic>),
        ),
        answers: $checkedConvert(
          'answers',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => ExamAnswerRecord.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <ExamAnswerRecord>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$ExamSnapshotToJson(_ExamSnapshot instance) =>
    <String, dynamic>{
      'attempt': instance.attempt.toJson(),
      'paper': instance.paper.toJson(),
      'answers': instance.answers.map((e) => e.toJson()).toList(),
    };
