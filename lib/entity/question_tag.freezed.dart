// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionTag {

 String get id; String get name;/// 这个知识点属于哪个科目节点（任意层级）。null = 未归类，
/// **未归类的不该出现在按学科筛选的候选里**（0096）。
@JsonKey(name: 'subject_node_id') String? get subjectNodeId;/// 父知识点，自引用成树。null = 顶层。
@JsonKey(name: 'parent_id') String? get parentId;/// 同层排序，小的在前。
@JsonKey(name: 'sort_order') int get sortOrder;
/// Create a copy of QuestionTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionTagCopyWith<QuestionTag> get copyWith => _$QuestionTagCopyWithImpl<QuestionTag>(this as QuestionTag, _$identity);

  /// Serializes this QuestionTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionTag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.subjectNodeId, _this.subjectNodeId) || other.subjectNodeId == _this.subjectNodeId)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionTag;
  return Object.hash(runtimeType,_this.id,_this.name,_this.subjectNodeId,_this.parentId,_this.sortOrder);
}

@override
String toString() {
  final _this = this as QuestionTag;
  return 'QuestionTag(id: ${_this.id}, name: ${_this.name}, subjectNodeId: ${_this.subjectNodeId}, parentId: ${_this.parentId}, sortOrder: ${_this.sortOrder})';
}


}

/// @nodoc
abstract mixin class $QuestionTagCopyWith<$Res>  {
  factory $QuestionTagCopyWith(QuestionTag value, $Res Function(QuestionTag) _then) = _$QuestionTagCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'subject_node_id') String? subjectNodeId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class _$QuestionTagCopyWithImpl<$Res>
    implements $QuestionTagCopyWith<$Res> {
  _$QuestionTagCopyWithImpl(this._self, this._then);

  final QuestionTag _self;
  final $Res Function(QuestionTag) _then;

/// Create a copy of QuestionTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? subjectNodeId = freezed,Object? parentId = freezed,Object? sortOrder = null,}) {
  return _then(QuestionTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subjectNodeId: freezed == subjectNodeId ? _self.subjectNodeId : subjectNodeId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionTag].
extension QuestionTagPatterns on QuestionTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionTag value)  $default,){
final _that = this;
switch (_that) {
case _QuestionTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionTag value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'subject_node_id')  String? subjectNodeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionTag() when $default != null:
return $default(_that.id,_that.name,_that.subjectNodeId,_that.parentId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'subject_node_id')  String? subjectNodeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _QuestionTag():
return $default(_that.id,_that.name,_that.subjectNodeId,_that.parentId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'subject_node_id')  String? subjectNodeId, @JsonKey(name: 'parent_id')  String? parentId, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _QuestionTag() when $default != null:
return $default(_that.id,_that.name,_that.subjectNodeId,_that.parentId,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionTag implements QuestionTag {
  const _QuestionTag({required this.id, required this.name, @JsonKey(name: 'subject_node_id') this.subjectNodeId, @JsonKey(name: 'parent_id') this.parentId, @JsonKey(name: 'sort_order') this.sortOrder = 0});
  factory _QuestionTag.fromJson(Map<String, dynamic> json) => _$QuestionTagFromJson(json);

@override final  String id;
@override final  String name;
/// 这个知识点属于哪个科目节点（任意层级）。null = 未归类，
/// **未归类的不该出现在按学科筛选的候选里**（0096）。
@override@JsonKey(name: 'subject_node_id') final  String? subjectNodeId;
/// 父知识点，自引用成树。null = 顶层。
@override@JsonKey(name: 'parent_id') final  String? parentId;
/// 同层排序，小的在前。
@override@JsonKey(name: 'sort_order') final  int sortOrder;

/// Create a copy of QuestionTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionTagCopyWith<_QuestionTag> get copyWith => __$QuestionTagCopyWithImpl<_QuestionTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionTag&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.subjectNodeId, subjectNodeId) || other.subjectNodeId == subjectNodeId)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,subjectNodeId,parentId,sortOrder);
}

@override
String toString() {
    return 'QuestionTag(id: $id, name: $name, subjectNodeId: $subjectNodeId, parentId: $parentId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$QuestionTagCopyWith<$Res> implements $QuestionTagCopyWith<$Res> {
  factory _$QuestionTagCopyWith(_QuestionTag value, $Res Function(_QuestionTag) _then) = __$QuestionTagCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'subject_node_id') String? subjectNodeId,@JsonKey(name: 'parent_id') String? parentId,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class __$QuestionTagCopyWithImpl<$Res>
    implements _$QuestionTagCopyWith<$Res> {
  __$QuestionTagCopyWithImpl(this._self, this._then);

  final _QuestionTag _self;
  final $Res Function(_QuestionTag) _then;

/// Create a copy of QuestionTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? subjectNodeId = freezed,Object? parentId = freezed,Object? sortOrder = null,}) {
  return _then(_QuestionTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,subjectNodeId: freezed == subjectNodeId ? _self.subjectNodeId : subjectNodeId // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
