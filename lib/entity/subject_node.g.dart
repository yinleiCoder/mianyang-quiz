// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubjectNode _$SubjectNodeFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SubjectNode',
  json,
  ($checkedConvert) {
    final val = _SubjectNode(
      id: $checkedConvert('id', (v) => v as String),
      parentId: $checkedConvert('parent_id', (v) => v as String?),
      scope: $checkedConvert('scope', (v) => v as String),
      kind: $checkedConvert('kind', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      sortOrder: $checkedConvert(
        'sort_order',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      isFrozen: $checkedConvert('is_frozen', (v) => v as bool? ?? false),
    );
    return val;
  },
  fieldKeyMap: const {
    'parentId': 'parent_id',
    'sortOrder': 'sort_order',
    'isFrozen': 'is_frozen',
  },
);

Map<String, dynamic> _$SubjectNodeToJson(_SubjectNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'scope': instance.scope,
      'kind': instance.kind,
      'name': instance.name,
      'sort_order': instance.sortOrder,
      'is_frozen': instance.isFrozen,
    };
