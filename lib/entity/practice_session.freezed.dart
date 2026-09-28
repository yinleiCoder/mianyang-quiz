// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PracticeItem {

 int get seq;@JsonKey(name: 'question_id') String get questionId;@JsonKey(name: 'version_id') String get versionId; String get qtype; int? get difficulty;@JsonKey(name: 'course_node_id') String? get courseNodeId; QuestionContent get content;
/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeItemCopyWith<PracticeItem> get copyWith => _$PracticeItemCopyWithImpl<PracticeItem>(this as PracticeItem, _$identity);

  /// Serializes this PracticeItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PracticeItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeItem&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.courseNodeId, _this.courseNodeId) || other.courseNodeId == _this.courseNodeId)&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PracticeItem;
  return Object.hash(runtimeType,_this.seq,_this.questionId,_this.versionId,_this.qtype,_this.difficulty,_this.courseNodeId,_this.content);
}

@override
String toString() {
  final _this = this as PracticeItem;
  return 'PracticeItem(seq: ${_this.seq}, questionId: ${_this.questionId}, versionId: ${_this.versionId}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, courseNodeId: ${_this.courseNodeId}, content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $PracticeItemCopyWith<$Res>  {
  factory $PracticeItemCopyWith(PracticeItem value, $Res Function(PracticeItem) _then) = _$PracticeItemCopyWithImpl;
@useResult
$Res call({
 int seq,@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String versionId, String qtype, int? difficulty,@JsonKey(name: 'course_node_id') String? courseNodeId, QuestionContent content
});


$QuestionContentCopyWith<$Res> get content;

}
/// @nodoc
class _$PracticeItemCopyWithImpl<$Res>
    implements $PracticeItemCopyWith<$Res> {
  _$PracticeItemCopyWithImpl(this._self, this._then);

  final PracticeItem _self;
  final $Res Function(PracticeItem) _then;

/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seq = null,Object? questionId = null,Object? versionId = null,Object? qtype = null,Object? difficulty = freezed,Object? courseNodeId = freezed,Object? content = null,}) {
  return _then(PracticeItem(
seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as QuestionContent,
  ));
}
/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionContentCopyWith<$Res> get content {
  
  return $QuestionContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [PracticeItem].
extension PracticeItemPatterns on PracticeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeItem value)  $default,){
final _that = this;
switch (_that) {
case _PracticeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeItem value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seq, @JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId,  QuestionContent content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeItem() when $default != null:
return $default(_that.seq,_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seq, @JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId,  QuestionContent content)  $default,) {final _that = this;
switch (_that) {
case _PracticeItem():
return $default(_that.seq,_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seq, @JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId,  QuestionContent content)?  $default,) {final _that = this;
switch (_that) {
case _PracticeItem() when $default != null:
return $default(_that.seq,_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeItem implements PracticeItem {
  const _PracticeItem({required this.seq, @JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'version_id') required this.versionId, required this.qtype, this.difficulty, @JsonKey(name: 'course_node_id') this.courseNodeId, required this.content});
  factory _PracticeItem.fromJson(Map<String, dynamic> json) => _$PracticeItemFromJson(json);

@override final  int seq;
@override@JsonKey(name: 'question_id') final  String questionId;
@override@JsonKey(name: 'version_id') final  String versionId;
@override final  String qtype;
@override final  int? difficulty;
@override@JsonKey(name: 'course_node_id') final  String? courseNodeId;
@override final  QuestionContent content;

/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeItemCopyWith<_PracticeItem> get copyWith => __$PracticeItemCopyWithImpl<_PracticeItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeItem&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.courseNodeId, courseNodeId) || other.courseNodeId == courseNodeId)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seq,questionId,versionId,qtype,difficulty,courseNodeId,content);
}

@override
String toString() {
    return 'PracticeItem(seq: $seq, questionId: $questionId, versionId: $versionId, qtype: $qtype, difficulty: $difficulty, courseNodeId: $courseNodeId, content: $content)';
}


}

/// @nodoc
abstract mixin class _$PracticeItemCopyWith<$Res> implements $PracticeItemCopyWith<$Res> {
  factory _$PracticeItemCopyWith(_PracticeItem value, $Res Function(_PracticeItem) _then) = __$PracticeItemCopyWithImpl;
@override @useResult
$Res call({
 int seq,@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String versionId, String qtype, int? difficulty,@JsonKey(name: 'course_node_id') String? courseNodeId, QuestionContent content
});


@override $QuestionContentCopyWith<$Res> get content;

}
/// @nodoc
class __$PracticeItemCopyWithImpl<$Res>
    implements _$PracticeItemCopyWith<$Res> {
  __$PracticeItemCopyWithImpl(this._self, this._then);

  final _PracticeItem _self;
  final $Res Function(_PracticeItem) _then;

/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seq = null,Object? questionId = null,Object? versionId = null,Object? qtype = null,Object? difficulty = freezed,Object? courseNodeId = freezed,Object? content = null,}) {
  return _then(_PracticeItem(
seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as QuestionContent,
  ));
}

/// Create a copy of PracticeItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionContentCopyWith<$Res> get content {
  
  return $QuestionContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$PracticeAnswerRecord {

@JsonKey(name: 'question_id') String get questionId; Map<String, dynamic> get answer; String get grading;@JsonKey(name: 'is_correct') bool? get isCorrect;@JsonKey(name: 'self_mastered') bool? get selfMastered;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'answered_at') DateTime? get answeredAt;
/// Create a copy of PracticeAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeAnswerRecordCopyWith<PracticeAnswerRecord> get copyWith => _$PracticeAnswerRecordCopyWithImpl<PracticeAnswerRecord>(this as PracticeAnswerRecord, _$identity);

  /// Serializes this PracticeAnswerRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PracticeAnswerRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeAnswerRecord&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&const DeepCollectionEquality().equals(other.answer, _this.answer)&&(identical(other.grading, _this.grading) || other.grading == _this.grading)&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect)&&(identical(other.selfMastered, _this.selfMastered) || other.selfMastered == _this.selfMastered)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.answeredAt, _this.answeredAt) || other.answeredAt == _this.answeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PracticeAnswerRecord;
  return Object.hash(runtimeType,_this.questionId,const DeepCollectionEquality().hash(_this.answer),_this.grading,_this.isCorrect,_this.selfMastered,_this.durationMs,_this.answeredAt);
}

@override
String toString() {
  final _this = this as PracticeAnswerRecord;
  return 'PracticeAnswerRecord(questionId: ${_this.questionId}, answer: ${_this.answer}, grading: ${_this.grading}, isCorrect: ${_this.isCorrect}, selfMastered: ${_this.selfMastered}, durationMs: ${_this.durationMs}, answeredAt: ${_this.answeredAt})';
}


}

/// @nodoc
abstract mixin class $PracticeAnswerRecordCopyWith<$Res>  {
  factory $PracticeAnswerRecordCopyWith(PracticeAnswerRecord value, $Res Function(PracticeAnswerRecord) _then) = _$PracticeAnswerRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') String questionId, Map<String, dynamic> answer, String grading,@JsonKey(name: 'is_correct') bool? isCorrect,@JsonKey(name: 'self_mastered') bool? selfMastered,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'answered_at') DateTime? answeredAt
});




}
/// @nodoc
class _$PracticeAnswerRecordCopyWithImpl<$Res>
    implements $PracticeAnswerRecordCopyWith<$Res> {
  _$PracticeAnswerRecordCopyWithImpl(this._self, this._then);

  final PracticeAnswerRecord _self;
  final $Res Function(PracticeAnswerRecord) _then;

/// Create a copy of PracticeAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? answer = null,Object? grading = null,Object? isCorrect = freezed,Object? selfMastered = freezed,Object? durationMs = null,Object? answeredAt = freezed,}) {
  return _then(PracticeAnswerRecord(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,selfMastered: freezed == selfMastered ? _self.selfMastered : selfMastered // ignore: cast_nullable_to_non_nullable
as bool?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PracticeAnswerRecord].
extension PracticeAnswerRecordPatterns on PracticeAnswerRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeAnswerRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeAnswerRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeAnswerRecord value)  $default,){
final _that = this;
switch (_that) {
case _PracticeAnswerRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeAnswerRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeAnswerRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId,  Map<String, dynamic> answer,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect, @JsonKey(name: 'self_mastered')  bool? selfMastered, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'answered_at')  DateTime? answeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeAnswerRecord() when $default != null:
return $default(_that.questionId,_that.answer,_that.grading,_that.isCorrect,_that.selfMastered,_that.durationMs,_that.answeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId,  Map<String, dynamic> answer,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect, @JsonKey(name: 'self_mastered')  bool? selfMastered, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'answered_at')  DateTime? answeredAt)  $default,) {final _that = this;
switch (_that) {
case _PracticeAnswerRecord():
return $default(_that.questionId,_that.answer,_that.grading,_that.isCorrect,_that.selfMastered,_that.durationMs,_that.answeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  String questionId,  Map<String, dynamic> answer,  String grading, @JsonKey(name: 'is_correct')  bool? isCorrect, @JsonKey(name: 'self_mastered')  bool? selfMastered, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'answered_at')  DateTime? answeredAt)?  $default,) {final _that = this;
switch (_that) {
case _PracticeAnswerRecord() when $default != null:
return $default(_that.questionId,_that.answer,_that.grading,_that.isCorrect,_that.selfMastered,_that.durationMs,_that.answeredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeAnswerRecord implements PracticeAnswerRecord {
  const _PracticeAnswerRecord({@JsonKey(name: 'question_id') required this.questionId,  Map<String, dynamic> answer = const <String, dynamic>{}, this.grading = 'auto', @JsonKey(name: 'is_correct') this.isCorrect, @JsonKey(name: 'self_mastered') this.selfMastered, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'answered_at') this.answeredAt}): _answer = answer;
  factory _PracticeAnswerRecord.fromJson(Map<String, dynamic> json) => _$PracticeAnswerRecordFromJson(json);

@override@JsonKey(name: 'question_id') final  String questionId;
 final  Map<String, dynamic> _answer;
@override@JsonKey() Map<String, dynamic> get answer {
  if (_answer is EqualUnmodifiableMapView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answer);
}

@override@JsonKey() final  String grading;
@override@JsonKey(name: 'is_correct') final  bool? isCorrect;
@override@JsonKey(name: 'self_mastered') final  bool? selfMastered;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'answered_at') final  DateTime? answeredAt;

/// Create a copy of PracticeAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeAnswerRecordCopyWith<_PracticeAnswerRecord> get copyWith => __$PracticeAnswerRecordCopyWithImpl<_PracticeAnswerRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeAnswerRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeAnswerRecord&&(identical(other.questionId, questionId) || other.questionId == questionId)&&const DeepCollectionEquality().equals(other.answer, _answer)&&(identical(other.grading, grading) || other.grading == grading)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.selfMastered, selfMastered) || other.selfMastered == selfMastered)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,const DeepCollectionEquality().hash(_answer),grading,isCorrect,selfMastered,durationMs,answeredAt);
}

@override
String toString() {
    return 'PracticeAnswerRecord(questionId: $questionId, answer: $answer, grading: $grading, isCorrect: $isCorrect, selfMastered: $selfMastered, durationMs: $durationMs, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class _$PracticeAnswerRecordCopyWith<$Res> implements $PracticeAnswerRecordCopyWith<$Res> {
  factory _$PracticeAnswerRecordCopyWith(_PracticeAnswerRecord value, $Res Function(_PracticeAnswerRecord) _then) = __$PracticeAnswerRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') String questionId, Map<String, dynamic> answer, String grading,@JsonKey(name: 'is_correct') bool? isCorrect,@JsonKey(name: 'self_mastered') bool? selfMastered,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'answered_at') DateTime? answeredAt
});




}
/// @nodoc
class __$PracticeAnswerRecordCopyWithImpl<$Res>
    implements _$PracticeAnswerRecordCopyWith<$Res> {
  __$PracticeAnswerRecordCopyWithImpl(this._self, this._then);

  final _PracticeAnswerRecord _self;
  final $Res Function(_PracticeAnswerRecord) _then;

/// Create a copy of PracticeAnswerRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? answer = null,Object? grading = null,Object? isCorrect = freezed,Object? selfMastered = freezed,Object? durationMs = null,Object? answeredAt = freezed,}) {
  return _then(_PracticeAnswerRecord(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,selfMastered: freezed == selfMastered ? _self.selfMastered : selfMastered // ignore: cast_nullable_to_non_nullable
as bool?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PracticeSessionSnapshot {

@JsonKey(name: 'session_id') String get sessionId; String get source; String get status;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'total_count') int get totalCount;@JsonKey(name: 'answered_count') int get answeredCount;@JsonKey(name: 'correct_count') int get correctCount; List<PracticeItem> get items; List<PracticeAnswerRecord> get answers;
/// Create a copy of PracticeSessionSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeSessionSnapshotCopyWith<PracticeSessionSnapshot> get copyWith => _$PracticeSessionSnapshotCopyWithImpl<PracticeSessionSnapshot>(this as PracticeSessionSnapshot, _$identity);

  /// Serializes this PracticeSessionSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PracticeSessionSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeSessionSnapshot&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.answeredCount, _this.answeredCount) || other.answeredCount == _this.answeredCount)&&(identical(other.correctCount, _this.correctCount) || other.correctCount == _this.correctCount)&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.answers, _this.answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PracticeSessionSnapshot;
  return Object.hash(runtimeType,_this.sessionId,_this.source,_this.status,_this.startedAt,_this.submittedAt,_this.durationMs,_this.totalCount,_this.answeredCount,_this.correctCount,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.answers));
}

@override
String toString() {
  final _this = this as PracticeSessionSnapshot;
  return 'PracticeSessionSnapshot(sessionId: ${_this.sessionId}, source: ${_this.source}, status: ${_this.status}, startedAt: ${_this.startedAt}, submittedAt: ${_this.submittedAt}, durationMs: ${_this.durationMs}, totalCount: ${_this.totalCount}, answeredCount: ${_this.answeredCount}, correctCount: ${_this.correctCount}, items: ${_this.items}, answers: ${_this.answers})';
}


}

/// @nodoc
abstract mixin class $PracticeSessionSnapshotCopyWith<$Res>  {
  factory $PracticeSessionSnapshotCopyWith(PracticeSessionSnapshot value, $Res Function(PracticeSessionSnapshot) _then) = _$PracticeSessionSnapshotCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String source, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'correct_count') int correctCount, List<PracticeItem> items, List<PracticeAnswerRecord> answers
});




}
/// @nodoc
class _$PracticeSessionSnapshotCopyWithImpl<$Res>
    implements $PracticeSessionSnapshotCopyWith<$Res> {
  _$PracticeSessionSnapshotCopyWithImpl(this._self, this._then);

  final PracticeSessionSnapshot _self;
  final $Res Function(PracticeSessionSnapshot) _then;

/// Create a copy of PracticeSessionSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? source = null,Object? status = null,Object? startedAt = freezed,Object? submittedAt = freezed,Object? durationMs = null,Object? totalCount = null,Object? answeredCount = null,Object? correctCount = null,Object? items = null,Object? answers = null,}) {
  return _then(PracticeSessionSnapshot(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PracticeItem>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<PracticeAnswerRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [PracticeSessionSnapshot].
extension PracticeSessionSnapshotPatterns on PracticeSessionSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeSessionSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeSessionSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeSessionSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _PracticeSessionSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeSessionSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeSessionSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount,  List<PracticeItem> items,  List<PracticeAnswerRecord> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeSessionSnapshot() when $default != null:
return $default(_that.sessionId,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount,_that.items,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount,  List<PracticeItem> items,  List<PracticeAnswerRecord> answers)  $default,) {final _that = this;
switch (_that) {
case _PracticeSessionSnapshot():
return $default(_that.sessionId,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount,_that.items,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  String source,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'correct_count')  int correctCount,  List<PracticeItem> items,  List<PracticeAnswerRecord> answers)?  $default,) {final _that = this;
switch (_that) {
case _PracticeSessionSnapshot() when $default != null:
return $default(_that.sessionId,_that.source,_that.status,_that.startedAt,_that.submittedAt,_that.durationMs,_that.totalCount,_that.answeredCount,_that.correctCount,_that.items,_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PracticeSessionSnapshot implements PracticeSessionSnapshot {
  const _PracticeSessionSnapshot({@JsonKey(name: 'session_id') required this.sessionId, this.source = 'all', this.status = 'active', @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'total_count') this.totalCount = 0, @JsonKey(name: 'answered_count') this.answeredCount = 0, @JsonKey(name: 'correct_count') this.correctCount = 0,  List<PracticeItem> items = const <PracticeItem>[],  List<PracticeAnswerRecord> answers = const <PracticeAnswerRecord>[]}): _items = items,_answers = answers;
  factory _PracticeSessionSnapshot.fromJson(Map<String, dynamic> json) => _$PracticeSessionSnapshotFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey() final  String source;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'total_count') final  int totalCount;
@override@JsonKey(name: 'answered_count') final  int answeredCount;
@override@JsonKey(name: 'correct_count') final  int correctCount;
 final  List<PracticeItem> _items;
@override@JsonKey() List<PracticeItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<PracticeAnswerRecord> _answers;
@override@JsonKey() List<PracticeAnswerRecord> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


/// Create a copy of PracticeSessionSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeSessionSnapshotCopyWith<_PracticeSessionSnapshot> get copyWith => __$PracticeSessionSnapshotCopyWithImpl<_PracticeSessionSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PracticeSessionSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeSessionSnapshot&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.answeredCount, answeredCount) || other.answeredCount == answeredCount)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,source,status,startedAt,submittedAt,durationMs,totalCount,answeredCount,correctCount,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_answers));
}

@override
String toString() {
    return 'PracticeSessionSnapshot(sessionId: $sessionId, source: $source, status: $status, startedAt: $startedAt, submittedAt: $submittedAt, durationMs: $durationMs, totalCount: $totalCount, answeredCount: $answeredCount, correctCount: $correctCount, items: $items, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$PracticeSessionSnapshotCopyWith<$Res> implements $PracticeSessionSnapshotCopyWith<$Res> {
  factory _$PracticeSessionSnapshotCopyWith(_PracticeSessionSnapshot value, $Res Function(_PracticeSessionSnapshot) _then) = __$PracticeSessionSnapshotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String source, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'correct_count') int correctCount, List<PracticeItem> items, List<PracticeAnswerRecord> answers
});




}
/// @nodoc
class __$PracticeSessionSnapshotCopyWithImpl<$Res>
    implements _$PracticeSessionSnapshotCopyWith<$Res> {
  __$PracticeSessionSnapshotCopyWithImpl(this._self, this._then);

  final _PracticeSessionSnapshot _self;
  final $Res Function(_PracticeSessionSnapshot) _then;

/// Create a copy of PracticeSessionSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? source = null,Object? status = null,Object? startedAt = freezed,Object? submittedAt = freezed,Object? durationMs = null,Object? totalCount = null,Object? answeredCount = null,Object? correctCount = null,Object? items = null,Object? answers = null,}) {
  return _then(_PracticeSessionSnapshot(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PracticeItem>,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<PracticeAnswerRecord>,
  ));
}


}

// dart format on
