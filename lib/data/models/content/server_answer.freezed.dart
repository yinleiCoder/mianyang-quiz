// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
ServerAnswer _$ServerAnswerFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'choice':
          return ChoiceServerAnswer.fromJson(
            json
          );
                case 'tf':
          return TrueFalseServerAnswer.fromJson(
            json
          );
                case 'blank':
          return BlankServerAnswer.fromJson(
            json
          );
                case 'text':
          return TextServerAnswer.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ServerAnswer',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ServerAnswer {



  /// Serializes this ServerAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAnswer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ServerAnswer()';
}


}

/// @nodoc
class $ServerAnswerCopyWith<$Res>  {
$ServerAnswerCopyWith(ServerAnswer _, $Res Function(ServerAnswer) __);
}


/// Adds pattern-matching-related methods to [ServerAnswer].
extension ServerAnswerPatterns on ServerAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChoiceServerAnswer value)?  choice,TResult Function( TrueFalseServerAnswer value)?  trueFalse,TResult Function( BlankServerAnswer value)?  blank,TResult Function( TextServerAnswer value)?  text,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChoiceServerAnswer() when choice != null:
return choice(_that);case TrueFalseServerAnswer() when trueFalse != null:
return trueFalse(_that);case BlankServerAnswer() when blank != null:
return blank(_that);case TextServerAnswer() when text != null:
return text(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChoiceServerAnswer value)  choice,required TResult Function( TrueFalseServerAnswer value)  trueFalse,required TResult Function( BlankServerAnswer value)  blank,required TResult Function( TextServerAnswer value)  text,}){
final _that = this;
switch (_that) {
case ChoiceServerAnswer():
return choice(_that);case TrueFalseServerAnswer():
return trueFalse(_that);case BlankServerAnswer():
return blank(_that);case TextServerAnswer():
return text(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChoiceServerAnswer value)?  choice,TResult? Function( TrueFalseServerAnswer value)?  trueFalse,TResult? Function( BlankServerAnswer value)?  blank,TResult? Function( TextServerAnswer value)?  text,}){
final _that = this;
switch (_that) {
case ChoiceServerAnswer() when choice != null:
return choice(_that);case TrueFalseServerAnswer() when trueFalse != null:
return trueFalse(_that);case BlankServerAnswer() when blank != null:
return blank(_that);case TextServerAnswer() when text != null:
return text(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<String> keys)?  choice,TResult Function( bool value)?  trueFalse,TResult Function( List<String> values)?  blank,TResult Function( List<String> samples)?  text,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChoiceServerAnswer() when choice != null:
return choice(_that.keys);case TrueFalseServerAnswer() when trueFalse != null:
return trueFalse(_that.value);case BlankServerAnswer() when blank != null:
return blank(_that.values);case TextServerAnswer() when text != null:
return text(_that.samples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<String> keys)  choice,required TResult Function( bool value)  trueFalse,required TResult Function( List<String> values)  blank,required TResult Function( List<String> samples)  text,}) {final _that = this;
switch (_that) {
case ChoiceServerAnswer():
return choice(_that.keys);case TrueFalseServerAnswer():
return trueFalse(_that.value);case BlankServerAnswer():
return blank(_that.values);case TextServerAnswer():
return text(_that.samples);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<String> keys)?  choice,TResult? Function( bool value)?  trueFalse,TResult? Function( List<String> values)?  blank,TResult? Function( List<String> samples)?  text,}) {final _that = this;
switch (_that) {
case ChoiceServerAnswer() when choice != null:
return choice(_that.keys);case TrueFalseServerAnswer() when trueFalse != null:
return trueFalse(_that.value);case BlankServerAnswer() when blank != null:
return blank(_that.values);case TextServerAnswer() when text != null:
return text(_that.samples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ChoiceServerAnswer implements ServerAnswer {
  const ChoiceServerAnswer({ List<String> keys = const <String>[],  String? $type}): _keys = keys,$type = $type ?? 'choice';
  factory ChoiceServerAnswer.fromJson(Map<String, dynamic> json) => _$ChoiceServerAnswerFromJson(json);

 final  List<String> _keys;
@JsonKey() List<String> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceServerAnswerCopyWith<ChoiceServerAnswer> get copyWith => _$ChoiceServerAnswerCopyWithImpl<ChoiceServerAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoiceServerAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceServerAnswer&&const DeepCollectionEquality().equals(other.keys, _keys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_keys));
}

@override
String toString() {
    return 'ServerAnswer.choice(keys: $keys)';
}


}

/// @nodoc
abstract mixin class $ChoiceServerAnswerCopyWith<$Res> implements $ServerAnswerCopyWith<$Res> {
  factory $ChoiceServerAnswerCopyWith(ChoiceServerAnswer value, $Res Function(ChoiceServerAnswer) _then) = _$ChoiceServerAnswerCopyWithImpl;
@useResult
$Res call({
 List<String> keys
});




}
/// @nodoc
class _$ChoiceServerAnswerCopyWithImpl<$Res>
    implements $ChoiceServerAnswerCopyWith<$Res> {
  _$ChoiceServerAnswerCopyWithImpl(this._self, this._then);

  final ChoiceServerAnswer _self;
  final $Res Function(ChoiceServerAnswer) _then;

/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? keys = null,}) {
  return _then(ChoiceServerAnswer(
keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TrueFalseServerAnswer implements ServerAnswer {
  const TrueFalseServerAnswer({required this.value,  String? $type}): $type = $type ?? 'tf';
  factory TrueFalseServerAnswer.fromJson(Map<String, dynamic> json) => _$TrueFalseServerAnswerFromJson(json);

 final  bool value;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrueFalseServerAnswerCopyWith<TrueFalseServerAnswer> get copyWith => _$TrueFalseServerAnswerCopyWithImpl<TrueFalseServerAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrueFalseServerAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TrueFalseServerAnswer&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'ServerAnswer.trueFalse(value: $value)';
}


}

/// @nodoc
abstract mixin class $TrueFalseServerAnswerCopyWith<$Res> implements $ServerAnswerCopyWith<$Res> {
  factory $TrueFalseServerAnswerCopyWith(TrueFalseServerAnswer value, $Res Function(TrueFalseServerAnswer) _then) = _$TrueFalseServerAnswerCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$TrueFalseServerAnswerCopyWithImpl<$Res>
    implements $TrueFalseServerAnswerCopyWith<$Res> {
  _$TrueFalseServerAnswerCopyWithImpl(this._self, this._then);

  final TrueFalseServerAnswer _self;
  final $Res Function(TrueFalseServerAnswer) _then;

/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(TrueFalseServerAnswer(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BlankServerAnswer implements ServerAnswer {
  const BlankServerAnswer({ List<String> values = const <String>[],  String? $type}): _values = values,$type = $type ?? 'blank';
  factory BlankServerAnswer.fromJson(Map<String, dynamic> json) => _$BlankServerAnswerFromJson(json);

 final  List<String> _values;
@JsonKey() List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlankServerAnswerCopyWith<BlankServerAnswer> get copyWith => _$BlankServerAnswerCopyWithImpl<BlankServerAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlankServerAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BlankServerAnswer&&const DeepCollectionEquality().equals(other.values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));
}

@override
String toString() {
    return 'ServerAnswer.blank(values: $values)';
}


}

/// @nodoc
abstract mixin class $BlankServerAnswerCopyWith<$Res> implements $ServerAnswerCopyWith<$Res> {
  factory $BlankServerAnswerCopyWith(BlankServerAnswer value, $Res Function(BlankServerAnswer) _then) = _$BlankServerAnswerCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$BlankServerAnswerCopyWithImpl<$Res>
    implements $BlankServerAnswerCopyWith<$Res> {
  _$BlankServerAnswerCopyWithImpl(this._self, this._then);

  final BlankServerAnswer _self;
  final $Res Function(BlankServerAnswer) _then;

/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(BlankServerAnswer(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TextServerAnswer implements ServerAnswer {
  const TextServerAnswer({ List<String> samples = const <String>[],  String? $type}): _samples = samples,$type = $type ?? 'text';
  factory TextServerAnswer.fromJson(Map<String, dynamic> json) => _$TextServerAnswerFromJson(json);

 final  List<String> _samples;
@JsonKey() List<String> get samples {
  if (_samples is EqualUnmodifiableListView) return _samples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_samples);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextServerAnswerCopyWith<TextServerAnswer> get copyWith => _$TextServerAnswerCopyWithImpl<TextServerAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextServerAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextServerAnswer&&const DeepCollectionEquality().equals(other.samples, _samples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_samples));
}

@override
String toString() {
    return 'ServerAnswer.text(samples: $samples)';
}


}

/// @nodoc
abstract mixin class $TextServerAnswerCopyWith<$Res> implements $ServerAnswerCopyWith<$Res> {
  factory $TextServerAnswerCopyWith(TextServerAnswer value, $Res Function(TextServerAnswer) _then) = _$TextServerAnswerCopyWithImpl;
@useResult
$Res call({
 List<String> samples
});




}
/// @nodoc
class _$TextServerAnswerCopyWithImpl<$Res>
    implements $TextServerAnswerCopyWith<$Res> {
  _$TextServerAnswerCopyWithImpl(this._self, this._then);

  final TextServerAnswer _self;
  final $Res Function(TextServerAnswer) _then;

/// Create a copy of ServerAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? samples = null,}) {
  return _then(TextServerAnswer(
samples: null == samples ? _self._samples : samples // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
