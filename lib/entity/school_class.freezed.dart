// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchoolClass {

 String get id;@JsonKey(name: 'school_id') String get schoolId;/// 所属专业节点：subject_nodes 里 kind 为 category（专业大类）或 major（专业）的行。
@JsonKey(name: 'major_node_id') String get majorNodeId; String get name;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of SchoolClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchoolClassCopyWith<SchoolClass> get copyWith => _$SchoolClassCopyWithImpl<SchoolClass>(this as SchoolClass, _$identity);

  /// Serializes this SchoolClass to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SchoolClass;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchoolClass&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.majorNodeId, _this.majorNodeId) || other.majorNodeId == _this.majorNodeId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SchoolClass;
  return Object.hash(runtimeType,_this.id,_this.schoolId,_this.majorNodeId,_this.name,_this.isActive);
}

@override
String toString() {
  final _this = this as SchoolClass;
  return 'SchoolClass(id: ${_this.id}, schoolId: ${_this.schoolId}, majorNodeId: ${_this.majorNodeId}, name: ${_this.name}, isActive: ${_this.isActive})';
}


}

/// @nodoc
abstract mixin class $SchoolClassCopyWith<$Res>  {
  factory $SchoolClassCopyWith(SchoolClass value, $Res Function(SchoolClass) _then) = _$SchoolClassCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'school_id') String schoolId,@JsonKey(name: 'major_node_id') String majorNodeId, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$SchoolClassCopyWithImpl<$Res>
    implements $SchoolClassCopyWith<$Res> {
  _$SchoolClassCopyWithImpl(this._self, this._then);

  final SchoolClass _self;
  final $Res Function(SchoolClass) _then;

/// Create a copy of SchoolClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? schoolId = null,Object? majorNodeId = null,Object? name = null,Object? isActive = null,}) {
  return _then(SchoolClass(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,majorNodeId: null == majorNodeId ? _self.majorNodeId : majorNodeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SchoolClass].
extension SchoolClassPatterns on SchoolClass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchoolClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchoolClass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchoolClass value)  $default,){
final _that = this;
switch (_that) {
case _SchoolClass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchoolClass value)?  $default,){
final _that = this;
switch (_that) {
case _SchoolClass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'school_id')  String schoolId, @JsonKey(name: 'major_node_id')  String majorNodeId,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchoolClass() when $default != null:
return $default(_that.id,_that.schoolId,_that.majorNodeId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'school_id')  String schoolId, @JsonKey(name: 'major_node_id')  String majorNodeId,  String name, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _SchoolClass():
return $default(_that.id,_that.schoolId,_that.majorNodeId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'school_id')  String schoolId, @JsonKey(name: 'major_node_id')  String majorNodeId,  String name, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _SchoolClass() when $default != null:
return $default(_that.id,_that.schoolId,_that.majorNodeId,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchoolClass implements SchoolClass {
  const _SchoolClass({required this.id, @JsonKey(name: 'school_id') required this.schoolId, @JsonKey(name: 'major_node_id') required this.majorNodeId, required this.name, @JsonKey(name: 'is_active') this.isActive = true});
  factory _SchoolClass.fromJson(Map<String, dynamic> json) => _$SchoolClassFromJson(json);

@override final  String id;
@override@JsonKey(name: 'school_id') final  String schoolId;
/// 所属专业节点：subject_nodes 里 kind 为 category（专业大类）或 major（专业）的行。
@override@JsonKey(name: 'major_node_id') final  String majorNodeId;
@override final  String name;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of SchoolClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchoolClassCopyWith<_SchoolClass> get copyWith => __$SchoolClassCopyWithImpl<_SchoolClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchoolClassToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchoolClass&&(identical(other.id, id) || other.id == id)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.majorNodeId, majorNodeId) || other.majorNodeId == majorNodeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,schoolId,majorNodeId,name,isActive);
}

@override
String toString() {
    return 'SchoolClass(id: $id, schoolId: $schoolId, majorNodeId: $majorNodeId, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$SchoolClassCopyWith<$Res> implements $SchoolClassCopyWith<$Res> {
  factory _$SchoolClassCopyWith(_SchoolClass value, $Res Function(_SchoolClass) _then) = __$SchoolClassCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'school_id') String schoolId,@JsonKey(name: 'major_node_id') String majorNodeId, String name,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$SchoolClassCopyWithImpl<$Res>
    implements _$SchoolClassCopyWith<$Res> {
  __$SchoolClassCopyWithImpl(this._self, this._then);

  final _SchoolClass _self;
  final $Res Function(_SchoolClass) _then;

/// Create a copy of SchoolClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? schoolId = null,Object? majorNodeId = null,Object? name = null,Object? isActive = null,}) {
  return _then(_SchoolClass(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,majorNodeId: null == majorNodeId ? _self.majorNodeId : majorNodeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
