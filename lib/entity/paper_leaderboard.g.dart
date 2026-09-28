// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_leaderboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardScope _$LeaderboardScopeFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_LeaderboardScope',
      json,
      ($checkedConvert) {
        final val = _LeaderboardScope(
          key: $checkedConvert('key', (v) => v as String? ?? 'class'),
          label: $checkedConvert('label', (v) => v as String? ?? '全班'),
          classId: $checkedConvert('class_id', (v) => v as String?),
          schoolId: $checkedConvert('school_id', (v) => v as String?),
          isStaff: $checkedConvert('is_staff', (v) => v as bool? ?? false),
          note: $checkedConvert('note', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'classId': 'class_id',
        'schoolId': 'school_id',
        'isStaff': 'is_staff',
      },
    );

Map<String, dynamic> _$LeaderboardScopeToJson(_LeaderboardScope instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'class_id': instance.classId,
      'school_id': instance.schoolId,
      'is_staff': instance.isStaff,
      'note': instance.note,
    };

_LeaderboardPaper _$LeaderboardPaperFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_LeaderboardPaper',
      json,
      ($checkedConvert) {
        final val = _LeaderboardPaper(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String? ?? ''),
          examName: $checkedConvert('exam_name', (v) => v as String?),
          subjectLabel: $checkedConvert('subject_label', (v) => v as String?),
          versionId: $checkedConvert('version_id', (v) => v as String?),
          versionNo: $checkedConvert('version_no', (v) => (v as num?)?.toInt()),
          fullScore: $checkedConvert(
            'full_score',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          publishedAt: $checkedConvert('published_at', (v) => v as String?),
          schoolId: $checkedConvert('school_id', (v) => v as String?),
          schoolName: $checkedConvert('school_name', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'examName': 'exam_name',
        'subjectLabel': 'subject_label',
        'versionId': 'version_id',
        'versionNo': 'version_no',
        'fullScore': 'full_score',
        'publishedAt': 'published_at',
        'schoolId': 'school_id',
        'schoolName': 'school_name',
      },
    );

Map<String, dynamic> _$LeaderboardPaperToJson(_LeaderboardPaper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'exam_name': instance.examName,
      'subject_label': instance.subjectLabel,
      'version_id': instance.versionId,
      'version_no': instance.versionNo,
      'full_score': instance.fullScore,
      'published_at': instance.publishedAt,
      'school_id': instance.schoolId,
      'school_name': instance.schoolName,
    };

_PaperLeaderboard _$PaperLeaderboardFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_PaperLeaderboard', json, ($checkedConvert) {
  final val = _PaperLeaderboard(
    paper: $checkedConvert(
      'paper',
      (v) => LeaderboardPaper.fromJson(v as Map<String, dynamic>),
    ),
    scope: $checkedConvert(
      'scope',
      (v) => LeaderboardScope.fromJson(v as Map<String, dynamic>),
    ),
    rows: $checkedConvert(
      'rows',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => LeaderboardRow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LeaderboardRow>[],
    ),
    nearby: $checkedConvert(
      'nearby',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => LeaderboardRow.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <LeaderboardRow>[],
    ),
    viewer: $checkedConvert(
      'viewer',
      (v) => v == null
          ? null
          : LeaderboardViewer.fromJson(v as Map<String, dynamic>),
    ),
    viewerNote: $checkedConvert('viewer_note', (v) => v as String?),
    stats: $checkedConvert(
      'stats',
      (v) => LeaderboardStats.fromJson(v as Map<String, dynamic>),
    ),
    limit: $checkedConvert('limit', (v) => (v as num?)?.toInt() ?? 200),
    truncated: $checkedConvert('truncated', (v) => v as bool? ?? false),
  );
  return val;
}, fieldKeyMap: const {'viewerNote': 'viewer_note'});

Map<String, dynamic> _$PaperLeaderboardToJson(_PaperLeaderboard instance) =>
    <String, dynamic>{
      'paper': instance.paper.toJson(),
      'scope': instance.scope.toJson(),
      'rows': instance.rows.map((e) => e.toJson()).toList(),
      'nearby': instance.nearby.map((e) => e.toJson()).toList(),
      'viewer': instance.viewer?.toJson(),
      'viewer_note': instance.viewerNote,
      'stats': instance.stats.toJson(),
      'limit': instance.limit,
      'truncated': instance.truncated,
    };
