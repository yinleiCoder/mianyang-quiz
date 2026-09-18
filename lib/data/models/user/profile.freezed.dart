// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

@JsonKey(name: 'user_id') String get userId; String get name; String get email; String get phone;@JsonKey(name: 'school_id') String? get schoolId;@JsonKey(name: 'is_admin') bool get isAdmin;@JsonKey(name: 'avatar_url') String? get avatarUrl; String? get identity;@JsonKey(name: 'enroll_year') int? get enrollYear;@JsonKey(name: 'major_category') String? get majorCategory; String? get major;@JsonKey(name: 'class_name') String? get className;@JsonKey(name: 'class_id') String? get classId;@JsonKey(name: 'major_node_id') String? get majorNodeId;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.identity, _this.identity) || other.identity == _this.identity)&&(identical(other.enrollYear, _this.enrollYear) || other.enrollYear == _this.enrollYear)&&(identical(other.majorCategory, _this.majorCategory) || other.majorCategory == _this.majorCategory)&&(identical(other.major, _this.major) || other.major == _this.major)&&(identical(other.className, _this.className) || other.className == _this.className)&&(identical(other.classId, _this.classId) || other.classId == _this.classId)&&(identical(other.majorNodeId, _this.majorNodeId) || other.majorNodeId == _this.majorNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.email,_this.phone,_this.schoolId,_this.isAdmin,_this.avatarUrl,_this.identity,_this.enrollYear,_this.majorCategory,_this.major,_this.className,_this.classId,_this.majorNodeId);
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(userId: ${_this.userId}, name: ${_this.name}, email: ${_this.email}, phone: ${_this.phone}, schoolId: ${_this.schoolId}, isAdmin: ${_this.isAdmin}, avatarUrl: ${_this.avatarUrl}, identity: ${_this.identity}, enrollYear: ${_this.enrollYear}, majorCategory: ${_this.majorCategory}, major: ${_this.major}, className: ${_this.className}, classId: ${_this.classId}, majorNodeId: ${_this.majorNodeId})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name, String email, String phone,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'is_admin') bool isAdmin,@JsonKey(name: 'avatar_url') String? avatarUrl, String? identity,@JsonKey(name: 'enroll_year') int? enrollYear,@JsonKey(name: 'major_category') String? majorCategory, String? major,@JsonKey(name: 'class_name') String? className,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'major_node_id') String? majorNodeId
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? email = null,Object? phone = null,Object? schoolId = freezed,Object? isAdmin = null,Object? avatarUrl = freezed,Object? identity = freezed,Object? enrollYear = freezed,Object? majorCategory = freezed,Object? major = freezed,Object? className = freezed,Object? classId = freezed,Object? majorNodeId = freezed,}) {
  return _then(Profile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,identity: freezed == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String?,enrollYear: freezed == enrollYear ? _self.enrollYear : enrollYear // ignore: cast_nullable_to_non_nullable
as int?,majorCategory: freezed == majorCategory ? _self.majorCategory : majorCategory // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,majorNodeId: freezed == majorNodeId ? _self.majorNodeId : majorNodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name,  String email,  String phone, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? identity, @JsonKey(name: 'enroll_year')  int? enrollYear, @JsonKey(name: 'major_category')  String? majorCategory,  String? major, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'major_node_id')  String? majorNodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.userId,_that.name,_that.email,_that.phone,_that.schoolId,_that.isAdmin,_that.avatarUrl,_that.identity,_that.enrollYear,_that.majorCategory,_that.major,_that.className,_that.classId,_that.majorNodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name,  String email,  String phone, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? identity, @JsonKey(name: 'enroll_year')  int? enrollYear, @JsonKey(name: 'major_category')  String? majorCategory,  String? major, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'major_node_id')  String? majorNodeId)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.userId,_that.name,_that.email,_that.phone,_that.schoolId,_that.isAdmin,_that.avatarUrl,_that.identity,_that.enrollYear,_that.majorCategory,_that.major,_that.className,_that.classId,_that.majorNodeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String name,  String email,  String phone, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? identity, @JsonKey(name: 'enroll_year')  int? enrollYear, @JsonKey(name: 'major_category')  String? majorCategory,  String? major, @JsonKey(name: 'class_name')  String? className, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'major_node_id')  String? majorNodeId)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.userId,_that.name,_that.email,_that.phone,_that.schoolId,_that.isAdmin,_that.avatarUrl,_that.identity,_that.enrollYear,_that.majorCategory,_that.major,_that.className,_that.classId,_that.majorNodeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({@JsonKey(name: 'user_id') required this.userId, this.name = '', this.email = '', this.phone = '', @JsonKey(name: 'school_id') this.schoolId, @JsonKey(name: 'is_admin') this.isAdmin = false, @JsonKey(name: 'avatar_url') this.avatarUrl, this.identity, @JsonKey(name: 'enroll_year') this.enrollYear, @JsonKey(name: 'major_category') this.majorCategory, this.major, @JsonKey(name: 'class_name') this.className, @JsonKey(name: 'class_id') this.classId, @JsonKey(name: 'major_node_id') this.majorNodeId});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey(name: 'is_admin') final  bool isAdmin;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String? identity;
@override@JsonKey(name: 'enroll_year') final  int? enrollYear;
@override@JsonKey(name: 'major_category') final  String? majorCategory;
@override final  String? major;
@override@JsonKey(name: 'class_name') final  String? className;
@override@JsonKey(name: 'class_id') final  String? classId;
@override@JsonKey(name: 'major_node_id') final  String? majorNodeId;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.enrollYear, enrollYear) || other.enrollYear == enrollYear)&&(identical(other.majorCategory, majorCategory) || other.majorCategory == majorCategory)&&(identical(other.major, major) || other.major == major)&&(identical(other.className, className) || other.className == className)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.majorNodeId, majorNodeId) || other.majorNodeId == majorNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,email,phone,schoolId,isAdmin,avatarUrl,identity,enrollYear,majorCategory,major,className,classId,majorNodeId);
}

@override
String toString() {
    return 'Profile(userId: $userId, name: $name, email: $email, phone: $phone, schoolId: $schoolId, isAdmin: $isAdmin, avatarUrl: $avatarUrl, identity: $identity, enrollYear: $enrollYear, majorCategory: $majorCategory, major: $major, className: $className, classId: $classId, majorNodeId: $majorNodeId)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name, String email, String phone,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'is_admin') bool isAdmin,@JsonKey(name: 'avatar_url') String? avatarUrl, String? identity,@JsonKey(name: 'enroll_year') int? enrollYear,@JsonKey(name: 'major_category') String? majorCategory, String? major,@JsonKey(name: 'class_name') String? className,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'major_node_id') String? majorNodeId
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? email = null,Object? phone = null,Object? schoolId = freezed,Object? isAdmin = null,Object? avatarUrl = freezed,Object? identity = freezed,Object? enrollYear = freezed,Object? majorCategory = freezed,Object? major = freezed,Object? className = freezed,Object? classId = freezed,Object? majorNodeId = freezed,}) {
  return _then(_Profile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,identity: freezed == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as String?,enrollYear: freezed == enrollYear ? _self.enrollYear : enrollYear // ignore: cast_nullable_to_non_nullable
as int?,majorCategory: freezed == majorCategory ? _self.majorCategory : majorCategory // ignore: cast_nullable_to_non_nullable
as String?,major: freezed == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String?,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,majorNodeId: freezed == majorNodeId ? _self.majorNodeId : majorNodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
