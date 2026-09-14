// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oss_sign_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OssSignResult _$OssSignResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OssSignResult', json, ($checkedConvert) {
      final val = _OssSignResult(
        uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
        bucket: $checkedConvert('bucket', (v) => v as String? ?? ''),
        fields: $checkedConvert(
          'fields',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const <String, String>{},
        ),
      );
      return val;
    });

Map<String, dynamic> _$OssSignResultToJson(_OssSignResult instance) =>
    <String, dynamic>{
      'uploadUrl': instance.uploadUrl,
      'bucket': instance.bucket,
      'fields': instance.fields,
    };
