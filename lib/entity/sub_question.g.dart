// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubQuestion _$SubQuestionFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SubQuestion',
  json,
  ($checkedConvert) {
    final val = _SubQuestion(
      type: $checkedConvert('type', (v) => v as String),
      formatVersion: $checkedConvert(
        'format_version',
        (v) => (v as num?)?.toInt() ?? 1,
      ),
      stem: $checkedConvert(
        'stem',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => Block.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <Block>[],
      ),
      options: $checkedConvert(
        'options',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <QuestionOption>[],
      ),
      answer: $checkedConvert(
        'answer',
        (v) =>
            v == null ? null : ServerAnswer.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'formatVersion': 'format_version'},
);

Map<String, dynamic> _$SubQuestionToJson(_SubQuestion instance) =>
    <String, dynamic>{
      'type': instance.type,
      'format_version': instance.formatVersion,
      'stem': instance.stem.map((e) => e.toJson()).toList(),
      'options': instance.options.map((e) => e.toJson()).toList(),
      'answer': instance.answer?.toJson(),
    };
