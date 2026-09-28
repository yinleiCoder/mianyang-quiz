// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionFilter {

/// 关键词，按题干全文检索（服务端会对 % _ \ 做转义）。
 String get keyword;/// 科目节点。选中父节点时服务端会包含其全部后代课程。
 String? get nodeId;/// 题型多选。空集合表示不限。
 Set<QuestionType> get qtypes;/// 难度 1 易 / 2 中 / 3 难。null 表示不限（注意与"值为 0"不同）。
 int? get difficulty; String? get tagId;
/// Create a copy of QuestionFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionFilterCopyWith<QuestionFilter> get copyWith => _$QuestionFilterCopyWithImpl<QuestionFilter>(this as QuestionFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuestionFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionFilter&&(identical(other.keyword, _this.keyword) || other.keyword == _this.keyword)&&(identical(other.nodeId, _this.nodeId) || other.nodeId == _this.nodeId)&&const DeepCollectionEquality().equals(other.qtypes, _this.qtypes)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.tagId, _this.tagId) || other.tagId == _this.tagId));
}


@override
int get hashCode {
  final _this = this as QuestionFilter;
  return Object.hash(runtimeType,_this.keyword,_this.nodeId,const DeepCollectionEquality().hash(_this.qtypes),_this.difficulty,_this.tagId);
}

@override
String toString() {
  final _this = this as QuestionFilter;
  return 'QuestionFilter(keyword: ${_this.keyword}, nodeId: ${_this.nodeId}, qtypes: ${_this.qtypes}, difficulty: ${_this.difficulty}, tagId: ${_this.tagId})';
}


}

/// @nodoc
abstract mixin class $QuestionFilterCopyWith<$Res>  {
  factory $QuestionFilterCopyWith(QuestionFilter value, $Res Function(QuestionFilter) _then) = _$QuestionFilterCopyWithImpl;
@useResult
$Res call({
 String keyword, String? nodeId, Set<QuestionType> qtypes, int? difficulty, String? tagId
});




}
/// @nodoc
class _$QuestionFilterCopyWithImpl<$Res>
    implements $QuestionFilterCopyWith<$Res> {
  _$QuestionFilterCopyWithImpl(this._self, this._then);

  final QuestionFilter _self;
  final $Res Function(QuestionFilter) _then;

/// Create a copy of QuestionFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? nodeId = freezed,Object? qtypes = null,Object? difficulty = freezed,Object? tagId = freezed,}) {
  return _then(QuestionFilter(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,qtypes: null == qtypes ? _self.qtypes : qtypes // ignore: cast_nullable_to_non_nullable
as Set<QuestionType>,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionFilter].
extension QuestionFilterPatterns on QuestionFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionFilter value)  $default,){
final _that = this;
switch (_that) {
case _QuestionFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionFilter value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyword,  String? nodeId,  Set<QuestionType> qtypes,  int? difficulty,  String? tagId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionFilter() when $default != null:
return $default(_that.keyword,_that.nodeId,_that.qtypes,_that.difficulty,_that.tagId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyword,  String? nodeId,  Set<QuestionType> qtypes,  int? difficulty,  String? tagId)  $default,) {final _that = this;
switch (_that) {
case _QuestionFilter():
return $default(_that.keyword,_that.nodeId,_that.qtypes,_that.difficulty,_that.tagId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyword,  String? nodeId,  Set<QuestionType> qtypes,  int? difficulty,  String? tagId)?  $default,) {final _that = this;
switch (_that) {
case _QuestionFilter() when $default != null:
return $default(_that.keyword,_that.nodeId,_that.qtypes,_that.difficulty,_that.tagId);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionFilter implements QuestionFilter {
  const _QuestionFilter({this.keyword = '', this.nodeId,  Set<QuestionType> qtypes = const <QuestionType>{}, this.difficulty, this.tagId}): _qtypes = qtypes;
  

/// 关键词，按题干全文检索（服务端会对 % _ \ 做转义）。
@override@JsonKey() final  String keyword;
/// 科目节点。选中父节点时服务端会包含其全部后代课程。
@override final  String? nodeId;
/// 题型多选。空集合表示不限。
 final  Set<QuestionType> _qtypes;
/// 题型多选。空集合表示不限。
@override@JsonKey() Set<QuestionType> get qtypes {
  if (_qtypes is EqualUnmodifiableSetView) return _qtypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_qtypes);
}

/// 难度 1 易 / 2 中 / 3 难。null 表示不限（注意与"值为 0"不同）。
@override final  int? difficulty;
@override final  String? tagId;

/// Create a copy of QuestionFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionFilterCopyWith<_QuestionFilter> get copyWith => __$QuestionFilterCopyWithImpl<_QuestionFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionFilter&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&const DeepCollectionEquality().equals(other.qtypes, _qtypes)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.tagId, tagId) || other.tagId == tagId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyword,nodeId,const DeepCollectionEquality().hash(_qtypes),difficulty,tagId);
}

@override
String toString() {
    return 'QuestionFilter(keyword: $keyword, nodeId: $nodeId, qtypes: $qtypes, difficulty: $difficulty, tagId: $tagId)';
}


}

/// @nodoc
abstract mixin class _$QuestionFilterCopyWith<$Res> implements $QuestionFilterCopyWith<$Res> {
  factory _$QuestionFilterCopyWith(_QuestionFilter value, $Res Function(_QuestionFilter) _then) = __$QuestionFilterCopyWithImpl;
@override @useResult
$Res call({
 String keyword, String? nodeId, Set<QuestionType> qtypes, int? difficulty, String? tagId
});




}
/// @nodoc
class __$QuestionFilterCopyWithImpl<$Res>
    implements _$QuestionFilterCopyWith<$Res> {
  __$QuestionFilterCopyWithImpl(this._self, this._then);

  final _QuestionFilter _self;
  final $Res Function(_QuestionFilter) _then;

/// Create a copy of QuestionFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? nodeId = freezed,Object? qtypes = null,Object? difficulty = freezed,Object? tagId = freezed,}) {
  return _then(_QuestionFilter(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,qtypes: null == qtypes ? _self._qtypes : qtypes // ignore: cast_nullable_to_non_nullable
as Set<QuestionType>,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,tagId: freezed == tagId ? _self.tagId : tagId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
