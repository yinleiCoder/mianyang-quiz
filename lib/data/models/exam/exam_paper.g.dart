// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_paper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamItem _$ExamItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ExamItem',
  json,
  ($checkedConvert) {
    final val = _ExamItem(
      id: $checkedConvert('id', (v) => v as String),
      seq: $checkedConvert('seq', (v) => (v as num).toInt()),
      qtype: $checkedConvert('qtype', (v) => v as String),
      difficulty: $checkedConvert('difficulty', (v) => (v as num?)?.toInt()),
      score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
      scoreUnits: $checkedConvert(
        'score_units',
        (v) =>
            (v as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ??
            const <double>[0],
      ),
      content: $checkedConvert(
        'content',
        (v) => QuestionContent.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'scoreUnits': 'score_units'},
);

Map<String, dynamic> _$ExamItemToJson(_ExamItem instance) => <String, dynamic>{
  'id': instance.id,
  'seq': instance.seq,
  'qtype': instance.qtype,
  'difficulty': instance.difficulty,
  'score': instance.score,
  'score_units': instance.scoreUnits,
  'content': instance.content.toJson(),
};

_ExamSection _$ExamSectionFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ExamSection',
  json,
  ($checkedConvert) {
    final val = _ExamSection(
      id: $checkedConvert('id', (v) => v as String),
      sortOrder: $checkedConvert(
        'sort_order',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      seqLabel: $checkedConvert('seq_label', (v) => v as String? ?? ''),
      title: $checkedConvert('title', (v) => v as String?),
      instruction: $checkedConvert('instruction', (v) => v as String?),
      sectionScore: $checkedConvert(
        'section_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      items: $checkedConvert(
        'items',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => ExamItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <ExamItem>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'sortOrder': 'sort_order',
    'seqLabel': 'seq_label',
    'sectionScore': 'section_score',
  },
);

Map<String, dynamic> _$ExamSectionToJson(_ExamSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_order': instance.sortOrder,
      'seq_label': instance.seqLabel,
      'title': instance.title,
      'instruction': instance.instruction,
      'section_score': instance.sectionScore,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_ExamPaper _$ExamPaperFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ExamPaper',
  json,
  ($checkedConvert) {
    final val = _ExamPaper(
      versionId: $checkedConvert('version_id', (v) => v as String),
      paperId: $checkedConvert('paper_id', (v) => v as String),
      title: $checkedConvert('title', (v) => v as String? ?? ''),
      examName: $checkedConvert('exam_name', (v) => v as String?),
      subjectLabel: $checkedConvert('subject_label', (v) => v as String?),
      durationMinutes: $checkedConvert(
        'duration_minutes',
        (v) => (v as num?)?.toInt() ?? 90,
      ),
      totalScore: $checkedConvert(
        'total_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      instructions: $checkedConvert(
        'instructions',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => Block.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <Block>[],
      ),
      sections: $checkedConvert(
        'sections',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => ExamSection.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <ExamSection>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'versionId': 'version_id',
    'paperId': 'paper_id',
    'examName': 'exam_name',
    'subjectLabel': 'subject_label',
    'durationMinutes': 'duration_minutes',
    'totalScore': 'total_score',
  },
);

Map<String, dynamic> _$ExamPaperToJson(_ExamPaper instance) =>
    <String, dynamic>{
      'version_id': instance.versionId,
      'paper_id': instance.paperId,
      'title': instance.title,
      'exam_name': instance.examName,
      'subject_label': instance.subjectLabel,
      'duration_minutes': instance.durationMinutes,
      'total_score': instance.totalScore,
      'instructions': instance.instructions.map((e) => e.toJson()).toList(),
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };
