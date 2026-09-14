// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubjectNode {

 String get id;@JsonKey(name: 'parent_id') String? get parentId; String get scope; String get kind; String get name;@JsonKey(name: 'sort_order') int get sortOrder;@JsonKey(name: 'is_frozen') bool get isFrozen;
/// Create a copy of SubjectNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectNodeCopyWith<SubjectNode> get copyWith => _$SubjectNodeCopyWithImpl<SubjectNode>(this as SubjectNode, _$identity);

  /// Serializes this SubjectNode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubjectNode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectNode&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.isFrozen, _this.isFrozen) || other.isFrozen == _this.isFrozen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubjectNode;
  return Object.hash(runtimeType,_this.id,_this.parentId,_this.scope,_this.kind,_this.name,_this.sortOrder,_this.isFrozen);
}

@override
String toString() {
  final _this = this as SubjectNode;
  return 'SubjectNode(id: ${_this.id}, parentId: ${_this.parentId}, scope: ${_this.scope}, kind: ${_this.kind}, name: ${_this.name}, sortOrder: ${_this.sortOrder}, isFrozen: ${_this.isFrozen})';
}


}

/// @nodoc
abstract mixin class $SubjectNodeCopyWith<$Res>  {
  factory $SubjectNodeCopyWith(SubjectNode value, $Res Function(SubjectNode) _then) = _$SubjectNodeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'parent_id') String? parentId, String scope, String kind, String name,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_frozen') bool isFrozen
});




}
/// @nodoc
class _$SubjectNodeCopyWithImpl<$Res>
    implements $SubjectNodeCopyWith<$Res> {
  _$SubjectNodeCopyWithImpl(this._self, this._then);

  final SubjectNode _self;
  final $Res Function(SubjectNode) _then;

/// Create a copy of SubjectNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentId = freezed,Object? scope = null,Object? kind = null,Object? name = null,Object? sortOrder = null,Object? isFrozen = null,}) {
  return _then(SubjectNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isFrozen: null == isFrozen ? _self.isFrozen : isFrozen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectNode].
extension SubjectNodePatterns on SubjectNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectNode value)  $default,){
final _that = this;
switch (_that) {
case _SubjectNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectNode value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'parent_id')  String? parentId,  String scope,  String kind,  String name, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_frozen')  bool isFrozen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectNode() when $default != null:
return $default(_that.id,_that.parentId,_that.scope,_that.kind,_that.name,_that.sortOrder,_that.isFrozen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'parent_id')  String? parentId,  String scope,  String kind,  String name, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_frozen')  bool isFrozen)  $default,) {final _that = this;
switch (_that) {
case _SubjectNode():
return $default(_that.id,_that.parentId,_that.scope,_that.kind,_that.name,_that.sortOrder,_that.isFrozen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'parent_id')  String? parentId,  String scope,  String kind,  String name, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'is_frozen')  bool isFrozen)?  $default,) {final _that = this;
switch (_that) {
case _SubjectNode() when $default != null:
return $default(_that.id,_that.parentId,_that.scope,_that.kind,_that.name,_that.sortOrder,_that.isFrozen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubjectNode implements SubjectNode {
  const _SubjectNode({required this.id, @JsonKey(name: 'parent_id') this.parentId, required this.scope, required this.kind, required this.name, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'is_frozen') this.isFrozen = false});
  factory _SubjectNode.fromJson(Map<String, dynamic> json) => _$SubjectNodeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'parent_id') final  String? parentId;
@override final  String scope;
@override final  String kind;
@override final  String name;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
@override@JsonKey(name: 'is_frozen') final  bool isFrozen;

/// Create a copy of SubjectNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectNodeCopyWith<_SubjectNode> get copyWith => __$SubjectNodeCopyWithImpl<_SubjectNode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectNodeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectNode&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isFrozen, isFrozen) || other.isFrozen == isFrozen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,parentId,scope,kind,name,sortOrder,isFrozen);
}

@override
String toString() {
    return 'SubjectNode(id: $id, parentId: $parentId, scope: $scope, kind: $kind, name: $name, sortOrder: $sortOrder, isFrozen: $isFrozen)';
}


}

/// @nodoc
abstract mixin class _$SubjectNodeCopyWith<$Res> implements $SubjectNodeCopyWith<$Res> {
  factory _$SubjectNodeCopyWith(_SubjectNode value, $Res Function(_SubjectNode) _then) = __$SubjectNodeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'parent_id') String? parentId, String scope, String kind, String name,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'is_frozen') bool isFrozen
});




}
/// @nodoc
class __$SubjectNodeCopyWithImpl<$Res>
    implements _$SubjectNodeCopyWith<$Res> {
  __$SubjectNodeCopyWithImpl(this._self, this._then);

  final _SubjectNode _self;
  final $Res Function(_SubjectNode) _then;

/// Create a copy of SubjectNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentId = freezed,Object? scope = null,Object? kind = null,Object? name = null,Object? sortOrder = null,Object? isFrozen = null,}) {
  return _then(_SubjectNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isFrozen: null == isFrozen ? _self.isFrozen : isFrozen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
