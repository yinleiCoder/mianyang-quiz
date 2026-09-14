// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PracticeSessionRecord _$PracticeSessionRecordFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_PracticeSessionRecord',
  json,
  ($checkedConvert) {
    final val = _PracticeSessionRecord(
      id: $checkedConvert('id', (v) => v as String),
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
    );
    return val;
  },
  fieldKeyMap: const {
    'startedAt': 'started_at',
    'submittedAt': 'submitted_at',
    'durationMs': 'duration_ms',
    'totalCount': 'total_count',
    'answeredCount': 'answered_count',
    'correctCount': 'correct_count',
  },
);

Map<String, dynamic> _$PracticeSessionRecordToJson(
  _PracticeSessionRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'source': instance.source,
  'status': instance.status,
  'started_at': instance.startedAt?.toIso8601String(),
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'duration_ms': instance.durationMs,
  'total_count': instance.totalCount,
  'answered_count': instance.answeredCount,
  'correct_count': instance.correctCount,
};
