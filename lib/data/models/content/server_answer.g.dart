// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoiceServerAnswer _$ChoiceServerAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChoiceServerAnswer', json, ($checkedConvert) {
      final val = ChoiceServerAnswer(
        keys: $checkedConvert(
          'keys',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$ChoiceServerAnswerToJson(ChoiceServerAnswer instance) =>
    <String, dynamic>{'keys': instance.keys, 'type': instance.$type};

TrueFalseServerAnswer _$TrueFalseServerAnswerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TrueFalseServerAnswer', json, ($checkedConvert) {
  final val = TrueFalseServerAnswer(
    value: $checkedConvert('value', (v) => v as bool),
    $type: $checkedConvert('type', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$TrueFalseServerAnswerToJson(
  TrueFalseServerAnswer instance,
) => <String, dynamic>{'value': instance.value, 'type': instance.$type};

BlankServerAnswer _$BlankServerAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BlankServerAnswer', json, ($checkedConvert) {
      final val = BlankServerAnswer(
        values: $checkedConvert(
          'values',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$BlankServerAnswerToJson(BlankServerAnswer instance) =>
    <String, dynamic>{'values': instance.values, 'type': instance.$type};

TextServerAnswer _$TextServerAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TextServerAnswer', json, ($checkedConvert) {
      final val = TextServerAnswer(
        samples: $checkedConvert(
          'samples',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$TextServerAnswerToJson(TextServerAnswer instance) =>
    <String, dynamic>{'samples': instance.samples, 'type': instance.$type};
