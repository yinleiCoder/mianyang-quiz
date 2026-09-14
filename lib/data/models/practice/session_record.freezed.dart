// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PracticeSessionRecord {

 String get id; String get source; String get status;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'total_count') int get totalCount;@JsonKey(name: 'answered_count') int get answeredCount;@JsonKey(name: 'correct_count') int get correctCount;
/// Create a copy of PracticeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeSessionRecordCopyWith<PracticeSessionRecord> get copyWith => _$PracticeSessionRecordCopyWithImpl<PracticeSessionRecord>(this as PracticeSessionRecord, _$identity);

  /// Serializes this PracticeSessionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PracticeSessionRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeSessionRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.answeredCount, _this.answeredCount) || other.answeredCount == _this.answeredCount)&&(identical(other.correctCount, _this.correctCount) || other.correctCount == _this.correctCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PracticeSessionRecord;
  return Object.hash(runtimeType,_this.id,_this.source,_this.status,_this.startedAt,_this.submittedAt,_this.durationMs,_this.totalCount,_this.answeredCount,_this.correctCount);
}

@override
String toString() {
  final _this = this as PracticeSessionRecord;
  return 'PracticeSessionRecord(id: ${_this.id}, source: ${_this.source}, status: ${_this.status}, startedAt: ${_this.startedAt}, submittedAt: ${_this.submittedAt}, durationMs: ${_this.durationMs}, totalCount: ${_this.totalCount}, answeredCount: ${_this.answeredCount}, correctCount: ${_this.correctCount})';
}


}

/// @nodoc
abstract mixin class $PracticeSessionRecordCopyWith<$Res>  {
  factory $PracticeSessionRecordCopyWith(PracticeSessionRecord value, $Res Function(PracticeSessionRecord) _then) = _$PracticeSessionRecordCopyWithImpl;
@useResult
$Res call({
 String id, String source, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'correct_count') int correctCount
});




}
/// @nodoc
class _$PracticeSessionRecordCopyWithImpl<$Res>
    implements $PracticeSessionRecordCopyWith<$Res> {
  _$PracticeSessionRecordCopyWithImpl(this._self, this._then);

  final PracticeSessionRecord _self;
  final $Res Function(PracticeSessionRecord) _then;

/// Create a copy of PracticeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? status = null,Object? startedAt = freezed,Object? submittedAt = freezed,Object? durationMs = null,Object? totalCount = null,Object? answeredCount = null,Object? correctCount = null,}) {
  return _then(PracticeSessionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PracticeSessionRecord].
extension PracticeSessionRecordPatterns on PracticeSessionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeSessionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeSessionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeSessionRecord value)  $default,){
final _that = this;
switch (_that) {
case _PracticeSessionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeSessionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeSessionRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeSessionRecord() when $default != null:
return $default(_that.id,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount)  $default,) {final _that = this;
switch (_that) {
case _PracticeSessionRecord():
return $default(_that.id,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount)?  $default,) {final _that = this;
switch (_that) {
case _PracticeSessionRecord() when $default != null:
return $default(_that.id,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeSessionRecord implements PracticeSessionRecord {
  const _PracticeSessionRecord({required this.id, this.source = 'all', this.status = 'active', @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'total_count') this.totalCount = 0, @JsonKey(name: 'answered_count') this.answeredCount = 0, @JsonKey(name: 'correct_count') this.correctCount = 0});
  factory _PracticeSessionRecord.fromJson(Map<String, dynamic> json) => _$PracticeSessionRecordFromJson(json);

@override final  String id;
@override@JsonKey() final  String source;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'total_count') final  int totalCount;
@override@JsonKey(name: 'answered_count') final  int answeredCount;
@override@JsonKey(name: 'correct_count') final  int correctCount;

/// Create a copy of PracticeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeSessionRecordCopyWith<_PracticeSessionRecord> get copyWith => __$PracticeSessionRecordCopyWithImpl<_PracticeSessionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeSessionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeSessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.answeredCount, answeredCount) || other.answeredCount == answeredCount)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,source,status,startedAt,submittedAt,durationMs,totalCount,answeredCount,correctCount);
}

@override
String toString() {
    return 'PracticeSessionRecord(id: $id, source: $source, status: $status, startedAt: $startedAt, submittedAt: $submittedAt, durationMs: $durationMs, totalCount: $totalCount, answeredCount: $answeredCount, correctCount: $correctCount)';
}


}

/// @nodoc
abstract mixin class _$PracticeSessionRecordCopyWith<$Res> implements $PracticeSessionRecordCopyWith<$Res> {
  factory _$PracticeSessionRecordCopyWith(_PracticeSessionRecord value, $Res Function(_PracticeSessionRecord) _then) = __$PracticeSessionRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String source, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'correct_count') int correctCount
});




}
/// @nodoc
class __$PracticeSessionRecordCopyWithImpl<$Res>
    implements _$PracticeSessionRecordCopyWith<$Res> {
  __$PracticeSessionRecordCopyWithImpl(this._self, this._then);

  final _PracticeSessionRecord _self;
  final $Res Function(_PracticeSessionRecord) _then;

/// Create a copy of PracticeSessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? status = null,Object? startedAt = freezed,Object? submittedAt = freezed,Object? durationMs = null,Object? totalCount = null,Object? answeredCount = null,Object? correctCount = null,}) {
  return _then(_PracticeSessionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
