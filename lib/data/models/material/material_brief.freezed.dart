// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material_brief.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaterialBrief {

 String get id;@JsonKey(name: 'object_key') String get objectKey; String get title; String? get description; String get kind;@JsonKey(name: 'course_node_id') String? get courseNodeId;@JsonKey(name: 'creator_id') String? get creatorId;@JsonKey(name: 'creator_name') String? get creatorName;@JsonKey(name: 'school_name') String? get schoolName;@JsonKey(name: 'download_count') int get downloadCount; int get size; String? get mime;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of MaterialBrief
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaterialBriefCopyWith<MaterialBrief> get copyWith => _$MaterialBriefCopyWithImpl<MaterialBrief>(this as MaterialBrief, _$identity);

  /// Serializes this MaterialBrief to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MaterialBrief;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaterialBrief&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.objectKey, _this.objectKey) || other.objectKey == _this.objectKey)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.courseNodeId, _this.courseNodeId) || other.courseNodeId == _this.courseNodeId)&&(identical(other.creatorId, _this.creatorId) || other.creatorId == _this.creatorId)&&(identical(other.creatorName, _this.creatorName) || other.creatorName == _this.creatorName)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName)&&(identical(other.downloadCount, _this.downloadCount) || other.downloadCount == _this.downloadCount)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.mime, _this.mime) || other.mime == _this.mime)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MaterialBrief;
  return Object.hash(runtimeType,_this.id,_this.objectKey,_this.title,_this.description,_this.kind,_this.courseNodeId,_this.creatorId,_this.creatorName,_this.schoolName,_this.downloadCount,_this.size,_this.mime,_this.createdAt);
}

@override
String toString() {
  final _this = this as MaterialBrief;
  return 'MaterialBrief(id: ${_this.id}, objectKey: ${_this.objectKey}, title: ${_this.title}, description: ${_this.description}, kind: ${_this.kind}, courseNodeId: ${_this.courseNodeId}, creatorId: ${_this.creatorId}, creatorName: ${_this.creatorName}, schoolName: ${_this.schoolName}, downloadCount: ${_this.downloadCount}, size: ${_this.size}, mime: ${_this.mime}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MaterialBriefCopyWith<$Res>  {
  factory $MaterialBriefCopyWith(MaterialBrief value, $Res Function(MaterialBrief) _then) = _$MaterialBriefCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'object_key') String objectKey, String title, String? description, String kind,@JsonKey(name: 'course_node_id') String? courseNodeId,@JsonKey(name: 'creator_id') String? creatorId,@JsonKey(name: 'creator_name') String? creatorName,@JsonKey(name: 'school_name') String? schoolName,@JsonKey(name: 'download_count') int downloadCount, int size, String? mime,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$MaterialBriefCopyWithImpl<$Res>
    implements $MaterialBriefCopyWith<$Res> {
  _$MaterialBriefCopyWithImpl(this._self, this._then);

  final MaterialBrief _self;
  final $Res Function(MaterialBrief) _then;

/// Create a copy of MaterialBrief
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? objectKey = null,Object? title = null,Object? description = freezed,Object? kind = null,Object? courseNodeId = freezed,Object? creatorId = freezed,Object? creatorName = freezed,Object? schoolName = freezed,Object? downloadCount = null,Object? size = null,Object? mime = freezed,Object? createdAt = freezed,}) {
  return _then(MaterialBrief(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,creatorId: freezed == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mime: freezed == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MaterialBrief].
extension MaterialBriefPatterns on MaterialBrief {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaterialBrief value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaterialBrief() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaterialBrief value)  $default,){
final _that = this;
switch (_that) {
case _MaterialBrief():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaterialBrief value)?  $default,){
final _that = this;
switch (_that) {
case _MaterialBrief() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'object_key')  String objectKey,  String title,  String? description,  String kind, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'creator_id')  String? creatorId, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'download_count')  int downloadCount,  int size,  String? mime, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaterialBrief() when $default != null:
return $default(_that.id,_that.objectKey,_that.title,_that.description,_that.kind,_that.courseNodeId,_that.creatorId,_that.creatorName,_that.schoolName,_that.downloadCount,_that.size,_that.mime,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'object_key')  String objectKey,  String title,  String? description,  String kind, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'creator_id')  String? creatorId, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'download_count')  int downloadCount,  int size,  String? mime, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _MaterialBrief():
return $default(_that.id,_that.objectKey,_that.title,_that.description,_that.kind,_that.courseNodeId,_that.creatorId,_that.creatorName,_that.schoolName,_that.downloadCount,_that.size,_that.mime,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'object_key')  String objectKey,  String title,  String? description,  String kind, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'creator_id')  String? creatorId, @JsonKey(name: 'creator_name')  String? creatorName, @JsonKey(name: 'school_name')  String? schoolName, @JsonKey(name: 'download_count')  int downloadCount,  int size,  String? mime, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MaterialBrief() when $default != null:
return $default(_that.id,_that.objectKey,_that.title,_that.description,_that.kind,_that.courseNodeId,_that.creatorId,_that.creatorName,_that.schoolName,_that.downloadCount,_that.size,_that.mime,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaterialBrief implements MaterialBrief {
  const _MaterialBrief({required this.id, @JsonKey(name: 'object_key') required this.objectKey, required this.title, this.description, this.kind = 'other', @JsonKey(name: 'course_node_id') this.courseNodeId, @JsonKey(name: 'creator_id') this.creatorId, @JsonKey(name: 'creator_name') this.creatorName, @JsonKey(name: 'school_name') this.schoolName, @JsonKey(name: 'download_count') this.downloadCount = 0, this.size = 0, this.mime, @JsonKey(name: 'created_at') this.createdAt});
  factory _MaterialBrief.fromJson(Map<String, dynamic> json) => _$MaterialBriefFromJson(json);

@override final  String id;
@override@JsonKey(name: 'object_key') final  String objectKey;
@override final  String title;
@override final  String? description;
@override@JsonKey() final  String kind;
@override@JsonKey(name: 'course_node_id') final  String? courseNodeId;
@override@JsonKey(name: 'creator_id') final  String? creatorId;
@override@JsonKey(name: 'creator_name') final  String? creatorName;
@override@JsonKey(name: 'school_name') final  String? schoolName;
@override@JsonKey(name: 'download_count') final  int downloadCount;
@override@JsonKey() final  int size;
@override final  String? mime;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of MaterialBrief
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaterialBriefCopyWith<_MaterialBrief> get copyWith => __$MaterialBriefCopyWithImpl<_MaterialBrief>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaterialBriefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaterialBrief&&(identical(other.id, id) || other.id == id)&&(identical(other.objectKey, objectKey) || other.objectKey == objectKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.courseNodeId, courseNodeId) || other.courseNodeId == courseNodeId)&&(identical(other.creatorId, creatorId) || other.creatorId == creatorId)&&(identical(other.creatorName, creatorName) || other.creatorName == creatorName)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.downloadCount, downloadCount) || other.downloadCount == downloadCount)&&(identical(other.size, size) || other.size == size)&&(identical(other.mime, mime) || other.mime == mime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,objectKey,title,description,kind,courseNodeId,creatorId,creatorName,schoolName,downloadCount,size,mime,createdAt);
}

@override
String toString() {
    return 'MaterialBrief(id: $id, objectKey: $objectKey, title: $title, description: $description, kind: $kind, courseNodeId: $courseNodeId, creatorId: $creatorId, creatorName: $creatorName, schoolName: $schoolName, downloadCount: $downloadCount, size: $size, mime: $mime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MaterialBriefCopyWith<$Res> implements $MaterialBriefCopyWith<$Res> {
  factory _$MaterialBriefCopyWith(_MaterialBrief value, $Res Function(_MaterialBrief) _then) = __$MaterialBriefCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'object_key') String objectKey, String title, String? description, String kind,@JsonKey(name: 'course_node_id') String? courseNodeId,@JsonKey(name: 'creator_id') String? creatorId,@JsonKey(name: 'creator_name') String? creatorName,@JsonKey(name: 'school_name') String? schoolName,@JsonKey(name: 'download_count') int downloadCount, int size, String? mime,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$MaterialBriefCopyWithImpl<$Res>
    implements _$MaterialBriefCopyWith<$Res> {
  __$MaterialBriefCopyWithImpl(this._self, this._then);

  final _MaterialBrief _self;
  final $Res Function(_MaterialBrief) _then;

/// Create a copy of MaterialBrief
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? objectKey = null,Object? title = null,Object? description = freezed,Object? kind = null,Object? courseNodeId = freezed,Object? creatorId = freezed,Object? creatorName = freezed,Object? schoolName = freezed,Object? downloadCount = null,Object? size = null,Object? mime = freezed,Object? createdAt = freezed,}) {
  return _then(_MaterialBrief(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objectKey: null == objectKey ? _self.objectKey : objectKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,creatorId: freezed == creatorId ? _self.creatorId : creatorId // ignore: cast_nullable_to_non_nullable
as String?,creatorName: freezed == creatorName ? _self.creatorName : creatorName // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,downloadCount: null == downloadCount ? _self.downloadCount : downloadCount // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mime: freezed == mime ? _self.mime : mime // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
