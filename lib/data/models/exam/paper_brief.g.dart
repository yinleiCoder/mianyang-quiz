// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_brief.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaperBrief _$PaperBriefFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_PaperBrief',
  json,
  ($checkedConvert) {
    final val = _PaperBrief(
      versionId: $checkedConvert('version_id', (v) => v as String),
      paperId: $checkedConvert('paper_id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String? ?? ''),
      examName: $checkedConvert('exam_name', (v) => v as String?),
      subjectLabel: $checkedConvert('subject_label', (v) => v as String?),
      totalScore: $checkedConvert(
        'total_score',
        (v) => (v as num?)?.toDouble(),
      ),
      durationMinutes: $checkedConvert(
        'duration_minutes',
        (v) => (v as num?)?.toInt(),
      ),
      itemCount: $checkedConvert(
        'item_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      publishedAt: $checkedConvert(
        'published_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'versionId': 'version_id',
    'paperId': 'paper_id',
    'examName': 'exam_name',
    'subjectLabel': 'subject_label',
    'totalScore': 'total_score',
    'durationMinutes': 'duration_minutes',
    'itemCount': 'item_count',
    'publishedAt': 'published_at',
  },
);

Map<String, dynamic> _$PaperBriefToJson(_PaperBrief instance) =>
    <String, dynamic>{
      'version_id': instance.versionId,
      'paper_id': instance.paperId,
      'title': instance.title,
      'exam_name': instance.examName,
      'subject_label': instance.subjectLabel,
      'total_score': instance.totalScore,
      'duration_minutes': instance.durationMinutes,
      'item_count': instance.itemCount,
      'published_at': instance.publishedAt?.toIso8601String(),
    };
