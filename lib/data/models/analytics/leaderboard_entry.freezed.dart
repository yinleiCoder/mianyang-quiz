// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardChase {

@JsonKey(name: 'user_id') String get userId; String get name; double get score;/// 与我相差的分数（正数 = 他比我高多少）。
 double get gap;
/// Create a copy of LeaderboardChase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardChaseCopyWith<LeaderboardChase> get copyWith => _$LeaderboardChaseCopyWithImpl<LeaderboardChase>(this as LeaderboardChase, _$identity);

  /// Serializes this LeaderboardChase to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardChase;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardChase&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.gap, _this.gap) || other.gap == _this.gap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardChase;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.score,_this.gap);
}

@override
String toString() {
  final _this = this as LeaderboardChase;
  return 'LeaderboardChase(userId: ${_this.userId}, name: ${_this.name}, score: ${_this.score}, gap: ${_this.gap})';
}


}

/// @nodoc
abstract mixin class $LeaderboardChaseCopyWith<$Res>  {
  factory $LeaderboardChaseCopyWith(LeaderboardChase value, $Res Function(LeaderboardChase) _then) = _$LeaderboardChaseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name, double score, double gap
});




}
/// @nodoc
class _$LeaderboardChaseCopyWithImpl<$Res>
    implements $LeaderboardChaseCopyWith<$Res> {
  _$LeaderboardChaseCopyWithImpl(this._self, this._then);

  final LeaderboardChase _self;
  final $Res Function(LeaderboardChase) _then;

/// Create a copy of LeaderboardChase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? score = null,Object? gap = null,}) {
  return _then(LeaderboardChase(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,gap: null == gap ? _self.gap : gap // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardChase].
extension LeaderboardChasePatterns on LeaderboardChase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardChase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardChase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardChase value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardChase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardChase value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardChase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name,  double score,  double gap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardChase() when $default != null:
return $default(_that.userId,_that.name,_that.score,_that.gap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name,  double score,  double gap)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardChase():
return $default(_that.userId,_that.name,_that.score,_that.gap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String name,  double score,  double gap)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardChase() when $default != null:
return $default(_that.userId,_that.name,_that.score,_that.gap);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardChase implements LeaderboardChase {
  const _LeaderboardChase({@JsonKey(name: 'user_id') required this.userId, this.name = '', this.score = 0, this.gap = 0});
  factory _LeaderboardChase.fromJson(Map<String, dynamic> json) => _$LeaderboardChaseFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey() final  double score;
/// 与我相差的分数（正数 = 他比我高多少）。
@override@JsonKey() final  double gap;

/// Create a copy of LeaderboardChase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardChaseCopyWith<_LeaderboardChase> get copyWith => __$LeaderboardChaseCopyWithImpl<_LeaderboardChase>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardChaseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardChase&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&(identical(other.gap, gap) || other.gap == gap));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,score,gap);
}

@override
String toString() {
    return 'LeaderboardChase(userId: $userId, name: $name, score: $score, gap: $gap)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardChaseCopyWith<$Res> implements $LeaderboardChaseCopyWith<$Res> {
  factory _$LeaderboardChaseCopyWith(_LeaderboardChase value, $Res Function(_LeaderboardChase) _then) = __$LeaderboardChaseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name, double score, double gap
});




}
/// @nodoc
class __$LeaderboardChaseCopyWithImpl<$Res>
    implements _$LeaderboardChaseCopyWith<$Res> {
  __$LeaderboardChaseCopyWithImpl(this._self, this._then);

  final _LeaderboardChase _self;
  final $Res Function(_LeaderboardChase) _then;

/// Create a copy of LeaderboardChase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? score = null,Object? gap = null,}) {
  return _then(_LeaderboardChase(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,gap: null == gap ? _self.gap : gap // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$LeaderboardRow {

 int get order; int get rank;@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'school_id') String? get schoolId;@JsonKey(name: 'school_name') String? get schoolName;@JsonKey(name: 'class_id') String? get classId;@JsonKey(name: 'class_name') String? get className; double get score;@JsonKey(name: 'full_score') double get fullScore; double get percent;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'submitted_at') String? get submittedAt;@JsonKey(name: 'is_me') bool get isMe;
/// Create a copy of LeaderboardRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardRowCopyWith<LeaderboardRow> get copyWith => _$LeaderboardRowCopyWithImpl<LeaderboardRow>(this as LeaderboardRow, _$identity);

  /// Serializes this LeaderboardRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardRow&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName)&&(identical(other.classId, _this.classId) || other.classId == _this.classId)&&(identical(other.className, _this.className) || other.className == _this.className)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardRow;
  return Object.hash(runtimeType,_this.order,_this.rank,_this.userId,_this.name,_this.avatarUrl,_this.schoolId,_this.schoolName,_this.classId,_this.className,_this.score,_this.fullScore,_this.percent,_this.durationMs,_this.submittedAt,_this.isMe);
}

@override
String toString() {
  final _this = this as LeaderboardRow;
  return 'LeaderboardRow(order: ${_this.order}, rank: ${_this.rank}, userId: ${_this.userId}, name: ${_this.name}, avatarUrl: ${_this.avatarUrl}, schoolId: ${_this.schoolId}, schoolName: ${_this.schoolName}, classId: ${_this.classId}, className: ${_this.className}, score: ${_this.score}, fullScore: ${_this.fullScore}, percent: ${_this.percent}, durationMs: ${_this.durationMs}, submittedAt: ${_this.submittedAt}, isMe: ${_this.isMe})';
}


}

/// @nodoc
abstract mixin class $LeaderboardRowCopyWith<$Res>  {
  factory $LeaderboardRowCopyWith(LeaderboardRow value, $Res Function(LeaderboardRow) _then) = _$LeaderboardRowCopyWithImpl;
@useResult
$Res call({
 int order, int rank,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'class_name') String? className, double score,@JsonKey(name: 'full_score') double fullScore, double percent,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'submitted_at') String? submittedAt,@JsonKey(name: 'is_me') bool isMe
});




}
/// @nodoc
class _$LeaderboardRowCopyWithImpl<$Res>
    implements $LeaderboardRowCopyWith<$Res> {
  _$LeaderboardRowCopyWithImpl(this._self, this._then);

  final LeaderboardRow _self;
  final $Res Function(LeaderboardRow) _then;

/// Create a copy of LeaderboardRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? rank = null,Object? userId = null,Object? name = null,Object? avatarUrl = freezed,Object? schoolId = freezed,Object? schoolName = freezed,Object? classId = freezed,Object? className = freezed,Object? score = null,Object? fullScore = null,Object? percent = null,Object? durationMs = null,Object? submittedAt = freezed,Object? isMe = null,}) {
  return _then(LeaderboardRow(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardRow].
extension LeaderboardRowPatterns on LeaderboardRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardRow value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardRow value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int order,  int rank, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'is_me')  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardRow() when $default != null:
return $default(_that.order,_that.rank,_that.userId,_that.name,_that.avatarUrl,_that.schoolId,_that.schoolName,_that.classId,_that.className,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int order,  int rank, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'is_me')  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardRow():
return $default(_that.order,_that.rank,_that.userId,_that.name,_that.avatarUrl,_that.schoolId,_that.schoolName,_that.classId,_that.className,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int order,  int rank, @JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'is_me')  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardRow() when $default != null:
return $default(_that.order,_that.rank,_that.userId,_that.name,_that.avatarUrl,_that.schoolId,_that.schoolName,_that.classId,_that.className,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardRow implements LeaderboardRow {
  const _LeaderboardRow({this.order = 0, this.rank = 0, @JsonKey(name: 'user_id') required this.userId, this.name = '', @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'school_id') this.schoolId, @JsonKey(name: 'school_name') this.schoolName, @JsonKey(name: 'class_id') this.classId, @JsonKey(name: 'class_name') this.className, this.score = 0, @JsonKey(name: 'full_score') this.fullScore = 0, this.percent = 0, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'is_me') this.isMe = false});
  factory _LeaderboardRow.fromJson(Map<String, dynamic> json) => _$LeaderboardRowFromJson(json);

@override@JsonKey() final  int order;
@override@JsonKey() final  int rank;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey(name: 'school_name') final  String? schoolName;
@override@JsonKey(name: 'class_id') final  String? classId;
@override@JsonKey(name: 'class_name') final  String? className;
@override@JsonKey() final  double score;
@override@JsonKey(name: 'full_score') final  double fullScore;
@override@JsonKey() final  double percent;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'submitted_at') final  String? submittedAt;
@override@JsonKey(name: 'is_me') final  bool isMe;

/// Create a copy of LeaderboardRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardRowCopyWith<_LeaderboardRow> get copyWith => __$LeaderboardRowCopyWithImpl<_LeaderboardRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardRow&&(identical(other.order, order) || other.order == order)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.className, className) || other.className == className)&&(identical(other.score, score) || other.score == score)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,order,rank,userId,name,avatarUrl,schoolId,schoolName,classId,className,score,fullScore,percent,durationMs,submittedAt,isMe);
}

@override
String toString() {
    return 'LeaderboardRow(order: $order, rank: $rank, userId: $userId, name: $name, avatarUrl: $avatarUrl, schoolId: $schoolId, schoolName: $schoolName, classId: $classId, className: $className, score: $score, fullScore: $fullScore, percent: $percent, durationMs: $durationMs, submittedAt: $submittedAt, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardRowCopyWith<$Res> implements $LeaderboardRowCopyWith<$Res> {
  factory _$LeaderboardRowCopyWith(_LeaderboardRow value, $Res Function(_LeaderboardRow) _then) = __$LeaderboardRowCopyWithImpl;
@override @useResult
$Res call({
 int order, int rank,@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'class_name') String? className, double score,@JsonKey(name: 'full_score') double fullScore, double percent,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'submitted_at') String? submittedAt,@JsonKey(name: 'is_me') bool isMe
});




}
/// @nodoc
class __$LeaderboardRowCopyWithImpl<$Res>
    implements _$LeaderboardRowCopyWith<$Res> {
  __$LeaderboardRowCopyWithImpl(this._self, this._then);

  final _LeaderboardRow _self;
  final $Res Function(_LeaderboardRow) _then;

/// Create a copy of LeaderboardRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? rank = null,Object? userId = null,Object? name = null,Object? avatarUrl = freezed,Object? schoolId = freezed,Object? schoolName = freezed,Object? classId = freezed,Object? className = freezed,Object? score = null,Object? fullScore = null,Object? percent = null,Object? durationMs = null,Object? submittedAt = freezed,Object? isMe = null,}) {
  return _then(_LeaderboardRow(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LeaderboardViewer {

@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'class_id') String? get classId;@JsonKey(name: 'class_name') String? get className;@JsonKey(name: 'school_id') String? get schoolId;@JsonKey(name: 'school_name') String? get schoolName;/// 当前口径下的名次（看全班榜时就是班内名次）。
 int get rank;@JsonKey(name: 'scope_total') int get scopeTotal; double get score;@JsonKey(name: 'full_score') double get fullScore; double get percent;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'submitted_at') String? get submittedAt;@JsonKey(name: 'class_rank') int? get classRank;@JsonKey(name: 'class_total') int? get classTotal;@JsonKey(name: 'school_rank') int? get schoolRank;@JsonKey(name: 'school_total') int? get schoolTotal;@JsonKey(name: 'city_rank') int? get cityRank;@JsonKey(name: 'city_total') int? get cityTotal;/// 超过全市多少比例的人（0~1）。榜上只有我一人时是 1。
 double get percentile; LeaderboardChase? get chase;
/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardViewerCopyWith<LeaderboardViewer> get copyWith => _$LeaderboardViewerCopyWithImpl<LeaderboardViewer>(this as LeaderboardViewer, _$identity);

  /// Serializes this LeaderboardViewer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardViewer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardViewer&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.classId, _this.classId) || other.classId == _this.classId)&&(identical(other.className, _this.className) || other.className == _this.className)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.scopeTotal, _this.scopeTotal) || other.scopeTotal == _this.scopeTotal)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.percent, _this.percent) || other.percent == _this.percent)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.classRank, _this.classRank) || other.classRank == _this.classRank)&&(identical(other.classTotal, _this.classTotal) || other.classTotal == _this.classTotal)&&(identical(other.schoolRank, _this.schoolRank) || other.schoolRank == _this.schoolRank)&&(identical(other.schoolTotal, _this.schoolTotal) || other.schoolTotal == _this.schoolTotal)&&(identical(other.cityRank, _this.cityRank) || other.cityRank == _this.cityRank)&&(identical(other.cityTotal, _this.cityTotal) || other.cityTotal == _this.cityTotal)&&(identical(other.percentile, _this.percentile) || other.percentile == _this.percentile)&&(identical(other.chase, _this.chase) || other.chase == _this.chase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardViewer;
  return Object.hashAll([runtimeType,_this.userId,_this.name,_this.avatarUrl,_this.classId,_this.className,_this.schoolId,_this.schoolName,_this.rank,_this.scopeTotal,_this.score,_this.fullScore,_this.percent,_this.durationMs,_this.submittedAt,_this.classRank,_this.classTotal,_this.schoolRank,_this.schoolTotal,_this.cityRank,_this.cityTotal,_this.percentile,_this.chase]);
}

@override
String toString() {
  final _this = this as LeaderboardViewer;
  return 'LeaderboardViewer(userId: ${_this.userId}, name: ${_this.name}, avatarUrl: ${_this.avatarUrl}, classId: ${_this.classId}, className: ${_this.className}, schoolId: ${_this.schoolId}, schoolName: ${_this.schoolName}, rank: ${_this.rank}, scopeTotal: ${_this.scopeTotal}, score: ${_this.score}, fullScore: ${_this.fullScore}, percent: ${_this.percent}, durationMs: ${_this.durationMs}, submittedAt: ${_this.submittedAt}, classRank: ${_this.classRank}, classTotal: ${_this.classTotal}, schoolRank: ${_this.schoolRank}, schoolTotal: ${_this.schoolTotal}, cityRank: ${_this.cityRank}, cityTotal: ${_this.cityTotal}, percentile: ${_this.percentile}, chase: ${_this.chase})';
}


}

/// @nodoc
abstract mixin class $LeaderboardViewerCopyWith<$Res>  {
  factory $LeaderboardViewerCopyWith(LeaderboardViewer value, $Res Function(LeaderboardViewer) _then) = _$LeaderboardViewerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'class_name') String? className,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName, int rank,@JsonKey(name: 'scope_total') int scopeTotal, double score,@JsonKey(name: 'full_score') double fullScore, double percent,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'submitted_at') String? submittedAt,@JsonKey(name: 'class_rank') int? classRank,@JsonKey(name: 'class_total') int? classTotal,@JsonKey(name: 'school_rank') int? schoolRank,@JsonKey(name: 'school_total') int? schoolTotal,@JsonKey(name: 'city_rank') int? cityRank,@JsonKey(name: 'city_total') int? cityTotal, double percentile, LeaderboardChase? chase
});


$LeaderboardChaseCopyWith<$Res>? get chase;

}
/// @nodoc
class _$LeaderboardViewerCopyWithImpl<$Res>
    implements $LeaderboardViewerCopyWith<$Res> {
  _$LeaderboardViewerCopyWithImpl(this._self, this._then);

  final LeaderboardViewer _self;
  final $Res Function(LeaderboardViewer) _then;

/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? avatarUrl = freezed,Object? classId = freezed,Object? className = freezed,Object? schoolId = freezed,Object? schoolName = freezed,Object? rank = null,Object? scopeTotal = null,Object? score = null,Object? fullScore = null,Object? percent = null,Object? durationMs = null,Object? submittedAt = freezed,Object? classRank = freezed,Object? classTotal = freezed,Object? schoolRank = freezed,Object? schoolTotal = freezed,Object? cityRank = freezed,Object? cityTotal = freezed,Object? percentile = null,Object? chase = freezed,}) {
  return _then(LeaderboardViewer(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,scopeTotal: null == scopeTotal ? _self.scopeTotal : scopeTotal // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,classRank: freezed == classRank ? _self.classRank : classRank // ignore: cast_nullable_to_non_nullable
as int?,classTotal: freezed == classTotal ? _self.classTotal : classTotal // ignore: cast_nullable_to_non_nullable
as int?,schoolRank: freezed == schoolRank ? _self.schoolRank : schoolRank // ignore: cast_nullable_to_non_nullable
as int?,schoolTotal: freezed == schoolTotal ? _self.schoolTotal : schoolTotal // ignore: cast_nullable_to_non_nullable
as int?,cityRank: freezed == cityRank ? _self.cityRank : cityRank // ignore: cast_nullable_to_non_nullable
as int?,cityTotal: freezed == cityTotal ? _self.cityTotal : cityTotal // ignore: cast_nullable_to_non_nullable
as int?,percentile: null == percentile ? _self.percentile : percentile // ignore: cast_nullable_to_non_nullable
as double,chase: freezed == chase ? _self.chase : chase // ignore: cast_nullable_to_non_nullable
as LeaderboardChase?,
  ));
}
/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardChaseCopyWith<$Res>? get chase {
    if (_self.chase == null) {
    return null;
  }

  return $LeaderboardChaseCopyWith<$Res>(_self.chase!, (value) {
    return _then(_self.copyWith(chase: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaderboardViewer].
extension LeaderboardViewerPatterns on LeaderboardViewer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardViewer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardViewer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardViewer value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardViewer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardViewer value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardViewer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName,  int rank, @JsonKey(name: 'scope_total')  int scopeTotal,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'class_rank')  int? classRank, @JsonKey(name: 'class_total')  int? classTotal, @JsonKey(name: 'school_rank')  int? schoolRank, @JsonKey(name: 'school_total')  int? schoolTotal, @JsonKey(name: 'city_rank')  int? cityRank, @JsonKey(name: 'city_total')  int? cityTotal,  double percentile,  LeaderboardChase? chase)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardViewer() when $default != null:
return $default(_that.userId,_that.name,_that.avatarUrl,_that.classId,_that.className,_that.schoolId,_that.schoolName,_that.rank,_that.scopeTotal,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.classRank,_that.classTotal,_that.schoolRank,_that.schoolTotal,_that.cityRank,_that.cityTotal,_that.percentile,_that.chase);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName,  int rank, @JsonKey(name: 'scope_total')  int scopeTotal,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'class_rank')  int? classRank, @JsonKey(name: 'class_total')  int? classTotal, @JsonKey(name: 'school_rank')  int? schoolRank, @JsonKey(name: 'school_total')  int? schoolTotal, @JsonKey(name: 'city_rank')  int? cityRank, @JsonKey(name: 'city_total')  int? cityTotal,  double percentile,  LeaderboardChase? chase)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardViewer():
return $default(_that.userId,_that.name,_that.avatarUrl,_that.classId,_that.className,_that.schoolId,_that.schoolName,_that.rank,_that.scopeTotal,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.classRank,_that.classTotal,_that.schoolRank,_that.schoolTotal,_that.cityRank,_that.cityTotal,_that.percentile,_that.chase);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName,  int rank, @JsonKey(name: 'scope_total')  int scopeTotal,  double score, @JsonKey(name: 'full_score')  double fullScore,  double percent, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'submitted_at')  String? submittedAt, @JsonKey(name: 'class_rank')  int? classRank, @JsonKey(name: 'class_total')  int? classTotal, @JsonKey(name: 'school_rank')  int? schoolRank, @JsonKey(name: 'school_total')  int? schoolTotal, @JsonKey(name: 'city_rank')  int? cityRank, @JsonKey(name: 'city_total')  int? cityTotal,  double percentile,  LeaderboardChase? chase)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardViewer() when $default != null:
return $default(_that.userId,_that.name,_that.avatarUrl,_that.classId,_that.className,_that.schoolId,_that.schoolName,_that.rank,_that.scopeTotal,_that.score,_that.fullScore,_that.percent,_that.durationMs,_that.submittedAt,_that.classRank,_that.classTotal,_that.schoolRank,_that.schoolTotal,_that.cityRank,_that.cityTotal,_that.percentile,_that.chase);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardViewer implements LeaderboardViewer {
  const _LeaderboardViewer({@JsonKey(name: 'user_id') required this.userId, this.name = '', @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'class_id') this.classId, @JsonKey(name: 'class_name') this.className, @JsonKey(name: 'school_id') this.schoolId, @JsonKey(name: 'school_name') this.schoolName, this.rank = 0, @JsonKey(name: 'scope_total') this.scopeTotal = 0, this.score = 0, @JsonKey(name: 'full_score') this.fullScore = 0, this.percent = 0, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'class_rank') this.classRank, @JsonKey(name: 'class_total') this.classTotal, @JsonKey(name: 'school_rank') this.schoolRank, @JsonKey(name: 'school_total') this.schoolTotal, @JsonKey(name: 'city_rank') this.cityRank, @JsonKey(name: 'city_total') this.cityTotal, this.percentile = 0, this.chase});
  factory _LeaderboardViewer.fromJson(Map<String, dynamic> json) => _$LeaderboardViewerFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'class_id') final  String? classId;
@override@JsonKey(name: 'class_name') final  String? className;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey(name: 'school_name') final  String? schoolName;
/// 当前口径下的名次（看全班榜时就是班内名次）。
@override@JsonKey() final  int rank;
@override@JsonKey(name: 'scope_total') final  int scopeTotal;
@override@JsonKey() final  double score;
@override@JsonKey(name: 'full_score') final  double fullScore;
@override@JsonKey() final  double percent;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'submitted_at') final  String? submittedAt;
@override@JsonKey(name: 'class_rank') final  int? classRank;
@override@JsonKey(name: 'class_total') final  int? classTotal;
@override@JsonKey(name: 'school_rank') final  int? schoolRank;
@override@JsonKey(name: 'school_total') final  int? schoolTotal;
@override@JsonKey(name: 'city_rank') final  int? cityRank;
@override@JsonKey(name: 'city_total') final  int? cityTotal;
/// 超过全市多少比例的人（0~1）。榜上只有我一人时是 1。
@override@JsonKey() final  double percentile;
@override final  LeaderboardChase? chase;

/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardViewerCopyWith<_LeaderboardViewer> get copyWith => __$LeaderboardViewerCopyWithImpl<_LeaderboardViewer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardViewerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardViewer&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.className, className) || other.className == className)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.scopeTotal, scopeTotal) || other.scopeTotal == scopeTotal)&&(identical(other.score, score) || other.score == score)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.classRank, classRank) || other.classRank == classRank)&&(identical(other.classTotal, classTotal) || other.classTotal == classTotal)&&(identical(other.schoolRank, schoolRank) || other.schoolRank == schoolRank)&&(identical(other.schoolTotal, schoolTotal) || other.schoolTotal == schoolTotal)&&(identical(other.cityRank, cityRank) || other.cityRank == cityRank)&&(identical(other.cityTotal, cityTotal) || other.cityTotal == cityTotal)&&(identical(other.percentile, percentile) || other.percentile == percentile)&&(identical(other.chase, chase) || other.chase == chase));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,userId,name,avatarUrl,classId,className,schoolId,schoolName,rank,scopeTotal,score,fullScore,percent,durationMs,submittedAt,classRank,classTotal,schoolRank,schoolTotal,cityRank,cityTotal,percentile,chase]);
}

@override
String toString() {
    return 'LeaderboardViewer(userId: $userId, name: $name, avatarUrl: $avatarUrl, classId: $classId, className: $className, schoolId: $schoolId, schoolName: $schoolName, rank: $rank, scopeTotal: $scopeTotal, score: $score, fullScore: $fullScore, percent: $percent, durationMs: $durationMs, submittedAt: $submittedAt, classRank: $classRank, classTotal: $classTotal, schoolRank: $schoolRank, schoolTotal: $schoolTotal, cityRank: $cityRank, cityTotal: $cityTotal, percentile: $percentile, chase: $chase)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardViewerCopyWith<$Res> implements $LeaderboardViewerCopyWith<$Res> {
  factory _$LeaderboardViewerCopyWith(_LeaderboardViewer value, $Res Function(_LeaderboardViewer) _then) = __$LeaderboardViewerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'class_name') String? className,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName, int rank,@JsonKey(name: 'scope_total') int scopeTotal, double score,@JsonKey(name: 'full_score') double fullScore, double percent,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'submitted_at') String? submittedAt,@JsonKey(name: 'class_rank') int? classRank,@JsonKey(name: 'class_total') int? classTotal,@JsonKey(name: 'school_rank') int? schoolRank,@JsonKey(name: 'school_total') int? schoolTotal,@JsonKey(name: 'city_rank') int? cityRank,@JsonKey(name: 'city_total') int? cityTotal, double percentile, LeaderboardChase? chase
});


@override $LeaderboardChaseCopyWith<$Res>? get chase;

}
/// @nodoc
class __$LeaderboardViewerCopyWithImpl<$Res>
    implements _$LeaderboardViewerCopyWith<$Res> {
  __$LeaderboardViewerCopyWithImpl(this._self, this._then);

  final _LeaderboardViewer _self;
  final $Res Function(_LeaderboardViewer) _then;

/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? avatarUrl = freezed,Object? classId = freezed,Object? className = freezed,Object? schoolId = freezed,Object? schoolName = freezed,Object? rank = null,Object? scopeTotal = null,Object? score = null,Object? fullScore = null,Object? percent = null,Object? durationMs = null,Object? submittedAt = freezed,Object? classRank = freezed,Object? classTotal = freezed,Object? schoolRank = freezed,Object? schoolTotal = freezed,Object? cityRank = freezed,Object? cityTotal = freezed,Object? percentile = null,Object? chase = freezed,}) {
  return _then(_LeaderboardViewer(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,scopeTotal: null == scopeTotal ? _self.scopeTotal : scopeTotal // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,classRank: freezed == classRank ? _self.classRank : classRank // ignore: cast_nullable_to_non_nullable
as int?,classTotal: freezed == classTotal ? _self.classTotal : classTotal // ignore: cast_nullable_to_non_nullable
as int?,schoolRank: freezed == schoolRank ? _self.schoolRank : schoolRank // ignore: cast_nullable_to_non_nullable
as int?,schoolTotal: freezed == schoolTotal ? _self.schoolTotal : schoolTotal // ignore: cast_nullable_to_non_nullable
as int?,cityRank: freezed == cityRank ? _self.cityRank : cityRank // ignore: cast_nullable_to_non_nullable
as int?,cityTotal: freezed == cityTotal ? _self.cityTotal : cityTotal // ignore: cast_nullable_to_non_nullable
as int?,percentile: null == percentile ? _self.percentile : percentile // ignore: cast_nullable_to_non_nullable
as double,chase: freezed == chase ? _self.chase : chase // ignore: cast_nullable_to_non_nullable
as LeaderboardChase?,
  ));
}

/// Create a copy of LeaderboardViewer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardChaseCopyWith<$Res>? get chase {
    if (_self.chase == null) {
    return null;
  }

  return $LeaderboardChaseCopyWith<$Res>(_self.chase!, (value) {
    return _then(_self.copyWith(chase: value));
  });
}
}

// dart format on
