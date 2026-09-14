// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionBrief _$QuestionBriefFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_QuestionBrief',
      json,
      ($checkedConvert) {
        final val = _QuestionBrief(
          questionId: $checkedConvert('question_id', (v) => v as String),
          versionId: $checkedConvert('version_id', (v) => v as String),
          qtype: $checkedConvert('qtype', (v) => v as String),
          difficulty: $checkedConvert(
            'difficulty',
            (v) => (v as num?)?.toInt(),
          ),
          courseNodeId: $checkedConvert('course_node_id', (v) => v as String?),
          schoolId: $checkedConvert('school_id', (v) => v as String?),
          stemText: $checkedConvert('stemText', (v) => v as String? ?? ''),
          versionNo: $checkedConvert('version_no', (v) => (v as num?)?.toInt()),
          publishedAt: $checkedConvert(
            'published_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          tags: $checkedConvert(
            'tags',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
          nodePath: $checkedConvert('node_path', (v) => v as String? ?? ''),
          schoolName: $checkedConvert('school_name', (v) => v as String? ?? ''),
          available: $checkedConvert('available', (v) => v as bool? ?? true),
        );
        return val;
      },
      fieldKeyMap: const {
        'questionId': 'question_id',
        'versionId': 'version_id',
        'courseNodeId': 'course_node_id',
        'schoolId': 'school_id',
        'versionNo': 'version_no',
        'publishedAt': 'published_at',
        'nodePath': 'node_path',
        'schoolName': 'school_name',
      },
    );

Map<String, dynamic> _$QuestionBriefToJson(_QuestionBrief instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'version_id': instance.versionId,
      'qtype': instance.qtype,
      'difficulty': instance.difficulty,
      'course_node_id': instance.courseNodeId,
      'school_id': instance.schoolId,
      'stemText': instance.stemText,
      'version_no': instance.versionNo,
      'published_at': instance.publishedAt?.toIso8601String(),
      'tags': instance.tags,
      'node_path': instance.nodePath,
      'school_name': instance.schoolName,
      'available': instance.available,
    };
