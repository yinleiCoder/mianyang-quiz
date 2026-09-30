// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgetting_curve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForgettingBucket _$ForgettingBucketFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ForgettingBucket', json, ($checkedConvert) {
      final val = _ForgettingBucket(
        days: $checkedConvert('days', (v) => (v as num?)?.toInt() ?? 0),
        attempts: $checkedConvert('attempts', (v) => (v as num?)?.toInt() ?? 0),
        correct: $checkedConvert('correct', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ForgettingBucketToJson(_ForgettingBucket instance) =>
    <String, dynamic>{
      'days': instance.days,
      'attempts': instance.attempts,
      'correct': instance.correct,
    };
