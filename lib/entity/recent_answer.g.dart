// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentAnswer _$RecentAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_RecentAnswer',
      json,
      ($checkedConvert) {
        final val = _RecentAnswer(
          questionId: $checkedConvert('question_id', (v) => v as String),
          versionId: $checkedConvert('version_id', (v) => v as String?),
          qtype: $checkedConvert('qtype', (v) => v as String?),
          difficulty: $checkedConvert(
            'difficulty',
            (v) => (v as num?)?.toInt(),
          ),
          isCorrect: $checkedConvert('is_correct', (v) => v as bool?),
          grading: $checkedConvert('grading', (v) => v as String? ?? 'auto'),
          answeredAt: $checkedConvert(
            'answered_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          stemText: $checkedConvert('stem_text', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'questionId': 'question_id',
        'versionId': 'version_id',
        'isCorrect': 'is_correct',
        'answeredAt': 'answered_at',
        'stemText': 'stem_text',
      },
    );

Map<String, dynamic> _$RecentAnswerToJson(_RecentAnswer instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'version_id': instance.versionId,
      'qtype': instance.qtype,
      'difficulty': instance.difficulty,
      'is_correct': instance.isCorrect,
      'grading': instance.grading,
      'answered_at': instance.answeredAt?.toIso8601String(),
      'stem_text': instance.stemText,
    };

_ActiveSessionBrief _$ActiveSessionBriefFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_ActiveSessionBrief',
      json,
      ($checkedConvert) {
        final val = _ActiveSessionBrief(
          sessionId: $checkedConvert('session_id', (v) => v as String),
          source: $checkedConvert('source', (v) => v as String? ?? 'all'),
          totalCount: $checkedConvert(
            'total_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          answeredCount: $checkedConvert(
            'answered_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          startedAt: $checkedConvert(
            'started_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'sessionId': 'session_id',
        'totalCount': 'total_count',
        'answeredCount': 'answered_count',
        'startedAt': 'started_at',
      },
    );

Map<String, dynamic> _$ActiveSessionBriefToJson(_ActiveSessionBrief instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'source': instance.source,
      'total_count': instance.totalCount,
      'answered_count': instance.answeredCount,
      'started_at': instance.startedAt?.toIso8601String(),
    };
