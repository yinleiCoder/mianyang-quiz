// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitResult {

/// 服务端判定。主观题由自评决定；`{"type":"unknown"}` 一律 false。
@JsonKey(name: 'is_correct') bool get isCorrect;/// 'auto' 机器判分 / 'self' 主观题自评。
 String get grading;/// 该版本 content 里的标准答案**原文**（未加工）。
///
/// 陷阱：复合题这里是 **null**——它的答案在 content.sub[].answer，顶层没有 answer。
/// 展示标准答案时必须对复合题逐子题渲染，不能只读这个字段。
@JsonKey(name: 'correct_answer') Map<String, dynamic>? get correctAnswer;
/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitResultCopyWith<SubmitResult> get copyWith => _$SubmitResultCopyWithImpl<SubmitResult>(this as SubmitResult, _$identity);

  /// Serializes this SubmitResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SubmitResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitResult&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect)&&(identical(other.grading, _this.grading) || other.grading == _this.grading)&&const DeepCollectionEquality().equals(other.correctAnswer, _this.correctAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SubmitResult;
  return Object.hash(runtimeType,_this.isCorrect,_this.grading,const DeepCollectionEquality().hash(_this.correctAnswer));
}

@override
String toString() {
  final _this = this as SubmitResult;
  return 'SubmitResult(isCorrect: ${_this.isCorrect}, grading: ${_this.grading}, correctAnswer: ${_this.correctAnswer})';
}


}

/// @nodoc
abstract mixin class $SubmitResultCopyWith<$Res>  {
  factory $SubmitResultCopyWith(SubmitResult value, $Res Function(SubmitResult) _then) = _$SubmitResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'is_correct') bool isCorrect, String grading,@JsonKey(name: 'correct_answer') Map<String, dynamic>? correctAnswer
});




}
/// @nodoc
class _$SubmitResultCopyWithImpl<$Res>
    implements $SubmitResultCopyWith<$Res> {
  _$SubmitResultCopyWithImpl(this._self, this._then);

  final SubmitResult _self;
  final $Res Function(SubmitResult) _then;

/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCorrect = null,Object? grading = null,Object? correctAnswer = freezed,}) {
  return _then(SubmitResult(
isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,correctAnswer: freezed == correctAnswer ? _self.correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitResult].
extension SubmitResultPatterns on SubmitResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitResult value)  $default,){
final _that = this;
switch (_that) {
case _SubmitResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitResult value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_correct')  bool isCorrect,  String grading, @JsonKey(name: 'correct_answer')  Map<String, dynamic>? correctAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
return $default(_that.isCorrect,_that.grading,_that.correctAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'is_correct')  bool isCorrect,  String grading, @JsonKey(name: 'correct_answer')  Map<String, dynamic>? correctAnswer)  $default,) {final _that = this;
switch (_that) {
case _SubmitResult():
return $default(_that.isCorrect,_that.grading,_that.correctAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'is_correct')  bool isCorrect,  String grading, @JsonKey(name: 'correct_answer')  Map<String, dynamic>? correctAnswer)?  $default,) {final _that = this;
switch (_that) {
case _SubmitResult() when $default != null:
return $default(_that.isCorrect,_that.grading,_that.correctAnswer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmitResult implements SubmitResult {
  const _SubmitResult({@JsonKey(name: 'is_correct') required this.isCorrect, this.grading = 'auto', @JsonKey(name: 'correct_answer')  Map<String, dynamic>? correctAnswer}): _correctAnswer = correctAnswer;
  factory _SubmitResult.fromJson(Map<String, dynamic> json) => _$SubmitResultFromJson(json);

/// 服务端判定。主观题由自评决定；`{"type":"unknown"}` 一律 false。
@override@JsonKey(name: 'is_correct') final  bool isCorrect;
/// 'auto' 机器判分 / 'self' 主观题自评。
@override@JsonKey() final  String grading;
/// 该版本 content 里的标准答案**原文**（未加工）。
///
/// 陷阱：复合题这里是 **null**——它的答案在 content.sub[].answer，顶层没有 answer。
/// 展示标准答案时必须对复合题逐子题渲染，不能只读这个字段。
 final  Map<String, dynamic>? _correctAnswer;
/// 该版本 content 里的标准答案**原文**（未加工）。
///
/// 陷阱：复合题这里是 **null**——它的答案在 content.sub[].answer，顶层没有 answer。
/// 展示标准答案时必须对复合题逐子题渲染，不能只读这个字段。
@override@JsonKey(name: 'correct_answer') Map<String, dynamic>? get correctAnswer {
  final value = _correctAnswer;
  if (value == null) return null;
  if (_correctAnswer is EqualUnmodifiableMapView) return _correctAnswer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitResultCopyWith<_SubmitResult> get copyWith => __$SubmitResultCopyWithImpl<_SubmitResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitResult&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.grading, grading) || other.grading == grading)&&const DeepCollectionEquality().equals(other.correctAnswer, _correctAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isCorrect,grading,const DeepCollectionEquality().hash(_correctAnswer));
}

@override
String toString() {
    return 'SubmitResult(isCorrect: $isCorrect, grading: $grading, correctAnswer: $correctAnswer)';
}


}

/// @nodoc
abstract mixin class _$SubmitResultCopyWith<$Res> implements $SubmitResultCopyWith<$Res> {
  factory _$SubmitResultCopyWith(_SubmitResult value, $Res Function(_SubmitResult) _then) = __$SubmitResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'is_correct') bool isCorrect, String grading,@JsonKey(name: 'correct_answer') Map<String, dynamic>? correctAnswer
});




}
/// @nodoc
class __$SubmitResultCopyWithImpl<$Res>
    implements _$SubmitResultCopyWith<$Res> {
  __$SubmitResultCopyWithImpl(this._self, this._then);

  final _SubmitResult _self;
  final $Res Function(_SubmitResult) _then;

/// Create a copy of SubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCorrect = null,Object? grading = null,Object? correctAnswer = freezed,}) {
  return _then(_SubmitResult(
isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,grading: null == grading ? _self.grading : grading // ignore: cast_nullable_to_non_nullable
as String,correctAnswer: freezed == correctAnswer ? _self._correctAnswer : correctAnswer // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$FinishSummary {

 int get total; int get answered; int get correct; int get wrong;/// 未作答数 = total - answered。
 int get omitted;/// 正确率 = correct / **total**（分母是总题数，不是已答数——与看板口径不同）。
 double get accuracy;@JsonKey(name: 'duration_ms') int get durationMs;
/// Create a copy of FinishSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinishSummaryCopyWith<FinishSummary> get copyWith => _$FinishSummaryCopyWithImpl<FinishSummary>(this as FinishSummary, _$identity);

  /// Serializes this FinishSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinishSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinishSummary&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.answered, _this.answered) || other.answered == _this.answered)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.wrong, _this.wrong) || other.wrong == _this.wrong)&&(identical(other.omitted, _this.omitted) || other.omitted == _this.omitted)&&(identical(other.accuracy, _this.accuracy) || other.accuracy == _this.accuracy)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinishSummary;
  return Object.hash(runtimeType,_this.total,_this.answered,_this.correct,_this.wrong,_this.omitted,_this.accuracy,_this.durationMs);
}

@override
String toString() {
  final _this = this as FinishSummary;
  return 'FinishSummary(total: ${_this.total}, answered: ${_this.answered}, correct: ${_this.correct}, wrong: ${_this.wrong}, omitted: ${_this.omitted}, accuracy: ${_this.accuracy}, durationMs: ${_this.durationMs})';
}


}

/// @nodoc
abstract mixin class $FinishSummaryCopyWith<$Res>  {
  factory $FinishSummaryCopyWith(FinishSummary value, $Res Function(FinishSummary) _then) = _$FinishSummaryCopyWithImpl;
@useResult
$Res call({
 int total, int answered, int correct, int wrong, int omitted, double accuracy,@JsonKey(name: 'duration_ms') int durationMs
});




}
/// @nodoc
class _$FinishSummaryCopyWithImpl<$Res>
    implements $FinishSummaryCopyWith<$Res> {
  _$FinishSummaryCopyWithImpl(this._self, this._then);

  final FinishSummary _self;
  final $Res Function(FinishSummary) _then;

/// Create a copy of FinishSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? answered = null,Object? correct = null,Object? wrong = null,Object? omitted = null,Object? accuracy = null,Object? durationMs = null,}) {
  return _then(FinishSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,omitted: null == omitted ? _self.omitted : omitted // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FinishSummary].
extension FinishSummaryPatterns on FinishSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinishSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinishSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinishSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinishSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinishSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinishSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int answered,  int correct,  int wrong,  int omitted,  double accuracy, @JsonKey(name: 'duration_ms')  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinishSummary() when $default != null:
return $default(_that.total,_that.answered,_that.correct,_that.wrong,_that.omitted,_that.accuracy,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int answered,  int correct,  int wrong,  int omitted,  double accuracy, @JsonKey(name: 'duration_ms')  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _FinishSummary():
return $default(_that.total,_that.answered,_that.correct,_that.wrong,_that.omitted,_that.accuracy,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int answered,  int correct,  int wrong,  int omitted,  double accuracy, @JsonKey(name: 'duration_ms')  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _FinishSummary() when $default != null:
return $default(_that.total,_that.answered,_that.correct,_that.wrong,_that.omitted,_that.accuracy,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinishSummary implements FinishSummary {
  const _FinishSummary({this.total = 0, this.answered = 0, this.correct = 0, this.wrong = 0, this.omitted = 0, this.accuracy = 0, @JsonKey(name: 'duration_ms') this.durationMs = 0});
  factory _FinishSummary.fromJson(Map<String, dynamic> json) => _$FinishSummaryFromJson(json);

@override@JsonKey() final  int total;
@override@JsonKey() final  int answered;
@override@JsonKey() final  int correct;
@override@JsonKey() final  int wrong;
/// 未作答数 = total - answered。
@override@JsonKey() final  int omitted;
/// 正确率 = correct / **total**（分母是总题数，不是已答数——与看板口径不同）。
@override@JsonKey() final  double accuracy;
@override@JsonKey(name: 'duration_ms') final  int durationMs;

/// Create a copy of FinishSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinishSummaryCopyWith<_FinishSummary> get copyWith => __$FinishSummaryCopyWithImpl<_FinishSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinishSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinishSummary&&(identical(other.total, total) || other.total == total)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.omitted, omitted) || other.omitted == omitted)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,answered,correct,wrong,omitted,accuracy,durationMs);
}

@override
String toString() {
    return 'FinishSummary(total: $total, answered: $answered, correct: $correct, wrong: $wrong, omitted: $omitted, accuracy: $accuracy, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$FinishSummaryCopyWith<$Res> implements $FinishSummaryCopyWith<$Res> {
  factory _$FinishSummaryCopyWith(_FinishSummary value, $Res Function(_FinishSummary) _then) = __$FinishSummaryCopyWithImpl;
@override @useResult
$Res call({
 int total, int answered, int correct, int wrong, int omitted, double accuracy,@JsonKey(name: 'duration_ms') int durationMs
});




}
/// @nodoc
class __$FinishSummaryCopyWithImpl<$Res>
    implements _$FinishSummaryCopyWith<$Res> {
  __$FinishSummaryCopyWithImpl(this._self, this._then);

  final _FinishSummary _self;
  final $Res Function(_FinishSummary) _then;

/// Create a copy of FinishSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? answered = null,Object? correct = null,Object? wrong = null,Object? omitted = null,Object? accuracy = null,Object? durationMs = null,}) {
  return _then(_FinishSummary(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,omitted: null == omitted ? _self.omitted : omitted // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
