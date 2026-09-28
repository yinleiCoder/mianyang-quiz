// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PracticeItem _$PracticeItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_PracticeItem',
      json,
      ($checkedConvert) {
        final val = _PracticeItem(
          seq: $checkedConvert('seq', (v) => (v as num).toInt()),
          questionId: $checkedConvert('question_id', (v) => v as String),
          versionId: $checkedConvert('version_id', (v) => v as String),
          qtype: $checkedConvert('qtype', (v) => v as String),
          difficulty: $checkedConvert(
            'difficulty',
            (v) => (v as num?)?.toInt(),
          ),
          courseNodeId: $checkedConvert('course_node_id', (v) => v as String?),
          content: $checkedConvert(
            'content',
            (v) => QuestionContent.fromJson(v as Map<String, dynamic>),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'questionId': 'question_id',
        'versionId': 'version_id',
        'courseNodeId': 'course_node_id',
      },
    );

Map<String, dynamic> _$PracticeItemToJson(_PracticeItem instance) =>
    <String, dynamic>{
      'seq': instance.seq,
      'question_id': instance.questionId,
      'version_id': instance.versionId,
      'qtype': instance.qtype,
      'difficulty': instance.difficulty,
      'course_node_id': instance.courseNodeId,
      'content': instance.content.toJson(),
    };

_PracticeAnswerRecord _$PracticeAnswerRecordFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_PracticeAnswerRecord',
  json,
  ($checkedConvert) {
    final val = _PracticeAnswerRecord(
      questionId: $checkedConvert('question_id', (v) => v as String),
      answer: $checkedConvert(
        'answer',
        (v) => v as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
      grading: $checkedConvert('grading', (v) => v as String? ?? 'auto'),
      isCorrect: $checkedConvert('is_correct', (v) => v as bool?),
      selfMastered: $checkedConvert('self_mastered', (v) => v as bool?),
      durationMs: $checkedConvert(
        'duration_ms',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      answeredAt: $checkedConvert(
        'answered_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'questionId': 'question_id',
    'isCorrect': 'is_correct',
    'selfMastered': 'self_mastered',
    'durationMs': 'duration_ms',
    'answeredAt': 'answered_at',
  },
);

Map<String, dynamic> _$PracticeAnswerRecordToJson(
  _PracticeAnswerRecord instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'answer': instance.answer,
  'grading': instance.grading,
  'is_correct': instance.isCorrect,
  'self_mastered': instance.selfMastered,
  'duration_ms': instance.durationMs,
  'answered_at': instance.answeredAt?.toIso8601String(),
};

_PracticeSessionSnapshot _$PracticeSessionSnapshotFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_PracticeSessionSnapshot',
  json,
  ($checkedConvert) {
    final val = _PracticeSessionSnapshot(
      sessionId: $checkedConvert('session_id', (v) => v as String),
      source: $checkedConvert('source', (v) => v as String? ?? 'all'),
      status: $checkedConvert('status', (v) => v as String? ?? 'active'),
      startedAt: $checkedConvert(
        'started_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      submittedAt: $checkedConvert(
        'submitted_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      durationMs: $checkedConvert(
        'duration_ms',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      totalCount: $checkedConvert(
        'total_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      answeredCount: $checkedConvert(
        'answered_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      correctCount: $checkedConvert(
        'correct_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      items: $checkedConvert(
        'items',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => PracticeItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <PracticeItem>[],
      ),
      answers: $checkedConvert(
        'answers',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) =>
                      PracticeAnswerRecord.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            const <PracticeAnswerRecord>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'sessionId': 'session_id',
    'startedAt': 'started_at',
    'submittedAt': 'submitted_at',
    'durationMs': 'duration_ms',
    'totalCount': 'total_count',
    'answeredCount': 'answered_count',
    'correctCount': 'correct_count',
  },
);

Map<String, dynamic> _$PracticeSessionSnapshotToJson(
  _PracticeSessionSnapshot instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'source': instance.source,
  'status': instance.status,
  'started_at': instance.startedAt?.toIso8601String(),
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'duration_ms': instance.durationMs,
  'total_count': instance.totalCount,
  'answered_count': instance.answeredCount,
  'correct_count': instance.correctCount,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'answers': instance.answers.map((e) => e.toJson()).toList(),
};
