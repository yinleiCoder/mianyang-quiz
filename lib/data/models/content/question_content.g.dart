// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionContent _$QuestionContentFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_QuestionContent', json, ($checkedConvert) {
  final val = _QuestionContent(
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
    analysis: $checkedConvert(
      'analysis',
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
    sub: $checkedConvert(
      'sub',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => SubQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SubQuestion>[],
    ),
  );
  return val;
}, fieldKeyMap: const {'formatVersion': 'format_version'});

Map<String, dynamic> _$QuestionContentToJson(_QuestionContent instance) =>
    <String, dynamic>{
      'format_version': instance.formatVersion,
      'stem': instance.stem.map((e) => e.toJson()).toList(),
      'analysis': instance.analysis.map((e) => e.toJson()).toList(),
      'options': instance.options.map((e) => e.toJson()).toList(),
      'answer': instance.answer?.toJson(),
      'sub': instance.sub.map((e) => e.toJson()).toList(),
    };
