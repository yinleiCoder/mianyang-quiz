// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_brief.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionBrief {

/// 内嵌的 questions 行——PostgREST 把它嵌在 question 键下，由仓储层摊平后传入。
@JsonKey(name: 'question_id') String get questionId;@JsonKey(name: 'version_id') String get versionId; String get qtype; int? get difficulty;@JsonKey(name: 'course_node_id') String? get courseNodeId;@JsonKey(name: 'school_id') String? get schoolId; String get stemText;@JsonKey(name: 'version_no') int? get versionNo;@JsonKey(name: 'published_at') DateTime? get publishedAt; List<String> get tags;@JsonKey(name: 'node_path') String get nodePath;@JsonKey(name: 'school_name') String get schoolName;/// 题目当前是否可用（已下线/已删除的题在错题本与收藏里是占位行）。
 bool get available;
/// Create a copy of QuestionBrief
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionBriefCopyWith<QuestionBrief> get copyWith => _$QuestionBriefCopyWithImpl<QuestionBrief>(this as QuestionBrief, _$identity);

  /// Serializes this QuestionBrief to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionBrief;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionBrief&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.courseNodeId, _this.courseNodeId) || other.courseNodeId == _this.courseNodeId)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.stemText, _this.stemText) || other.stemText == _this.stemText)&&(identical(other.versionNo, _this.versionNo) || other.versionNo == _this.versionNo)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&const DeepCollectionEquality().equals(other.tags, _this.tags)&&(identical(other.nodePath, _this.nodePath) || other.nodePath == _this.nodePath)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName)&&(identical(other.available, _this.available) || other.available == _this.available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionBrief;
  return Object.hash(runtimeType,_this.questionId,_this.versionId,_this.qtype,_this.difficulty,_this.courseNodeId,_this.schoolId,_this.stemText,_this.versionNo,_this.publishedAt,const DeepCollectionEquality().hash(_this.tags),_this.nodePath,_this.schoolName,_this.available);
}

@override
String toString() {
  final _this = this as QuestionBrief;
  return 'QuestionBrief(questionId: ${_this.questionId}, versionId: ${_this.versionId}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, courseNodeId: ${_this.courseNodeId}, schoolId: ${_this.schoolId}, stemText: ${_this.stemText}, versionNo: ${_this.versionNo}, publishedAt: ${_this.publishedAt}, tags: ${_this.tags}, nodePath: ${_this.nodePath}, schoolName: ${_this.schoolName}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $QuestionBriefCopyWith<$Res>  {
  factory $QuestionBriefCopyWith(QuestionBrief value, $Res Function(QuestionBrief) _then) = _$QuestionBriefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String versionId, String qtype, int? difficulty,@JsonKey(name: 'course_node_id') String? courseNodeId,@JsonKey(name: 'school_id') String? schoolId, String stemText,@JsonKey(name: 'version_no') int? versionNo,@JsonKey(name: 'published_at') DateTime? publishedAt, List<String> tags,@JsonKey(name: 'node_path') String nodePath,@JsonKey(name: 'school_name') String schoolName, bool available
});




}
/// @nodoc
class _$QuestionBriefCopyWithImpl<$Res>
    implements $QuestionBriefCopyWith<$Res> {
  _$QuestionBriefCopyWithImpl(this._self, this._then);

  final QuestionBrief _self;
  final $Res Function(QuestionBrief) _then;

/// Create a copy of QuestionBrief
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? versionId = null,Object? qtype = null,Object? difficulty = freezed,Object? courseNodeId = freezed,Object? schoolId = freezed,Object? stemText = null,Object? versionNo = freezed,Object? publishedAt = freezed,Object? tags = null,Object? nodePath = null,Object? schoolName = null,Object? available = null,}) {
  return _then(QuestionBrief(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stemText: null == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String,versionNo: freezed == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,nodePath: null == nodePath ? _self.nodePath : nodePath // ignore: cast_nullable_to_non_nullable
as String,schoolName: null == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionBrief].
extension QuestionBriefPatterns on QuestionBrief {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionBrief value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionBrief() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionBrief value)  $default,){
final _that = this;
switch (_that) {
case _QuestionBrief():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionBrief value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionBrief() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'school_id')  String? schoolId,  String stemText, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'published_at')  DateTime? publishedAt,  List<String> tags, @JsonKey(name: 'node_path')  String nodePath, @JsonKey(name: 'school_name')  String schoolName,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionBrief() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.schoolId,_that.stemText,_that.versionNo,_that.publishedAt,_that.tags,_that.nodePath,_that.schoolName,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'school_id')  String? schoolId,  String stemText, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'published_at')  DateTime? publishedAt,  List<String> tags, @JsonKey(name: 'node_path')  String nodePath, @JsonKey(name: 'school_name')  String schoolName,  bool available)  $default,) {final _that = this;
switch (_that) {
case _QuestionBrief():
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.schoolId,_that.stemText,_that.versionNo,_that.publishedAt,_that.tags,_that.nodePath,_that.schoolName,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'question_id')  String questionId, @JsonKey(name: 'version_id')  String versionId,  String qtype,  int? difficulty, @JsonKey(name: 'course_node_id')  String? courseNodeId, @JsonKey(name: 'school_id')  String? schoolId,  String stemText, @JsonKey(name: 'version_no')  int? versionNo, @JsonKey(name: 'published_at')  DateTime? publishedAt,  List<String> tags, @JsonKey(name: 'node_path')  String nodePath, @JsonKey(name: 'school_name')  String schoolName,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _QuestionBrief() when $default != null:
return $default(_that.questionId,_that.versionId,_that.qtype,_that.difficulty,_that.courseNodeId,_that.schoolId,_that.stemText,_that.versionNo,_that.publishedAt,_that.tags,_that.nodePath,_that.schoolName,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionBrief implements QuestionBrief {
  const _QuestionBrief({@JsonKey(name: 'question_id') required this.questionId, @JsonKey(name: 'version_id') required this.versionId, required this.qtype, this.difficulty, @JsonKey(name: 'course_node_id') this.courseNodeId, @JsonKey(name: 'school_id') this.schoolId, this.stemText = '', @JsonKey(name: 'version_no') this.versionNo, @JsonKey(name: 'published_at') this.publishedAt,  List<String> tags = const <String>[], @JsonKey(name: 'node_path') this.nodePath = '', @JsonKey(name: 'school_name') this.schoolName = '', this.available = true}): _tags = tags;
  factory _QuestionBrief.fromJson(Map<String, dynamic> json) => _$QuestionBriefFromJson(json);

/// 内嵌的 questions 行——PostgREST 把它嵌在 question 键下，由仓储层摊平后传入。
@override@JsonKey(name: 'question_id') final  String questionId;
@override@JsonKey(name: 'version_id') final  String versionId;
@override final  String qtype;
@override final  int? difficulty;
@override@JsonKey(name: 'course_node_id') final  String? courseNodeId;
@override@JsonKey(name: 'school_id') final  String? schoolId;
@override@JsonKey() final  String stemText;
@override@JsonKey(name: 'version_no') final  int? versionNo;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey(name: 'node_path') final  String nodePath;
@override@JsonKey(name: 'school_name') final  String schoolName;
/// 题目当前是否可用（已下线/已删除的题在错题本与收藏里是占位行）。
@override@JsonKey() final  bool available;

/// Create a copy of QuestionBrief
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionBriefCopyWith<_QuestionBrief> get copyWith => __$QuestionBriefCopyWithImpl<_QuestionBrief>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionBriefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionBrief&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.courseNodeId, courseNodeId) || other.courseNodeId == courseNodeId)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.stemText, stemText) || other.stemText == stemText)&&(identical(other.versionNo, versionNo) || other.versionNo == versionNo)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other.tags, _tags)&&(identical(other.nodePath, nodePath) || other.nodePath == nodePath)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,versionId,qtype,difficulty,courseNodeId,schoolId,stemText,versionNo,publishedAt,const DeepCollectionEquality().hash(_tags),nodePath,schoolName,available);
}

@override
String toString() {
    return 'QuestionBrief(questionId: $questionId, versionId: $versionId, qtype: $qtype, difficulty: $difficulty, courseNodeId: $courseNodeId, schoolId: $schoolId, stemText: $stemText, versionNo: $versionNo, publishedAt: $publishedAt, tags: $tags, nodePath: $nodePath, schoolName: $schoolName, available: $available)';
}


}

/// @nodoc
abstract mixin class _$QuestionBriefCopyWith<$Res> implements $QuestionBriefCopyWith<$Res> {
  factory _$QuestionBriefCopyWith(_QuestionBrief value, $Res Function(_QuestionBrief) _then) = __$QuestionBriefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'question_id') String questionId,@JsonKey(name: 'version_id') String versionId, String qtype, int? difficulty,@JsonKey(name: 'course_node_id') String? courseNodeId,@JsonKey(name: 'school_id') String? schoolId, String stemText,@JsonKey(name: 'version_no') int? versionNo,@JsonKey(name: 'published_at') DateTime? publishedAt, List<String> tags,@JsonKey(name: 'node_path') String nodePath,@JsonKey(name: 'school_name') String schoolName, bool available
});




}
/// @nodoc
class __$QuestionBriefCopyWithImpl<$Res>
    implements _$QuestionBriefCopyWith<$Res> {
  __$QuestionBriefCopyWithImpl(this._self, this._then);

  final _QuestionBrief _self;
  final $Res Function(_QuestionBrief) _then;

/// Create a copy of QuestionBrief
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? versionId = null,Object? qtype = null,Object? difficulty = freezed,Object? courseNodeId = freezed,Object? schoolId = freezed,Object? stemText = null,Object? versionNo = freezed,Object? publishedAt = freezed,Object? tags = null,Object? nodePath = null,Object? schoolName = null,Object? available = null,}) {
  return _then(_QuestionBrief(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,courseNodeId: freezed == courseNodeId ? _self.courseNodeId : courseNodeId // ignore: cast_nullable_to_non_nullable
as String?,schoolId: freezed == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String?,stemText: null == stemText ? _self.stemText : stemText // ignore: cast_nullable_to_non_nullable
as String,versionNo: freezed == versionNo ? _self.versionNo : versionNo // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,nodePath: null == nodePath ? _self.nodePath : nodePath // ignore: cast_nullable_to_non_nullable
as String,schoolName: null == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
