// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_records.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamAttemptRecord {

@JsonKey(name: 'attempt_id') String get attemptId;@JsonKey(name: 'paper_id') String get paperId;@JsonKey(name: 'paper_version_id') String get paperVersionId;/// 标题取自**这场考试当时用的那一版**，不是试卷的当前版。
 String get title;@JsonKey(name: 'exam_name') String? get examName;@JsonKey(name: 'subject_label') String? get subjectLabel; String get status;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'deadline_at') DateTime? get deadlineAt;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'graded_at') DateTime? get gradedAt;@JsonKey(name: 'total_score') double get totalScore;@JsonKey(name: 'full_score') double get fullScore;@JsonKey(name: 'objective_score') double get objectiveScore;@JsonKey(name: 'subjective_score') double get subjectiveScore;@JsonKey(name: 'pending_review_count') int get pendingReviewCount;@JsonKey(name: 'duration_ms') int get durationMs;@JsonKey(name: 'item_count') int get itemCount;/// 是否本人对这一版卷面的第一次交卷（0076）。**只有它为 true 才进排行榜**，
/// 重做的那几场是自主练习——列表上要标出来，否则学生会以为重做把成绩覆盖了。
@JsonKey(name: 'is_official') bool get isOfficial;
/// Create a copy of ExamAttemptRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamAttemptRecordCopyWith<ExamAttemptRecord> get copyWith => _$ExamAttemptRecordCopyWithImpl<ExamAttemptRecord>(this as ExamAttemptRecord, _$identity);

  /// Serializes this ExamAttemptRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamAttemptRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamAttemptRecord&&(identical(other.attemptId, _this.attemptId) || other.attemptId == _this.attemptId)&&(identical(other.paperId, _this.paperId) || other.paperId == _this.paperId)&&(identical(other.paperVersionId, _this.paperVersionId) || other.paperVersionId == _this.paperVersionId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.examName, _this.examName) || other.examName == _this.examName)&&(identical(other.subjectLabel, _this.subjectLabel) || other.subjectLabel == _this.subjectLabel)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.deadlineAt, _this.deadlineAt) || other.deadlineAt == _this.deadlineAt)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.gradedAt, _this.gradedAt) || other.gradedAt == _this.gradedAt)&&(identical(other.totalScore, _this.totalScore) || other.totalScore == _this.totalScore)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.objectiveScore, _this.objectiveScore) || other.objectiveScore == _this.objectiveScore)&&(identical(other.subjectiveScore, _this.subjectiveScore) || other.subjectiveScore == _this.subjectiveScore)&&(identical(other.pendingReviewCount, _this.pendingReviewCount) || other.pendingReviewCount == _this.pendingReviewCount)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.itemCount, _this.itemCount) || other.itemCount == _this.itemCount)&&(identical(other.isOfficial, _this.isOfficial) || other.isOfficial == _this.isOfficial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamAttemptRecord;
  return Object.hashAll([runtimeType,_this.attemptId,_this.paperId,_this.paperVersionId,_this.title,_this.examName,_this.subjectLabel,_this.status,_this.startedAt,_this.deadlineAt,_this.submittedAt,_this.gradedAt,_this.totalScore,_this.fullScore,_this.objectiveScore,_this.subjectiveScore,_this.pendingReviewCount,_this.durationMs,_this.itemCount,_this.isOfficial]);
}

@override
String toString() {
  final _this = this as ExamAttemptRecord;
  return 'ExamAttemptRecord(attemptId: ${_this.attemptId}, paperId: ${_this.paperId}, paperVersionId: ${_this.paperVersionId}, title: ${_this.title}, examName: ${_this.examName}, subjectLabel: ${_this.subjectLabel}, status: ${_this.status}, startedAt: ${_this.startedAt}, deadlineAt: ${_this.deadlineAt}, submittedAt: ${_this.submittedAt}, gradedAt: ${_this.gradedAt}, totalScore: ${_this.totalScore}, fullScore: ${_this.fullScore}, objectiveScore: ${_this.objectiveScore}, subjectiveScore: ${_this.subjectiveScore}, pendingReviewCount: ${_this.pendingReviewCount}, durationMs: ${_this.durationMs}, itemCount: ${_this.itemCount}, isOfficial: ${_this.isOfficial})';
}


}

/// @nodoc
abstract mixin class $ExamAttemptRecordCopyWith<$Res>  {
  factory $ExamAttemptRecordCopyWith(ExamAttemptRecord value, $Res Function(ExamAttemptRecord) _then) = _$ExamAttemptRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'attempt_id') String attemptId,@JsonKey(name: 'paper_id') String paperId,@JsonKey(name: 'paper_version_id') String paperVersionId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'deadline_at') DateTime? deadlineAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'graded_at') DateTime? gradedAt,@JsonKey(name: 'total_score') double totalScore,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'subjective_score') double subjectiveScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'is_official') bool isOfficial
});




}
/// @nodoc
class _$ExamAttemptRecordCopyWithImpl<$Res>
    implements $ExamAttemptRecordCopyWith<$Res> {
  _$ExamAttemptRecordCopyWithImpl(this._self, this._then);

  final ExamAttemptRecord _self;
  final $Res Function(ExamAttemptRecord) _then;

/// Create a copy of ExamAttemptRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? paperId = null,Object? paperVersionId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? status = null,Object? startedAt = freezed,Object? deadlineAt = freezed,Object? submittedAt = freezed,Object? gradedAt = freezed,Object? totalScore = null,Object? fullScore = null,Object? objectiveScore = null,Object? subjectiveScore = null,Object? pendingReviewCount = null,Object? durationMs = null,Object? itemCount = null,Object? isOfficial = null,}) {
  return _then(ExamAttemptRecord(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,paperVersionId: null == paperVersionId ? _self.paperVersionId : paperVersionId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gradedAt: freezed == gradedAt ? _self.gradedAt : gradedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,subjectiveScore: null == subjectiveScore ? _self.subjectiveScore : subjectiveScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamAttemptRecord].
extension ExamAttemptRecordPatterns on ExamAttemptRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamAttemptRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamAttemptRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamAttemptRecord value)  $default,){
final _that = this;
switch (_that) {
case _ExamAttemptRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamAttemptRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ExamAttemptRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'attempt_id')  String attemptId, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'is_official')  bool isOfficial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamAttemptRecord() when $default != null:
return $default(_that.attemptId,_that.paperId,_that.paperVersionId,_that.title,_that.examName,_that.subjectLabel,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.totalScore,_that.fullScore,_that.objectiveScore,_that.subjectiveScore,_that.pendingReviewCount,_that.durationMs,_that.itemCount,_that.isOfficial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'attempt_id')  String attemptId, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'is_official')  bool isOfficial)  $default,) {final _that = this;
switch (_that) {
case _ExamAttemptRecord():
return $default(_that.attemptId,_that.paperId,_that.paperVersionId,_that.title,_that.examName,_that.subjectLabel,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.totalScore,_that.fullScore,_that.objectiveScore,_that.subjectiveScore,_that.pendingReviewCount,_that.durationMs,_that.itemCount,_that.isOfficial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'attempt_id')  String attemptId, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'is_official')  bool isOfficial)?  $default,) {final _that = this;
switch (_that) {
case _ExamAttemptRecord() when $default != null:
return $default(_that.attemptId,_that.paperId,_that.paperVersionId,_that.title,_that.examName,_that.subjectLabel,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.totalScore,_that.fullScore,_that.objectiveScore,_that.subjectiveScore,_that.pendingReviewCount,_that.durationMs,_that.itemCount,_that.isOfficial);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamAttemptRecord implements ExamAttemptRecord {
  const _ExamAttemptRecord({@JsonKey(name: 'attempt_id') required this.attemptId, @JsonKey(name: 'paper_id') required this.paperId, @JsonKey(name: 'paper_version_id') required this.paperVersionId, this.title = '', @JsonKey(name: 'exam_name') this.examName, @JsonKey(name: 'subject_label') this.subjectLabel, this.status = 'in_progress', @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'deadline_at') this.deadlineAt, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'graded_at') this.gradedAt, @JsonKey(name: 'total_score') this.totalScore = 0, @JsonKey(name: 'full_score') this.fullScore = 0, @JsonKey(name: 'objective_score') this.objectiveScore = 0, @JsonKey(name: 'subjective_score') this.subjectiveScore = 0, @JsonKey(name: 'pending_review_count') this.pendingReviewCount = 0, @JsonKey(name: 'duration_ms') this.durationMs = 0, @JsonKey(name: 'item_count') this.itemCount = 0, @JsonKey(name: 'is_official') this.isOfficial = false});
  factory _ExamAttemptRecord.fromJson(Map<String, dynamic> json) => _$ExamAttemptRecordFromJson(json);

@override@JsonKey(name: 'attempt_id') final  String attemptId;
@override@JsonKey(name: 'paper_id') final  String paperId;
@override@JsonKey(name: 'paper_version_id') final  String paperVersionId;
/// 标题取自**这场考试当时用的那一版**，不是试卷的当前版。
@override@JsonKey() final  String title;
@override@JsonKey(name: 'exam_name') final  String? examName;
@override@JsonKey(name: 'subject_label') final  String? subjectLabel;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'deadline_at') final  DateTime? deadlineAt;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'graded_at') final  DateTime? gradedAt;
@override@JsonKey(name: 'total_score') final  double totalScore;
@override@JsonKey(name: 'full_score') final  double fullScore;
@override@JsonKey(name: 'objective_score') final  double objectiveScore;
@override@JsonKey(name: 'subjective_score') final  double subjectiveScore;
@override@JsonKey(name: 'pending_review_count') final  int pendingReviewCount;
@override@JsonKey(name: 'duration_ms') final  int durationMs;
@override@JsonKey(name: 'item_count') final  int itemCount;
/// 是否本人对这一版卷面的第一次交卷（0076）。**只有它为 true 才进排行榜**，
/// 重做的那几场是自主练习——列表上要标出来，否则学生会以为重做把成绩覆盖了。
@override@JsonKey(name: 'is_official') final  bool isOfficial;

/// Create a copy of ExamAttemptRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamAttemptRecordCopyWith<_ExamAttemptRecord> get copyWith => __$ExamAttemptRecordCopyWithImpl<_ExamAttemptRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamAttemptRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamAttemptRecord&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.paperId, paperId) || other.paperId == paperId)&&(identical(other.paperVersionId, paperVersionId) || other.paperVersionId == paperVersionId)&&(identical(other.title, title) || other.title == title)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.subjectLabel, subjectLabel) || other.subjectLabel == subjectLabel)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.gradedAt, gradedAt) || other.gradedAt == gradedAt)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.objectiveScore, objectiveScore) || other.objectiveScore == objectiveScore)&&(identical(other.subjectiveScore, subjectiveScore) || other.subjectiveScore == subjectiveScore)&&(identical(other.pendingReviewCount, pendingReviewCount) || other.pendingReviewCount == pendingReviewCount)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,attemptId,paperId,paperVersionId,title,examName,subjectLabel,status,startedAt,deadlineAt,submittedAt,gradedAt,totalScore,fullScore,objectiveScore,subjectiveScore,pendingReviewCount,durationMs,itemCount,isOfficial]);
}

@override
String toString() {
    return 'ExamAttemptRecord(attemptId: $attemptId, paperId: $paperId, paperVersionId: $paperVersionId, title: $title, examName: $examName, subjectLabel: $subjectLabel, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt, submittedAt: $submittedAt, gradedAt: $gradedAt, totalScore: $totalScore, fullScore: $fullScore, objectiveScore: $objectiveScore, subjectiveScore: $subjectiveScore, pendingReviewCount: $pendingReviewCount, durationMs: $durationMs, itemCount: $itemCount, isOfficial: $isOfficial)';
}


}

/// @nodoc
abstract mixin class _$ExamAttemptRecordCopyWith<$Res> implements $ExamAttemptRecordCopyWith<$Res> {
  factory _$ExamAttemptRecordCopyWith(_ExamAttemptRecord value, $Res Function(_ExamAttemptRecord) _then) = __$ExamAttemptRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'attempt_id') String attemptId,@JsonKey(name: 'paper_id') String paperId,@JsonKey(name: 'paper_version_id') String paperVersionId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'deadline_at') DateTime? deadlineAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'graded_at') DateTime? gradedAt,@JsonKey(name: 'total_score') double totalScore,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'subjective_score') double subjectiveScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount,@JsonKey(name: 'duration_ms') int durationMs,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'is_official') bool isOfficial
});




}
/// @nodoc
class __$ExamAttemptRecordCopyWithImpl<$Res>
    implements _$ExamAttemptRecordCopyWith<$Res> {
  __$ExamAttemptRecordCopyWithImpl(this._self, this._then);

  final _ExamAttemptRecord _self;
  final $Res Function(_ExamAttemptRecord) _then;

/// Create a copy of ExamAttemptRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? paperId = null,Object? paperVersionId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? status = null,Object? startedAt = freezed,Object? deadlineAt = freezed,Object? submittedAt = freezed,Object? gradedAt = freezed,Object? totalScore = null,Object? fullScore = null,Object? objectiveScore = null,Object? subjectiveScore = null,Object? pendingReviewCount = null,Object? durationMs = null,Object? itemCount = null,Object? isOfficial = null,}) {
  return _then(_ExamAttemptRecord(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,paperVersionId: null == paperVersionId ? _self.paperVersionId : paperVersionId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gradedAt: freezed == gradedAt ? _self.gradedAt : gradedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,subjectiveScore: null == subjectiveScore ? _self.subjectiveScore : subjectiveScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ExamSubmitSummary {

/// 本次自动判分得到的分数（主观题还没判，所以不等于最终成绩）。
 double get total;@JsonKey(name: 'full_score') double get fullScore;@JsonKey(name: 'objective_score') double get objectiveScore;@JsonKey(name: 'pending_review_count') int get pendingReviewCount;
/// Create a copy of ExamSubmitSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSubmitSummaryCopyWith<ExamSubmitSummary> get copyWith => _$ExamSubmitSummaryCopyWithImpl<ExamSubmitSummary>(this as ExamSubmitSummary, _$identity);

  /// Serializes this ExamSubmitSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamSubmitSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSubmitSummary&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.objectiveScore, _this.objectiveScore) || other.objectiveScore == _this.objectiveScore)&&(identical(other.pendingReviewCount, _this.pendingReviewCount) || other.pendingReviewCount == _this.pendingReviewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamSubmitSummary;
  return Object.hash(runtimeType,_this.total,_this.fullScore,_this.objectiveScore,_this.pendingReviewCount);
}

@override
String toString() {
  final _this = this as ExamSubmitSummary;
  return 'ExamSubmitSummary(total: ${_this.total}, fullScore: ${_this.fullScore}, objectiveScore: ${_this.objectiveScore}, pendingReviewCount: ${_this.pendingReviewCount})';
}


}

/// @nodoc
abstract mixin class $ExamSubmitSummaryCopyWith<$Res>  {
  factory $ExamSubmitSummaryCopyWith(ExamSubmitSummary value, $Res Function(ExamSubmitSummary) _then) = _$ExamSubmitSummaryCopyWithImpl;
@useResult
$Res call({
 double total,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount
});




}
/// @nodoc
class _$ExamSubmitSummaryCopyWithImpl<$Res>
    implements $ExamSubmitSummaryCopyWith<$Res> {
  _$ExamSubmitSummaryCopyWithImpl(this._self, this._then);

  final ExamSubmitSummary _self;
  final $Res Function(ExamSubmitSummary) _then;

/// Create a copy of ExamSubmitSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? fullScore = null,Object? objectiveScore = null,Object? pendingReviewCount = null,}) {
  return _then(ExamSubmitSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSubmitSummary].
extension ExamSubmitSummaryPatterns on ExamSubmitSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSubmitSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSubmitSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSubmitSummary value)  $default,){
final _that = this;
switch (_that) {
case _ExamSubmitSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSubmitSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSubmitSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double total, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSubmitSummary() when $default != null:
return $default(_that.total,_that.fullScore,_that.objectiveScore,_that.pendingReviewCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double total, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount)  $default,) {final _that = this;
switch (_that) {
case _ExamSubmitSummary():
return $default(_that.total,_that.fullScore,_that.objectiveScore,_that.pendingReviewCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double total, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount)?  $default,) {final _that = this;
switch (_that) {
case _ExamSubmitSummary() when $default != null:
return $default(_that.total,_that.fullScore,_that.objectiveScore,_that.pendingReviewCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSubmitSummary implements ExamSubmitSummary {
  const _ExamSubmitSummary({this.total = 0, @JsonKey(name: 'full_score') this.fullScore = 0, @JsonKey(name: 'objective_score') this.objectiveScore = 0, @JsonKey(name: 'pending_review_count') this.pendingReviewCount = 0});
  factory _ExamSubmitSummary.fromJson(Map<String, dynamic> json) => _$ExamSubmitSummaryFromJson(json);

/// 本次自动判分得到的分数（主观题还没判，所以不等于最终成绩）。
@override@JsonKey() final  double total;
@override@JsonKey(name: 'full_score') final  double fullScore;
@override@JsonKey(name: 'objective_score') final  double objectiveScore;
@override@JsonKey(name: 'pending_review_count') final  int pendingReviewCount;

/// Create a copy of ExamSubmitSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSubmitSummaryCopyWith<_ExamSubmitSummary> get copyWith => __$ExamSubmitSummaryCopyWithImpl<_ExamSubmitSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSubmitSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSubmitSummary&&(identical(other.total, total) || other.total == total)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.objectiveScore, objectiveScore) || other.objectiveScore == objectiveScore)&&(identical(other.pendingReviewCount, pendingReviewCount) || other.pendingReviewCount == pendingReviewCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,fullScore,objectiveScore,pendingReviewCount);
}

@override
String toString() {
    return 'ExamSubmitSummary(total: $total, fullScore: $fullScore, objectiveScore: $objectiveScore, pendingReviewCount: $pendingReviewCount)';
}


}

/// @nodoc
abstract mixin class _$ExamSubmitSummaryCopyWith<$Res> implements $ExamSubmitSummaryCopyWith<$Res> {
  factory _$ExamSubmitSummaryCopyWith(_ExamSubmitSummary value, $Res Function(_ExamSubmitSummary) _then) = __$ExamSubmitSummaryCopyWithImpl;
@override @useResult
$Res call({
 double total,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount
});




}
/// @nodoc
class __$ExamSubmitSummaryCopyWithImpl<$Res>
    implements _$ExamSubmitSummaryCopyWith<$Res> {
  __$ExamSubmitSummaryCopyWithImpl(this._self, this._then);

  final _ExamSubmitSummary _self;
  final $Res Function(_ExamSubmitSummary) _then;

/// Create a copy of ExamSubmitSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? fullScore = null,Object? objectiveScore = null,Object? pendingReviewCount = null,}) {
  return _then(_ExamSubmitSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
