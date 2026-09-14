// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentAnswer {

@JsonKey(name: 'question_id') String get questionId;@JsonKey(name: 'version_id') String? get versionId; String? get qtype; int? get difficulty;@JsonKey(name: 'is_correct') bool? get isCorrect; String get grading;@JsonKey(name: 'answered_at') DateTime? get answeredAt;/// 题干摘要（数据库取当前发布版 search_text 左 120 字）。
/// 题目已下线或已删除时为 null——界面要显示占位而不是空白。
@JsonKey(name: 'stem_text') String? get stemText;
/// Create a copy of RecentAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentAnswerCopyWith<RecentAnswer> get copyWith => _$RecentAnswerCopyWithImpl<RecentAnswer>(this as RecentAnswer, _$identity);

  /// Serializes this RecentAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecentAnswer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentAnswer&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect)&&(identical(other.grading, _this.grading) || other.grading == _this.grading)&&(identical(other.answeredAt, _this.answeredAt) || other.answeredAt == _this.answeredAt)&&(identical(other.stemText, _this.stemText) || other.stemText == _this.stemText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecentAnswer;
  return Object.hash(runtimeType,_this.questionId,_this.versionId,_this.qtype,_this.difficulty,_this.isCorrect,_this.grading,_this.answeredAt,_this.stemText);
}

@override
String toString() {
  final _this = this as RecentAnswer;
  return 'RecentAnswer(questionId: ${_this.questionId}, versionId: ${_this.versionId}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, isCorrect: ${_this.isCorrect}, grading: ${_this.grading}, answeredAt: ${_this.answeredAt}, stemText: ${_this.stemText})';
}


}

/// @nodoc
abstract mixin class $RecentAnswerCopyWith<$Res>  {
  factory $RecentAnswerCopyWith(RecentAnswer value, $Res Function(RecentAnswer) _then) = _$RecentAnswerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'is_correct') bool? isCorrect, String grading,@JsonKey(name: 'answered_at') DateTime? answeredAt,@JsonKey(name: 'stem_text') String? stemText
});




}
/// @nodoc
class _$RecentAnswerCopyWithImpl<$Res>
    implements $RecentAnswerCopyWith<$Res> {
  _$RecentAnswerCopyWithImpl(this._self, this._then);

  final RecentAnswer _self;
  final $Res Function(RecentAnswer) _then;

/// Create a copy of RecentAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? isCorrect = freezed,Object? grading = null,Object? answeredAt = freezed,Object? stemText = freezed,}) {
  return _then(RecentAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentAnswer].
extension RecentAnswerPatterns on RecentAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentAnswer value)  $default,){
final _that = this;
switch (_that) {
case _RecentAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _RecentAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'is_correct')  bool? isCorrect,  String grading, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'stem_text')  String? stemText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentAnswer() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.isCorrect,_that.grading,_that.answeredAt,_that.stemText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'is_correct')  bool? isCorrect,  String grading, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'stem_text')  String? stemText)  $default,) {final _that = this;
switch (_that) {
case _RecentAnswer():
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.isCorrect,_that.grading,_that.answeredAt,_that.stemText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'is_correct')  bool? isCorrect,  String grading, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'stem_text')  String? stemText)?  $default,) {final _that = this;
switch (_that) {
case _RecentAnswer() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.isCorrect,_that.grading,_that.answeredAt,_that.stemText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentAnswer implements RecentAnswer {
  const _RecentAnswer({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'version_id') this.versionId, this.qtype, this.difficulty, @JsonKey(name: 'is_correct') this.isCorrect, this.grading = 'auto', @JsonKey(name: 'answered_at') this.answeredAt, @JsonKey(name: 'stem_text') this.stemText});
  factory _RecentAnswer.fromJson(Map<String, dynamic> json) => _$RecentAnswerFromJson(json);

@override@JsonKey(name: 'question_id') final  String questionId;
@override@JsonKey(name: 'version_id') final  String? versionId;
@override final  String? qtype;
@override final  int? difficulty;
@override@JsonKey(name: 'is_correct') final  bool? isCorrect;
@override@JsonKey() final  String grading;
@override@JsonKey(name: 'answered_at') final  DateTime? answeredAt;
/// 题干摘要（数据库取当前发布版 search_text 左 120 字）。
/// 题目已下线或已删除时为 null——界面要显示占位而不是空白。
@override@JsonKey(name: 'stem_text') final  String? stemText;

/// Create a copy of RecentAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentAnswerCopyWith<_RecentAnswer> get copyWith => __$RecentAnswerCopyWithImpl<_RecentAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.grading, grading) || other.grading == grading)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.stemText, stemText) || other.stemText == stemText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,versionId,qtype,difficulty,isCorrect,grading,answeredAt,stemText);
}

@override
String toString() {
    return 'RecentAnswer(questionId: $questionId, versionId: $versionId, qtype: $qtype, difficulty: $difficulty, isCorrect: $isCorrect, grading: $grading, answeredAt: $answeredAt, stemText: $stemText)';
}


}

/// @nodoc
abstract mixin class _$RecentAnswerCopyWith<$Res> implements $RecentAnswerCopyWith<$Res> {
  factory _$RecentAnswerCopyWith(_RecentAnswer value, $Res Function(_RecentAnswer) _then) = __$RecentAnswerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'is_correct') bool? isCorrect, String grading,@JsonKey(name: 'answered_at') DateTime? answeredAt,@JsonKey(name: 'stem_text') String? stemText
});




}
/// @nodoc
class __$RecentAnswerCopyWithImpl<$Res>
    implements _$RecentAnswerCopyWith<$Res> {
  __$RecentAnswerCopyWithImpl(this._self, this._then);

  final _RecentAnswer _self;
  final $Res Function(_RecentAnswer) _then;

/// Create a copy of RecentAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? isCorrect = freezed,Object? grading = null,Object? answeredAt = freezed,Object? stemText = freezed,}) {
  return _then(_RecentAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActiveSessionBrief {

@JsonKey(name: 'session_id') String get sessionId; String get source;@JsonKey(name: 'total_count') int get totalCount;@JsonKey(name: 'answered_count') int get answeredCount;@JsonKey(name: 'started_at') DateTime? get startedAt;
/// Create a copy of ActiveSessionBrief
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveSessionBriefCopyWith<ActiveSessionBrief> get copyWith => _$ActiveSessionBriefCopyWithImpl<ActiveSessionBrief>(this as ActiveSessionBrief, _$identity);

  /// Serializes this ActiveSessionBrief to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ActiveSessionBrief;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveSessionBrief&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&(identical(other.answeredCount, _this.answeredCount) || other.answeredCount == _this.answeredCount)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ActiveSessionBrief;
  return Object.hash(runtimeType,_this.sessionId,_this.source,_this.totalCount,_this.answeredCount,_this.startedAt);
}

@override
String toString() {
  final _this = this as ActiveSessionBrief;
  return 'ActiveSessionBrief(sessionId: ${_this.sessionId}, source: ${_this.source}, totalCount: ${_this.totalCount}, answeredCount: ${_this.answeredCount}, startedAt: ${_this.startedAt})';
}


}

/// @nodoc
abstract mixin class $ActiveSessionBriefCopyWith<$Res>  {
  factory $ActiveSessionBriefCopyWith(ActiveSessionBrief value, $Res Function(ActiveSessionBrief) _then) = _$ActiveSessionBriefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String source,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'started_at') DateTime? startedAt
});




}
/// @nodoc
class _$ActiveSessionBriefCopyWithImpl<$Res>
    implements $ActiveSessionBriefCopyWith<$Res> {
  _$ActiveSessionBriefCopyWithImpl(this._self, this._then);

  final ActiveSessionBrief _self;
  final $Res Function(ActiveSessionBrief) _then;

/// Create a copy of ActiveSessionBrief
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? source = null,Object? totalCount = null,Object? answeredCount = null,Object? startedAt = freezed,}) {
  return _then(ActiveSessionBrief(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveSessionBrief].
extension ActiveSessionBriefPatterns on ActiveSessionBrief {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveSessionBrief value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveSessionBrief() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveSessionBrief value)  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionBrief():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveSessionBrief value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionBrief() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String source, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'started_at')  DateTime? startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveSessionBrief() when $default != null:
return $default(_that.sessionId,_that.source,_that.totalCount,_that.answeredCount,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String source, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'started_at')  DateTime? startedAt)  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionBrief():
return $default(_that.sessionId,_that.source,_that.totalCount,_that.answeredCount,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  String source, @JsonKey(name: 'total_count')  int totalCount, @JsonKey(name: 'answered_count')  int answeredCount, @JsonKey(name: 'started_at')  DateTime? startedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionBrief() when $default != null:
return $default(_that.sessionId,_that.source,_that.totalCount,_that.answeredCount,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveSessionBrief implements ActiveSessionBrief {
  const _ActiveSessionBrief({@JsonKey(name: 'session_id') required this.sessionId, this.source = 'all', @JsonKey(name: 'total_count') this.totalCount = 0, @JsonKey(name: 'answered_count') this.answeredCount = 0, @JsonKey(name: 'started_at') this.startedAt});
  factory _ActiveSessionBrief.fromJson(Map<String, dynamic> json) => _$ActiveSessionBriefFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey() final  String source;
@override@JsonKey(name: 'total_count') final  int totalCount;
@override@JsonKey(name: 'answered_count') final  int answeredCount;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;

/// Create a copy of ActiveSessionBrief
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveSessionBriefCopyWith<_ActiveSessionBrief> get copyWith => __$ActiveSessionBriefCopyWithImpl<_ActiveSessionBrief>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveSessionBriefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveSessionBrief&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.source, source) || other.source == source)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.answeredCount, answeredCount) || other.answeredCount == answeredCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,source,totalCount,answeredCount,startedAt);
}

@override
String toString() {
    return 'ActiveSessionBrief(sessionId: $sessionId, source: $source, totalCount: $totalCount, answeredCount: $answeredCount, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$ActiveSessionBriefCopyWith<$Res> implements $ActiveSessionBriefCopyWith<$Res> {
  factory _$ActiveSessionBriefCopyWith(_ActiveSessionBrief value, $Res Function(_ActiveSessionBrief) _then) = __$ActiveSessionBriefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String source,@JsonKey(name: 'total_count') int totalCount,@JsonKey(name: 'answered_count') int answeredCount,@JsonKey(name: 'started_at') DateTime? startedAt
});




}
/// @nodoc
class __$ActiveSessionBriefCopyWithImpl<$Res>
    implements _$ActiveSessionBriefCopyWith<$Res> {
  __$ActiveSessionBriefCopyWithImpl(this._self, this._then);

  final _ActiveSessionBrief _self;
  final $Res Function(_ActiveSessionBrief) _then;

/// Create a copy of ActiveSessionBrief
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? source = null,Object? totalCount = null,Object? answeredCount = null,Object? startedAt = freezed,}) {
  return _then(_ActiveSessionBrief(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,answeredCount: null == answeredCount ? _self.answeredCount : answeredCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
