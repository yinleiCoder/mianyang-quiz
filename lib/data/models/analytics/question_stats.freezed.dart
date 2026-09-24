// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WrongStudent {

@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'class_name') String? get className; String? get label;
/// Create a copy of WrongStudent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WrongStudentCopyWith<WrongStudent> get copyWith => _$WrongStudentCopyWithImpl<WrongStudent>(this as WrongStudent, _$identity);

  /// Serializes this WrongStudent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WrongStudent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WrongStudent&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.className, _this.className) || other.className == _this.className)&&(identical(other.label, _this.label) || other.label == _this.label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WrongStudent;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.className,_this.label);
}

@override
String toString() {
  final _this = this as WrongStudent;
  return 'WrongStudent(userId: ${_this.userId}, name: ${_this.name}, className: ${_this.className}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $WrongStudentCopyWith<$Res>  {
  factory $WrongStudentCopyWith(WrongStudent value, $Res Function(WrongStudent) _then) = _$WrongStudentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'class_name') String? className, String? label
});




}
/// @nodoc
class _$WrongStudentCopyWithImpl<$Res>
    implements $WrongStudentCopyWith<$Res> {
  _$WrongStudentCopyWithImpl(this._self, this._then);

  final WrongStudent _self;
  final $Res Function(WrongStudent) _then;

/// Create a copy of WrongStudent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? className = freezed,Object? label = freezed,}) {
  return _then(WrongStudent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WrongStudent].
extension WrongStudentPatterns on WrongStudent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WrongStudent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WrongStudent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WrongStudent value)  $default,){
final _that = this;
switch (_that) {
case _WrongStudent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WrongStudent value)?  $default,){
final _that = this;
switch (_that) {
case _WrongStudent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className,  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WrongStudent() when $default != null:
return $default(_that.userId,_that.name,_that.className,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className,  String? label)  $default,) {final _that = this;
switch (_that) {
case _WrongStudent():
return $default(_that.userId,_that.name,_that.className,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className,  String? label)?  $default,) {final _that = this;
switch (_that) {
case _WrongStudent() when $default != null:
return $default(_that.userId,_that.name,_that.className,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WrongStudent implements WrongStudent {
  const _WrongStudent({@JsonKey(name: 'user_id') required this.userId, this.name = '', @JsonKey(name: 'class_name') this.className, this.label});
  factory _WrongStudent.fromJson(Map<String, dynamic> json) => _$WrongStudentFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'class_name') final  String? className;
@override final  String? label;

/// Create a copy of WrongStudent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WrongStudentCopyWith<_WrongStudent> get copyWith => __$WrongStudentCopyWithImpl<_WrongStudent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WrongStudentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WrongStudent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,className,label);
}

@override
String toString() {
    return 'WrongStudent(userId: $userId, name: $name, className: $className, label: $label)';
}


}

/// @nodoc
abstract mixin class _$WrongStudentCopyWith<$Res> implements $WrongStudentCopyWith<$Res> {
  factory _$WrongStudentCopyWith(_WrongStudent value, $Res Function(_WrongStudent) _then) = __$WrongStudentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'class_name') String? className, String? label
});




}
/// @nodoc
class __$WrongStudentCopyWithImpl<$Res>
    implements _$WrongStudentCopyWith<$Res> {
  __$WrongStudentCopyWithImpl(this._self, this._then);

  final _WrongStudent _self;
  final $Res Function(_WrongStudent) _then;

/// Create a copy of WrongStudent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? className = freezed,Object? label = freezed,}) {
  return _then(_WrongStudent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuestionStat {

@JsonKey(name: 'item_id') String get itemId; int get seq; String get qtype; double get score;/// 参与统计的场次里，有多少人这题有作答记录（含未作答）。
 int get total; int get blank; int get graded; int get correct; int get pending;@JsonKey(name: 'correct_rate') double? get correctRate; List<QuestionOptionStat> get options;@JsonKey(name: 'text_counts') List<TextCount> get textCounts;@JsonKey(name: 'wrong_students') List<WrongStudent> get wrongStudents;@JsonKey(name: 'wrong_total') int get wrongTotal;
/// Create a copy of QuestionStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionStatCopyWith<QuestionStat> get copyWith => _$QuestionStatCopyWithImpl<QuestionStat>(this as QuestionStat, _$identity);

  /// Serializes this QuestionStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionStat&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.blank, _this.blank) || other.blank == _this.blank)&&(identical(other.graded, _this.graded) || other.graded == _this.graded)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.correctRate, _this.correctRate) || other.correctRate == _this.correctRate)&&const DeepCollectionEquality().equals(other.options, _this.options)&&const DeepCollectionEquality().equals(other.textCounts, _this.textCounts)&&const DeepCollectionEquality().equals(other.wrongStudents, _this.wrongStudents)&&(identical(other.wrongTotal, _this.wrongTotal) || other.wrongTotal == _this.wrongTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionStat;
  return Object.hash(runtimeType,_this.itemId,_this.seq,_this.qtype,_this.score,_this.total,_this.blank,_this.graded,_this.correct,_this.pending,_this.correctRate,const DeepCollectionEquality().hash(_this.options),const DeepCollectionEquality().hash(_this.textCounts),const DeepCollectionEquality().hash(_this.wrongStudents),_this.wrongTotal);
}

@override
String toString() {
  final _this = this as QuestionStat;
  return 'QuestionStat(itemId: ${_this.itemId}, seq: ${_this.seq}, qtype: ${_this.qtype}, score: ${_this.score}, total: ${_this.total}, blank: ${_this.blank}, graded: ${_this.graded}, correct: ${_this.correct}, pending: ${_this.pending}, correctRate: ${_this.correctRate}, options: ${_this.options}, textCounts: ${_this.textCounts}, wrongStudents: ${_this.wrongStudents}, wrongTotal: ${_this.wrongTotal})';
}


}

/// @nodoc
abstract mixin class $QuestionStatCopyWith<$Res>  {
  factory $QuestionStatCopyWith(QuestionStat value, $Res Function(QuestionStat) _then) = _$QuestionStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item_id') String itemId, int seq, String qtype, double score, int total, int blank, int graded, int correct, int pending,@JsonKey(name: 'correct_rate') double? correctRate, List<QuestionOptionStat> options,@JsonKey(name: 'text_counts') List<TextCount> textCounts,@JsonKey(name: 'wrong_students') List<WrongStudent> wrongStudents,@JsonKey(name: 'wrong_total') int wrongTotal
});




}
/// @nodoc
class _$QuestionStatCopyWithImpl<$Res>
    implements $QuestionStatCopyWith<$Res> {
  _$QuestionStatCopyWithImpl(this._self, this._then);

  final QuestionStat _self;
  final $Res Function(QuestionStat) _then;

/// Create a copy of QuestionStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? seq = null,Object? qtype = null,Object? score = null,Object? total = null,Object? blank = null,Object? graded = null,Object? correct = null,Object? pending = null,Object? correctRate = freezed,Object? options = null,Object? textCounts = null,Object? wrongStudents = null,Object? wrongTotal = null,}) {
  return _then(QuestionStat(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,blank: null == blank ? _self.blank : blank // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,correctRate: freezed == correctRate ? _self.correctRate : correctRate // ignore: cast_nullable_to_non_nullable
as double?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionStat>,textCounts: null == textCounts ? _self.textCounts : textCounts // ignore: cast_nullable_to_non_nullable
as List<TextCount>,wrongStudents: null == wrongStudents ? _self.wrongStudents : wrongStudents // ignore: cast_nullable_to_non_nullable
as List<WrongStudent>,wrongTotal: null == wrongTotal ? _self.wrongTotal : wrongTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionStat].
extension QuestionStatPatterns on QuestionStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionStat value)  $default,){
final _that = this;
switch (_that) {
case _QuestionStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionStat value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_id')  String itemId,  int seq,  String qtype,  double score,  int total,  int blank,  int graded,  int correct,  int pending, @JsonKey(name: 'correct_rate')  double? correctRate,  List<QuestionOptionStat> options, @JsonKey(name: 'text_counts')  List<TextCount> textCounts, @JsonKey(name: 'wrong_students')  List<WrongStudent> wrongStudents, @JsonKey(name: 'wrong_total')  int wrongTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionStat() when $default != null:
return $default(_that.itemId,_that.seq,_that.qtype,_that.score,_that.total,_that.blank,_that.graded,_that.correct,_that.pending,_that.correctRate,_that.options,_that.textCounts,_that.wrongStudents,_that.wrongTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_id')  String itemId,  int seq,  String qtype,  double score,  int total,  int blank,  int graded,  int correct,  int pending, @JsonKey(name: 'correct_rate')  double? correctRate,  List<QuestionOptionStat> options, @JsonKey(name: 'text_counts')  List<TextCount> textCounts, @JsonKey(name: 'wrong_students')  List<WrongStudent> wrongStudents, @JsonKey(name: 'wrong_total')  int wrongTotal)  $default,) {final _that = this;
switch (_that) {
case _QuestionStat():
return $default(_that.itemId,_that.seq,_that.qtype,_that.score,_that.total,_that.blank,_that.graded,_that.correct,_that.pending,_that.correctRate,_that.options,_that.textCounts,_that.wrongStudents,_that.wrongTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'item_id')  String itemId,  int seq,  String qtype,  double score,  int total,  int blank,  int graded,  int correct,  int pending, @JsonKey(name: 'correct_rate')  double? correctRate,  List<QuestionOptionStat> options, @JsonKey(name: 'text_counts')  List<TextCount> textCounts, @JsonKey(name: 'wrong_students')  List<WrongStudent> wrongStudents, @JsonKey(name: 'wrong_total')  int wrongTotal)?  $default,) {final _that = this;
switch (_that) {
case _QuestionStat() when $default != null:
return $default(_that.itemId,_that.seq,_that.qtype,_that.score,_that.total,_that.blank,_that.graded,_that.correct,_that.pending,_that.correctRate,_that.options,_that.textCounts,_that.wrongStudents,_that.wrongTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionStat implements QuestionStat {
  const _QuestionStat({@JsonKey(name: 'item_id') required this.itemId, this.seq = 0, this.qtype = '', this.score = 0, this.total = 0, this.blank = 0, this.graded = 0, this.correct = 0, this.pending = 0, @JsonKey(name: 'correct_rate') this.correctRate,  List<QuestionOptionStat> options = const <QuestionOptionStat>[], @JsonKey(name: 'text_counts')  List<TextCount> textCounts = const <TextCount>[], @JsonKey(name: 'wrong_students')  List<WrongStudent> wrongStudents = const <WrongStudent>[], @JsonKey(name: 'wrong_total') this.wrongTotal = 0}): _options = options,_textCounts = textCounts,_wrongStudents = wrongStudents;
  factory _QuestionStat.fromJson(Map<String, dynamic> json) => _$QuestionStatFromJson(json);

@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey() final  int seq;
@override@JsonKey() final  String qtype;
@override@JsonKey() final  double score;
/// 参与统计的场次里，有多少人这题有作答记录（含未作答）。
@override@JsonKey() final  int total;
@override@JsonKey() final  int blank;
@override@JsonKey() final  int graded;
@override@JsonKey() final  int correct;
@override@JsonKey() final  int pending;
@override@JsonKey(name: 'correct_rate') final  double? correctRate;
 final  List<QuestionOptionStat> _options;
@override@JsonKey() List<QuestionOptionStat> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  List<TextCount> _textCounts;
@override@JsonKey(name: 'text_counts') List<TextCount> get textCounts {
  if (_textCounts is EqualUnmodifiableListView) return _textCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textCounts);
}

 final  List<WrongStudent> _wrongStudents;
@override@JsonKey(name: 'wrong_students') List<WrongStudent> get wrongStudents {
  if (_wrongStudents is EqualUnmodifiableListView) return _wrongStudents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wrongStudents);
}

@override@JsonKey(name: 'wrong_total') final  int wrongTotal;

/// Create a copy of QuestionStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionStatCopyWith<_QuestionStat> get copyWith => __$QuestionStatCopyWithImpl<_QuestionStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionStat&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.score, score) || other.score == score)&&(identical(other.total, total) || other.total == total)&&(identical(other.blank, blank) || other.blank == blank)&&(identical(other.graded, graded) || other.graded == graded)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.correctRate, correctRate) || other.correctRate == correctRate)&&const DeepCollectionEquality().equals(other.options, _options)&&const DeepCollectionEquality().equals(other.textCounts, _textCounts)&&const DeepCollectionEquality().equals(other.wrongStudents, _wrongStudents)&&(identical(other.wrongTotal, wrongTotal) || other.wrongTotal == wrongTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,itemId,seq,qtype,score,total,blank,graded,correct,pending,correctRate,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_textCounts),const DeepCollectionEquality().hash(_wrongStudents),wrongTotal);
}

@override
String toString() {
    return 'QuestionStat(itemId: $itemId, seq: $seq, qtype: $qtype, score: $score, total: $total, blank: $blank, graded: $graded, correct: $correct, pending: $pending, correctRate: $correctRate, options: $options, textCounts: $textCounts, wrongStudents: $wrongStudents, wrongTotal: $wrongTotal)';
}


}

/// @nodoc
abstract mixin class _$QuestionStatCopyWith<$Res> implements $QuestionStatCopyWith<$Res> {
  factory _$QuestionStatCopyWith(_QuestionStat value, $Res Function(_QuestionStat) _then) = __$QuestionStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item_id') String itemId, int seq, String qtype, double score, int total, int blank, int graded, int correct, int pending,@JsonKey(name: 'correct_rate') double? correctRate, List<QuestionOptionStat> options,@JsonKey(name: 'text_counts') List<TextCount> textCounts,@JsonKey(name: 'wrong_students') List<WrongStudent> wrongStudents,@JsonKey(name: 'wrong_total') int wrongTotal
});




}
/// @nodoc
class __$QuestionStatCopyWithImpl<$Res>
    implements _$QuestionStatCopyWith<$Res> {
  __$QuestionStatCopyWithImpl(this._self, this._then);

  final _QuestionStat _self;
  final $Res Function(_QuestionStat) _then;

/// Create a copy of QuestionStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? seq = null,Object? qtype = null,Object? score = null,Object? total = null,Object? blank = null,Object? graded = null,Object? correct = null,Object? pending = null,Object? correctRate = freezed,Object? options = null,Object? textCounts = null,Object? wrongStudents = null,Object? wrongTotal = null,}) {
  return _then(_QuestionStat(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,blank: null == blank ? _self.blank : blank // ignore: cast_nullable_to_non_nullable
as int,graded: null == graded ? _self.graded : graded // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,correctRate: freezed == correctRate ? _self.correctRate : correctRate // ignore: cast_nullable_to_non_nullable
as double?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<QuestionOptionStat>,textCounts: null == textCounts ? _self._textCounts : textCounts // ignore: cast_nullable_to_non_nullable
as List<TextCount>,wrongStudents: null == wrongStudents ? _self._wrongStudents : wrongStudents // ignore: cast_nullable_to_non_nullable
as List<WrongStudent>,wrongTotal: null == wrongTotal ? _self.wrongTotal : wrongTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
