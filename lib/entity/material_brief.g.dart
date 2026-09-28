// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaterialBrief _$MaterialBriefFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_MaterialBrief',
      json,
      ($checkedConvert) {
        final val = _MaterialBrief(
          id: $checkedConvert('id', (v) => v as String),
          objectKey: $checkedConvert('object_key', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String?),
          kind: $checkedConvert('kind', (v) => v as String? ?? 'other'),
          courseNodeId: $checkedConvert('course_node_id', (v) => v as String?),
          creatorId: $checkedConvert('creator_id', (v) => v as String?),
          creatorName: $checkedConvert('creator_name', (v) => v as String?),
          schoolName: $checkedConvert('school_name', (v) => v as String?),
          downloadCount: $checkedConvert(
            'download_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          size: $checkedConvert('size', (v) => (v as num?)?.toInt() ?? 0),
          mime: $checkedConvert('mime', (v) => v as String?),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'objectKey': 'object_key',
        'courseNodeId': 'course_node_id',
        'creatorId': 'creator_id',
        'creatorName': 'creator_name',
        'schoolName': 'school_name',
        'downloadCount': 'download_count',
        'createdAt': 'created_at',
      },
    );

Map<String, dynamic> _$MaterialBriefToJson(_MaterialBrief instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object_key': instance.objectKey,
      'title': instance.title,
      'description': instance.description,
      'kind': instance.kind,
      'course_node_id': instance.courseNodeId,
      'creator_id': instance.creatorId,
      'creator_name': instance.creatorName,
      'school_name': instance.schoolName,
      'download_count': instance.downloadCount,
      'size': instance.size,
      'mime': instance.mime,
      'created_at': instance.createdAt?.toIso8601String(),
    };
