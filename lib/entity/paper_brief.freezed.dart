// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paper_brief.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaperBrief {

/// 开考要传的就是它（start_exam_attempt 的 p_paper_version_id）。
@JsonKey(name: 'version_id') String get versionId;@JsonKey(name: 'paper_id') String get paperId; String get title;@JsonKey(name: 'exam_name') String? get examName;@JsonKey(name: 'subject_label') String? get subjectLabel;/// 满分与时长都是**发布时定版**的值，不是实时算的。
@JsonKey(name: 'total_score') double? get totalScore;@JsonKey(name: 'duration_minutes') int? get durationMinutes;@JsonKey(name: 'item_count') int get itemCount;@JsonKey(name: 'published_at') DateTime? get publishedAt;
/// Create a copy of PaperBrief
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaperBriefCopyWith<PaperBrief> get copyWith => _$PaperBriefCopyWithImpl<PaperBrief>(this as PaperBrief, _$identity);

  /// Serializes this PaperBrief to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaperBrief;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaperBrief&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.paperId, _this.paperId) || other.paperId == _this.paperId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.examName, _this.examName) || other.examName == _this.examName)&&(identical(other.subjectLabel, _this.subjectLabel) || other.subjectLabel == _this.subjectLabel)&&(identical(other.totalScore, _this.totalScore) || other.totalScore == _this.totalScore)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaperBrief;
  return Object.hash(runtimeType,_this.versionId,_this.paperId,_this.title,_this.examName,_this.subjectLabel,_this.totalScore,_this.durationMinutes,_this.itemCount,_this.publishedAt);
}

@override
String toString() {
  final _this = this as PaperBrief;
  return 'PaperBrief(versionId: ${_this.versionId}, paperId: ${_this.paperId}, title: ${_this.title}, examName: ${_this.examName}, subjectLabel: ${_this.subjectLabel}, totalScore: ${_this.totalScore}, durationMinutes: ${_this.durationMinutes}, itemCount: ${_this.itemCount}, publishedAt: ${_this.publishedAt})';
}


}

/// @nodoc
abstract mixin class $PaperBriefCopyWith<$Res>  {
  factory $PaperBriefCopyWith(PaperBrief value, $Res Function(PaperBrief) _then) = _$PaperBriefCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version_id') String versionId,@JsonKey(name: 'paper_id') String paperId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'total_score') double? totalScore,@JsonKey(name: 'duration_minutes') int? durationMinutes,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class _$PaperBriefCopyWithImpl<$Res>
    implements $PaperBriefCopyWith<$Res> {
  _$PaperBriefCopyWithImpl(this._self, this._then);

  final PaperBrief _self;
  final $Res Function(PaperBrief) _then;

/// Create a copy of PaperBrief
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? versionId = null,Object? paperId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? totalScore = freezed,Object? durationMinutes = freezed,Object? itemCount = null,Object? publishedAt = freezed,}) {
  return _then(PaperBrief(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,totalScore: freezed == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaperBrief].
extension PaperBriefPatterns on PaperBrief {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaperBrief value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaperBrief() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaperBrief value)  $default,){
final _that = this;
switch (_that) {
case _PaperBrief():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaperBrief value)?  $default,){
final _that = this;
switch (_that) {
case _PaperBrief() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'total_score')  double? totalScore, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaperBrief() when $default != null:
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.totalScore,_that.durationMinutes,_that.itemCount,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'total_score')  double? totalScore, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'published_at')  DateTime? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _PaperBrief():
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.totalScore,_that.durationMinutes,_that.itemCount,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'total_score')  double? totalScore, @JsonKey(name: 'duration_minutes')  int? durationMinutes, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'published_at')  DateTime? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _PaperBrief() when $default != null:
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.totalScore,_that.durationMinutes,_that.itemCount,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaperBrief implements PaperBrief {
  const _PaperBrief({@JsonKey(name: 'version_id') required this.versionId, @JsonKey(name: 'paper_id') required this.paperId, this.title = '', @JsonKey(name: 'exam_name') this.examName, @JsonKey(name: 'subject_label') this.subjectLabel, @JsonKey(name: 'total_score') this.totalScore, @JsonKey(name: 'duration_minutes') this.durationMinutes, @JsonKey(name: 'item_count') this.itemCount = 0, @JsonKey(name: 'published_at') this.publishedAt});
  factory _PaperBrief.fromJson(Map<String, dynamic> json) => _$PaperBriefFromJson(json);

/// 开考要传的就是它（start_exam_attempt 的 p_paper_version_id）。
@override@JsonKey(name: 'version_id') final  String versionId;
@override@JsonKey(name: 'paper_id') final  String paperId;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'exam_name') final  String? examName;
@override@JsonKey(name: 'subject_label') final  String? subjectLabel;
/// 满分与时长都是**发布时定版**的值，不是实时算的。
@override@JsonKey(name: 'total_score') final  double? totalScore;
@override@JsonKey(name: 'duration_minutes') final  int? durationMinutes;
@override@JsonKey(name: 'item_count') final  int itemCount;
@override@JsonKey(name: 'published_at') final  DateTime? publishedAt;

/// Create a copy of PaperBrief
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaperBriefCopyWith<_PaperBrief> get copyWith => __$PaperBriefCopyWithImpl<_PaperBrief>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaperBriefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaperBrief&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.paperId, paperId) || other.paperId == paperId)&&(identical(other.title, title) || other.title == title)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.subjectLabel, subjectLabel) || other.subjectLabel == subjectLabel)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,versionId,paperId,title,examName,subjectLabel,totalScore,durationMinutes,itemCount,publishedAt);
}

@override
String toString() {
    return 'PaperBrief(versionId: $versionId, paperId: $paperId, title: $title, examName: $examName, subjectLabel: $subjectLabel, totalScore: $totalScore, durationMinutes: $durationMinutes, itemCount: $itemCount, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$PaperBriefCopyWith<$Res> implements $PaperBriefCopyWith<$Res> {
  factory _$PaperBriefCopyWith(_PaperBrief value, $Res Function(_PaperBrief) _then) = __$PaperBriefCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version_id') String versionId,@JsonKey(name: 'paper_id') String paperId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'total_score') double? totalScore,@JsonKey(name: 'duration_minutes') int? durationMinutes,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'published_at') DateTime? publishedAt
});




}
/// @nodoc
class __$PaperBriefCopyWithImpl<$Res>
    implements _$PaperBriefCopyWith<$Res> {
  __$PaperBriefCopyWithImpl(this._self, this._then);

  final _PaperBrief _self;
  final $Res Function(_PaperBrief) _then;

/// Create a copy of PaperBrief
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? versionId = null,Object? paperId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? totalScore = freezed,Object? durationMinutes = freezed,Object? itemCount = null,Object? publishedAt = freezed,}) {
  return _then(_PaperBrief(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,totalScore: freezed == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
