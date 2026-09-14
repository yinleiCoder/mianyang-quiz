// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_QuestionOption', json, ($checkedConvert) {
      final val = _QuestionOption(
        key: $checkedConvert('key', (v) => v as String),
        label: $checkedConvert(
          'label',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => Block.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <Block>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$QuestionOptionToJson(_QuestionOption instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label.map((e) => e.toJson()).toList(),
    };
