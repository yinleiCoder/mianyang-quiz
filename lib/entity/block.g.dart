// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextBlock _$TextBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TextBlock', json, ($checkedConvert) {
      final val = TextBlock(
        text: $checkedConvert('text', (v) => v as String),
        $type: $checkedConvert('t', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 't'});

Map<String, dynamic> _$TextBlockToJson(TextBlock instance) => <String, dynamic>{
  'text': instance.text,
  't': instance.$type,
};

MediaBlock _$MediaBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MediaBlock', json, ($checkedConvert) {
      final val = MediaBlock(
        kind: $checkedConvert('kind', (v) => v as String),
        key: $checkedConvert('key', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String?),
        alt: $checkedConvert('alt', (v) => v as String?),
        $type: $checkedConvert('t', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 't'});

Map<String, dynamic> _$MediaBlockToJson(MediaBlock instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'key': instance.key,
      'url': instance.url,
      'alt': instance.alt,
      't': instance.$type,
    };
