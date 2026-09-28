// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Profile',
  json,
  ($checkedConvert) {
    final val = _Profile(
      userId: $checkedConvert('user_id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String? ?? ''),
      email: $checkedConvert('email', (v) => v as String? ?? ''),
      phone: $checkedConvert('phone', (v) => v as String? ?? ''),
      schoolId: $checkedConvert('school_id', (v) => v as String?),
      isAdmin: $checkedConvert('is_admin', (v) => v as bool? ?? false),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      identity: $checkedConvert('identity', (v) => v as String?),
      enrollYear: $checkedConvert('enroll_year', (v) => (v as num?)?.toInt()),
      majorCategory: $checkedConvert('major_category', (v) => v as String?),
      major: $checkedConvert('major', (v) => v as String?),
      className: $checkedConvert('class_name', (v) => v as String?),
      classId: $checkedConvert('class_id', (v) => v as String?),
      majorNodeId: $checkedConvert('major_node_id', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'user_id',
    'schoolId': 'school_id',
    'isAdmin': 'is_admin',
    'avatarUrl': 'avatar_url',
    'enrollYear': 'enroll_year',
    'majorCategory': 'major_category',
    'className': 'class_name',
    'classId': 'class_id',
    'majorNodeId': 'major_node_id',
  },
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'school_id': instance.schoolId,
  'is_admin': instance.isAdmin,
  'avatar_url': instance.avatarUrl,
  'identity': instance.identity,
  'enroll_year': instance.enrollYear,
  'major_category': instance.majorCategory,
  'major': instance.major,
  'class_name': instance.className,
  'class_id': instance.classId,
  'major_node_id': instance.majorNodeId,
};
