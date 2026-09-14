// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WrongQuestion {

@JsonKey(name: 'question_id') String get questionId;@JsonKey(name: 'version_id') String? get versionId; String? get qtype; int? get difficulty;@JsonKey(name: 'answered_at') DateTime? get answeredAt;/// 这道题历史上被判错的总次数（不是本次连续错）。
@JsonKey(name: 'wrong_count') int get wrongCount;@JsonKey(name: 'stem_text') String? get stemText; bool get available;
/// Create a copy of WrongQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrongQuestionCopyWith<WrongQuestion> get copyWith => _$WrongQuestionCopyWithImpl<WrongQuestion>(this as WrongQuestion, _$identity);

  /// Serializes this WrongQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WrongQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrongQuestion&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.answeredAt, _this.answeredAt) || other.answeredAt == _this.answeredAt)&&(identical(other.wrongCount, _this.wrongCount) || other.wrongCount == _this.wrongCount)&&(identical(other.stemText, _this.stemText) || other.stemText == _this.stemText)&&(identical(other.available, _this.available) || other.available == _this.available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WrongQuestion;
  return Object.hash(runtimeType,_this.questionId,_this.versionId,_this.qtype,_this.difficulty,_this.answeredAt,_this.wrongCount,_this.stemText,_this.available);
}

@override
String toString() {
  final _this = this as WrongQuestion;
  return 'WrongQuestion(questionId: ${_this.questionId}, versionId: ${_this.versionId}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, answeredAt: ${_this.answeredAt}, wrongCount: ${_this.wrongCount}, stemText: ${_this.stemText}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $WrongQuestionCopyWith<$Res>  {
  factory $WrongQuestionCopyWith(WrongQuestion value, $Res Function(WrongQuestion) _then) = _$WrongQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'answered_at') DateTime? answeredAt,@JsonKey(name: 'wrong_count') int wrongCount,@JsonKey(name: 'stem_text') String? stemText, bool available
});




}
/// @nodoc
class _$WrongQuestionCopyWithImpl<$Res>
    implements $WrongQuestionCopyWith<$Res> {
  _$WrongQuestionCopyWithImpl(this._self, this._then);

  final WrongQuestion _self;
  final $Res Function(WrongQuestion) _then;

/// Create a copy of WrongQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? answeredAt = freezed,Object? wrongCount = null,Object? stemText = freezed,Object? available = null,}) {
  return _then(WrongQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WrongQuestion].
extension WrongQuestionPatterns on WrongQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrongQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrongQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrongQuestion value)  $default,){
final _that = this;
switch (_that) {
case _WrongQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrongQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _WrongQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'stem_text')  String? stemText,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrongQuestion() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.answeredAt,_that.wrongCount,_that.stemText,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'stem_text')  String? stemText,  bool available)  $default,) {final _that = this;
switch (_that) {
case _WrongQuestion():
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.answeredAt,_that.wrongCount,_that.stemText,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'answered_at')  DateTime? answeredAt, @JsonKey(name: 'wrong_count')  int wrongCount, @JsonKey(name: 'stem_text')  String? stemText,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _WrongQuestion() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.answeredAt,_that.wrongCount,_that.stemText,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrongQuestion implements WrongQuestion {
  const _WrongQuestion({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'version_id') this.versionId, this.qtype, this.difficulty, @JsonKey(name: 'answered_at') this.answeredAt, @JsonKey(name: 'wrong_count') this.wrongCount = 1, @JsonKey(name: 'stem_text') this.stemText, this.available = true});
  factory _WrongQuestion.fromJson(Map<String, dynamic> json) => _$WrongQuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  String questionId;
@override@JsonKey(name: 'version_id') final  String? versionId;
@override final  String? qtype;
@override final  int? difficulty;
@override@JsonKey(name: 'answered_at') final  DateTime? answeredAt;
/// 这道题历史上被判错的总次数（不是本次连续错）。
@override@JsonKey(name: 'wrong_count') final  int wrongCount;
@override@JsonKey(name: 'stem_text') final  String? stemText;
@override@JsonKey() final  bool available;

/// Create a copy of WrongQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrongQuestionCopyWith<_WrongQuestion> get copyWith => __$WrongQuestionCopyWithImpl<_WrongQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrongQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrongQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.wrongCount, wrongCount) || other.wrongCount == wrongCount)&&(identical(other.stemText, stemText) || other.stemText == stemText)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,versionId,qtype,difficulty,answeredAt,wrongCount,stemText,available);
}

@override
String toString() {
    return 'WrongQuestion(questionId: $questionId, versionId: $versionId, qtype: $qtype, difficulty: $difficulty, answeredAt: $answeredAt, wrongCount: $wrongCount, stemText: $stemText, available: $available)';
}


}

/// @nodoc
abstract mixin class _$WrongQuestionCopyWith<$Res> implements $WrongQuestionCopyWith<$Res> {
  factory _$WrongQuestionCopyWith(_WrongQuestion value, $Res Function(_WrongQuestion) _then) = __$WrongQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'answered_at') DateTime? answeredAt,@JsonKey(name: 'wrong_count') int wrongCount,@JsonKey(name: 'stem_text') String? stemText, bool available
});




}
/// @nodoc
class __$WrongQuestionCopyWithImpl<$Res>
    implements _$WrongQuestionCopyWith<$Res> {
  __$WrongQuestionCopyWithImpl(this._self, this._then);

  final _WrongQuestion _self;
  final $Res Function(_WrongQuestion) _then;

/// Create a copy of WrongQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? answeredAt = freezed,Object? wrongCount = null,Object? stemText = freezed,Object? available = null,}) {
  return _then(_WrongQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$FavoriteQuestion {

@JsonKey(name: 'question_id') String get questionId;@JsonKey(name: 'version_id') String? get versionId; String? get qtype; int? get difficulty;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'stem_text') String? get stemText; bool get available;
/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteQuestionCopyWith<FavoriteQuestion> get copyWith => _$FavoriteQuestionCopyWithImpl<FavoriteQuestion>(this as FavoriteQuestion, _$identity);

  /// Serializes this FavoriteQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FavoriteQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteQuestion&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.stemText, _this.stemText) || other.stemText == _this.stemText)&&(identical(other.available, _this.available) || other.available == _this.available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FavoriteQuestion;
  return Object.hash(runtimeType,_this.questionId,_this.versionId,_this.qtype,_this.difficulty,_this.createdAt,_this.stemText,_this.available);
}

@override
String toString() {
  final _this = this as FavoriteQuestion;
  return 'FavoriteQuestion(questionId: ${_this.questionId}, versionId: ${_this.versionId}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, createdAt: ${_this.createdAt}, stemText: ${_this.stemText}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $FavoriteQuestionCopyWith<$Res>  {
  factory $FavoriteQuestionCopyWith(FavoriteQuestion value, $Res Function(FavoriteQuestion) _then) = _$FavoriteQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'stem_text') String? stemText, bool available
});




}
/// @nodoc
class _$FavoriteQuestionCopyWithImpl<$Res>
    implements $FavoriteQuestionCopyWith<$Res> {
  _$FavoriteQuestionCopyWithImpl(this._self, this._then);

  final FavoriteQuestion _self;
  final $Res Function(FavoriteQuestion) _then;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? createdAt = freezed,Object? stemText = freezed,Object? available = null,}) {
  return _then(FavoriteQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteQuestion].
extension FavoriteQuestionPatterns on FavoriteQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteQuestion value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'stem_text')  String? stemText,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.createdAt,_that.stemText,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'stem_text')  String? stemText,  bool available)  $default,) {final _that = this;
switch (_that) {
case _FavoriteQuestion():
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.createdAt,_that.stemText,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String? versionId,  String? qtype,  int? difficulty, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'stem_text')  String? stemText,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteQuestion() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.createdAt,_that.stemText,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteQuestion implements FavoriteQuestion {
  const _FavoriteQuestion({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'version_id') this.versionId, this.qtype, this.difficulty, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'stem_text') this.stemText, this.available = true});
  factory _FavoriteQuestion.fromJson(Map<String, dynamic> json) => _$FavoriteQuestionFromJson(json);

@override@JsonKey(name: 'question_id') final  String questionId;
@override@JsonKey(name: 'version_id') final  String? versionId;
@override final  String? qtype;
@override final  int? difficulty;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'stem_text') final  String? stemText;
@override@JsonKey() final  bool available;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteQuestionCopyWith<_FavoriteQuestion> get copyWith => __$FavoriteQuestionCopyWithImpl<_FavoriteQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteQuestion&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stemText, stemText) || other.stemText == stemText)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,versionId,qtype,difficulty,createdAt,stemText,available);
}

@override
String toString() {
    return 'FavoriteQuestion(questionId: $questionId, versionId: $versionId, qtype: $qtype, difficulty: $difficulty, createdAt: $createdAt, stemText: $stemText, available: $available)';
}


}

/// @nodoc
abstract mixin class _$FavoriteQuestionCopyWith<$Res> implements $FavoriteQuestionCopyWith<$Res> {
  factory _$FavoriteQuestionCopyWith(_FavoriteQuestion value, $Res Function(_FavoriteQuestion) _then) = __$FavoriteQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String? versionId, String? qtype, int? difficulty,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'stem_text') String? stemText, bool available
});




}
/// @nodoc
class __$FavoriteQuestionCopyWithImpl<$Res>
    implements _$FavoriteQuestionCopyWith<$Res> {
  __$FavoriteQuestionCopyWithImpl(this._self, this._then);

  final _FavoriteQuestion _self;
  final $Res Function(_FavoriteQuestion) _then;

/// Create a copy of FavoriteQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? versionId = freezed,Object? qtype = freezed,Object? difficulty = freezed,Object? createdAt = freezed,Object? stemText = freezed,Object? available = null,}) {
  return _then(_FavoriteQuestion(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,qtype: freezed == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stemText: freezed == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
