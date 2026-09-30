// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgetting_curve.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForgettingBucket {

/// 该桶的代表间隔天数（x 轴位置）。服务端给的就是档位本身，不是区间中点。
 int get days;/// 落在这个桶里的作答次数（分母）。
 int get attempts;/// 其中答对的次数（分子）。
 int get correct;
/// Create a copy of ForgettingBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgettingBucketCopyWith<ForgettingBucket> get copyWith => _$ForgettingBucketCopyWithImpl<ForgettingBucket>(this as ForgettingBucket, _$identity);

  /// Serializes this ForgettingBucket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ForgettingBucket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgettingBucket&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ForgettingBucket;
  return Object.hash(runtimeType,_this.days,_this.attempts,_this.correct);
}

@override
String toString() {
  final _this = this as ForgettingBucket;
  return 'ForgettingBucket(days: ${_this.days}, attempts: ${_this.attempts}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $ForgettingBucketCopyWith<$Res>  {
  factory $ForgettingBucketCopyWith(ForgettingBucket value, $Res Function(ForgettingBucket) _then) = _$ForgettingBucketCopyWithImpl;
@useResult
$Res call({
 int days, int attempts, int correct
});




}
/// @nodoc
class _$ForgettingBucketCopyWithImpl<$Res>
    implements $ForgettingBucketCopyWith<$Res> {
  _$ForgettingBucketCopyWithImpl(this._self, this._then);

  final ForgettingBucket _self;
  final $Res Function(ForgettingBucket) _then;

/// Create a copy of ForgettingBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,Object? attempts = null,Object? correct = null,}) {
  return _then(ForgettingBucket(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ForgettingBucket].
extension ForgettingBucketPatterns on ForgettingBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForgettingBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForgettingBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForgettingBucket value)  $default,){
final _that = this;
switch (_that) {
case _ForgettingBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForgettingBucket value)?  $default,){
final _that = this;
switch (_that) {
case _ForgettingBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int days,  int attempts,  int correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForgettingBucket() when $default != null:
return $default(_that.days,_that.attempts,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int days,  int attempts,  int correct)  $default,) {final _that = this;
switch (_that) {
case _ForgettingBucket():
return $default(_that.days,_that.attempts,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int days,  int attempts,  int correct)?  $default,) {final _that = this;
switch (_that) {
case _ForgettingBucket() when $default != null:
return $default(_that.days,_that.attempts,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ForgettingBucket implements ForgettingBucket {
  const _ForgettingBucket({this.days = 0, this.attempts = 0, this.correct = 0});
  factory _ForgettingBucket.fromJson(Map<String, dynamic> json) => _$ForgettingBucketFromJson(json);

/// 该桶的代表间隔天数（x 轴位置）。服务端给的就是档位本身，不是区间中点。
@override@JsonKey() final  int days;
/// 落在这个桶里的作答次数（分母）。
@override@JsonKey() final  int attempts;
/// 其中答对的次数（分子）。
@override@JsonKey() final  int correct;

/// Create a copy of ForgettingBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgettingBucketCopyWith<_ForgettingBucket> get copyWith => __$ForgettingBucketCopyWithImpl<_ForgettingBucket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForgettingBucketToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgettingBucket&&(identical(other.days, days) || other.days == days)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,days,attempts,correct);
}

@override
String toString() {
    return 'ForgettingBucket(days: $days, attempts: $attempts, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$ForgettingBucketCopyWith<$Res> implements $ForgettingBucketCopyWith<$Res> {
  factory _$ForgettingBucketCopyWith(_ForgettingBucket value, $Res Function(_ForgettingBucket) _then) = __$ForgettingBucketCopyWithImpl;
@override @useResult
$Res call({
 int days, int attempts, int correct
});




}
/// @nodoc
class __$ForgettingBucketCopyWithImpl<$Res>
    implements _$ForgettingBucketCopyWith<$Res> {
  __$ForgettingBucketCopyWithImpl(this._self, this._then);

  final _ForgettingBucket _self;
  final $Res Function(_ForgettingBucket) _then;

/// Create a copy of ForgettingBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,Object? attempts = null,Object? correct = null,}) {
  return _then(_ForgettingBucket(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
