// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WrongQuestion _$WrongQuestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_WrongQuestion',
      json,
      ($checkedConvert) {
        final val = _WrongQuestion(
          questionId: $checkedConvert('question_id', (v) => v as String),
          versionId: $checkedConvert('version_id', (v) => v as String?),
          qtype: $checkedConvert('qtype', (v) => v as String?),
          difficulty: $checkedConvert(
            'difficulty',
            (v) => (v as num?)?.toInt(),
          ),
          answeredAt: $checkedConvert(
            'answered_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          wrongCount: $checkedConvert(
            'wrong_count',
            (v) => (v as num?)?.toInt() ?? 1,
          ),
          stemText: $checkedConvert('stem_text', (v) => v as String?),
          available: $checkedConvert('available', (v) => v as bool? ?? true),
        );
        return val;
      },
      fieldKeyMap: const {
        'questionId': 'question_id',
        'versionId': 'version_id',
        'answeredAt': 'answered_at',
        'wrongCount': 'wrong_count',
        'stemText': 'stem_text',
      },
    );

Map<String, dynamic> _$WrongQuestionToJson(_WrongQuestion instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'version_id': instance.versionId,
      'qtype': instance.qtype,
      'difficulty': instance.difficulty,
      'answered_at': instance.answeredAt?.toIso8601String(),
      'wrong_count': instance.wrongCount,
      'stem_text': instance.stemText,
      'available': instance.available,
    };

_FavoriteQuestion _$FavoriteQuestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_FavoriteQuestion',
      json,
      ($checkedConvert) {
        final val = _FavoriteQuestion(
          questionId: $checkedConvert('question_id', (v) => v as String),
          versionId: $checkedConvert('version_id', (v) => v as String?),
          qtype: $checkedConvert('qtype', (v) => v as String?),
          difficulty: $checkedConvert(
            'difficulty',
            (v) => (v as num?)?.toInt(),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          stemText: $checkedConvert('stem_text', (v) => v as String?),
          available: $checkedConvert('available', (v) => v as bool? ?? true),
        );
        return val;
      },
      fieldKeyMap: const {
        'questionId': 'question_id',
        'versionId': 'version_id',
        'createdAt': 'created_at',
        'stemText': 'stem_text',
      },
    );

Map<String, dynamic> _$FavoriteQuestionToJson(_FavoriteQuestion instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'version_id': instance.versionId,
      'qtype': instance.qtype,
      'difficulty': instance.difficulty,
      'created_at': instance.createdAt?.toIso8601String(),
      'stem_text': instance.stemText,
      'available': instance.available,
    };
