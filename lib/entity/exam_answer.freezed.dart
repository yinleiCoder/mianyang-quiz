// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreUnit {

 bool get ok; double get score;
/// Create a copy of ScoreUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreUnitCopyWith<ScoreUnit> get copyWith => _$ScoreUnitCopyWithImpl<ScoreUnit>(this as ScoreUnit, _$identity);

  /// Serializes this ScoreUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScoreUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreUnit&&(identical(other.ok, _this.ok) || other.ok == _this.ok)&&(identical(other.score, _this.score) || other.score == _this.score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScoreUnit;
  return Object.hash(runtimeType,_this.ok,_this.score);
}

@override
String toString() {
  final _this = this as ScoreUnit;
  return 'ScoreUnit(ok: ${_this.ok}, score: ${_this.score})';
}


}

/// @nodoc
abstract mixin class $ScoreUnitCopyWith<$Res>  {
  factory $ScoreUnitCopyWith(ScoreUnit value, $Res Function(ScoreUnit) _then) = _$ScoreUnitCopyWithImpl;
@useResult
$Res call({
 bool ok, double score
});




}
/// @nodoc
class _$ScoreUnitCopyWithImpl<$Res>
    implements $ScoreUnitCopyWith<$Res> {
  _$ScoreUnitCopyWithImpl(this._self, this._then);

  final ScoreUnit _self;
  final $Res Function(ScoreUnit) _then;

/// Create a copy of ScoreUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? score = null,}) {
  return _then(ScoreUnit(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreUnit].
extension ScoreUnitPatterns on ScoreUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreUnit value)  $default,){
final _that = this;
switch (_that) {
case _ScoreUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreUnit value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  double score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreUnit() when $default != null:
return $default(_that.ok,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  double score)  $default,) {final _that = this;
switch (_that) {
case _ScoreUnit():
return $default(_that.ok,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  double score)?  $default,) {final _that = this;
switch (_that) {
case _ScoreUnit() when $default != null:
return $default(_that.ok,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreUnit implements ScoreUnit {
  const _ScoreUnit({this.ok = false, this.score = 0});
  factory _ScoreUnit.fromJson(Map<String, dynamic> json) => _$ScoreUnitFromJson(json);

@override@JsonKey() final  bool ok;
@override@JsonKey() final  double score;

/// Create a copy of ScoreUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreUnitCopyWith<_ScoreUnit> get copyWith => __$ScoreUnitCopyWithImpl<_ScoreUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreUnitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreUnit&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ok,score);
}

@override
String toString() {
    return 'ScoreUnit(ok: $ok, score: $score)';
}


}

/// @nodoc
abstract mixin class _$ScoreUnitCopyWith<$Res> implements $ScoreUnitCopyWith<$Res> {
  factory _$ScoreUnitCopyWith(_ScoreUnit value, $Res Function(_ScoreUnit) _then) = __$ScoreUnitCopyWithImpl;
@override @useResult
$Res call({
 bool ok, double score
});




}
/// @nodoc
class __$ScoreUnitCopyWithImpl<$Res>
    implements _$ScoreUnitCopyWith<$Res> {
  __$ScoreUnitCopyWithImpl(this._self, this._then);

  final _ScoreUnit _self;
  final $Res Function(_ScoreUnit) _then;

/// Create a copy of ScoreUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? score = null,}) {
  return _then(_ScoreUnit(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ExamAnswerRecord {

@JsonKey(name: 'paper_item_id') String get paperItemId; int get seq;/// 学生提交上去的那份 JSON（形状见 domain/submitted_answer.dart）。
/// 未作答是空 Map，不是 null。
 Map<String, dynamic> get answer; List<ScoreUnit> get units;/// 本题得分。主观题在教师给分前恒为 0（**不是**"答错了"）。
 double get score;/// auto（机器判）/ manual（教师判）/ pending（待教师判）。
 String get grading;/// 机器或教师判定的对错。主观题判分前是 null。
@JsonKey(name: 'is_correct') bool? get isCorrect;/// 教师评语（可选）。
 String? get comment;
/// Create a copy of ExamAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamAnswerRecordCopyWith<ExamAnswerRecord> get copyWith => _$ExamAnswerRecordCopyWithImpl<ExamAnswerRecord>(this as ExamAnswerRecord, _$identity);

  /// Serializes this ExamAnswerRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamAnswerRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamAnswerRecord&&(identical(other.paperItemId, _this.paperItemId) || other.paperItemId == _this.paperItemId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&const DeepCollectionEquality().equals(other.answer, _this.answer)&&const DeepCollectionEquality().equals(other.units, _this.units)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.grading, _this.grading) || other.grading == _this.grading)&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect)&&(identical(other.comment, _this.comment) || other.comment == _this.comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamAnswerRecord;
  return Object.hash(runtimeType,_this.paperItemId,_this.seq,const DeepCollectionEquality().hash(_this.answer),const DeepCollectionEquality().hash(_this.units),_this.score,_this.grading,_this.isCorrect,_this.comment);
}

@override
String toString() {
  final _this = this as ExamAnswerRecord;
  return 'ExamAnswerRecord(paperItemId: ${_this.paperItemId}, seq: ${_this.seq}, answer: ${_this.answer}, units: ${_this.units}, score: ${_this.score}, grading: ${_this.grading}, isCorrect: ${_this.isCorrect}, comment: ${_this.comment})';
}


}

/// @nodoc
abstract mixin class $ExamAnswerRecordCopyWith<$Res>  {
  factory $ExamAnswerRecordCopyWith(ExamAnswerRecord value, $Res Function(ExamAnswerRecord) _then) = _$ExamAnswerRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'paper_item_id') String paperItemId, int seq, Map<String, dynamic> answer, List<ScoreUnit> units, double score, String grading,@JsonKey(name: 'is_correct') bool? isCorrect, String? comment
});




}
/// @nodoc
class _$ExamAnswerRecordCopyWithImpl<$Res>
    implements $ExamAnswerRecordCopyWith<$Res> {
  _$ExamAnswerRecordCopyWithImpl(this._self, this._then);

  final ExamAnswerRecord _self;
  final $Res Function(ExamAnswerRecord) _then;

/// Create a copy of ExamAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paperItemId = null,Object? seq = null,Object? answer = null,Object? units = null,Object? score = null,Object? grading = null,Object? isCorrect = freezed,Object? comment = freezed,}) {
  return _then(ExamAnswerRecord(
paperItemId: null == paperItemId ? _self.paperItemId : paperItemId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<ScoreUnit>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamAnswerRecord].
extension ExamAnswerRecordPatterns on ExamAnswerRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamAnswerRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamAnswerRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamAnswerRecord value)  $default,){
final _that = this;
switch (_that) {
case _ExamAnswerRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamAnswerRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ExamAnswerRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'paper_item_id')  String paperItemId,  int seq,  Map<String, dynamic> answer,  List<ScoreUnit> units,  double score,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamAnswerRecord() when $default != null:
return $default(_that.paperItemId,_that.seq,_that.answer,_that.units,_that.score,_that.grading,_that.isCorrect,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'paper_item_id')  String paperItemId,  int seq,  Map<String, dynamic> answer,  List<ScoreUnit> units,  double score,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _ExamAnswerRecord():
return $default(_that.paperItemId,_that.seq,_that.answer,_that.units,_that.score,_that.grading,_that.isCorrect,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'paper_item_id')  String paperItemId,  int seq,  Map<String, dynamic> answer,  List<ScoreUnit> units,  double score,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _ExamAnswerRecord() when $default != null:
return $default(_that.paperItemId,_that.seq,_that.answer,_that.units,_that.score,_that.grading,_that.isCorrect,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamAnswerRecord implements ExamAnswerRecord {
  const _ExamAnswerRecord({@JsonKey(name: 'paper_item_id') required this.paperItemId, this.seq = 0,  Map<String, dynamic> answer = const <String, dynamic>{},  List<ScoreUnit> units = const <ScoreUnit>[], this.score = 0, this.grading = 'auto', @JsonKey(name: 'is_correct') this.isCorrect, this.comment}): _answer = answer,_units = units;
  factory _ExamAnswerRecord.fromJson(Map<String, dynamic> json) => _$ExamAnswerRecordFromJson(json);

@override@JsonKey(name: 'paper_item_id') final  String paperItemId;
@override@JsonKey() final  int seq;
/// 学生提交上去的那份 JSON（形状见 domain/submitted_answer.dart）。
/// 未作答是空 Map，不是 null。
 final  Map<String, dynamic> _answer;
/// 学生提交上去的那份 JSON（形状见 domain/submitted_answer.dart）。
/// 未作答是空 Map，不是 null。
@override@JsonKey() Map<String, dynamic> get answer {
  if (_answer is EqualUnmodifiableMapView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answer);
}

 final  List<ScoreUnit> _units;
@override@JsonKey() List<ScoreUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

/// 本题得分。主观题在教师给分前恒为 0（**不是**"答错了"）。
@override@JsonKey() final  double score;
/// auto（机器判）/ manual（教师判）/ pending（待教师判）。
@override@JsonKey() final  String grading;
/// 机器或教师判定的对错。主观题判分前是 null。
@override@JsonKey(name: 'is_correct') final  bool? isCorrect;
/// 教师评语（可选）。
@override final  String? comment;

/// Create a copy of ExamAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamAnswerRecordCopyWith<_ExamAnswerRecord> get copyWith => __$ExamAnswerRecordCopyWithImpl<_ExamAnswerRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamAnswerRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamAnswerRecord&&(identical(other.paperItemId, paperItemId) || other.paperItemId == paperItemId)&&(identical(other.seq, seq) || other.seq == seq)&&const DeepCollectionEquality().equals(other.answer, _answer)&&const DeepCollectionEquality().equals(other.units, _units)&&(identical(other.score, score) || other.score == score)&&(identical(other.grading, grading) || other.grading == grading)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,paperItemId,seq,const DeepCollectionEquality().hash(_answer),const DeepCollectionEquality().hash(_units),score,grading,isCorrect,comment);
}

@override
String toString() {
    return 'ExamAnswerRecord(paperItemId: $paperItemId, seq: $seq, answer: $answer, units: $units, score: $score, grading: $grading, isCorrect: $isCorrect, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$ExamAnswerRecordCopyWith<$Res> implements $ExamAnswerRecordCopyWith<$Res> {
  factory _$ExamAnswerRecordCopyWith(_ExamAnswerRecord value, $Res Function(_ExamAnswerRecord) _then) = __$ExamAnswerRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'paper_item_id') String paperItemId, int seq, Map<String, dynamic> answer, List<ScoreUnit> units, double score, String grading,@JsonKey(name: 'is_correct') bool? isCorrect, String? comment
});




}
/// @nodoc
class __$ExamAnswerRecordCopyWithImpl<$Res>
    implements _$ExamAnswerRecordCopyWith<$Res> {
  __$ExamAnswerRecordCopyWithImpl(this._self, this._then);

  final _ExamAnswerRecord _self;
  final $Res Function(_ExamAnswerRecord) _then;

/// Create a copy of ExamAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paperItemId = null,Object? seq = null,Object? answer = null,Object? units = null,Object? score = null,Object? grading = null,Object? isCorrect = freezed,Object? comment = freezed,}) {
  return _then(_ExamAnswerRecord(
paperItemId: null == paperItemId ? _self.paperItemId : paperItemId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,answer: null == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<ScoreUnit>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
