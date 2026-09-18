// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchoolClass _$SchoolClassFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SchoolClass',
  json,
  ($checkedConvert) {
    final val = _SchoolClass(
      id: $checkedConvert('id', (v) => v as String),
      schoolId: $checkedConvert('school_id', (v) => v as String),
      majorNodeId: $checkedConvert('major_node_id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String),
      isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
    );
    return val;
  },
  fieldKeyMap: const {
    'schoolId': 'school_id',
    'majorNodeId': 'major_node_id',
    'isActive': 'is_active',
  },
);

Map<String, dynamic> _$SchoolClassToJson(_SchoolClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'school_id': instance.schoolId,
      'major_node_id': instance.majorNodeId,
      'name': instance.name,
      'is_active': instance.isActive,
    };
