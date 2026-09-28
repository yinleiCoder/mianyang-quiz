// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paper_question_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionStatsTotals {

/// 参与统计的场次数（含待阅卷）。
 int get attempts;/// 其中主观题还没判完的场次数。
 int get ungraded;/// 考的是旧版卷面、未计入的场次数。
@JsonKey(name: 'other_version_skipped') int get otherVersionSkipped;
/// Create a copy of QuestionStatsTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionStatsTotalsCopyWith<QuestionStatsTotals> get copyWith => _$QuestionStatsTotalsCopyWithImpl<QuestionStatsTotals>(this as QuestionStatsTotals, _$identity);

  /// Serializes this QuestionStatsTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionStatsTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionStatsTotals&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.ungraded, _this.ungraded) || other.ungraded == _this.ungraded)&&(identical(other.otherVersionSkipped, _this.otherVersionSkipped) || other.otherVersionSkipped == _this.otherVersionSkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionStatsTotals;
  return Object.hash(runtimeType,_this.attempts,_this.ungraded,_this.otherVersionSkipped);
}

@override
String toString() {
  final _this = this as QuestionStatsTotals;
  return 'QuestionStatsTotals(attempts: ${_this.attempts}, ungraded: ${_this.ungraded}, otherVersionSkipped: ${_this.otherVersionSkipped})';
}


}

/// @nodoc
abstract mixin class $QuestionStatsTotalsCopyWith<$Res>  {
  factory $QuestionStatsTotalsCopyWith(QuestionStatsTotals value, $Res Function(QuestionStatsTotals) _then) = _$QuestionStatsTotalsCopyWithImpl;
@useResult
$Res call({
 int attempts, int ungraded,@JsonKey(name: 'other_version_skipped') int otherVersionSkipped
});




}
/// @nodoc
class _$QuestionStatsTotalsCopyWithImpl<$Res>
    implements $QuestionStatsTotalsCopyWith<$Res> {
  _$QuestionStatsTotalsCopyWithImpl(this._self, this._then);

  final QuestionStatsTotals _self;
  final $Res Function(QuestionStatsTotals) _then;

/// Create a copy of QuestionStatsTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attempts = null,Object? ungraded = null,Object? otherVersionSkipped = null,}) {
  return _then(QuestionStatsTotals(
attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,ungraded: null == ungraded ? _self.ungraded : ungraded // ignore: cast_nullable_to_non_nullable
as int,otherVersionSkipped: null == otherVersionSkipped ? _self.otherVersionSkipped : otherVersionSkipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionStatsTotals].
extension QuestionStatsTotalsPatterns on QuestionStatsTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionStatsTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionStatsTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionStatsTotals value)  $default,){
final _that = this;
switch (_that) {
case _QuestionStatsTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionStatsTotals value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionStatsTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int attempts,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionStatsTotals() when $default != null:
return $default(_that.attempts,_that.ungraded,_that.otherVersionSkipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int attempts,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped)  $default,) {final _that = this;
switch (_that) {
case _QuestionStatsTotals():
return $default(_that.attempts,_that.ungraded,_that.otherVersionSkipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int attempts,  int ungraded, @JsonKey(name: 'other_version_skipped')  int otherVersionSkipped)?  $default,) {final _that = this;
switch (_that) {
case _QuestionStatsTotals() when $default != null:
return $default(_that.attempts,_that.ungraded,_that.otherVersionSkipped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionStatsTotals implements QuestionStatsTotals {
  const _QuestionStatsTotals({this.attempts = 0, this.ungraded = 0, @JsonKey(name: 'other_version_skipped') this.otherVersionSkipped = 0});
  factory _QuestionStatsTotals.fromJson(Map<String, dynamic> json) => _$QuestionStatsTotalsFromJson(json);

/// 参与统计的场次数（含待阅卷）。
@override@JsonKey() final  int attempts;
/// 其中主观题还没判完的场次数。
@override@JsonKey() final  int ungraded;
/// 考的是旧版卷面、未计入的场次数。
@override@JsonKey(name: 'other_version_skipped') final  int otherVersionSkipped;

/// Create a copy of QuestionStatsTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionStatsTotalsCopyWith<_QuestionStatsTotals> get copyWith => __$QuestionStatsTotalsCopyWithImpl<_QuestionStatsTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionStatsTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionStatsTotals&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.ungraded, ungraded) || other.ungraded == ungraded)&&(identical(other.otherVersionSkipped, otherVersionSkipped) || other.otherVersionSkipped == otherVersionSkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,attempts,ungraded,otherVersionSkipped);
}

@override
String toString() {
    return 'QuestionStatsTotals(attempts: $attempts, ungraded: $ungraded, otherVersionSkipped: $otherVersionSkipped)';
}


}

/// @nodoc
abstract mixin class _$QuestionStatsTotalsCopyWith<$Res> implements $QuestionStatsTotalsCopyWith<$Res> {
  factory _$QuestionStatsTotalsCopyWith(_QuestionStatsTotals value, $Res Function(_QuestionStatsTotals) _then) = __$QuestionStatsTotalsCopyWithImpl;
@override @useResult
$Res call({
 int attempts, int ungraded,@JsonKey(name: 'other_version_skipped') int otherVersionSkipped
});




}
/// @nodoc
class __$QuestionStatsTotalsCopyWithImpl<$Res>
    implements _$QuestionStatsTotalsCopyWith<$Res> {
  __$QuestionStatsTotalsCopyWithImpl(this._self, this._then);

  final _QuestionStatsTotals _self;
  final $Res Function(_QuestionStatsTotals) _then;

/// Create a copy of QuestionStatsTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attempts = null,Object? ungraded = null,Object? otherVersionSkipped = null,}) {
  return _then(_QuestionStatsTotals(
attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,ungraded: null == ungraded ? _self.ungraded : ungraded // ignore: cast_nullable_to_non_nullable
as int,otherVersionSkipped: null == otherVersionSkipped ? _self.otherVersionSkipped : otherVersionSkipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PaperQuestionStats {

 List<QuestionStat> get items;@JsonKey(name: 'student_limit') int get studentLimit;/// 字段名与 payload 的 stats 子对象对应，**不拍平**：自定义 fromJson 会让
/// json_serializable 干脆不生成这个类（吃过这个亏）。
@JsonKey(name: 'stats') QuestionStatsTotals get totals;
/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaperQuestionStatsCopyWith<PaperQuestionStats> get copyWith => _$PaperQuestionStatsCopyWithImpl<PaperQuestionStats>(this as PaperQuestionStats, _$identity);

  /// Serializes this PaperQuestionStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaperQuestionStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaperQuestionStats&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.studentLimit, _this.studentLimit) || other.studentLimit == _this.studentLimit)&&(identical(other.totals, _this.totals) || other.totals == _this.totals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaperQuestionStats;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.studentLimit,_this.totals);
}

@override
String toString() {
  final _this = this as PaperQuestionStats;
  return 'PaperQuestionStats(items: ${_this.items}, studentLimit: ${_this.studentLimit}, totals: ${_this.totals})';
}


}

/// @nodoc
abstract mixin class $PaperQuestionStatsCopyWith<$Res>  {
  factory $PaperQuestionStatsCopyWith(PaperQuestionStats value, $Res Function(PaperQuestionStats) _then) = _$PaperQuestionStatsCopyWithImpl;
@useResult
$Res call({
 List<QuestionStat> items,@JsonKey(name: 'student_limit') int studentLimit,@JsonKey(name: 'stats') QuestionStatsTotals totals
});


$QuestionStatsTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class _$PaperQuestionStatsCopyWithImpl<$Res>
    implements $PaperQuestionStatsCopyWith<$Res> {
  _$PaperQuestionStatsCopyWithImpl(this._self, this._then);

  final PaperQuestionStats _self;
  final $Res Function(PaperQuestionStats) _then;

/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? studentLimit = null,Object? totals = null,}) {
  return _then(PaperQuestionStats(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<QuestionStat>,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as QuestionStatsTotals,
  ));
}
/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStatsTotalsCopyWith<$Res> get totals {
  
  return $QuestionStatsTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaperQuestionStats].
extension PaperQuestionStatsPatterns on PaperQuestionStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaperQuestionStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaperQuestionStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaperQuestionStats value)  $default,){
final _that = this;
switch (_that) {
case _PaperQuestionStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaperQuestionStats value)?  $default,){
final _that = this;
switch (_that) {
case _PaperQuestionStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QuestionStat> items, @JsonKey(name: 'student_limit')  int studentLimit, @JsonKey(name: 'stats')  QuestionStatsTotals totals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaperQuestionStats() when $default != null:
return $default(_that.items,_that.studentLimit,_that.totals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QuestionStat> items, @JsonKey(name: 'student_limit')  int studentLimit, @JsonKey(name: 'stats')  QuestionStatsTotals totals)  $default,) {final _that = this;
switch (_that) {
case _PaperQuestionStats():
return $default(_that.items,_that.studentLimit,_that.totals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QuestionStat> items, @JsonKey(name: 'student_limit')  int studentLimit, @JsonKey(name: 'stats')  QuestionStatsTotals totals)?  $default,) {final _that = this;
switch (_that) {
case _PaperQuestionStats() when $default != null:
return $default(_that.items,_that.studentLimit,_that.totals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaperQuestionStats implements PaperQuestionStats {
  const _PaperQuestionStats({ List<QuestionStat> items = const <QuestionStat>[], @JsonKey(name: 'student_limit') this.studentLimit = 50, @JsonKey(name: 'stats') this.totals = const QuestionStatsTotals()}): _items = items;
  factory _PaperQuestionStats.fromJson(Map<String, dynamic> json) => _$PaperQuestionStatsFromJson(json);

 final  List<QuestionStat> _items;
@override@JsonKey() List<QuestionStat> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'student_limit') final  int studentLimit;
/// 字段名与 payload 的 stats 子对象对应，**不拍平**：自定义 fromJson 会让
/// json_serializable 干脆不生成这个类（吃过这个亏）。
@override@JsonKey(name: 'stats') final  QuestionStatsTotals totals;

/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaperQuestionStatsCopyWith<_PaperQuestionStats> get copyWith => __$PaperQuestionStatsCopyWithImpl<_PaperQuestionStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaperQuestionStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaperQuestionStats&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.studentLimit, studentLimit) || other.studentLimit == studentLimit)&&(identical(other.totals, totals) || other.totals == totals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),studentLimit,totals);
}

@override
String toString() {
    return 'PaperQuestionStats(items: $items, studentLimit: $studentLimit, totals: $totals)';
}


}

/// @nodoc
abstract mixin class _$PaperQuestionStatsCopyWith<$Res> implements $PaperQuestionStatsCopyWith<$Res> {
  factory _$PaperQuestionStatsCopyWith(_PaperQuestionStats value, $Res Function(_PaperQuestionStats) _then) = __$PaperQuestionStatsCopyWithImpl;
@override @useResult
$Res call({
 List<QuestionStat> items,@JsonKey(name: 'student_limit') int studentLimit,@JsonKey(name: 'stats') QuestionStatsTotals totals
});


@override $QuestionStatsTotalsCopyWith<$Res> get totals;

}
/// @nodoc
class __$PaperQuestionStatsCopyWithImpl<$Res>
    implements _$PaperQuestionStatsCopyWith<$Res> {
  __$PaperQuestionStatsCopyWithImpl(this._self, this._then);

  final _PaperQuestionStats _self;
  final $Res Function(_PaperQuestionStats) _then;

/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? studentLimit = null,Object? totals = null,}) {
  return _then(_PaperQuestionStats(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<QuestionStat>,studentLimit: null == studentLimit ? _self.studentLimit : studentLimit // ignore: cast_nullable_to_non_nullable
as int,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as QuestionStatsTotals,
  ));
}

/// Create a copy of PaperQuestionStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionStatsTotalsCopyWith<$Res> get totals {
  
  return $QuestionStatsTotalsCopyWith<$Res>(_self.totals, (value) {
    return _then(_self.copyWith(totals: value));
  });
}
}

// dart format on
