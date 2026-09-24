// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WrongStudent _$WrongStudentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_WrongStudent', json, ($checkedConvert) {
      final val = _WrongStudent(
        userId: $checkedConvert('user_id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        className: $checkedConvert('class_name', (v) => v as String?),
        label: $checkedConvert('label', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'userId': 'user_id', 'className': 'class_name'});

Map<String, dynamic> _$WrongStudentToJson(_WrongStudent instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'class_name': instance.className,
      'label': instance.label,
    };

_QuestionStat _$QuestionStatFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_QuestionStat',
  json,
  ($checkedConvert) {
    final val = _QuestionStat(
      itemId: $checkedConvert('item_id', (v) => v as String),
      seq: $checkedConvert('seq', (v) => (v as num?)?.toInt() ?? 0),
      qtype: $checkedConvert('qtype', (v) => v as String? ?? ''),
      score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
      total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
      blank: $checkedConvert('blank', (v) => (v as num?)?.toInt() ?? 0),
      graded: $checkedConvert('graded', (v) => (v as num?)?.toInt() ?? 0),
      correct: $checkedConvert('correct', (v) => (v as num?)?.toInt() ?? 0),
      pending: $checkedConvert('pending', (v) => (v as num?)?.toInt() ?? 0),
      correctRate: $checkedConvert(
        'correct_rate',
        (v) => (v as num?)?.toDouble(),
      ),
      options: $checkedConvert(
        'options',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => QuestionOptionStat.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            const <QuestionOptionStat>[],
      ),
      textCounts: $checkedConvert(
        'text_counts',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => TextCount.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <TextCount>[],
      ),
      wrongStudents: $checkedConvert(
        'wrong_students',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => WrongStudent.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <WrongStudent>[],
      ),
      wrongTotal: $checkedConvert(
        'wrong_total',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'itemId': 'item_id',
    'correctRate': 'correct_rate',
    'textCounts': 'text_counts',
    'wrongStudents': 'wrong_students',
    'wrongTotal': 'wrong_total',
  },
);

Map<String, dynamic> _$QuestionStatToJson(_QuestionStat instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'seq': instance.seq,
      'qtype': instance.qtype,
      'score': instance.score,
      'total': instance.total,
      'blank': instance.blank,
      'graded': instance.graded,
      'correct': instance.correct,
      'pending': instance.pending,
      'correct_rate': instance.correctRate,
      'options': instance.options.map((e) => e.toJson()).toList(),
      'text_counts': instance.textCounts.map((e) => e.toJson()).toList(),
      'wrong_students': instance.wrongStudents.map((e) => e.toJson()).toList(),
      'wrong_total': instance.wrongTotal,
    };
