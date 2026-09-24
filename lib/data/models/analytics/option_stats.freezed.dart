// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OptionStudent {

@JsonKey(name: 'user_id') String get userId; String get name;@JsonKey(name: 'class_name') String? get className;
/// Create a copy of OptionStudent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionStudentCopyWith<OptionStudent> get copyWith => _$OptionStudentCopyWithImpl<OptionStudent>(this as OptionStudent, _$identity);

  /// Serializes this OptionStudent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OptionStudent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionStudent&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.className, _this.className) || other.className == _this.className));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OptionStudent;
  return Object.hash(runtimeType,_this.userId,_this.name,_this.className);
}

@override
String toString() {
  final _this = this as OptionStudent;
  return 'OptionStudent(userId: ${_this.userId}, name: ${_this.name}, className: ${_this.className})';
}


}

/// @nodoc
abstract mixin class $OptionStudentCopyWith<$Res>  {
  factory $OptionStudentCopyWith(OptionStudent value, $Res Function(OptionStudent) _then) = _$OptionStudentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'class_name') String? className
});




}
/// @nodoc
class _$OptionStudentCopyWithImpl<$Res>
    implements $OptionStudentCopyWith<$Res> {
  _$OptionStudentCopyWithImpl(this._self, this._then);

  final OptionStudent _self;
  final $Res Function(OptionStudent) _then;

/// Create a copy of OptionStudent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? name = null,Object? className = freezed,}) {
  return _then(OptionStudent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionStudent].
extension OptionStudentPatterns on OptionStudent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionStudent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionStudent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionStudent value)  $default,){
final _that = this;
switch (_that) {
case _OptionStudent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionStudent value)?  $default,){
final _that = this;
switch (_that) {
case _OptionStudent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionStudent() when $default != null:
return $default(_that.userId,_that.name,_that.className);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className)  $default,) {final _that = this;
switch (_that) {
case _OptionStudent():
return $default(_that.userId,_that.name,_that.className);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  String name, @JsonKey(name: 'class_name')  String? className)?  $default,) {final _that = this;
switch (_that) {
case _OptionStudent() when $default != null:
return $default(_that.userId,_that.name,_that.className);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OptionStudent implements OptionStudent {
  const _OptionStudent({@JsonKey(name: 'user_id') required this.userId, this.name = '', @JsonKey(name: 'class_name') this.className});
  factory _OptionStudent.fromJson(Map<String, dynamic> json) => _$OptionStudentFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'class_name') final  String? className;

/// Create a copy of OptionStudent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionStudentCopyWith<_OptionStudent> get copyWith => __$OptionStudentCopyWithImpl<_OptionStudent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OptionStudentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionStudent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,name,className);
}

@override
String toString() {
    return 'OptionStudent(userId: $userId, name: $name, className: $className)';
}


}

/// @nodoc
abstract mixin class _$OptionStudentCopyWith<$Res> implements $OptionStudentCopyWith<$Res> {
  factory _$OptionStudentCopyWith(_OptionStudent value, $Res Function(_OptionStudent) _then) = __$OptionStudentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, String name,@JsonKey(name: 'class_name') String? className
});




}
/// @nodoc
class __$OptionStudentCopyWithImpl<$Res>
    implements _$OptionStudentCopyWith<$Res> {
  __$OptionStudentCopyWithImpl(this._self, this._then);

  final _OptionStudent _self;
  final $Res Function(_OptionStudent) _then;

/// Create a copy of OptionStudent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? name = null,Object? className = freezed,}) {
  return _then(_OptionStudent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: freezed == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuestionOptionStat {

 String get key; String get text;@JsonKey(name: 'is_answer') bool get isAnswer; int get count; List<OptionStudent> get students;@JsonKey(name: 'students_truncated') bool get studentsTruncated;
/// Create a copy of QuestionOptionStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionOptionStatCopyWith<QuestionOptionStat> get copyWith => _$QuestionOptionStatCopyWithImpl<QuestionOptionStat>(this as QuestionOptionStat, _$identity);

  /// Serializes this QuestionOptionStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionOptionStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionOptionStat&&(identical(other.key, _this.key) || other.key == _this.key)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.isAnswer, _this.isAnswer) || other.isAnswer == _this.isAnswer)&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.students, _this.students)&&(identical(other.studentsTruncated, _this.studentsTruncated) || other.studentsTruncated == _this.studentsTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionOptionStat;
  return Object.hash(runtimeType,_this.key,_this.text,_this.isAnswer,_this.count,const DeepCollectionEquality().hash(_this.students),_this.studentsTruncated);
}

@override
String toString() {
  final _this = this as QuestionOptionStat;
  return 'QuestionOptionStat(key: ${_this.key}, text: ${_this.text}, isAnswer: ${_this.isAnswer}, count: ${_this.count}, students: ${_this.students}, studentsTruncated: ${_this.studentsTruncated})';
}


}

/// @nodoc
abstract mixin class $QuestionOptionStatCopyWith<$Res>  {
  factory $QuestionOptionStatCopyWith(QuestionOptionStat value, $Res Function(QuestionOptionStat) _then) = _$QuestionOptionStatCopyWithImpl;
@useResult
$Res call({
 String key, String text,@JsonKey(name: 'is_answer') bool isAnswer, int count, List<OptionStudent> students,@JsonKey(name: 'students_truncated') bool studentsTruncated
});




}
/// @nodoc
class _$QuestionOptionStatCopyWithImpl<$Res>
    implements $QuestionOptionStatCopyWith<$Res> {
  _$QuestionOptionStatCopyWithImpl(this._self, this._then);

  final QuestionOptionStat _self;
  final $Res Function(QuestionOptionStat) _then;

/// Create a copy of QuestionOptionStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? text = null,Object? isAnswer = null,Object? count = null,Object? students = null,Object? studentsTruncated = null,}) {
  return _then(QuestionOptionStat(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isAnswer: null == isAnswer ? _self.isAnswer : isAnswer // ignore: cast_nullable_to_non_nullable
as bool,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,students: null == students ? _self.students : students // ignore: cast_nullable_to_non_nullable
as List<OptionStudent>,studentsTruncated: null == studentsTruncated ? _self.studentsTruncated : studentsTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionOptionStat].
extension QuestionOptionStatPatterns on QuestionOptionStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionOptionStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionOptionStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionOptionStat value)  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionOptionStat value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionOptionStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String text, @JsonKey(name: 'is_answer')  bool isAnswer,  int count,  List<OptionStudent> students, @JsonKey(name: 'students_truncated')  bool studentsTruncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionOptionStat() when $default != null:
return $default(_that.key,_that.text,_that.isAnswer,_that.count,_that.students,_that.studentsTruncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String text, @JsonKey(name: 'is_answer')  bool isAnswer,  int count,  List<OptionStudent> students, @JsonKey(name: 'students_truncated')  bool studentsTruncated)  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionStat():
return $default(_that.key,_that.text,_that.isAnswer,_that.count,_that.students,_that.studentsTruncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String text, @JsonKey(name: 'is_answer')  bool isAnswer,  int count,  List<OptionStudent> students, @JsonKey(name: 'students_truncated')  bool studentsTruncated)?  $default,) {final _that = this;
switch (_that) {
case _QuestionOptionStat() when $default != null:
return $default(_that.key,_that.text,_that.isAnswer,_that.count,_that.students,_that.studentsTruncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionOptionStat implements QuestionOptionStat {
  const _QuestionOptionStat({required this.key, this.text = '', @JsonKey(name: 'is_answer') this.isAnswer = false, this.count = 0,  List<OptionStudent> students = const <OptionStudent>[], @JsonKey(name: 'students_truncated') this.studentsTruncated = false}): _students = students;
  factory _QuestionOptionStat.fromJson(Map<String, dynamic> json) => _$QuestionOptionStatFromJson(json);

@override final  String key;
@override@JsonKey() final  String text;
@override@JsonKey(name: 'is_answer') final  bool isAnswer;
@override@JsonKey() final  int count;
 final  List<OptionStudent> _students;
@override@JsonKey() List<OptionStudent> get students {
  if (_students is EqualUnmodifiableListView) return _students;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_students);
}

@override@JsonKey(name: 'students_truncated') final  bool studentsTruncated;

/// Create a copy of QuestionOptionStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionOptionStatCopyWith<_QuestionOptionStat> get copyWith => __$QuestionOptionStatCopyWithImpl<_QuestionOptionStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionOptionStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionOptionStat&&(identical(other.key, key) || other.key == key)&&(identical(other.text, text) || other.text == text)&&(identical(other.isAnswer, isAnswer) || other.isAnswer == isAnswer)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.students, _students)&&(identical(other.studentsTruncated, studentsTruncated) || other.studentsTruncated == studentsTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,text,isAnswer,count,const DeepCollectionEquality().hash(_students),studentsTruncated);
}

@override
String toString() {
    return 'QuestionOptionStat(key: $key, text: $text, isAnswer: $isAnswer, count: $count, students: $students, studentsTruncated: $studentsTruncated)';
}


}

/// @nodoc
abstract mixin class _$QuestionOptionStatCopyWith<$Res> implements $QuestionOptionStatCopyWith<$Res> {
  factory _$QuestionOptionStatCopyWith(_QuestionOptionStat value, $Res Function(_QuestionOptionStat) _then) = __$QuestionOptionStatCopyWithImpl;
@override @useResult
$Res call({
 String key, String text,@JsonKey(name: 'is_answer') bool isAnswer, int count, List<OptionStudent> students,@JsonKey(name: 'students_truncated') bool studentsTruncated
});




}
/// @nodoc
class __$QuestionOptionStatCopyWithImpl<$Res>
    implements _$QuestionOptionStatCopyWith<$Res> {
  __$QuestionOptionStatCopyWithImpl(this._self, this._then);

  final _QuestionOptionStat _self;
  final $Res Function(_QuestionOptionStat) _then;

/// Create a copy of QuestionOptionStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? text = null,Object? isAnswer = null,Object? count = null,Object? students = null,Object? studentsTruncated = null,}) {
  return _then(_QuestionOptionStat(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isAnswer: null == isAnswer ? _self.isAnswer : isAnswer // ignore: cast_nullable_to_non_nullable
as bool,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,students: null == students ? _self._students : students // ignore: cast_nullable_to_non_nullable
as List<OptionStudent>,studentsTruncated: null == studentsTruncated ? _self.studentsTruncated : studentsTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TextCount {

 String get text; int get count;
/// Create a copy of TextCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextCountCopyWith<TextCount> get copyWith => _$TextCountCopyWithImpl<TextCount>(this as TextCount, _$identity);

  /// Serializes this TextCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TextCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextCount&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TextCount;
  return Object.hash(runtimeType,_this.text,_this.count);
}

@override
String toString() {
  final _this = this as TextCount;
  return 'TextCount(text: ${_this.text}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $TextCountCopyWith<$Res>  {
  factory $TextCountCopyWith(TextCount value, $Res Function(TextCount) _then) = _$TextCountCopyWithImpl;
@useResult
$Res call({
 String text, int count
});




}
/// @nodoc
class _$TextCountCopyWithImpl<$Res>
    implements $TextCountCopyWith<$Res> {
  _$TextCountCopyWithImpl(this._self, this._then);

  final TextCount _self;
  final $Res Function(TextCount) _then;

/// Create a copy of TextCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? count = null,}) {
  return _then(TextCount(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TextCount].
extension TextCountPatterns on TextCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextCount value)  $default,){
final _that = this;
switch (_that) {
case _TextCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextCount value)?  $default,){
final _that = this;
switch (_that) {
case _TextCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextCount() when $default != null:
return $default(_that.text,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  int count)  $default,) {final _that = this;
switch (_that) {
case _TextCount():
return $default(_that.text,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  int count)?  $default,) {final _that = this;
switch (_that) {
case _TextCount() when $default != null:
return $default(_that.text,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextCount implements TextCount {
  const _TextCount({this.text = '', this.count = 0});
  factory _TextCount.fromJson(Map<String, dynamic> json) => _$TextCountFromJson(json);

@override@JsonKey() final  String text;
@override@JsonKey() final  int count;

/// Create a copy of TextCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextCountCopyWith<_TextCount> get copyWith => __$TextCountCopyWithImpl<_TextCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextCount&&(identical(other.text, text) || other.text == text)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,count);
}

@override
String toString() {
    return 'TextCount(text: $text, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TextCountCopyWith<$Res> implements $TextCountCopyWith<$Res> {
  factory _$TextCountCopyWith(_TextCount value, $Res Function(_TextCount) _then) = __$TextCountCopyWithImpl;
@override @useResult
$Res call({
 String text, int count
});




}
/// @nodoc
class __$TextCountCopyWithImpl<$Res>
    implements _$TextCountCopyWith<$Res> {
  __$TextCountCopyWithImpl(this._self, this._then);

  final _TextCount _self;
  final $Res Function(_TextCount) _then;

/// Create a copy of TextCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? count = null,}) {
  return _then(_TextCount(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
