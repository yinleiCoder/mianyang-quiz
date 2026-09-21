// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MaterialFilter {

/// 关键词，匹配标题 + 简介（服务端列是 search_text，已 lower）。
 String get keyword;/// 学科 / 专业大类节点。选中父节点时要不要含后代由页面的取数逻辑决定
///（PostgREST 直查做不了子树展开，所以这里只按精确节点筛）。
 String? get nodeId;/// 类型多选。空集合表示不限。
 Set<MaterialKind> get kinds;
/// Create a copy of MaterialFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialFilterCopyWith<MaterialFilter> get copyWith => _$MaterialFilterCopyWithImpl<MaterialFilter>(this as MaterialFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MaterialFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialFilter&&(identical(other.keyword, _this.keyword) || other.keyword == _this.keyword)&&(identical(other.nodeId, _this.nodeId) || other.nodeId == _this.nodeId)&&const DeepCollectionEquality().equals(other.kinds, _this.kinds));
}


@override
int get hashCode {
  final _this = this as MaterialFilter;
  return Object.hash(runtimeType,_this.keyword,_this.nodeId,const DeepCollectionEquality().hash(_this.kinds));
}

@override
String toString() {
  final _this = this as MaterialFilter;
  return 'MaterialFilter(keyword: ${_this.keyword}, nodeId: ${_this.nodeId}, kinds: ${_this.kinds})';
}


}

/// @nodoc
abstract mixin class $MaterialFilterCopyWith<$Res>  {
  factory $MaterialFilterCopyWith(MaterialFilter value, $Res Function(MaterialFilter) _then) = _$MaterialFilterCopyWithImpl;
@useResult
$Res call({
 String keyword, String? nodeId, Set<MaterialKind> kinds
});




}
/// @nodoc
class _$MaterialFilterCopyWithImpl<$Res>
    implements $MaterialFilterCopyWith<$Res> {
  _$MaterialFilterCopyWithImpl(this._self, this._then);

  final MaterialFilter _self;
  final $Res Function(MaterialFilter) _then;

/// Create a copy of MaterialFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyword = null,Object? nodeId = freezed,Object? kinds = null,}) {
  return _then(MaterialFilter(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,kinds: null == kinds ? _self.kinds : kinds // ignore: cast_nullable_to_non_nullable
as Set<MaterialKind>,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialFilter].
extension MaterialFilterPatterns on MaterialFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialFilter value)  $default,){
final _that = this;
switch (_that) {
case _MaterialFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialFilter value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyword,  String? nodeId,  Set<MaterialKind> kinds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialFilter() when $default != null:
return $default(_that.keyword,_that.nodeId,_that.kinds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyword,  String? nodeId,  Set<MaterialKind> kinds)  $default,) {final _that = this;
switch (_that) {
case _MaterialFilter():
return $default(_that.keyword,_that.nodeId,_that.kinds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyword,  String? nodeId,  Set<MaterialKind> kinds)?  $default,) {final _that = this;
switch (_that) {
case _MaterialFilter() when $default != null:
return $default(_that.keyword,_that.nodeId,_that.kinds);case _:
  return null;

}
}

}

/// @nodoc


class _MaterialFilter implements MaterialFilter {
  const _MaterialFilter({this.keyword = '', this.nodeId,  Set<MaterialKind> kinds = const <MaterialKind>{}}): _kinds = kinds;
  

/// 关键词，匹配标题 + 简介（服务端列是 search_text，已 lower）。
@override@JsonKey() final  String keyword;
/// 学科 / 专业大类节点。选中父节点时要不要含后代由页面的取数逻辑决定
///（PostgREST 直查做不了子树展开，所以这里只按精确节点筛）。
@override final  String? nodeId;
/// 类型多选。空集合表示不限。
 final  Set<MaterialKind> _kinds;
/// 类型多选。空集合表示不限。
@override@JsonKey() Set<MaterialKind> get kinds {
  if (_kinds is EqualUnmodifiableSetView) return _kinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_kinds);
}


/// Create a copy of MaterialFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialFilterCopyWith<_MaterialFilter> get copyWith => __$MaterialFilterCopyWithImpl<_MaterialFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialFilter&&(identical(other.keyword, keyword) || other.keyword == keyword)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&const DeepCollectionEquality().equals(other.kinds, _kinds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,keyword,nodeId,const DeepCollectionEquality().hash(_kinds));
}

@override
String toString() {
    return 'MaterialFilter(keyword: $keyword, nodeId: $nodeId, kinds: $kinds)';
}


}

/// @nodoc
abstract mixin class _$MaterialFilterCopyWith<$Res> implements $MaterialFilterCopyWith<$Res> {
  factory _$MaterialFilterCopyWith(_MaterialFilter value, $Res Function(_MaterialFilter) _then) = __$MaterialFilterCopyWithImpl;
@override @useResult
$Res call({
 String keyword, String? nodeId, Set<MaterialKind> kinds
});




}
/// @nodoc
class __$MaterialFilterCopyWithImpl<$Res>
    implements _$MaterialFilterCopyWith<$Res> {
  __$MaterialFilterCopyWithImpl(this._self, this._then);

  final _MaterialFilter _self;
  final $Res Function(_MaterialFilter) _then;

/// Create a copy of MaterialFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyword = null,Object? nodeId = freezed,Object? kinds = null,}) {
  return _then(_MaterialFilter(
keyword: null == keyword ? _self.keyword : keyword // ignore: cast_nullable_to_non_nullable
as String,nodeId: freezed == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String?,kinds: null == kinds ? _self._kinds : kinds // ignore: cast_nullable_to_non_nullable
as Set<MaterialKind>,
  ));
}


}

// dart format on
