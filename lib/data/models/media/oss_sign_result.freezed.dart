// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oss_sign_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OssSignResult {

@JsonKey(name: 'uploadUrl') String get uploadUrl; String get bucket;/// 必须原样、按序放进 multipart 的字段（含 key/policy/signature/Content-Type 等）。
/// 服务端生成的 key 就在这里——上传后要用它拼展示 URL 或登记媒体。
 Map<String, String> get fields;
/// Create a copy of OssSignResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OssSignResultCopyWith<OssSignResult> get copyWith => _$OssSignResultCopyWithImpl<OssSignResult>(this as OssSignResult, _$identity);

  /// Serializes this OssSignResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OssSignResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OssSignResult&&(identical(other.uploadUrl, _this.uploadUrl) || other.uploadUrl == _this.uploadUrl)&&(identical(other.bucket, _this.bucket) || other.bucket == _this.bucket)&&const DeepCollectionEquality().equals(other.fields, _this.fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OssSignResult;
  return Object.hash(runtimeType,_this.uploadUrl,_this.bucket,const DeepCollectionEquality().hash(_this.fields));
}

@override
String toString() {
  final _this = this as OssSignResult;
  return 'OssSignResult(uploadUrl: ${_this.uploadUrl}, bucket: ${_this.bucket}, fields: ${_this.fields})';
}


}

/// @nodoc
abstract mixin class $OssSignResultCopyWith<$Res>  {
  factory $OssSignResultCopyWith(OssSignResult value, $Res Function(OssSignResult) _then) = _$OssSignResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'uploadUrl') String uploadUrl, String bucket, Map<String, String> fields
});




}
/// @nodoc
class _$OssSignResultCopyWithImpl<$Res>
    implements $OssSignResultCopyWith<$Res> {
  _$OssSignResultCopyWithImpl(this._self, this._then);

  final OssSignResult _self;
  final $Res Function(OssSignResult) _then;

/// Create a copy of OssSignResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uploadUrl = null,Object? bucket = null,Object? fields = null,}) {
  return _then(OssSignResult(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OssSignResult].
extension OssSignResultPatterns on OssSignResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OssSignResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OssSignResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OssSignResult value)  $default,){
final _that = this;
switch (_that) {
case _OssSignResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OssSignResult value)?  $default,){
final _that = this;
switch (_that) {
case _OssSignResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'uploadUrl')  String uploadUrl,  String bucket,  Map<String, String> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OssSignResult() when $default != null:
return $default(_that.uploadUrl,_that.bucket,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'uploadUrl')  String uploadUrl,  String bucket,  Map<String, String> fields)  $default,) {final _that = this;
switch (_that) {
case _OssSignResult():
return $default(_that.uploadUrl,_that.bucket,_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'uploadUrl')  String uploadUrl,  String bucket,  Map<String, String> fields)?  $default,) {final _that = this;
switch (_that) {
case _OssSignResult() when $default != null:
return $default(_that.uploadUrl,_that.bucket,_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OssSignResult implements OssSignResult {
  const _OssSignResult({@JsonKey(name: 'uploadUrl') required this.uploadUrl, this.bucket = '',  Map<String, String> fields = const <String, String>{}}): _fields = fields;
  factory _OssSignResult.fromJson(Map<String, dynamic> json) => _$OssSignResultFromJson(json);

@override@JsonKey(name: 'uploadUrl') final  String uploadUrl;
@override@JsonKey() final  String bucket;
/// 必须原样、按序放进 multipart 的字段（含 key/policy/signature/Content-Type 等）。
/// 服务端生成的 key 就在这里——上传后要用它拼展示 URL 或登记媒体。
 final  Map<String, String> _fields;
/// 必须原样、按序放进 multipart 的字段（含 key/policy/signature/Content-Type 等）。
/// 服务端生成的 key 就在这里——上传后要用它拼展示 URL 或登记媒体。
@override@JsonKey() Map<String, String> get fields {
  if (_fields is EqualUnmodifiableMapView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fields);
}


/// Create a copy of OssSignResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OssSignResultCopyWith<_OssSignResult> get copyWith => __$OssSignResultCopyWithImpl<_OssSignResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OssSignResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OssSignResult&&(identical(other.uploadUrl, uploadUrl) || other.uploadUrl == uploadUrl)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&const DeepCollectionEquality().equals(other.fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uploadUrl,bucket,const DeepCollectionEquality().hash(_fields));
}

@override
String toString() {
    return 'OssSignResult(uploadUrl: $uploadUrl, bucket: $bucket, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$OssSignResultCopyWith<$Res> implements $OssSignResultCopyWith<$Res> {
  factory _$OssSignResultCopyWith(_OssSignResult value, $Res Function(_OssSignResult) _then) = __$OssSignResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'uploadUrl') String uploadUrl, String bucket, Map<String, String> fields
});




}
/// @nodoc
class __$OssSignResultCopyWithImpl<$Res>
    implements _$OssSignResultCopyWith<$Res> {
  __$OssSignResultCopyWithImpl(this._self, this._then);

  final _OssSignResult _self;
  final $Res Function(_OssSignResult) _then;

/// Create a copy of OssSignResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uploadUrl = null,Object? bucket = null,Object? fields = null,}) {
  return _then(_OssSignResult(
uploadUrl: null == uploadUrl ? _self.uploadUrl : uploadUrl // ignore: cast_nullable_to_non_nullable
as String,bucket: null == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
