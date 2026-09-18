// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionReport {

 String get id; String get status; String get category; String get content;/// 作者处理时写的说明。**学生会看到这句话** —— 这是本功能的全部意义所在。
/// 未处理时为 null。
@JsonKey(name: 'resolve_note') String? get resolveNote;@JsonKey(name: 'resolved_at') DateTime? get resolvedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of QuestionReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionReportCopyWith<QuestionReport> get copyWith => _$QuestionReportCopyWithImpl<QuestionReport>(this as QuestionReport, _$identity);

  /// Serializes this QuestionReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionReport&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.resolveNote, _this.resolveNote) || other.resolveNote == _this.resolveNote)&&(identical(other.resolvedAt, _this.resolvedAt) || other.resolvedAt == _this.resolvedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionReport;
  return Object.hash(runtimeType,_this.id,_this.status,_this.category,_this.content,_this.resolveNote,_this.resolvedAt,_this.createdAt);
}

@override
String toString() {
  final _this = this as QuestionReport;
  return 'QuestionReport(id: ${_this.id}, status: ${_this.status}, category: ${_this.category}, content: ${_this.content}, resolveNote: ${_this.resolveNote}, resolvedAt: ${_this.resolvedAt}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $QuestionReportCopyWith<$Res>  {
  factory $QuestionReportCopyWith(QuestionReport value, $Res Function(QuestionReport) _then) = _$QuestionReportCopyWithImpl;
@useResult
$Res call({
 String id, String status, String category, String content,@JsonKey(name: 'resolve_note') String? resolveNote,@JsonKey(name: 'resolved_at') DateTime? resolvedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$QuestionReportCopyWithImpl<$Res>
    implements $QuestionReportCopyWith<$Res> {
  _$QuestionReportCopyWithImpl(this._self, this._then);

  final QuestionReport _self;
  final $Res Function(QuestionReport) _then;

/// Create a copy of QuestionReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? category = null,Object? content = null,Object? resolveNote = freezed,Object? resolvedAt = freezed,Object? createdAt = freezed,}) {
  return _then(QuestionReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,resolveNote: freezed == resolveNote ? _self.resolveNote : resolveNote // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionReport].
extension QuestionReportPatterns on QuestionReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionReport value)  $default,){
final _that = this;
switch (_that) {
case _QuestionReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionReport value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String category,  String content, @JsonKey(name: 'resolve_note')  String? resolveNote, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionReport() when $default != null:
return $default(_that.id,_that.status,_that.category,_that.content,_that.resolveNote,_that.resolvedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String category,  String content, @JsonKey(name: 'resolve_note')  String? resolveNote, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuestionReport():
return $default(_that.id,_that.status,_that.category,_that.content,_that.resolveNote,_that.resolvedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String category,  String content, @JsonKey(name: 'resolve_note')  String? resolveNote, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuestionReport() when $default != null:
return $default(_that.id,_that.status,_that.category,_that.content,_that.resolveNote,_that.resolvedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionReport implements QuestionReport {
  const _QuestionReport({required this.id, this.status = 'open', this.category = 'other', this.content = '', @JsonKey(name: 'resolve_note') this.resolveNote, @JsonKey(name: 'resolved_at') this.resolvedAt, @JsonKey(name: 'created_at') this.createdAt});
  factory _QuestionReport.fromJson(Map<String, dynamic> json) => _$QuestionReportFromJson(json);

@override final  String id;
@override@JsonKey() final  String status;
@override@JsonKey() final  String category;
@override@JsonKey() final  String content;
/// 作者处理时写的说明。**学生会看到这句话** —— 这是本功能的全部意义所在。
/// 未处理时为 null。
@override@JsonKey(name: 'resolve_note') final  String? resolveNote;
@override@JsonKey(name: 'resolved_at') final  DateTime? resolvedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of QuestionReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionReportCopyWith<_QuestionReport> get copyWith => __$QuestionReportCopyWithImpl<_QuestionReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionReport&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.content, content) || other.content == content)&&(identical(other.resolveNote, resolveNote) || other.resolveNote == resolveNote)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,category,content,resolveNote,resolvedAt,createdAt);
}

@override
String toString() {
    return 'QuestionReport(id: $id, status: $status, category: $category, content: $content, resolveNote: $resolveNote, resolvedAt: $resolvedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuestionReportCopyWith<$Res> implements $QuestionReportCopyWith<$Res> {
  factory _$QuestionReportCopyWith(_QuestionReport value, $Res Function(_QuestionReport) _then) = __$QuestionReportCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String category, String content,@JsonKey(name: 'resolve_note') String? resolveNote,@JsonKey(name: 'resolved_at') DateTime? resolvedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$QuestionReportCopyWithImpl<$Res>
    implements _$QuestionReportCopyWith<$Res> {
  __$QuestionReportCopyWithImpl(this._self, this._then);

  final _QuestionReport _self;
  final $Res Function(_QuestionReport) _then;

/// Create a copy of QuestionReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? category = null,Object? content = null,Object? resolveNote = freezed,Object? resolvedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_QuestionReport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,resolveNote: freezed == resolveNote ? _self.resolveNote : resolveNote // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
