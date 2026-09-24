// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaderboardStats _$LeaderboardStatsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_LeaderboardStats',
  json,
  ($checkedConvert) {
    final val = _LeaderboardStats(
      total: $checkedConvert('total', (v) => (v as num?)?.toInt() ?? 0),
      graded: $checkedConvert('graded', (v) => (v as num?)?.toInt() ?? 0),
      ungraded: $checkedConvert('ungraded', (v) => (v as num?)?.toInt() ?? 0),
      otherVersionSkipped: $checkedConvert(
        'other_version_skipped',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      avgScore: $checkedConvert('avg_score', (v) => (v as num?)?.toDouble()),
      avgPercent: $checkedConvert(
        'avg_percent',
        (v) => (v as num?)?.toDouble(),
      ),
      maxScore: $checkedConvert('max_score', (v) => (v as num?)?.toDouble()),
      minScore: $checkedConvert('min_score', (v) => (v as num?)?.toDouble()),
      medianPercent: $checkedConvert(
        'median_percent',
        (v) => (v as num?)?.toDouble(),
      ),
      p25Percent: $checkedConvert(
        'p25_percent',
        (v) => (v as num?)?.toDouble(),
      ),
      p75Percent: $checkedConvert(
        'p75_percent',
        (v) => (v as num?)?.toDouble(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'otherVersionSkipped': 'other_version_skipped',
    'avgScore': 'avg_score',
    'avgPercent': 'avg_percent',
    'maxScore': 'max_score',
    'minScore': 'min_score',
    'medianPercent': 'median_percent',
    'p25Percent': 'p25_percent',
    'p75Percent': 'p75_percent',
  },
);

Map<String, dynamic> _$LeaderboardStatsToJson(_LeaderboardStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'graded': instance.graded,
      'ungraded': instance.ungraded,
      'other_version_skipped': instance.otherVersionSkipped,
      'avg_score': instance.avgScore,
      'avg_percent': instance.avgPercent,
      'max_score': instance.maxScore,
      'min_score': instance.minScore,
      'median_percent': instance.medianPercent,
      'p25_percent': instance.p25Percent,
      'p75_percent': instance.p75Percent,
    };
