// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyStat _$DailyStatFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DailyStat', json, ($checkedConvert) {
      final val = _DailyStat(
        date: $checkedConvert('date', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
        correct: $checkedConvert('correct', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$DailyStatToJson(_DailyStat instance) =>
    <String, dynamic>{
      'date': instance.date,
      'count': instance.count,
      'correct': instance.correct,
    };

_QtypeStat _$QtypeStatFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_QtypeStat', json, ($checkedConvert) {
      final val = _QtypeStat(
        qtype: $checkedConvert('qtype', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
        correct: $checkedConvert('correct', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$QtypeStatToJson(_QtypeStat instance) =>
    <String, dynamic>{
      'qtype': instance.qtype,
      'count': instance.count,
      'correct': instance.correct,
    };

_PracticeDashboard _$PracticeDashboardFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_PracticeDashboard',
      json,
      ($checkedConvert) {
        final val = _PracticeDashboard(
          totalAnswers: $checkedConvert(
            'total_answers',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          correctAnswers: $checkedConvert(
            'correct_answers',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          accuracy: $checkedConvert(
            'accuracy',
            (v) => (v as num?)?.toDouble() ?? 0,
          ),
          todayAnswers: $checkedConvert(
            'today_answers',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          totalDurationMs: $checkedConvert(
            'total_duration_ms',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          wrongCount: $checkedConvert(
            'wrong_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          favoriteCount: $checkedConvert(
            'favorite_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          weekAnswers: $checkedConvert(
            'week_answers',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          prevWeekAnswers: $checkedConvert(
            'prev_week_answers',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          streakDays: $checkedConvert(
            'streak_days',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          lastPracticeDay: $checkedConvert(
            'last_practice_day',
            (v) => v as String?,
          ),
          activeSession: $checkedConvert(
            'active_session',
            (v) => v == null
                ? null
                : ActiveSessionBrief.fromJson(v as Map<String, dynamic>),
          ),
          daily: $checkedConvert(
            'daily',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => DailyStat.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const <DailyStat>[],
          ),
          qtypeStats: $checkedConvert(
            'qtype_stats',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => QtypeStat.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const <QtypeStat>[],
          ),
          recent: $checkedConvert(
            'recent',
            (v) =>
                (v as List<dynamic>?)
                    ?.map(
                      (e) => RecentAnswer.fromJson(e as Map<String, dynamic>),
                    )
                    .toList() ??
                const <RecentAnswer>[],
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalAnswers': 'total_answers',
        'correctAnswers': 'correct_answers',
        'todayAnswers': 'today_answers',
        'totalDurationMs': 'total_duration_ms',
        'wrongCount': 'wrong_count',
        'favoriteCount': 'favorite_count',
        'weekAnswers': 'week_answers',
        'prevWeekAnswers': 'prev_week_answers',
        'streakDays': 'streak_days',
        'lastPracticeDay': 'last_practice_day',
        'activeSession': 'active_session',
        'qtypeStats': 'qtype_stats',
      },
    );

Map<String, dynamic> _$PracticeDashboardToJson(_PracticeDashboard instance) =>
    <String, dynamic>{
      'total_answers': instance.totalAnswers,
      'correct_answers': instance.correctAnswers,
      'accuracy': instance.accuracy,
      'today_answers': instance.todayAnswers,
      'total_duration_ms': instance.totalDurationMs,
      'wrong_count': instance.wrongCount,
      'favorite_count': instance.favoriteCount,
      'week_answers': instance.weekAnswers,
      'prev_week_answers': instance.prevWeekAnswers,
      'streak_days': instance.streakDays,
      'last_practice_day': instance.lastPracticeDay,
      'active_session': instance.activeSession?.toJson(),
      'daily': instance.daily.map((e) => e.toJson()).toList(),
      'qtype_stats': instance.qtypeStats.map((e) => e.toJson()).toList(),
      'recent': instance.recent.map((e) => e.toJson()).toList(),
    };
