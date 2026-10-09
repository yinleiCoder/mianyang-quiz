// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionTag _$QuestionTagFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_QuestionTag',
  json,
  ($checkedConvert) {
    final val = _QuestionTag(
      id: $checkedConvert('id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      subjectNodeId: $checkedConvert('subject_node_id', (v) => v as String?),
      parentId: $checkedConvert('parent_id', (v) => v as String?),
      sortOrder: $checkedConvert(
        'sort_order',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'subjectNodeId': 'subject_node_id',
    'parentId': 'parent_id',
    'sortOrder': 'sort_order',
  },
);

Map<String, dynamic> _$QuestionTagToJson(_QuestionTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subject_node_id': instance.subjectNodeId,
      'parent_id': instance.parentId,
      'sort_order': instance.sortOrder,
    };
