// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paper_leaderboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardScope {

 String get key; String get label;@JsonKey(name: 'class_id') String? get classId;@JsonKey(name: 'school_id') String? get schoolId;@JsonKey(name: 'is_staff') bool get isStaff;/// 学生没分班时是 not_in_class —— 界面据此提示"先看全校/全市"。
 String? get note;
/// Create a copy of LeaderboardScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardScopeCopyWith<LeaderboardScope> get copyWith => _$LeaderboardScopeCopyWithImpl<LeaderboardScope>(this as LeaderboardScope, _$identity);

  /// Serializes this LeaderboardScope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardScope;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardScope&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.classId, _this.classId) || other.classId == _this.classId)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.isStaff, _this.isStaff) || other.isStaff == _this.isStaff)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardScope;
  return Object.hash(runtimeType,_this.key,_this.label,_this.classId,_this.schoolId,_this.isStaff,_this.note);
}

@override
String toString() {
  final _this = this as LeaderboardScope;
  return 'LeaderboardScope(key: ${_this.key}, label: ${_this.label}, classId: ${_this.classId}, schoolId: ${_this.schoolId}, isStaff: ${_this.isStaff}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $LeaderboardScopeCopyWith<$Res>  {
  factory $LeaderboardScopeCopyWith(LeaderboardScope value, $Res Function(LeaderboardScope) _then) = _$LeaderboardScopeCopyWithImpl;
@useResult
$Res call({
 String key, String label,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'is_staff') bool isStaff, String? note
});




}
/// @nodoc
class _$LeaderboardScopeCopyWithImpl<$Res>
    implements $LeaderboardScopeCopyWith<$Res> {
  _$LeaderboardScopeCopyWithImpl(this._self, this._then);

  final LeaderboardScope _self;
  final $Res Function(LeaderboardScope) _then;

/// Create a copy of LeaderboardScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? classId = freezed,Object? schoolId = freezed,Object? isStaff = null,Object? note = freezed,}) {
  return _then(LeaderboardScope(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,isStaff: null == isStaff ? _self.isStaff : isStaff // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardScope].
extension LeaderboardScopePatterns on LeaderboardScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardScope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardScope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardScope value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardScope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardScope value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardScope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_staff')  bool isStaff,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardScope() when $default != null:
return $default(_that.key,_that.label,_that.classId,_that.schoolId,_that.isStaff,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_staff')  bool isStaff,  String? note)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardScope():
return $default(_that.key,_that.label,_that.classId,_that.schoolId,_that.isStaff,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label, @JsonKey(name: 'class_id')  String? classId, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'is_staff')  bool isStaff,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardScope() when $default != null:
return $default(_that.key,_that.label,_that.classId,_that.schoolId,_that.isStaff,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardScope implements LeaderboardScope {
  const _LeaderboardScope({this.key = 'class', this.label = '全班', @JsonKey(name: 'class_id') this.classId, @JsonKey(name: 'school_id') this.schoolId, @JsonKey(name: 'is_staff') this.isStaff = false, this.note});
  factory _LeaderboardScope.fromJson(Map<String, dynamic> json) => _$LeaderboardScopeFromJson(json);

@override@JsonKey() final  String key;
@override@JsonKey() final  String label;
@override@JsonKey(name: 'class_id') final  String? classId;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey(name: 'is_staff') final  bool isStaff;
/// 学生没分班时是 not_in_class —— 界面据此提示"先看全校/全市"。
@override final  String? note;

/// Create a copy of LeaderboardScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardScopeCopyWith<_LeaderboardScope> get copyWith => __$LeaderboardScopeCopyWithImpl<_LeaderboardScope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardScopeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardScope&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.classId, classId) || other.classId == classId)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.isStaff, isStaff) || other.isStaff == isStaff)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,label,classId,schoolId,isStaff,note);
}

@override
String toString() {
    return 'LeaderboardScope(key: $key, label: $label, classId: $classId, schoolId: $schoolId, isStaff: $isStaff, note: $note)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardScopeCopyWith<$Res> implements $LeaderboardScopeCopyWith<$Res> {
  factory _$LeaderboardScopeCopyWith(_LeaderboardScope value, $Res Function(_LeaderboardScope) _then) = __$LeaderboardScopeCopyWithImpl;
@override @useResult
$Res call({
 String key, String label,@JsonKey(name: 'class_id') String? classId,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'is_staff') bool isStaff, String? note
});




}
/// @nodoc
class __$LeaderboardScopeCopyWithImpl<$Res>
    implements _$LeaderboardScopeCopyWith<$Res> {
  __$LeaderboardScopeCopyWithImpl(this._self, this._then);

  final _LeaderboardScope _self;
  final $Res Function(_LeaderboardScope) _then;

/// Create a copy of LeaderboardScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? classId = freezed,Object? schoolId = freezed,Object? isStaff = null,Object? note = freezed,}) {
  return _then(_LeaderboardScope(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,classId: freezed == classId ? _self.classId : classId // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,isStaff: null == isStaff ? _self.isStaff : isStaff // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeaderboardPaper {

 String get id; String get title;@JsonKey(name: 'exam_name') String? get examName;@JsonKey(name: 'subject_label') String? get subjectLabel;@JsonKey(name: 'version_id') String? get versionId;@JsonKey(name: 'version_no') int? get versionNo;@JsonKey(name: 'full_score') double get fullScore;@JsonKey(name: 'published_at') String? get publishedAt;@JsonKey(name: 'school_id') String? get schoolId;@JsonKey(name: 'school_name') String? get schoolName;
/// Create a copy of LeaderboardPaper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardPaperCopyWith<LeaderboardPaper> get copyWith => _$LeaderboardPaperCopyWithImpl<LeaderboardPaper>(this as LeaderboardPaper, _$identity);

  /// Serializes this LeaderboardPaper to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardPaper;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardPaper&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.examName, _this.examName) || other.examName == _this.examName)&&(identical(other.subjectLabel, _this.subjectLabel) || other.subjectLabel == _this.subjectLabel)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.versionNo, _this.versionNo) || other.versionNo == _this.versionNo)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardPaper;
  return Object.hash(runtimeType,_this.id,_this.title,_this.examName,_this.subjectLabel,_this.versionId,_this.versionNo,_this.fullScore,_this.publishedAt,_this.schoolId,_this.schoolName);
}

@override
String toString() {
  final _this = this as LeaderboardPaper;
  return 'LeaderboardPaper(id: ${_this.id}, title: ${_this.title}, examName: ${_this.examName}, subjectLabel: ${_this.subjectLabel}, versionId: ${_this.versionId}, versionNo: ${_this.versionNo}, fullScore: ${_this.fullScore}, publishedAt: ${_this.publishedAt}, schoolId: ${_this.schoolId}, schoolName: ${_this.schoolName})';
}


}

/// @nodoc
abstract mixin class $LeaderboardPaperCopyWith<$Res>  {
  factory $LeaderboardPaperCopyWith(LeaderboardPaper value, $Res Function(LeaderboardPaper) _then) = _$LeaderboardPaperCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'version_id') String? versionId,@JsonKey(name: 'version_no') int? versionNo,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'published_at') String? publishedAt,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName
});




}
/// @nodoc
class _$LeaderboardPaperCopyWithImpl<$Res>
    implements $LeaderboardPaperCopyWith<$Res> {
  _$LeaderboardPaperCopyWithImpl(this._self, this._then);

  final LeaderboardPaper _self;
  final $Res Function(LeaderboardPaper) _then;

/// Create a copy of LeaderboardPaper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? versionId = freezed,Object? versionNo = freezed,Object? fullScore = null,Object? publishedAt = freezed,Object? schoolId = freezed,Object? schoolName = freezed,}) {
  return _then(LeaderboardPaper(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,versionNo: freezed == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int?,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardPaper].
extension LeaderboardPaperPatterns on LeaderboardPaper {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardPaper value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardPaper() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardPaper value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardPaper():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardPaper value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardPaper() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'version_id')  String? versionId, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'published_at')  String? publishedAt, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardPaper() when $default != null:
return $default(_that.id,_that.title,_that.examName,_that.subjectLabel,_that.versionId,_that.versionNo,_that.fullScore,_that.publishedAt,_that.schoolId,_that.schoolName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'version_id')  String? versionId, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'published_at')  String? publishedAt, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardPaper():
return $default(_that.id,_that.title,_that.examName,_that.subjectLabel,_that.versionId,_that.versionNo,_that.fullScore,_that.publishedAt,_that.schoolId,_that.schoolName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'version_id')  String? versionId, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'published_at')  String? publishedAt, @JsonKey(name: 'school_id')  String? schoolId, @JsonKey(name: 'school_name')  String? schoolName)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardPaper() when $default != null:
return $default(_that.id,_that.title,_that.examName,_that.subjectLabel,_that.versionId,_that.versionNo,_that.fullScore,_that.publishedAt,_that.schoolId,_that.schoolName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardPaper implements LeaderboardPaper {
  const _LeaderboardPaper({required this.id, this.title = '', @JsonKey(name: 'exam_name') this.examName, @JsonKey(name: 'subject_label') this.subjectLabel, @JsonKey(name: 'version_id') this.versionId, @JsonKey(name: 'version_no') this.versionNo, @JsonKey(name: 'full_score') this.fullScore = 0, @JsonKey(name: 'published_at') this.publishedAt, @JsonKey(name: 'school_id') this.schoolId, @JsonKey(name: 'school_name') this.schoolName});
  factory _LeaderboardPaper.fromJson(Map<String, dynamic> json) => _$LeaderboardPaperFromJson(json);

@override final  String id;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'exam_name') final  String? examName;
@override@JsonKey(name: 'subject_label') final  String? subjectLabel;
@override@JsonKey(name: 'version_id') final  String? versionId;
@override@JsonKey(name: 'version_no') final  int? versionNo;
@override@JsonKey(name: 'full_score') final  double fullScore;
@override@JsonKey(name: 'published_at') final  String? publishedAt;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey(name: 'school_name') final  String? schoolName;

/// Create a copy of LeaderboardPaper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardPaperCopyWith<_LeaderboardPaper> get copyWith => __$LeaderboardPaperCopyWithImpl<_LeaderboardPaper>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardPaperToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardPaper&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.subjectLabel, subjectLabel) || other.subjectLabel == subjectLabel)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,examName,subjectLabel,versionId,versionNo,fullScore,publishedAt,schoolId,schoolName);
}

@override
String toString() {
    return 'LeaderboardPaper(id: $id, title: $title, examName: $examName, subjectLabel: $subjectLabel, versionId: $versionId, versionNo: $versionNo, fullScore: $fullScore, publishedAt: $publishedAt, schoolId: $schoolId, schoolName: $schoolName)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardPaperCopyWith<$Res> implements $LeaderboardPaperCopyWith<$Res> {
  factory _$LeaderboardPaperCopyWith(_LeaderboardPaper value, $Res Function(_LeaderboardPaper) _then) = __$LeaderboardPaperCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'version_id') String? versionId,@JsonKey(name: 'version_no') int? versionNo,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'published_at') String? publishedAt,@JsonKey(name: 'school_id') String? schoolId,@JsonKey(name: 'school_name') String? schoolName
});




}
/// @nodoc
class __$LeaderboardPaperCopyWithImpl<$Res>
    implements _$LeaderboardPaperCopyWith<$Res> {
  __$LeaderboardPaperCopyWithImpl(this._self, this._then);

  final _LeaderboardPaper _self;
  final $Res Function(_LeaderboardPaper) _then;

/// Create a copy of LeaderboardPaper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? versionId = freezed,Object? versionNo = freezed,Object? fullScore = null,Object? publishedAt = freezed,Object? schoolId = freezed,Object? schoolName = freezed,}) {
  return _then(_LeaderboardPaper(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,versionId: freezed == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String?,versionNo: freezed == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int?,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,schoolName: freezed == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PaperLeaderboard {

 LeaderboardPaper get paper; LeaderboardScope get scope;/// 榜单（已按名次排序，最多 limit 条）。
 List<LeaderboardRow> get rows;/// 我附近的几名（我不在前 limit 名时，界面用它把我钉在表尾）。
 List<LeaderboardRow> get nearby;/// 我这一场。为 null = 不在榜上，原因看 viewerNote。
 LeaderboardViewer? get viewer;@JsonKey(name: 'viewer_note') String? get viewerNote; LeaderboardStats get stats; int get limit; bool get truncated;
/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaperLeaderboardCopyWith<PaperLeaderboard> get copyWith => _$PaperLeaderboardCopyWithImpl<PaperLeaderboard>(this as PaperLeaderboard, _$identity);

  /// Serializes this PaperLeaderboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaperLeaderboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaperLeaderboard&&(identical(other.paper, _this.paper) || other.paper == _this.paper)&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&const DeepCollectionEquality().equals(other.rows, _this.rows)&&const DeepCollectionEquality().equals(other.nearby, _this.nearby)&&(identical(other.viewer, _this.viewer) || other.viewer == _this.viewer)&&(identical(other.viewerNote, _this.viewerNote) || other.viewerNote == _this.viewerNote)&&(identical(other.stats, _this.stats) || other.stats == _this.stats)&&(identical(other.limit, _this.limit) || other.limit == _this.limit)&&(identical(other.truncated, _this.truncated) || other.truncated == _this.truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaperLeaderboard;
  return Object.hash(runtimeType,_this.paper,_this.scope,const DeepCollectionEquality().hash(_this.rows),const DeepCollectionEquality().hash(_this.nearby),_this.viewer,_this.viewerNote,_this.stats,_this.limit,_this.truncated);
}

@override
String toString() {
  final _this = this as PaperLeaderboard;
  return 'PaperLeaderboard(paper: ${_this.paper}, scope: ${_this.scope}, rows: ${_this.rows}, nearby: ${_this.nearby}, viewer: ${_this.viewer}, viewerNote: ${_this.viewerNote}, stats: ${_this.stats}, limit: ${_this.limit}, truncated: ${_this.truncated})';
}


}

/// @nodoc
abstract mixin class $PaperLeaderboardCopyWith<$Res>  {
  factory $PaperLeaderboardCopyWith(PaperLeaderboard value, $Res Function(PaperLeaderboard) _then) = _$PaperLeaderboardCopyWithImpl;
@useResult
$Res call({
 LeaderboardPaper paper, LeaderboardScope scope, List<LeaderboardRow> rows, List<LeaderboardRow> nearby, LeaderboardViewer? viewer,@JsonKey(name: 'viewer_note') String? viewerNote, LeaderboardStats stats, int limit, bool truncated
});


$LeaderboardPaperCopyWith<$Res> get paper;$LeaderboardScopeCopyWith<$Res> get scope;$LeaderboardViewerCopyWith<$Res>? get viewer;$LeaderboardStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$PaperLeaderboardCopyWithImpl<$Res>
    implements $PaperLeaderboardCopyWith<$Res> {
  _$PaperLeaderboardCopyWithImpl(this._self, this._then);

  final PaperLeaderboard _self;
  final $Res Function(PaperLeaderboard) _then;

/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paper = null,Object? scope = null,Object? rows = null,Object? nearby = null,Object? viewer = freezed,Object? viewerNote = freezed,Object? stats = null,Object? limit = null,Object? truncated = null,}) {
  return _then(PaperLeaderboard(
paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as LeaderboardPaper,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as LeaderboardScope,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<LeaderboardRow>,nearby: null == nearby ? _self.nearby : nearby // ignore: cast_nullable_to_non_nullable
as List<LeaderboardRow>,viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as LeaderboardViewer?,viewerNote: freezed == viewerNote ? _self.viewerNote : viewerNote // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as LeaderboardStats,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardPaperCopyWith<$Res> get paper {
  
  return $LeaderboardPaperCopyWith<$Res>(_self.paper, (value) {
    return _then(_self.copyWith(paper: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardScopeCopyWith<$Res> get scope {
  
  return $LeaderboardScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardViewerCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $LeaderboardViewerCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardStatsCopyWith<$Res> get stats {
  
  return $LeaderboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaperLeaderboard].
extension PaperLeaderboardPatterns on PaperLeaderboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaperLeaderboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaperLeaderboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaperLeaderboard value)  $default,){
final _that = this;
switch (_that) {
case _PaperLeaderboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaperLeaderboard value)?  $default,){
final _that = this;
switch (_that) {
case _PaperLeaderboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeaderboardPaper paper,  LeaderboardScope scope,  List<LeaderboardRow> rows,  List<LeaderboardRow> nearby,  LeaderboardViewer? viewer, @JsonKey(name: 'viewer_note')  String? viewerNote,  LeaderboardStats stats,  int limit,  bool truncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaperLeaderboard() when $default != null:
return $default(_that.paper,_that.scope,_that.rows,_that.nearby,_that.viewer,_that.viewerNote,_that.stats,_that.limit,_that.truncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeaderboardPaper paper,  LeaderboardScope scope,  List<LeaderboardRow> rows,  List<LeaderboardRow> nearby,  LeaderboardViewer? viewer, @JsonKey(name: 'viewer_note')  String? viewerNote,  LeaderboardStats stats,  int limit,  bool truncated)  $default,) {final _that = this;
switch (_that) {
case _PaperLeaderboard():
return $default(_that.paper,_that.scope,_that.rows,_that.nearby,_that.viewer,_that.viewerNote,_that.stats,_that.limit,_that.truncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeaderboardPaper paper,  LeaderboardScope scope,  List<LeaderboardRow> rows,  List<LeaderboardRow> nearby,  LeaderboardViewer? viewer, @JsonKey(name: 'viewer_note')  String? viewerNote,  LeaderboardStats stats,  int limit,  bool truncated)?  $default,) {final _that = this;
switch (_that) {
case _PaperLeaderboard() when $default != null:
return $default(_that.paper,_that.scope,_that.rows,_that.nearby,_that.viewer,_that.viewerNote,_that.stats,_that.limit,_that.truncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaperLeaderboard implements PaperLeaderboard {
  const _PaperLeaderboard({required this.paper, required this.scope,  List<LeaderboardRow> rows = const <LeaderboardRow>[],  List<LeaderboardRow> nearby = const <LeaderboardRow>[], this.viewer, @JsonKey(name: 'viewer_note') this.viewerNote, required this.stats, this.limit = 200, this.truncated = false}): _rows = rows,_nearby = nearby;
  factory _PaperLeaderboard.fromJson(Map<String, dynamic> json) => _$PaperLeaderboardFromJson(json);

@override final  LeaderboardPaper paper;
@override final  LeaderboardScope scope;
/// 榜单（已按名次排序，最多 limit 条）。
 final  List<LeaderboardRow> _rows;
/// 榜单（已按名次排序，最多 limit 条）。
@override@JsonKey() List<LeaderboardRow> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}

/// 我附近的几名（我不在前 limit 名时，界面用它把我钉在表尾）。
 final  List<LeaderboardRow> _nearby;
/// 我附近的几名（我不在前 limit 名时，界面用它把我钉在表尾）。
@override@JsonKey() List<LeaderboardRow> get nearby {
  if (_nearby is EqualUnmodifiableListView) return _nearby;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nearby);
}

/// 我这一场。为 null = 不在榜上，原因看 viewerNote。
@override final  LeaderboardViewer? viewer;
@override@JsonKey(name: 'viewer_note') final  String? viewerNote;
@override final  LeaderboardStats stats;
@override@JsonKey() final  int limit;
@override@JsonKey() final  bool truncated;

/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaperLeaderboardCopyWith<_PaperLeaderboard> get copyWith => __$PaperLeaderboardCopyWithImpl<_PaperLeaderboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaperLeaderboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaperLeaderboard&&(identical(other.paper, paper) || other.paper == paper)&&(identical(other.scope, scope) || other.scope == scope)&&const DeepCollectionEquality().equals(other.rows, _rows)&&const DeepCollectionEquality().equals(other.nearby, _nearby)&&(identical(other.viewer, viewer) || other.viewer == viewer)&&(identical(other.viewerNote, viewerNote) || other.viewerNote == viewerNote)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.truncated, truncated) || other.truncated == truncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,paper,scope,const DeepCollectionEquality().hash(_rows),const DeepCollectionEquality().hash(_nearby),viewer,viewerNote,stats,limit,truncated);
}

@override
String toString() {
    return 'PaperLeaderboard(paper: $paper, scope: $scope, rows: $rows, nearby: $nearby, viewer: $viewer, viewerNote: $viewerNote, stats: $stats, limit: $limit, truncated: $truncated)';
}


}

/// @nodoc
abstract mixin class _$PaperLeaderboardCopyWith<$Res> implements $PaperLeaderboardCopyWith<$Res> {
  factory _$PaperLeaderboardCopyWith(_PaperLeaderboard value, $Res Function(_PaperLeaderboard) _then) = __$PaperLeaderboardCopyWithImpl;
@override @useResult
$Res call({
 LeaderboardPaper paper, LeaderboardScope scope, List<LeaderboardRow> rows, List<LeaderboardRow> nearby, LeaderboardViewer? viewer,@JsonKey(name: 'viewer_note') String? viewerNote, LeaderboardStats stats, int limit, bool truncated
});


@override $LeaderboardPaperCopyWith<$Res> get paper;@override $LeaderboardScopeCopyWith<$Res> get scope;@override $LeaderboardViewerCopyWith<$Res>? get viewer;@override $LeaderboardStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$PaperLeaderboardCopyWithImpl<$Res>
    implements _$PaperLeaderboardCopyWith<$Res> {
  __$PaperLeaderboardCopyWithImpl(this._self, this._then);

  final _PaperLeaderboard _self;
  final $Res Function(_PaperLeaderboard) _then;

/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paper = null,Object? scope = null,Object? rows = null,Object? nearby = null,Object? viewer = freezed,Object? viewerNote = freezed,Object? stats = null,Object? limit = null,Object? truncated = null,}) {
  return _then(_PaperLeaderboard(
paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as LeaderboardPaper,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as LeaderboardScope,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<LeaderboardRow>,nearby: null == nearby ? _self._nearby : nearby // ignore: cast_nullable_to_non_nullable
as List<LeaderboardRow>,viewer: freezed == viewer ? _self.viewer : viewer // ignore: cast_nullable_to_non_nullable
as LeaderboardViewer?,viewerNote: freezed == viewerNote ? _self.viewerNote : viewerNote // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as LeaderboardStats,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,truncated: null == truncated ? _self.truncated : truncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardPaperCopyWith<$Res> get paper {
  
  return $LeaderboardPaperCopyWith<$Res>(_self.paper, (value) {
    return _then(_self.copyWith(paper: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardScopeCopyWith<$Res> get scope {
  
  return $LeaderboardScopeCopyWith<$Res>(_self.scope, (value) {
    return _then(_self.copyWith(scope: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardViewerCopyWith<$Res>? get viewer {
    if (_self.viewer == null) {
    return null;
  }

  return $LeaderboardViewerCopyWith<$Res>(_self.viewer!, (value) {
    return _then(_self.copyWith(viewer: value));
  });
}/// Create a copy of PaperLeaderboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LeaderboardStatsCopyWith<$Res> get stats {
  
  return $LeaderboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
