// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamAttempt {

 String get id;@JsonKey(name: 'paper_id') String get paperId;@JsonKey(name: 'paper_version_id') String get paperVersionId; String get status;@JsonKey(name: 'started_at') DateTime? get startedAt;/// 截止时刻，服务端在起考时算好（now + duration_minutes）。
/// **客户端只读**：倒计时以它为准，改本机时间续不了命（也骗不了自己）。
@JsonKey(name: 'deadline_at') DateTime? get deadlineAt;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'graded_at') DateTime? get gradedAt;/// 起考时冻结的满分（含主观题）。
@JsonKey(name: 'full_score') double get fullScore;/// 其中客观题占多少分——待阅卷时学生看到的"满分"只能是这个数，
/// 拿 fullScore 当分母会显示成"得了 40/100"，看起来像考砸了。
@JsonKey(name: 'objective_full_score') double get objectiveFullScore;@JsonKey(name: 'objective_score') double get objectiveScore;@JsonKey(name: 'subjective_score') double get subjectiveScore;@JsonKey(name: 'total_score') double get totalScore;@JsonKey(name: 'pending_review_count') int get pendingReviewCount;@JsonKey(name: 'duration_ms') int get durationMs;
/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamAttemptCopyWith<ExamAttempt> get copyWith => _$ExamAttemptCopyWithImpl<ExamAttempt>(this as ExamAttempt, _$identity);

  /// Serializes this ExamAttempt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamAttempt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamAttempt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.paperId, _this.paperId) || other.paperId == _this.paperId)&&(identical(other.paperVersionId, _this.paperVersionId) || other.paperVersionId == _this.paperVersionId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.deadlineAt, _this.deadlineAt) || other.deadlineAt == _this.deadlineAt)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.gradedAt, _this.gradedAt) || other.gradedAt == _this.gradedAt)&&(identical(other.fullScore, _this.fullScore) || other.fullScore == _this.fullScore)&&(identical(other.objectiveFullScore, _this.objectiveFullScore) || other.objectiveFullScore == _this.objectiveFullScore)&&(identical(other.objectiveScore, _this.objectiveScore) || other.objectiveScore == _this.objectiveScore)&&(identical(other.subjectiveScore, _this.subjectiveScore) || other.subjectiveScore == _this.subjectiveScore)&&(identical(other.totalScore, _this.totalScore) || other.totalScore == _this.totalScore)&&(identical(other.pendingReviewCount, _this.pendingReviewCount) || other.pendingReviewCount == _this.pendingReviewCount)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamAttempt;
  return Object.hash(runtimeType,_this.id,_this.paperId,_this.paperVersionId,_this.status,_this.startedAt,_this.deadlineAt,_this.submittedAt,_this.gradedAt,_this.fullScore,_this.objectiveFullScore,_this.objectiveScore,_this.subjectiveScore,_this.totalScore,_this.pendingReviewCount,_this.durationMs);
}

@override
String toString() {
  final _this = this as ExamAttempt;
  return 'ExamAttempt(id: ${_this.id}, paperId: ${_this.paperId}, paperVersionId: ${_this.paperVersionId}, status: ${_this.status}, startedAt: ${_this.startedAt}, deadlineAt: ${_this.deadlineAt}, submittedAt: ${_this.submittedAt}, gradedAt: ${_this.gradedAt}, fullScore: ${_this.fullScore}, objectiveFullScore: ${_this.objectiveFullScore}, objectiveScore: ${_this.objectiveScore}, subjectiveScore: ${_this.subjectiveScore}, totalScore: ${_this.totalScore}, pendingReviewCount: ${_this.pendingReviewCount}, durationMs: ${_this.durationMs})';
}


}

/// @nodoc
abstract mixin class $ExamAttemptCopyWith<$Res>  {
  factory $ExamAttemptCopyWith(ExamAttempt value, $Res Function(ExamAttempt) _then) = _$ExamAttemptCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'paper_id') String paperId,@JsonKey(name: 'paper_version_id') String paperVersionId, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'deadline_at') DateTime? deadlineAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'graded_at') DateTime? gradedAt,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_full_score') double objectiveFullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'subjective_score') double subjectiveScore,@JsonKey(name: 'total_score') double totalScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount,@JsonKey(name: 'duration_ms') int durationMs
});




}
/// @nodoc
class _$ExamAttemptCopyWithImpl<$Res>
    implements $ExamAttemptCopyWith<$Res> {
  _$ExamAttemptCopyWithImpl(this._self, this._then);

  final ExamAttempt _self;
  final $Res Function(ExamAttempt) _then;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? paperId = null,Object? paperVersionId = null,Object? status = null,Object? startedAt = freezed,Object? deadlineAt = freezed,Object? submittedAt = freezed,Object? gradedAt = freezed,Object? fullScore = null,Object? objectiveFullScore = null,Object? objectiveScore = null,Object? subjectiveScore = null,Object? totalScore = null,Object? pendingReviewCount = null,Object? durationMs = null,}) {
  return _then(ExamAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,paperVersionId: null == paperVersionId ? _self.paperVersionId : paperVersionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gradedAt: freezed == gradedAt ? _self.gradedAt : gradedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveFullScore: null == objectiveFullScore ? _self.objectiveFullScore : objectiveFullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,subjectiveScore: null == subjectiveScore ? _self.subjectiveScore : subjectiveScore // ignore: cast_nullable_to_non_nullable
as double,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamAttempt].
extension ExamAttemptPatterns on ExamAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamAttempt value)  $default,){
final _that = this;
switch (_that) {
case _ExamAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_full_score')  double objectiveFullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
return $default(_that.id,_that.paperId,_that.paperVersionId,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.fullScore,_that.objectiveFullScore,_that.objectiveScore,_that.subjectiveScore,_that.totalScore,_that.pendingReviewCount,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_full_score')  double objectiveFullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _ExamAttempt():
return $default(_that.id,_that.paperId,_that.paperVersionId,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.fullScore,_that.objectiveFullScore,_that.objectiveScore,_that.subjectiveScore,_that.totalScore,_that.pendingReviewCount,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'paper_id')  String paperId, @JsonKey(name: 'paper_version_id')  String paperVersionId,  String status, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'deadline_at')  DateTime? deadlineAt, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'graded_at')  DateTime? gradedAt, @JsonKey(name: 'full_score')  double fullScore, @JsonKey(name: 'objective_full_score')  double objectiveFullScore, @JsonKey(name: 'objective_score')  double objectiveScore, @JsonKey(name: 'subjective_score')  double subjectiveScore, @JsonKey(name: 'total_score')  double totalScore, @JsonKey(name: 'pending_review_count')  int pendingReviewCount, @JsonKey(name: 'duration_ms')  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
return $default(_that.id,_that.paperId,_that.paperVersionId,_that.status,_that.startedAt,_that.deadlineAt,_that.submittedAt,_that.gradedAt,_that.fullScore,_that.objectiveFullScore,_that.objectiveScore,_that.subjectiveScore,_that.totalScore,_that.pendingReviewCount,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamAttempt implements ExamAttempt {
  const _ExamAttempt({required this.id, @JsonKey(name: 'paper_id') required this.paperId, @JsonKey(name: 'paper_version_id') required this.paperVersionId, this.status = 'in_progress', @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'deadline_at') this.deadlineAt, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'graded_at') this.gradedAt, @JsonKey(name: 'full_score') this.fullScore = 0, @JsonKey(name: 'objective_full_score') this.objectiveFullScore = 0, @JsonKey(name: 'objective_score') this.objectiveScore = 0, @JsonKey(name: 'subjective_score') this.subjectiveScore = 0, @JsonKey(name: 'total_score') this.totalScore = 0, @JsonKey(name: 'pending_review_count') this.pendingReviewCount = 0, @JsonKey(name: 'duration_ms') this.durationMs = 0});
  factory _ExamAttempt.fromJson(Map<String, dynamic> json) => _$ExamAttemptFromJson(json);

@override final  String id;
@override@JsonKey(name: 'paper_id') final  String paperId;
@override@JsonKey(name: 'paper_version_id') final  String paperVersionId;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
/// 截止时刻，服务端在起考时算好（now + duration_minutes）。
/// **客户端只读**：倒计时以它为准，改本机时间续不了命（也骗不了自己）。
@override@JsonKey(name: 'deadline_at') final  DateTime? deadlineAt;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'graded_at') final  DateTime? gradedAt;
/// 起考时冻结的满分（含主观题）。
@override@JsonKey(name: 'full_score') final  double fullScore;
/// 其中客观题占多少分——待阅卷时学生看到的"满分"只能是这个数，
/// 拿 fullScore 当分母会显示成"得了 40/100"，看起来像考砸了。
@override@JsonKey(name: 'objective_full_score') final  double objectiveFullScore;
@override@JsonKey(name: 'objective_score') final  double objectiveScore;
@override@JsonKey(name: 'subjective_score') final  double subjectiveScore;
@override@JsonKey(name: 'total_score') final  double totalScore;
@override@JsonKey(name: 'pending_review_count') final  int pendingReviewCount;
@override@JsonKey(name: 'duration_ms') final  int durationMs;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamAttemptCopyWith<_ExamAttempt> get copyWith => __$ExamAttemptCopyWithImpl<_ExamAttempt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamAttemptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.paperId, paperId) || other.paperId == paperId)&&(identical(other.paperVersionId, paperVersionId) || other.paperVersionId == paperVersionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.gradedAt, gradedAt) || other.gradedAt == gradedAt)&&(identical(other.fullScore, fullScore) || other.fullScore == fullScore)&&(identical(other.objectiveFullScore, objectiveFullScore) || other.objectiveFullScore == objectiveFullScore)&&(identical(other.objectiveScore, objectiveScore) || other.objectiveScore == objectiveScore)&&(identical(other.subjectiveScore, subjectiveScore) || other.subjectiveScore == subjectiveScore)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.pendingReviewCount, pendingReviewCount) || other.pendingReviewCount == pendingReviewCount)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,paperId,paperVersionId,status,startedAt,deadlineAt,submittedAt,gradedAt,fullScore,objectiveFullScore,objectiveScore,subjectiveScore,totalScore,pendingReviewCount,durationMs);
}

@override
String toString() {
    return 'ExamAttempt(id: $id, paperId: $paperId, paperVersionId: $paperVersionId, status: $status, startedAt: $startedAt, deadlineAt: $deadlineAt, submittedAt: $submittedAt, gradedAt: $gradedAt, fullScore: $fullScore, objectiveFullScore: $objectiveFullScore, objectiveScore: $objectiveScore, subjectiveScore: $subjectiveScore, totalScore: $totalScore, pendingReviewCount: $pendingReviewCount, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$ExamAttemptCopyWith<$Res> implements $ExamAttemptCopyWith<$Res> {
  factory _$ExamAttemptCopyWith(_ExamAttempt value, $Res Function(_ExamAttempt) _then) = __$ExamAttemptCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'paper_id') String paperId,@JsonKey(name: 'paper_version_id') String paperVersionId, String status,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'deadline_at') DateTime? deadlineAt,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'graded_at') DateTime? gradedAt,@JsonKey(name: 'full_score') double fullScore,@JsonKey(name: 'objective_full_score') double objectiveFullScore,@JsonKey(name: 'objective_score') double objectiveScore,@JsonKey(name: 'subjective_score') double subjectiveScore,@JsonKey(name: 'total_score') double totalScore,@JsonKey(name: 'pending_review_count') int pendingReviewCount,@JsonKey(name: 'duration_ms') int durationMs
});




}
/// @nodoc
class __$ExamAttemptCopyWithImpl<$Res>
    implements _$ExamAttemptCopyWith<$Res> {
  __$ExamAttemptCopyWithImpl(this._self, this._then);

  final _ExamAttempt _self;
  final $Res Function(_ExamAttempt) _then;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? paperId = null,Object? paperVersionId = null,Object? status = null,Object? startedAt = freezed,Object? deadlineAt = freezed,Object? submittedAt = freezed,Object? gradedAt = freezed,Object? fullScore = null,Object? objectiveFullScore = null,Object? objectiveScore = null,Object? subjectiveScore = null,Object? totalScore = null,Object? pendingReviewCount = null,Object? durationMs = null,}) {
  return _then(_ExamAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,paperVersionId: null == paperVersionId ? _self.paperVersionId : paperVersionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gradedAt: freezed == gradedAt ? _self.gradedAt : gradedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fullScore: null == fullScore ? _self.fullScore : fullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveFullScore: null == objectiveFullScore ? _self.objectiveFullScore : objectiveFullScore // ignore: cast_nullable_to_non_nullable
as double,objectiveScore: null == objectiveScore ? _self.objectiveScore : objectiveScore // ignore: cast_nullable_to_non_nullable
as double,subjectiveScore: null == subjectiveScore ? _self.subjectiveScore : subjectiveScore // ignore: cast_nullable_to_non_nullable
as double,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,pendingReviewCount: null == pendingReviewCount ? _self.pendingReviewCount : pendingReviewCount // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ExamSnapshot {

 ExamAttempt get attempt; ExamPaper get paper;/// 已作答的记录。开考那次是**瘦对象**（只有 paper_item_id / seq / answer），
/// 查成绩那次还带判分字段（units / score / grading）——缺字段按默认值解析。
 List<ExamAnswerRecord> get answers;
/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSnapshotCopyWith<ExamSnapshot> get copyWith => _$ExamSnapshotCopyWithImpl<ExamSnapshot>(this as ExamSnapshot, _$identity);

  /// Serializes this ExamSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSnapshot&&(identical(other.attempt, _this.attempt) || other.attempt == _this.attempt)&&(identical(other.paper, _this.paper) || other.paper == _this.paper)&&const DeepCollectionEquality().equals(other.answers, _this.answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamSnapshot;
  return Object.hash(runtimeType,_this.attempt,_this.paper,const DeepCollectionEquality().hash(_this.answers));
}

@override
String toString() {
  final _this = this as ExamSnapshot;
  return 'ExamSnapshot(attempt: ${_this.attempt}, paper: ${_this.paper}, answers: ${_this.answers})';
}


}

/// @nodoc
abstract mixin class $ExamSnapshotCopyWith<$Res>  {
  factory $ExamSnapshotCopyWith(ExamSnapshot value, $Res Function(ExamSnapshot) _then) = _$ExamSnapshotCopyWithImpl;
@useResult
$Res call({
 ExamAttempt attempt, ExamPaper paper, List<ExamAnswerRecord> answers
});


$ExamAttemptCopyWith<$Res> get attempt;$ExamPaperCopyWith<$Res> get paper;

}
/// @nodoc
class _$ExamSnapshotCopyWithImpl<$Res>
    implements $ExamSnapshotCopyWith<$Res> {
  _$ExamSnapshotCopyWithImpl(this._self, this._then);

  final ExamSnapshot _self;
  final $Res Function(ExamSnapshot) _then;

/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attempt = null,Object? paper = null,Object? answers = null,}) {
  return _then(ExamSnapshot(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as ExamAttempt,paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as ExamPaper,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<ExamAnswerRecord>,
  ));
}
/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamAttemptCopyWith<$Res> get attempt {
  
  return $ExamAttemptCopyWith<$Res>(_self.attempt, (value) {
    return _then(_self.copyWith(attempt: value));
  });
}/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamPaperCopyWith<$Res> get paper {
  
  return $ExamPaperCopyWith<$Res>(_self.paper, (value) {
    return _then(_self.copyWith(paper: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExamSnapshot].
extension ExamSnapshotPatterns on ExamSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ExamSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExamAttempt attempt,  ExamPaper paper,  List<ExamAnswerRecord> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSnapshot() when $default != null:
return $default(_that.attempt,_that.paper,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExamAttempt attempt,  ExamPaper paper,  List<ExamAnswerRecord> answers)  $default,) {final _that = this;
switch (_that) {
case _ExamSnapshot():
return $default(_that.attempt,_that.paper,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExamAttempt attempt,  ExamPaper paper,  List<ExamAnswerRecord> answers)?  $default,) {final _that = this;
switch (_that) {
case _ExamSnapshot() when $default != null:
return $default(_that.attempt,_that.paper,_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSnapshot implements ExamSnapshot {
  const _ExamSnapshot({required this.attempt, required this.paper,  List<ExamAnswerRecord> answers = const <ExamAnswerRecord>[]}): _answers = answers;
  factory _ExamSnapshot.fromJson(Map<String, dynamic> json) => _$ExamSnapshotFromJson(json);

@override final  ExamAttempt attempt;
@override final  ExamPaper paper;
/// 已作答的记录。开考那次是**瘦对象**（只有 paper_item_id / seq / answer），
/// 查成绩那次还带判分字段（units / score / grading）——缺字段按默认值解析。
 final  List<ExamAnswerRecord> _answers;
/// 已作答的记录。开考那次是**瘦对象**（只有 paper_item_id / seq / answer），
/// 查成绩那次还带判分字段（units / score / grading）——缺字段按默认值解析。
@override@JsonKey() List<ExamAnswerRecord> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSnapshotCopyWith<_ExamSnapshot> get copyWith => __$ExamSnapshotCopyWithImpl<_ExamSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSnapshot&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.paper, paper) || other.paper == paper)&&const DeepCollectionEquality().equals(other.answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,attempt,paper,const DeepCollectionEquality().hash(_answers));
}

@override
String toString() {
    return 'ExamSnapshot(attempt: $attempt, paper: $paper, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$ExamSnapshotCopyWith<$Res> implements $ExamSnapshotCopyWith<$Res> {
  factory _$ExamSnapshotCopyWith(_ExamSnapshot value, $Res Function(_ExamSnapshot) _then) = __$ExamSnapshotCopyWithImpl;
@override @useResult
$Res call({
 ExamAttempt attempt, ExamPaper paper, List<ExamAnswerRecord> answers
});


@override $ExamAttemptCopyWith<$Res> get attempt;@override $ExamPaperCopyWith<$Res> get paper;

}
/// @nodoc
class __$ExamSnapshotCopyWithImpl<$Res>
    implements _$ExamSnapshotCopyWith<$Res> {
  __$ExamSnapshotCopyWithImpl(this._self, this._then);

  final _ExamSnapshot _self;
  final $Res Function(_ExamSnapshot) _then;

/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attempt = null,Object? paper = null,Object? answers = null,}) {
  return _then(_ExamSnapshot(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as ExamAttempt,paper: null == paper ? _self.paper : paper // ignore: cast_nullable_to_non_nullable
as ExamPaper,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<ExamAnswerRecord>,
  ));
}

/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamAttemptCopyWith<$Res> get attempt {
  
  return $ExamAttemptCopyWith<$Res>(_self.attempt, (value) {
    return _then(_self.copyWith(attempt: value));
  });
}/// Create a copy of ExamSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamPaperCopyWith<$Res> get paper {
  
  return $ExamPaperCopyWith<$Res>(_self.paper, (value) {
    return _then(_self.copyWith(paper: value));
  });
}
}

// dart format on
