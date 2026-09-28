// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionContent {

@JsonKey(name: 'format_version') int get formatVersion; List<Block> get stem;/// 解析。网页端出题时强制填写，但数据库不强制，历史数据可能缺失。
 List<Block> get analysis; List<QuestionOption> get options;/// 标准答案。复合题根节点为 null——各子题自带 answer。
 ServerAnswer? get answer;/// 子题（仅复合题）。**不可嵌套复合题**（数据库约束）。
 List<SubQuestion> get sub;
/// Create a copy of QuestionContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionContentCopyWith<QuestionContent> get copyWith => _$QuestionContentCopyWithImpl<QuestionContent>(this as QuestionContent, _$identity);

  /// Serializes this QuestionContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionContent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionContent&&(identical(other.formatVersion, _this.formatVersion) || other.formatVersion == _this.formatVersion)&&const DeepCollectionEquality().equals(other.stem, _this.stem)&&const DeepCollectionEquality().equals(other.analysis, _this.analysis)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.answer, _this.answer) || other.answer == _this.answer)&&const DeepCollectionEquality().equals(other.sub, _this.sub));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionContent;
  return Object.hash(runtimeType,_this.formatVersion,const DeepCollectionEquality().hash(_this.stem),const DeepCollectionEquality().hash(_this.analysis),const DeepCollectionEquality().hash(_this.options),_this.answer,const DeepCollectionEquality().hash(_this.sub));
}

@override
String toString() {
  final _this = this as QuestionContent;
  return 'QuestionContent(formatVersion: ${_this.formatVersion}, stem: ${_this.stem}, analysis: ${_this.analysis}, options: ${_this.options}, answer: ${_this.answer}, sub: ${_this.sub})';
}


}

/// @nodoc
abstract mixin class $QuestionContentCopyWith<$Res>  {
  factory $QuestionContentCopyWith(QuestionContent value, $Res Function(QuestionContent) _then) = _$QuestionContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'format_version') int formatVersion, List<Block> stem, List<Block> analysis, List<QuestionOption> options, ServerAnswer? answer, List<SubQuestion> sub
});


$ServerAnswerCopyWith<$Res>? get answer;

}
/// @nodoc
class _$QuestionContentCopyWithImpl<$Res>
    implements $QuestionContentCopyWith<$Res> {
  _$QuestionContentCopyWithImpl(this._self, this._then);

  final QuestionContent _self;
  final $Res Function(QuestionContent) _then;

/// Create a copy of QuestionContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatVersion = null,Object? stem = null,Object? analysis = null,Object? options = null,Object? answer = freezed,Object? sub = null,}) {
  return _then(QuestionContent(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,stem: null == stem ? _self.stem : stem // ignore: cast_nullable_to_non_nullable
as List<Block>,analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as List<Block>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as ServerAnswer?,sub: null == sub ? _self.sub : sub // ignore: cast_nullable_to_non_nullable
as List<SubQuestion>,
  ));
}
/// Create a copy of QuestionContent
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


/// Adds pattern-matching-related methods to [QuestionContent].
extension QuestionContentPatterns on QuestionContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionContent value)  $default,){
final _that = this;
switch (_that) {
case _QuestionContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionContent value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<Block> analysis,  List<QuestionOption> options,  ServerAnswer? answer,  List<SubQuestion> sub)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionContent() when $default != null:
return $default(_that.formatVersion,_that.stem,_that.analysis,_that.options,_that.answer,_that.sub);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<Block> analysis,  List<QuestionOption> options,  ServerAnswer? answer,  List<SubQuestion> sub)  $default,) {final _that = this;
switch (_that) {
case _QuestionContent():
return $default(_that.formatVersion,_that.stem,_that.analysis,_that.options,_that.answer,_that.sub);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'format_version')  int formatVersion,  List<Block> stem,  List<Block> analysis,  List<QuestionOption> options,  ServerAnswer? answer,  List<SubQuestion> sub)?  $default,) {final _that = this;
switch (_that) {
case _QuestionContent() when $default != null:
return $default(_that.formatVersion,_that.stem,_that.analysis,_that.options,_that.answer,_that.sub);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionContent implements QuestionContent {
  const _QuestionContent({@JsonKey(name: 'format_version') this.formatVersion = 1,  List<Block> stem = const <Block>[],  List<Block> analysis = const <Block>[],  List<QuestionOption> options = const <QuestionOption>[], this.answer,  List<SubQuestion> sub = const <SubQuestion>[]}): _stem = stem,_analysis = analysis,_options = options,_sub = sub;
  factory _QuestionContent.fromJson(Map<String, dynamic> json) => _$QuestionContentFromJson(json);

@override@JsonKey(name: 'format_version') final  int formatVersion;
 final  List<Block> _stem;
@override@JsonKey() List<Block> get stem {
  if (_stem is EqualUnmodifiableListView) return _stem;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stem);
}

/// 解析。网页端出题时强制填写，但数据库不强制，历史数据可能缺失。
 final  List<Block> _analysis;
/// 解析。网页端出题时强制填写，但数据库不强制，历史数据可能缺失。
@override@JsonKey() List<Block> get analysis {
  if (_analysis is EqualUnmodifiableListView) return _analysis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_analysis);
}

 final  List<QuestionOption> _options;
@override@JsonKey() List<QuestionOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

/// 标准答案。复合题根节点为 null——各子题自带 answer。
@override final  ServerAnswer? answer;
/// 子题（仅复合题）。**不可嵌套复合题**（数据库约束）。
 final  List<SubQuestion> _sub;
/// 子题（仅复合题）。**不可嵌套复合题**（数据库约束）。
@override@JsonKey() List<SubQuestion> get sub {
  if (_sub is EqualUnmodifiableListView) return _sub;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sub);
}


/// Create a copy of QuestionContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionContentCopyWith<_QuestionContent> get copyWith => __$QuestionContentCopyWithImpl<_QuestionContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionContentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionContent&&(identical(other.formatVersion, formatVersion) || other.formatVersion == formatVersion)&&const DeepCollectionEquality().equals(other.stem, _stem)&&const DeepCollectionEquality().equals(other.analysis, _analysis)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other.sub, _sub));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,formatVersion,const DeepCollectionEquality().hash(_stem),const DeepCollectionEquality().hash(_analysis),const DeepCollectionEquality().hash(_options),answer,const DeepCollectionEquality().hash(_sub));
}

@override
String toString() {
    return 'QuestionContent(formatVersion: $formatVersion, stem: $stem, analysis: $analysis, options: $options, answer: $answer, sub: $sub)';
}


}

/// @nodoc
abstract mixin class _$QuestionContentCopyWith<$Res> implements $QuestionContentCopyWith<$Res> {
  factory _$QuestionContentCopyWith(_QuestionContent value, $Res Function(_QuestionContent) _then) = __$QuestionContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'format_version') int formatVersion, List<Block> stem, List<Block> analysis, List<QuestionOption> options, ServerAnswer? answer, List<SubQuestion> sub
});


@override $ServerAnswerCopyWith<$Res>? get answer;

}
/// @nodoc
class __$QuestionContentCopyWithImpl<$Res>
    implements _$QuestionContentCopyWith<$Res> {
  __$QuestionContentCopyWithImpl(this._self, this._then);

  final _QuestionContent _self;
  final $Res Function(_QuestionContent) _then;

/// Create a copy of QuestionContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatVersion = null,Object? stem = null,Object? analysis = null,Object? options = null,Object? answer = freezed,Object? sub = null,}) {
  return _then(_QuestionContent(
formatVersion: null == formatVersion ? _self.formatVersion : formatVersion // ignore: cast_nullable_to_non_nullable
as int,stem: null == stem ? _self._stem : stem // ignore: cast_nullable_to_non_nullable
as List<Block>,analysis: null == analysis ? _self._analysis : analysis // ignore: cast_nullable_to_non_nullable
as List<Block>,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOption>,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as ServerAnswer?,sub: null == sub ? _self._sub : sub // ignore: cast_nullable_to_non_nullable
as List<SubQuestion>,
  ));
}

/// Create a copy of QuestionContent
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
