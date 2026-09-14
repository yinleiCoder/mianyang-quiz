// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyStat {

 String get date; int get count; int get correct;
/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyStatCopyWith<DailyStat> get copyWith => _$DailyStatCopyWithImpl<DailyStat>(this as DailyStat, _$identity);

  /// Serializes this DailyStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyStat&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyStat;
  return Object.hash(runtimeType,_this.date,_this.count,_this.correct);
}

@override
String toString() {
  final _this = this as DailyStat;
  return 'DailyStat(date: ${_this.date}, count: ${_this.count}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $DailyStatCopyWith<$Res>  {
  factory $DailyStatCopyWith(DailyStat value, $Res Function(DailyStat) _then) = _$DailyStatCopyWithImpl;
@useResult
$Res call({
 String date, int count, int correct
});




}
/// @nodoc
class _$DailyStatCopyWithImpl<$Res>
    implements $DailyStatCopyWith<$Res> {
  _$DailyStatCopyWithImpl(this._self, this._then);

  final DailyStat _self;
  final $Res Function(DailyStat) _then;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,Object? correct = null,}) {
  return _then(DailyStat(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyStat].
extension DailyStatPatterns on DailyStat {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyStat value)  $default,){
final _that = this;
switch (_that) {
case _DailyStat():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyStat value)?  $default,){
final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int count,  int correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that.date,_that.count,_that.correct);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int count,  int correct)  $default,) {final _that = this;
switch (_that) {
case _DailyStat():
return $default(_that.date,_that.count,_that.correct);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int count,  int correct)?  $default,) {final _that = this;
switch (_that) {
case _DailyStat() when $default != null:
return $default(_that.date,_that.count,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyStat implements DailyStat {
  const _DailyStat({required this.date, this.count = 0, this.correct = 0});
  factory _DailyStat.fromJson(Map<String, dynamic> json) => _$DailyStatFromJson(json);

@override final  String date;
@override@JsonKey() final  int count;
@override@JsonKey() final  int correct;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyStatCopyWith<_DailyStat> get copyWith => __$DailyStatCopyWithImpl<_DailyStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyStat&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,count,correct);
}

@override
String toString() {
    return 'DailyStat(date: $date, count: $count, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$DailyStatCopyWith<$Res> implements $DailyStatCopyWith<$Res> {
  factory _$DailyStatCopyWith(_DailyStat value, $Res Function(_DailyStat) _then) = __$DailyStatCopyWithImpl;
@override @useResult
$Res call({
 String date, int count, int correct
});




}
/// @nodoc
class __$DailyStatCopyWithImpl<$Res>
    implements _$DailyStatCopyWith<$Res> {
  __$DailyStatCopyWithImpl(this._self, this._then);

  final _DailyStat _self;
  final $Res Function(_DailyStat) _then;

/// Create a copy of DailyStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,Object? correct = null,}) {
  return _then(_DailyStat(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$QtypeStat {

 String get qtype; int get count; int get correct;
/// Create a copy of QtypeStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QtypeStatCopyWith<QtypeStat> get copyWith => _$QtypeStatCopyWithImpl<QtypeStat>(this as QtypeStat, _$identity);

  /// Serializes this QtypeStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QtypeStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QtypeStat&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QtypeStat;
  return Object.hash(runtimeType,_this.qtype,_this.count,_this.correct);
}

@override
String toString() {
  final _this = this as QtypeStat;
  return 'QtypeStat(qtype: ${_this.qtype}, count: ${_this.count}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $QtypeStatCopyWith<$Res>  {
  factory $QtypeStatCopyWith(QtypeStat value, $Res Function(QtypeStat) _then) = _$QtypeStatCopyWithImpl;
@useResult
$Res call({
 String qtype, int count, int correct
});




}
/// @nodoc
class _$QtypeStatCopyWithImpl<$Res>
    implements $QtypeStatCopyWith<$Res> {
  _$QtypeStatCopyWithImpl(this._self, this._then);

  final QtypeStat _self;
  final $Res Function(QtypeStat) _then;

/// Create a copy of QtypeStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? qtype = null,Object? count = null,Object? correct = null,}) {
  return _then(QtypeStat(
qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QtypeStat].
extension QtypeStatPatterns on QtypeStat {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QtypeStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QtypeStat() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QtypeStat value)  $default,){
final _that = this;
switch (_that) {
case _QtypeStat():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QtypeStat value)?  $default,){
final _that = this;
switch (_that) {
case _QtypeStat() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String qtype,  int count,  int correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QtypeStat() when $default != null:
return $default(_that.qtype,_that.count,_that.correct);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String qtype,  int count,  int correct)  $default,) {final _that = this;
switch (_that) {
case _QtypeStat():
return $default(_that.qtype,_that.count,_that.correct);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String qtype,  int count,  int correct)?  $default,) {final _that = this;
switch (_that) {
case _QtypeStat() when $default != null:
return $default(_that.qtype,_that.count,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QtypeStat implements QtypeStat {
  const _QtypeStat({required this.qtype, this.count = 0, this.correct = 0});
  factory _QtypeStat.fromJson(Map<String, dynamic> json) => _$QtypeStatFromJson(json);

@override final  String qtype;
@override@JsonKey() final  int count;
@override@JsonKey() final  int correct;

/// Create a copy of QtypeStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QtypeStatCopyWith<_QtypeStat> get copyWith => __$QtypeStatCopyWithImpl<_QtypeStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QtypeStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QtypeStat&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.count, count) || other.count == count)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,qtype,count,correct);
}

@override
String toString() {
    return 'QtypeStat(qtype: $qtype, count: $count, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$QtypeStatCopyWith<$Res> implements $QtypeStatCopyWith<$Res> {
  factory _$QtypeStatCopyWith(_QtypeStat value, $Res Function(_QtypeStat) _then) = __$QtypeStatCopyWithImpl;
@override @useResult
$Res call({
 String qtype, int count, int correct
});




}
/// @nodoc
class __$QtypeStatCopyWithImpl<$Res>
    implements _$QtypeStatCopyWith<$Res> {
  __$QtypeStatCopyWithImpl(this._self, this._then);

  final _QtypeStat _self;
  final $Res Function(_QtypeStat) _then;

/// Create a copy of QtypeStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? qtype = null,Object? count = null,Object? correct = null,}) {
  return _then(_QtypeStat(
qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PracticeDashboard {

@JsonKey(name: 'total_answers') int get totalAnswers;@JsonKey(name: 'correct_answers') int get correctAnswers;/// 累计正确率 = correct_answers / **total_answers**（已答数，与交卷结算的分母不同）。
 double get accuracy;@JsonKey(name: 'today_answers') int get todayAnswers;@JsonKey(name: 'total_duration_ms') int get totalDurationMs;/// 错题数：最近一次作答为错、且题目当前仍在线。
@JsonKey(name: 'wrong_count') int get wrongCount;@JsonKey(name: 'favorite_count') int get favoriteCount;@JsonKey(name: 'week_answers') int get weekAnswers;@JsonKey(name: 'prev_week_answers') int get prevWeekAnswers;@JsonKey(name: 'streak_days') int get streakDays;@JsonKey(name: 'last_practice_day') String? get lastPracticeDay;/// 进行中的会话；非空时首页显示「继续练习」。
/// **注意**：开始新练习会静默作废它，所以入口处要先问用户。
@JsonKey(name: 'active_session') ActiveSessionBrief? get activeSession; List<DailyStat> get daily;@JsonKey(name: 'qtype_stats') List<QtypeStat> get qtypeStats; List<RecentAnswer> get recent;
/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeDashboardCopyWith<PracticeDashboard> get copyWith => _$PracticeDashboardCopyWithImpl<PracticeDashboard>(this as PracticeDashboard, _$identity);

  /// Serializes this PracticeDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PracticeDashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeDashboard&&(identical(other.totalAnswers, _this.totalAnswers) || other.totalAnswers == _this.totalAnswers)&&(identical(other.correctAnswers, _this.correctAnswers) || other.correctAnswers == _this.correctAnswers)&&(identical(other.accuracy, _this.accuracy) || other.accuracy == _this.accuracy)&&(identical(other.todayAnswers, _this.todayAnswers) || other.todayAnswers == _this.todayAnswers)&&(identical(other.totalDurationMs, _this.totalDurationMs) || other.totalDurationMs == _this.totalDurationMs)&&(identical(other.wrongCount, _this.wrongCount) || other.wrongCount == _this.wrongCount)&&(identical(other.favoriteCount, _this.favoriteCount) || other.favoriteCount == _this.favoriteCount)&&(identical(other.weekAnswers, _this.weekAnswers) || other.weekAnswers == _this.weekAnswers)&&(identical(other.prevWeekAnswers, _this.prevWeekAnswers) || other.prevWeekAnswers == _this.prevWeekAnswers)&&(identical(other.streakDays, _this.streakDays) || other.streakDays == _this.streakDays)&&(identical(other.lastPracticeDay, _this.lastPracticeDay) || other.lastPracticeDay == _this.lastPracticeDay)&&(identical(other.activeSession, _this.activeSession) || other.activeSession == _this.activeSession)&&const DeepCollectionEquality().equals(other.daily, _this.daily)&&const DeepCollectionEquality().equals(other.qtypeStats, _this.qtypeStats)&&const DeepCollectionEquality().equals(other.recent, _this.recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PracticeDashboard;
  return Object.hash(runtimeType,_this.totalAnswers,_this.correctAnswers,_this.accuracy,_this.todayAnswers,_this.totalDurationMs,_this.wrongCount,_this.favoriteCount,_this.weekAnswers,_this.prevWeekAnswers,_this.streakDays,_this.lastPracticeDay,_this.activeSession,const DeepCollectionEquality().hash(_this.daily),const DeepCollectionEquality().hash(_this.qtypeStats),const DeepCollectionEquality().hash(_this.recent));
}

@override
String toString() {
  final _this = this as PracticeDashboard;
  return 'PracticeDashboard(totalAnswers: ${_this.totalAnswers}, correctAnswers: ${_this.correctAnswers}, accuracy: ${_this.accuracy}, todayAnswers: ${_this.todayAnswers}, totalDurationMs: ${_this.totalDurationMs}, wrongCount: ${_this.wrongCount}, favoriteCount: ${_this.favoriteCount}, weekAnswers: ${_this.weekAnswers}, prevWeekAnswers: ${_this.prevWeekAnswers}, streakDays: ${_this.streakDays}, lastPracticeDay: ${_this.lastPracticeDay}, activeSession: ${_this.activeSession}, daily: ${_this.daily}, qtypeStats: ${_this.qtypeStats}, recent: ${_this.recent})';
}


}

/// @nodoc
abstract mixin class $PracticeDashboardCopyWith<$Res>  {
  factory $PracticeDashboardCopyWith(PracticeDashboard value, $Res Function(PracticeDashboard) _then) = _$PracticeDashboardCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_answers') int totalAnswers,@JsonKey(name: 'correct_answers') int correctAnswers, double accuracy,@JsonKey(name: 'today_answers') int todayAnswers,@JsonKey(name: 'total_duration_ms') int totalDurationMs,@JsonKey(name: 'wrong_count') int wrongCount,@JsonKey(name: 'favorite_count') int favoriteCount,@JsonKey(name: 'week_answers') int weekAnswers,@JsonKey(name: 'prev_week_answers') int prevWeekAnswers,@JsonKey(name: 'streak_days') int streakDays,@JsonKey(name: 'last_practice_day') String? lastPracticeDay,@JsonKey(name: 'active_session') ActiveSessionBrief? activeSession, List<DailyStat> daily,@JsonKey(name: 'qtype_stats') List<QtypeStat> qtypeStats, List<RecentAnswer> recent
});


$ActiveSessionBriefCopyWith<$Res>? get activeSession;

}
/// @nodoc
class _$PracticeDashboardCopyWithImpl<$Res>
    implements $PracticeDashboardCopyWith<$Res> {
  _$PracticeDashboardCopyWithImpl(this._self, this._then);

  final PracticeDashboard _self;
  final $Res Function(PracticeDashboard) _then;

/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalAnswers = null,Object? correctAnswers = null,Object? accuracy = null,Object? todayAnswers = null,Object? totalDurationMs = null,Object? wrongCount = null,Object? favoriteCount = null,Object? weekAnswers = null,Object? prevWeekAnswers = null,Object? streakDays = null,Object? lastPracticeDay = freezed,Object? activeSession = freezed,Object? daily = null,Object? qtypeStats = null,Object? recent = null,}) {
  return _then(PracticeDashboard(
totalAnswers: null == totalAnswers ? _self.totalAnswers : totalAnswers // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,todayAnswers: null == todayAnswers ? _self.todayAnswers : todayAnswers // ignore: cast_nullable_to_non_nullable
as int,totalDurationMs: null == totalDurationMs ? _self.totalDurationMs : totalDurationMs // ignore: cast_nullable_to_non_nullable
as int,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,weekAnswers: null == weekAnswers ? _self.weekAnswers : weekAnswers // ignore: cast_nullable_to_non_nullable
as int,prevWeekAnswers: null == prevWeekAnswers ? _self.prevWeekAnswers : prevWeekAnswers // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastPracticeDay: freezed == lastPracticeDay ? _self.lastPracticeDay : lastPracticeDay // ignore: cast_nullable_to_non_nullable
as String?,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as ActiveSessionBrief?,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,qtypeStats: null == qtypeStats ? _self.qtypeStats : qtypeStats // ignore: cast_nullable_to_non_nullable
as List<QtypeStat>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<RecentAnswer>,
  ));
}
/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveSessionBriefCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $ActiveSessionBriefCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}


/// Adds pattern-matching-related methods to [PracticeDashboard].
extension PracticeDashboardPatterns on PracticeDashboard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeDashboard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeDashboard value)  $default,){
final _that = this;
switch (_that) {
case _PracticeDashboard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeDashboard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_answers')  int totalAnswers, @JsonKey(name: 'correct_answers')  int correctAnswers,  double accuracy, @JsonKey(name: 'today_answers')  int todayAnswers, @JsonKey(name: 'total_duration_ms')  int totalDurationMs, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'favorite_count')  int favoriteCount, @JsonKey(name: 'week_answers')  int weekAnswers, @JsonKey(name: 'prev_week_answers')  int prevWeekAnswers, @JsonKey(name: 'streak_days')  int streakDays, @JsonKey(name: 'last_practice_day')  String? lastPracticeDay, @JsonKey(name: 'active_session')  ActiveSessionBrief? activeSession,  List<DailyStat> daily, @JsonKey(name: 'qtype_stats')  List<QtypeStat> qtypeStats,  List<RecentAnswer> recent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeDashboard() when $default != null:
return $default(_that.totalAnswers,_that.correctAnswers,_that.accuracy,_that.todayAnswers,_that.totalDurationMs,_that.wrongCount,_that.favoriteCount,_that.weekAnswers,_that.prevWeekAnswers,_that.streakDays,_that.lastPracticeDay,_that.activeSession,_that.daily,_that.qtypeStats,_that.recent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_answers')  int totalAnswers, @JsonKey(name: 'correct_answers')  int correctAnswers,  double accuracy, @JsonKey(name: 'today_answers')  int todayAnswers, @JsonKey(name: 'total_duration_ms')  int totalDurationMs, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'favorite_count')  int favoriteCount, @JsonKey(name: 'week_answers')  int weekAnswers, @JsonKey(name: 'prev_week_answers')  int prevWeekAnswers, @JsonKey(name: 'streak_days')  int streakDays, @JsonKey(name: 'last_practice_day')  String? lastPracticeDay, @JsonKey(name: 'active_session')  ActiveSessionBrief? activeSession,  List<DailyStat> daily, @JsonKey(name: 'qtype_stats')  List<QtypeStat> qtypeStats,  List<RecentAnswer> recent)  $default,) {final _that = this;
switch (_that) {
case _PracticeDashboard():
return $default(_that.totalAnswers,_that.correctAnswers,_that.accuracy,_that.todayAnswers,_that.totalDurationMs,_that.wrongCount,_that.favoriteCount,_that.weekAnswers,_that.prevWeekAnswers,_that.streakDays,_that.lastPracticeDay,_that.activeSession,_that.daily,_that.qtypeStats,_that.recent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_answers')  int totalAnswers, @JsonKey(name: 'correct_answers')  int correctAnswers,  double accuracy, @JsonKey(name: 'today_answers')  int todayAnswers, @JsonKey(name: 'total_duration_ms')  int totalDurationMs, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'favorite_count')  int favoriteCount, @JsonKey(name: 'week_answers')  int weekAnswers, @JsonKey(name: 'prev_week_answers')  int prevWeekAnswers, @JsonKey(name: 'streak_days')  int streakDays, @JsonKey(name: 'last_practice_day')  String? lastPracticeDay, @JsonKey(name: 'active_session')  ActiveSessionBrief? activeSession,  List<DailyStat> daily, @JsonKey(name: 'qtype_stats')  List<QtypeStat> qtypeStats,  List<RecentAnswer> recent)?  $default,) {final _that = this;
switch (_that) {
case _PracticeDashboard() when $default != null:
return $default(_that.totalAnswers,_that.correctAnswers,_that.accuracy,_that.todayAnswers,_that.totalDurationMs,_that.wrongCount,_that.favoriteCount,_that.weekAnswers,_that.prevWeekAnswers,_that.streakDays,_that.lastPracticeDay,_that.activeSession,_that.daily,_that.qtypeStats,_that.recent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeDashboard implements PracticeDashboard {
  const _PracticeDashboard({@JsonKey(name: 'total_answers') this.totalAnswers = 0, @JsonKey(name: 'correct_answers') this.correctAnswers = 0, this.accuracy = 0, @JsonKey(name: 'today_answers') this.todayAnswers = 0, @JsonKey(name: 'total_duration_ms') this.totalDurationMs = 0, @JsonKey(name: 'wrong_count') this.wrongCount = 0, @JsonKey(name: 'favorite_count') this.favoriteCount = 0, @JsonKey(name: 'week_answers') this.weekAnswers = 0, @JsonKey(name: 'prev_week_answers') this.prevWeekAnswers = 0, @JsonKey(name: 'streak_days') this.streakDays = 0, @JsonKey(name: 'last_practice_day') this.lastPracticeDay, @JsonKey(name: 'active_session') this.activeSession,  List<DailyStat> daily = const <DailyStat>[], @JsonKey(name: 'qtype_stats')  List<QtypeStat> qtypeStats = const <QtypeStat>[],  List<RecentAnswer> recent = const <RecentAnswer>[]}): _daily = daily,_qtypeStats = qtypeStats,_recent = recent;
  factory _PracticeDashboard.fromJson(Map<String, dynamic> json) => _$PracticeDashboardFromJson(json);

@override@JsonKey(name: 'total_answers') final  int totalAnswers;
@override@JsonKey(name: 'correct_answers') final  int correctAnswers;
/// 累计正确率 = correct_answers / **total_answers**（已答数，与交卷结算的分母不同）。
@override@JsonKey() final  double accuracy;
@override@JsonKey(name: 'today_answers') final  int todayAnswers;
@override@JsonKey(name: 'total_duration_ms') final  int totalDurationMs;
/// 错题数：最近一次作答为错、且题目当前仍在线。
@override@JsonKey(name: 'wrong_count') final  int wrongCount;
@override@JsonKey(name: 'favorite_count') final  int favoriteCount;
@override@JsonKey(name: 'week_answers') final  int weekAnswers;
@override@JsonKey(name: 'prev_week_answers') final  int prevWeekAnswers;
@override@JsonKey(name: 'streak_days') final  int streakDays;
@override@JsonKey(name: 'last_practice_day') final  String? lastPracticeDay;
/// 进行中的会话；非空时首页显示「继续练习」。
/// **注意**：开始新练习会静默作废它，所以入口处要先问用户。
@override@JsonKey(name: 'active_session') final  ActiveSessionBrief? activeSession;
 final  List<DailyStat> _daily;
@override@JsonKey() List<DailyStat> get daily {
  if (_daily is EqualUnmodifiableListView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_daily);
}

 final  List<QtypeStat> _qtypeStats;
@override@JsonKey(name: 'qtype_stats') List<QtypeStat> get qtypeStats {
  if (_qtypeStats is EqualUnmodifiableListView) return _qtypeStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_qtypeStats);
}

 final  List<RecentAnswer> _recent;
@override@JsonKey() List<RecentAnswer> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}


/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeDashboardCopyWith<_PracticeDashboard> get copyWith => __$PracticeDashboardCopyWithImpl<_PracticeDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeDashboard&&(identical(other.totalAnswers, totalAnswers) || other.totalAnswers == totalAnswers)&&(identical(other.correctAnswers, correctAnswers) || other.correctAnswers == correctAnswers)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.todayAnswers, todayAnswers) || other.todayAnswers == todayAnswers)&&(identical(other.totalDurationMs, totalDurationMs) || other.totalDurationMs == totalDurationMs)&&(identical(other.wrongCount, wrongCount) || other.wrongCount == wrongCount)&&(identical(other.favoriteCount, favoriteCount) || other.favoriteCount == favoriteCount)&&(identical(other.weekAnswers, weekAnswers) || other.weekAnswers == weekAnswers)&&(identical(other.prevWeekAnswers, prevWeekAnswers) || other.prevWeekAnswers == prevWeekAnswers)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.lastPracticeDay, lastPracticeDay) || other.lastPracticeDay == lastPracticeDay)&&(identical(other.activeSession, activeSession) || other.activeSession == activeSession)&&const DeepCollectionEquality().equals(other.daily, _daily)&&const DeepCollectionEquality().equals(other.qtypeStats, _qtypeStats)&&const DeepCollectionEquality().equals(other.recent, _recent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalAnswers,correctAnswers,accuracy,todayAnswers,totalDurationMs,wrongCount,favoriteCount,weekAnswers,prevWeekAnswers,streakDays,lastPracticeDay,activeSession,const DeepCollectionEquality().hash(_daily),const DeepCollectionEquality().hash(_qtypeStats),const DeepCollectionEquality().hash(_recent));
}

@override
String toString() {
    return 'PracticeDashboard(totalAnswers: $totalAnswers, correctAnswers: $correctAnswers, accuracy: $accuracy, todayAnswers: $todayAnswers, totalDurationMs: $totalDurationMs, wrongCount: $wrongCount, favoriteCount: $favoriteCount, weekAnswers: $weekAnswers, prevWeekAnswers: $prevWeekAnswers, streakDays: $streakDays, lastPracticeDay: $lastPracticeDay, activeSession: $activeSession, daily: $daily, qtypeStats: $qtypeStats, recent: $recent)';
}


}

/// @nodoc
abstract mixin class _$PracticeDashboardCopyWith<$Res> implements $PracticeDashboardCopyWith<$Res> {
  factory _$PracticeDashboardCopyWith(_PracticeDashboard value, $Res Function(_PracticeDashboard) _then) = __$PracticeDashboardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_answers') int totalAnswers,@JsonKey(name: 'correct_answers') int correctAnswers, double accuracy,@JsonKey(name: 'today_answers') int todayAnswers,@JsonKey(name: 'total_duration_ms') int totalDurationMs,@JsonKey(name: 'wrong_count') int wrongCount,@JsonKey(name: 'favorite_count') int favoriteCount,@JsonKey(name: 'week_answers') int weekAnswers,@JsonKey(name: 'prev_week_answers') int prevWeekAnswers,@JsonKey(name: 'streak_days') int streakDays,@JsonKey(name: 'last_practice_day') String? lastPracticeDay,@JsonKey(name: 'active_session') ActiveSessionBrief? activeSession, List<DailyStat> daily,@JsonKey(name: 'qtype_stats') List<QtypeStat> qtypeStats, List<RecentAnswer> recent
});


@override $ActiveSessionBriefCopyWith<$Res>? get activeSession;

}
/// @nodoc
class __$PracticeDashboardCopyWithImpl<$Res>
    implements _$PracticeDashboardCopyWith<$Res> {
  __$PracticeDashboardCopyWithImpl(this._self, this._then);

  final _PracticeDashboard _self;
  final $Res Function(_PracticeDashboard) _then;

/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalAnswers = null,Object? correctAnswers = null,Object? accuracy = null,Object? todayAnswers = null,Object? totalDurationMs = null,Object? wrongCount = null,Object? favoriteCount = null,Object? weekAnswers = null,Object? prevWeekAnswers = null,Object? streakDays = null,Object? lastPracticeDay = freezed,Object? activeSession = freezed,Object? daily = null,Object? qtypeStats = null,Object? recent = null,}) {
  return _then(_PracticeDashboard(
totalAnswers: null == totalAnswers ? _self.totalAnswers : totalAnswers // ignore: cast_nullable_to_non_nullable
as int,correctAnswers: null == correctAnswers ? _self.correctAnswers : correctAnswers // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,todayAnswers: null == todayAnswers ? _self.todayAnswers : todayAnswers // ignore: cast_nullable_to_non_nullable
as int,totalDurationMs: null == totalDurationMs ? _self.totalDurationMs : totalDurationMs // ignore: cast_nullable_to_non_nullable
as int,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,favoriteCount: null == favoriteCount ? _self.favoriteCount : favoriteCount // ignore: cast_nullable_to_non_nullable
as int,weekAnswers: null == weekAnswers ? _self.weekAnswers : weekAnswers // ignore: cast_nullable_to_non_nullable
as int,prevWeekAnswers: null == prevWeekAnswers ? _self.prevWeekAnswers : prevWeekAnswers // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,lastPracticeDay: freezed == lastPracticeDay ? _self.lastPracticeDay : lastPracticeDay // ignore: cast_nullable_to_non_nullable
as String?,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as ActiveSessionBrief?,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as List<DailyStat>,qtypeStats: null == qtypeStats ? _self._qtypeStats : qtypeStats // ignore: cast_nullable_to_non_nullable
as List<QtypeStat>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<RecentAnswer>,
  ));
}

/// Create a copy of PracticeDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveSessionBriefCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $ActiveSessionBriefCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}

// dart format on
