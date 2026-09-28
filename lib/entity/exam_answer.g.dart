// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScoreUnit _$ScoreUnitFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ScoreUnit', json, ($checkedConvert) {
      final val = _ScoreUnit(
        ok: $checkedConvert('ok', (v) => v as bool? ?? false),
        score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ScoreUnitToJson(_ScoreUnit instance) =>
    <String, dynamic>{'ok': instance.ok, 'score': instance.score};

_ExamAnswerRecord _$ExamAnswerRecordFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_ExamAnswerRecord',
      json,
      ($checkedConvert) {
        final val = _ExamAnswerRecord(
          paperItemId: $checkedConvert('paper_item_id', (v) => v as String),
          seq: $checkedConvert('seq', (v) => (v as num?)?.toInt() ?? 0),
          answer: $checkedConvert(
            'answer',
            (v) => v as Map<String, dynamic>? ?? const <String, dynamic>{},
          ),
          units: $checkedConvert(
            'units',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => ScoreUnit.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const <ScoreUnit>[],
          ),
          score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
          grading: $checkedConvert('grading', (v) => v as String? ?? 'auto'),
          isCorrect: $checkedConvert('is_correct', (v) => v as bool?),
          comment: $checkedConvert('comment', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'paperItemId': 'paper_item_id',
        'isCorrect': 'is_correct',
      },
    );

Map<String, dynamic> _$ExamAnswerRecordToJson(_ExamAnswerRecord instance) =>
    <String, dynamic>{
      'paper_item_id': instance.paperItemId,
      'seq': instance.seq,
      'answer': instance.answer,
      'units': instance.units.map((e) => e.toJson()).toList(),
      'score': instance.score,
      'grading': instance.grading,
      'is_correct': instance.isCorrect,
      'comment': instance.comment,
    };
