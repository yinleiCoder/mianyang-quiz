// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_results.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmitResult _$SubmitResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_SubmitResult',
      json,
      ($checkedConvert) {
        final val = _SubmitResult(
          isCorrect: $checkedConvert('is_correct', (v) => v as bool),
          grading: $checkedConvert('grading', (v) => v as String? ?? 'auto'),
          correctAnswer: $checkedConvert(
            'correct_answer',
            (v) => v as Map<String, dynamic>?,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'isCorrect': 'is_correct',
        'correctAnswer': 'correct_answer',
      },
    );

Map<String, dynamic> _$SubmitResultToJson(_SubmitResult instance) =>
    <String, dynamic>{
      'is_correct': instance.isCorrect,
      'grading': instance.grading,
      'correct_answer': instance.correctAnswer,
    };

_FinishSummary _$FinishSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FinishSummary', json, ($checkedConvert) {
      final val = _FinishSummary(
        total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
        answered: $checkedConvert('answered', (v) => (v as num?)?.toInt() ?? 0),
        correct: $checkedConvert('correct', (v) => (v as num?)?.toInt() ?? 0),
        wrong: $checkedConvert('wrong', (v) => (v as num?)?.toInt() ?? 0),
        omitted: $checkedConvert('omitted', (v) => (v as num?)?.toInt() ?? 0),
        accuracy: $checkedConvert(
          'accuracy',
          (v) => (v as num?)?.toDouble() ?? 0,
        ),
        durationMs: $checkedConvert(
          'duration_ms',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    }, fieldKeyMap: const {'durationMs': 'duration_ms'});

Map<String, dynamic> _$FinishSummaryToJson(_FinishSummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'answered': instance.answered,
      'correct': instance.correct,
      'wrong': instance.wrong,
      'omitted': instance.omitted,
      'accuracy': instance.accuracy,
      'duration_ms': instance.durationMs,
    };
