// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionReport _$QuestionReportFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_QuestionReport',
      json,
      ($checkedConvert) {
        final val = _QuestionReport(
          id: $checkedConvert('id', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String? ?? 'open'),
          category: $checkedConvert('category', (v) => v as String? ?? 'other'),
          content: $checkedConvert('content', (v) => v as String? ?? ''),
          resolveNote: $checkedConvert('resolve_note', (v) => v as String?),
          resolvedAt: $checkedConvert(
            'resolved_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'resolveNote': 'resolve_note',
        'resolvedAt': 'resolved_at',
        'createdAt': 'created_at',
      },
    );

Map<String, dynamic> _$QuestionReportToJson(_QuestionReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'category': instance.category,
      'content': instance.content,
      'resolve_note': instance.resolveNote,
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
