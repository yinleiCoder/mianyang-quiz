// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_question_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionStatsTotals _$QuestionStatsTotalsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_QuestionStatsTotals', json, ($checkedConvert) {
      final val = _QuestionStatsTotals(
        attempts: $checkedConvert('attempts', (v) => (v as num?)?.toInt() ?? 0),
        ungraded: $checkedConvert('ungraded', (v) => (v as num?)?.toInt() ?? 0),
        otherVersionSkipped: $checkedConvert(
          'other_version_skipped',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    }, fieldKeyMap: const {'otherVersionSkipped': 'other_version_skipped'});

Map<String, dynamic> _$QuestionStatsTotalsToJson(
  _QuestionStatsTotals instance,
) => <String, dynamic>{
  'attempts': instance.attempts,
  'ungraded': instance.ungraded,
  'other_version_skipped': instance.otherVersionSkipped,
};

_PaperQuestionStats _$PaperQuestionStatsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PaperQuestionStats', json, ($checkedConvert) {
      final val = _PaperQuestionStats(
        items: $checkedConvert(
          'items',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => QuestionStat.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <QuestionStat>[],
        ),
        studentLimit: $checkedConvert(
          'student_limit',
          (v) => (v as num?)?.toInt() ?? 50,
        ),
        totals: $checkedConvert(
          'stats',
          (v) => v == null
              ? const QuestionStatsTotals()
              : QuestionStatsTotals.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'studentLimit': 'student_limit', 'totals': 'stats'});

Map<String, dynamic> _$PaperQuestionStatsToJson(_PaperQuestionStats instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'student_limit': instance.studentLimit,
      'stats': instance.totals.toJson(),
    };
