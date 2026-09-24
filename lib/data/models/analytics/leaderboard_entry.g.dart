// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardChase _$LeaderboardChaseFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LeaderboardChase', json, ($checkedConvert) {
      final val = _LeaderboardChase(
        userId: $checkedConvert('user_id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String? ?? ''),
        score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
        gap: $checkedConvert('gap', (v) => (v as num?)?.toDouble() ?? 0),
      );
      return val;
    }, fieldKeyMap: const {'userId': 'user_id'});

Map<String, dynamic> _$LeaderboardChaseToJson(_LeaderboardChase instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'score': instance.score,
      'gap': instance.gap,
    };

_LeaderboardRow _$LeaderboardRowFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_LeaderboardRow',
      json,
      ($checkedConvert) {
        final val = _LeaderboardRow(
          order: $checkedConvert('order', (v) => (v as num?)?.toInt() ?? 0),
          rank: $checkedConvert('rank', (v) => (v as num?)?.toInt() ?? 0),
          userId: $checkedConvert('user_id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String? ?? ''),
          avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
          schoolId: $checkedConvert('school_id', (v) => v as String?),
          schoolName: $checkedConvert('school_name', (v) => v as String?),
          classId: $checkedConvert('class_id', (v) => v as String?),
          className: $checkedConvert('class_name', (v) => v as String?),
          score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
          fullScore: $checkedConvert(
            'full_score',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          percent: $checkedConvert(
            'percent',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          durationMs: $checkedConvert(
            'duration_ms',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          submittedAt: $checkedConvert('submitted_at', (v) => v as String?),
          isMe: $checkedConvert('is_me', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'avatarUrl': 'avatar_url',
        'schoolId': 'school_id',
        'schoolName': 'school_name',
        'classId': 'class_id',
        'className': 'class_name',
        'fullScore': 'full_score',
        'durationMs': 'duration_ms',
        'submittedAt': 'submitted_at',
        'isMe': 'is_me',
      },
    );

Map<String, dynamic> _$LeaderboardRowToJson(_LeaderboardRow instance) =>
    <String, dynamic>{
      'order': instance.order,
      'rank': instance.rank,
      'user_id': instance.userId,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'school_id': instance.schoolId,
      'school_name': instance.schoolName,
      'class_id': instance.classId,
      'class_name': instance.className,
      'score': instance.score,
      'full_score': instance.fullScore,
      'percent': instance.percent,
      'duration_ms': instance.durationMs,
      'submitted_at': instance.submittedAt,
      'is_me': instance.isMe,
    };

_LeaderboardViewer _$LeaderboardViewerFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_LeaderboardViewer',
  json,
  ($checkedConvert) {
    final val = _LeaderboardViewer(
      userId: $checkedConvert('user_id', (v) => v as String),
      name: $checkedConvert('name', (v) => v as String? ?? ''),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      classId: $checkedConvert('class_id', (v) => v as String?),
      className: $checkedConvert('class_name', (v) => v as String?),
      schoolId: $checkedConvert('school_id', (v) => v as String?),
      schoolName: $checkedConvert('school_name', (v) => v as String?),
      rank: $checkedConvert('rank', (v) => (v as num?)?.toInt() ?? 0),
      scopeTotal: $checkedConvert(
        'scope_total',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      score: $checkedConvert('score', (v) => (v as num?)?.toDouble() ?? 0),
      fullScore: $checkedConvert(
        'full_score',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      percent: $checkedConvert('percent', (v) => (v as num?)?.toDouble() ?? 0),
      durationMs: $checkedConvert(
        'duration_ms',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      submittedAt: $checkedConvert('submitted_at', (v) => v as String?),
      classRank: $checkedConvert('class_rank', (v) => (v as num?)?.toInt()),
      classTotal: $checkedConvert('class_total', (v) => (v as num?)?.toInt()),
      schoolRank: $checkedConvert('school_rank', (v) => (v as num?)?.toInt()),
      schoolTotal: $checkedConvert('school_total', (v) => (v as num?)?.toInt()),
      cityRank: $checkedConvert('city_rank', (v) => (v as num?)?.toInt()),
      cityTotal: $checkedConvert('city_total', (v) => (v as num?)?.toInt()),
      percentile: $checkedConvert(
        'percentile',
        (v) => (v as num?)?.toDouble() ?? 0,
      ),
      chase: $checkedConvert(
        'chase',
        (v) => v == null
            ? null
            : LeaderboardChase.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'userId': 'user_id',
    'avatarUrl': 'avatar_url',
    'classId': 'class_id',
    'className': 'class_name',
    'schoolId': 'school_id',
    'schoolName': 'school_name',
    'scopeTotal': 'scope_total',
    'fullScore': 'full_score',
    'durationMs': 'duration_ms',
    'submittedAt': 'submitted_at',
    'classRank': 'class_rank',
    'classTotal': 'class_total',
    'schoolRank': 'school_rank',
    'schoolTotal': 'school_total',
    'cityRank': 'city_rank',
    'cityTotal': 'city_total',
  },
);

Map<String, dynamic> _$LeaderboardViewerToJson(_LeaderboardViewer instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'class_id': instance.classId,
      'class_name': instance.className,
      'school_id': instance.schoolId,
      'school_name': instance.schoolName,
      'rank': instance.rank,
      'scope_total': instance.scopeTotal,
      'score': instance.score,
      'full_score': instance.fullScore,
      'percent': instance.percent,
      'duration_ms': instance.durationMs,
      'submitted_at': instance.submittedAt,
      'class_rank': instance.classRank,
      'class_total': instance.classTotal,
      'school_rank': instance.schoolRank,
      'school_total': instance.schoolTotal,
      'city_rank': instance.cityRank,
      'city_total': instance.cityTotal,
      'percentile': instance.percentile,
      'chase': instance.chase?.toJson(),
    };
