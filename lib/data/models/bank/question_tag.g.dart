// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionTag _$QuestionTagFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_QuestionTag', json, ($checkedConvert) {
      final val = _QuestionTag(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$QuestionTagToJson(_QuestionTag instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
