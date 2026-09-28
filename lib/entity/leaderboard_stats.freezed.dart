// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardStats {

/// 当前口径下上榜人数。
 int get total; int get graded;/// 已交卷但还没判完（主观题）的人数。
 int get ungraded;/// 考的是旧版卷面、因此不计入本榜的场次。
@JsonKey(name: 'other_version_skipped') int get otherVersionSkipped;@JsonKey(name: 'avg_score') double? get avgScore;@JsonKey(name: 'avg_percent') double? get avgPercent;@JsonKey(name: 'max_score') double? get maxScore;@JsonKey(name: 'min_score') double? get minScore;@JsonKey(name: 'median_percent') double? get medianPercent;@JsonKey(name: 'p25_percent') double? get p25Percent;@JsonKey(name: 'p75_percent') double? get p75Percent;
/// Create a copy of LeaderboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardStatsCopyWith<LeaderboardStats> get copyWith => _$LeaderboardStatsCopyWithImpl<LeaderboardStats>(this as LeaderboardStats, _$identity);

  /// Serializes this LeaderboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.graded, _this.graded) || other.graded == _this.graded)&&(identical(other.ungraded, _this.ungraded) || other.ungraded == _this.ungraded)&&(identical(other.otherVersionSkipped, _this.otherVersionSkipped) || other.otherVersionSkipped == _this.otherVersionSkipped)&&(identical(other.avgScore, _this.avgScore) || other.avgScore == _this.avgScore)&&(identical(other.avgPercent, _this.avgPercent) || other.avgPercent == _this.avgPercent)&&(identical(other.maxScore, _this.maxScore) || other.maxScore == _this.maxScore)&&(identical(other.minScore, _this.minScore) || other.minScore == _this.minScore)&&(identical(other.medianPercent, _this.medianPercent) || other.medianPercent == _this.medianPercent)&&(identical(other.p25Percent, _this.p25Percent) || other.p25Percent == _this.p25Percent)&&(identical(other.p75Percent, _this.p75Percent) || other.p75Percent == _this.p75Percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardStats;
  return Object.hash(runtimeType,_this.total,_this.graded,_this.ungraded,_this.otherVersionSkipped,_this.avgScore,_this.avgPercent,_this.maxScore,_this.minScore,_this.medianPercent,_this.p25Percent,_this.p75Percent);
}

@override
String toString() {
  final _this = this as LeaderboardStats;
  return 'LeaderboardStats(total: ${_this.total}, graded: ${_this.graded}, ungraded: ${_this.ungraded}, otherVersionSkipped: ${_this.otherVersionSkipped}, avgScore: ${_this.avgScore}, avgPercent: ${_this.avgPercent}, maxScore: ${_this.maxScore}, minScore: ${_this.minScore}, medianPercent: ${_this.medianPercent}, p25Percent: ${_this.p25Percent}, p75Percent: ${_this.p75Percent})';
}


}

/// @nodoc
abstract mixin class $LeaderboardStatsCopyWith<$Res>  {
  factory $LeaderboardStatsCopyWith(LeaderboardStats value, $Res Function(LeaderboardStats) _then) = _$LeaderboardStatsCopyWithImpl;
@useResult
$Res call({
 int total, int graded, int ungraded,@JsonKey(name: 'other_version_skipped') int otherVersionSkipped,@JsonKey(name: 'avg_score') double? avgScore,@JsonKey(name: 'avg_percent') double? avgPercent,@JsonKey(name: 'max_score') double? maxScore,@JsonKey(name: 'min_score') double? minScore,@JsonKey(name: 'median_percent') double? medianPercent,@JsonKey(name: 'p25_percent') double? p25Percent,@JsonKey(name: 'p75_percent') double? p75Percent
});




}
/// @nodoc
class _$LeaderboardStatsCopyWithImpl<$Res>
    implements $LeaderboardStatsCopyWith<$Res> {
  _$LeaderboardStatsCopyWithImpl(this._self, this._then);

  final LeaderboardStats _self;
  final $Res Function(LeaderboardStats) _then;

/// Create a copy of LeaderboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? graded = null,Object? ungraded = null,Object? otherVersionSkipped = null,Object? avgScore = freezed,Object? avgPercent = freezed,Object? maxScore = freezed,Object? minScore = freezed,Object? medianPercent = freezed,Object? p25Percent = freezed,Object? p75Percent = freezed,}) {
  return _then(LeaderboardStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,ungraded: null == ungraded ? _self.ungraded : ungraded // ignore: cast_nullable_to_non_nullable
as int,otherVersionSkipped: null == otherVersionSkipped ? _self.otherVersionSkipped : otherVersionSkipped // ignore: cast_nullable_to_non_nullable
as int,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,avgPercent: freezed == avgPercent ? _self.avgPercent : avgPercent // ignore: cast_nullable_to_non_nullable
as double?,maxScore: freezed == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as double?,minScore: freezed == minScore ? _self.minScore : minScore // ignore: cast_nullable_to_non_nullable
as double?,medianPercent: freezed == medianPercent ? _self.medianPercent : medianPercent // ignore: cast_nullable_to_non_nullable
as double?,p25Percent: freezed == p25Percent ? _self.p25Percent : p25Percent // ignore: cast_nullable_to_non_nullable
as double?,p75Percent: freezed == p75Percent ? _self.p75Percent : p75Percent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardStats].
extension LeaderboardStatsPatterns on LeaderboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardStats value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int graded,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped, @JsonKey(name: 'avg_score')  double? avgScore, @JsonKey(name: 'avg_percent')  double? avgPercent, @JsonKey(name: 'max_score')  double? maxScore, @JsonKey(name: 'min_score')  double? minScore, @JsonKey(name: 'median_percent')  double? medianPercent, @JsonKey(name: 'p25_percent')  double? p25Percent, @JsonKey(name: 'p75_percent')  double? p75Percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardStats() when $default != null:
return $default(_that.total,_that.graded,_that.ungraded,_that.otherVersionSkipped,_that.avgScore,_that.avgPercent,_that.maxScore,_that.minScore,_that.medianPercent,_that.p25Percent,_that.p75Percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int graded,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped, @JsonKey(name: 'avg_score')  double? avgScore, @JsonKey(name: 'avg_percent')  double? avgPercent, @JsonKey(name: 'max_score')  double? maxScore, @JsonKey(name: 'min_score')  double? minScore, @JsonKey(name: 'median_percent')  double? medianPercent, @JsonKey(name: 'p25_percent')  double? p25Percent, @JsonKey(name: 'p75_percent')  double? p75Percent)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardStats():
return $default(_that.total,_that.graded,_that.ungraded,_that.otherVersionSkipped,_that.avgScore,_that.avgPercent,_that.maxScore,_that.minScore,_that.medianPercent,_that.p25Percent,_that.p75Percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int graded,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped, @JsonKey(name: 'avg_score')  double? avgScore, @JsonKey(name: 'avg_percent')  double? avgPercent, @JsonKey(name: 'max_score')  double? maxScore, @JsonKey(name: 'min_score')  double? minScore, @JsonKey(name: 'median_percent')  double? medianPercent, @JsonKey(name: 'p25_percent')  double? p25Percent, @JsonKey(name: 'p75_percent')  double? p75Percent)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardStats() when $default != null:
return $default(_that.total,_that.graded,_that.ungraded,_that.otherVersionSkipped,_that.avgScore,_that.avgPercent,_that.maxScore,_that.minScore,_that.medianPercent,_that.p25Percent,_that.p75Percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardStats implements LeaderboardStats {
  const _LeaderboardStats({this.total = 0, this.graded = 0, this.ungraded = 0, @JsonKey(name: 'other_version_skipped') this.otherVersionSkipped = 0, @JsonKey(name: 'avg_score') this.avgScore, @JsonKey(name: 'avg_percent') this.avgPercent, @JsonKey(name: 'max_score') this.maxScore, @JsonKey(name: 'min_score') this.minScore, @JsonKey(name: 'median_percent') this.medianPercent, @JsonKey(name: 'p25_percent') this.p25Percent, @JsonKey(name: 'p75_percent') this.p75Percent});
  factory _LeaderboardStats.fromJson(Map<String, dynamic> json) => _$LeaderboardStatsFromJson(json);

/// 当前口径下上榜人数。
@override@JsonKey() final  int total;
@override@JsonKey() final  int graded;
/// 已交卷但还没判完（主观题）的人数。
@override@JsonKey() final  int ungraded;
/// 考的是旧版卷面、因此不计入本榜的场次。
@override@JsonKey(name: 'other_version_skipped') final  int otherVersionSkipped;
@override@JsonKey(name: 'avg_score') final  double? avgScore;
@override@JsonKey(name: 'avg_percent') final  double? avgPercent;
@override@JsonKey(name: 'max_score') final  double? maxScore;
@override@JsonKey(name: 'min_score') final  double? minScore;
@override@JsonKey(name: 'median_percent') final  double? medianPercent;
@override@JsonKey(name: 'p25_percent') final  double? p25Percent;
@override@JsonKey(name: 'p75_percent') final  double? p75Percent;

/// Create a copy of LeaderboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardStatsCopyWith<_LeaderboardStats> get copyWith => __$LeaderboardStatsCopyWithImpl<_LeaderboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardStats&&(identical(other.total, total) || other.total == total)&&(identical(other.graded, graded) || other.graded == graded)&&(identical(other.ungraded, ungraded) || other.ungraded == ungraded)&&(identical(other.otherVersionSkipped, otherVersionSkipped) || other.otherVersionSkipped == otherVersionSkipped)&&(identical(other.avgScore, avgScore) || other.avgScore == avgScore)&&(identical(other.avgPercent, avgPercent) || other.avgPercent == avgPercent)&&(identical(other.maxScore, maxScore) || other.maxScore == maxScore)&&(identical(other.minScore, minScore) || other.minScore == minScore)&&(identical(other.medianPercent, medianPercent) || other.medianPercent == medianPercent)&&(identical(other.p25Percent, p25Percent) || other.p25Percent == p25Percent)&&(identical(other.p75Percent, p75Percent) || other.p75Percent == p75Percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,graded,ungraded,otherVersionSkipped,avgScore,avgPercent,maxScore,minScore,medianPercent,p25Percent,p75Percent);
}

@override
String toString() {
    return 'LeaderboardStats(total: $total, graded: $graded, ungraded: $ungraded, otherVersionSkipped: $otherVersionSkipped, avgScore: $avgScore, avgPercent: $avgPercent, maxScore: $maxScore, minScore: $minScore, medianPercent: $medianPercent, p25Percent: $p25Percent, p75Percent: $p75Percent)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardStatsCopyWith<$Res> implements $LeaderboardStatsCopyWith<$Res> {
  factory _$LeaderboardStatsCopyWith(_LeaderboardStats value, $Res Function(_LeaderboardStats) _then) = __$LeaderboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int graded, int ungraded,@JsonKey(name: 'other_version_skipped') int otherVersionSkipped,@JsonKey(name: 'avg_score') double? avgScore,@JsonKey(name: 'avg_percent') double? avgPercent,@JsonKey(name: 'max_score') double? maxScore,@JsonKey(name: 'min_score') double? minScore,@JsonKey(name: 'median_percent') double? medianPercent,@JsonKey(name: 'p25_percent') double? p25Percent,@JsonKey(name: 'p75_percent') double? p75Percent
});




}
/// @nodoc
class __$LeaderboardStatsCopyWithImpl<$Res>
    implements _$LeaderboardStatsCopyWith<$Res> {
  __$LeaderboardStatsCopyWithImpl(this._self, this._then);

  final _LeaderboardStats _self;
  final $Res Function(_LeaderboardStats) _then;

/// Create a copy of LeaderboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? graded = null,Object? ungraded = null,Object? otherVersionSkipped = null,Object? avgScore = freezed,Object? avgPercent = freezed,Object? maxScore = freezed,Object? minScore = freezed,Object? medianPercent = freezed,Object? p25Percent = freezed,Object? p75Percent = freezed,}) {
  return _then(_LeaderboardStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,ungraded: null == ungraded ? _self.ungraded : ungraded // ignore: cast_nullable_to_non_nullable
as int,otherVersionSkipped: null == otherVersionSkipped ? _self.otherVersionSkipped : otherVersionSkipped // ignore: cast_nullable_to_non_nullable
as int,avgScore: freezed == avgScore ? _self.avgScore : avgScore // ignore: cast_nullable_to_non_nullable
as double?,avgPercent: freezed == avgPercent ? _self.avgPercent : avgPercent // ignore: cast_nullable_to_non_nullable
as double?,maxScore: freezed == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as double?,minScore: freezed == minScore ? _self.minScore : minScore // ignore: cast_nullable_to_non_nullable
as double?,medianPercent: freezed == medianPercent ? _self.medianPercent : medianPercent // ignore: cast_nullable_to_non_nullable
as double?,p25Percent: freezed == p25Percent ? _self.p25Percent : p25Percent // ignore: cast_nullable_to_non_nullable
as double?,p75Percent: freezed == p75Percent ? _self.p75Percent : p75Percent // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
