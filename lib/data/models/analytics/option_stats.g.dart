// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OptionStudent _$OptionStudentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OptionStudent', json, ($checkedConvert) {
      final val = _OptionStudent(
        userId: $checkedConvert('user_id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        className: $checkedConvert('class_name', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'userId': 'user_id', 'className': 'class_name'});

Map<String, dynamic> _$OptionStudentToJson(_OptionStudent instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'class_name': instance.className,
    };

_QuestionOptionStat _$QuestionOptionStatFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_QuestionOptionStat',
      json,
      ($checkedConvert) {
        final val = _QuestionOptionStat(
          key: $checkedConvert('key', (v) => v as String),
          text: $checkedConvert('text', (v) => v as String? ?? ''),
          isAnswer: $checkedConvert('is_answer', (v) => v as bool? ?? false),
          count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
          students: $checkedConvert(
            'students',
            (v) =>
                (v as List<dynamic>?)
                    ?.map(
                      (e) => OptionStudent.fromJson(e as Map<String, dynamic>),
                    )
                    .toList() ??
                const <OptionStudent>[],
          ),
          studentsTruncated: $checkedConvert(
            'students_truncated',
            (v) => v as bool? ?? false,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'isAnswer': 'is_answer',
        'studentsTruncated': 'students_truncated',
      },
    );

Map<String, dynamic> _$QuestionOptionStatToJson(_QuestionOptionStat instance) =>
    <String, dynamic>{
      'key': instance.key,
      'text': instance.text,
      'is_answer': instance.isAnswer,
      'count': instance.count,
      'students': instance.students.map((e) => e.toJson()).toList(),
      'students_truncated': instance.studentsTruncated,
    };

_TextCount _$TextCountFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TextCount', json, ($checkedConvert) {
      final val = _TextCount(
        text: $checkedConvert('text', (v) => v as String? ?? ''),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$TextCountToJson(_TextCount instance) =>
    <String, dynamic>{'text': instance.text, 'count': instance.count};
