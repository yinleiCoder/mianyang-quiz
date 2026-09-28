// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubQuestion {

/// 题型线格式（single_choice / true_false / fill_blank / short_answer…）。
/// 不做成枚举：未知题型要能原样透传，让判分函数去决定怎么处理。
 String get type;@JsonKey(name: 'format_version') int get formatVersion; List<Block> get stem; List<QuestionOption> get options; ServerAnswer? get answer;
/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubQuestionCopyWith<SubQuestion> get copyWith => _$SubQuestionCopyWithImpl<SubQuestion>(this as SubQuestion, _$identity);

  /// Serializes this SubQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubQuestion&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&const DeepCollectionEquality().equals(other.stem, _this.stem)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.answer, _this.answer) || other.answer == _this.answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubQuestion;
  return Object.hash(runtimeType,_this.type,_this.formatVersion,const DeepCollectionEquality().hash(_this.stem),const DeepCollectionEquality().hash(_this.options),_this.answer);
}

@override
String toString() {
  final _this = this as SubQuestion;
  return 'SubQuestion(type: ${_this.type}, formatVersion: ${_this.formatVersion}, stem: ${_this.stem}, options: ${_this.options}, answer: ${_this.answer})';
}


}

/// @nodoc
abstract mixin class $SubQuestionCopyWith<$Res>  {
  factory $SubQuestionCopyWith(SubQuestion value, $Res Function(SubQuestion) _then) = _$SubQuestionCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(name: 'format_version') int formatVersion, List<Block> stem, List<QuestionOption> options, ServerAnswer? answer
});


$ServerAnswerCopyWith<$Res>? get answer;

}
/// @nodoc
class _$SubQuestionCopyWithImpl<$Res>
    implements $SubQuestionCopyWith<$Res> {
  _$SubQuestionCopyWithImpl(this._self, this._then);

  final SubQuestion _self;
  final $Res Function(SubQuestion) _then;

/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? formatVersion = null,Object? stem = null,Object? options = null,Object? answer = freezed,}) {
  return _then(SubQuestion(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,stem: null == stem ? _self.stem : stem // ignore: cast_nullable_to_non_nullable
as List<Block>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as ServerAnswer?,
  ));
}
/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerAnswerCopyWith<$Res>? get answer {
    if (_self.answer == null) {
    return null;
  }

  return $ServerAnswerCopyWith<$Res>(_self.answer!, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubQuestion].
extension SubQuestionPatterns on SubQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubQuestion value)  $default,){
final _that = this;
switch (_that) {
case _SubQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _SubQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<QuestionOption> options,  ServerAnswer? answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubQuestion() when $default != null:
return $default(_that.type,_that.formatVersion,_that.stem,_that.options,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<QuestionOption> options,  ServerAnswer? answer)  $default,) {final _that = this;
switch (_that) {
case _SubQuestion():
return $default(_that.type,_that.formatVersion,_that.stem,_that.options,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<QuestionOption> options,  ServerAnswer? answer)?  $default,) {final _that = this;
switch (_that) {
case _SubQuestion() when $default != null:
return $default(_that.type,_that.formatVersion,_that.stem,_that.options,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubQuestion implements SubQuestion {
  const _SubQuestion({required this.type, @JsonKey(name: 'format_version') this.formatVersion = 1,  List<Block> stem = const <Block>[],  List<QuestionOption> options = const <QuestionOption>[], this.answer}): _stem = stem,_options = options;
  factory _SubQuestion.fromJson(Map<String, dynamic> json) => _$SubQuestionFromJson(json);

/// 题型线格式（single_choice / true_false / fill_blank / short_answer…）。
/// 不做成枚举：未知题型要能原样透传，让判分函数去决定怎么处理。
@override final  String type;
@override@JsonKey(name: 'format_version') final  int formatVersion;
 final  List<Block> _stem;
@override@JsonKey() List<Block> get stem {
  if (_stem is EqualUnmodifiableListView) return _stem;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stem);
}

 final  List<QuestionOption> _options;
@override@JsonKey() List<QuestionOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  ServerAnswer? answer;

/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubQuestionCopyWith<_SubQuestion> get copyWith => __$SubQuestionCopyWithImpl<_SubQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubQuestion&&(identical(other.type, type) || other.type == type)&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&const DeepCollectionEquality().equals(other.stem, _stem)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,formatVersion,const DeepCollectionEquality().hash(_stem),const DeepCollectionEquality().hash(_options),answer);
}

@override
String toString() {
    return 'SubQuestion(type: $type, formatVersion: $formatVersion, stem: $stem, options: $options, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$SubQuestionCopyWith<$Res> implements $SubQuestionCopyWith<$Res> {
  factory _$SubQuestionCopyWith(_SubQuestion value, $Res Function(_SubQuestion) _then) = __$SubQuestionCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(name: 'format_version') int formatVersion, List<Block> stem, List<QuestionOption> options, ServerAnswer? answer
});


@override $ServerAnswerCopyWith<$Res>? get answer;

}
/// @nodoc
class __$SubQuestionCopyWithImpl<$Res>
    implements _$SubQuestionCopyWith<$Res> {
  __$SubQuestionCopyWithImpl(this._self, this._then);

  final _SubQuestion _self;
  final $Res Function(_SubQuestion) _then;

/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? formatVersion = null,Object? stem = null,Object? options = null,Object? answer = freezed,}) {
  return _then(_SubQuestion(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,stem: null == stem ? _self._stem : stem // ignore: cast_nullable_to_non_nullable
as List<Block>,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as ServerAnswer?,
  ));
}

/// Create a copy of SubQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerAnswerCopyWith<$Res>? get answer {
    if (_self.answer == null) {
    return null;
  }

  return $ServerAnswerCopyWith<$Res>(_self.answer!, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}

// dart format on
