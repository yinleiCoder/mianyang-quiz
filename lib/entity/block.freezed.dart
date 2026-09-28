// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
Block _$BlockFromJson(
  Map<String, dynamic> json
) {
        switch (json['t']) {
                  case 'text':
          return TextBlock.fromJson(
            json
          );
                case 'media':
          return MediaBlock.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  't',
  'Block',
  'Invalid union type "${json['t']}"!'
);
        }
      
}

/// @nodoc
mixin _$Block {



  /// Serializes this Block to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Block);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'Block()';
}


}

/// @nodoc
class $BlockCopyWith<$Res>  {
$BlockCopyWith(Block _, $Res Function(Block) __);
}


/// Adds pattern-matching-related methods to [Block].
extension BlockPatterns on Block {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextBlock value)?  text,TResult Function( MediaBlock value)?  media,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextBlock() when text != null:
return text(_that);case MediaBlock() when media != null:
return media(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextBlock value)  text,required TResult Function( MediaBlock value)  media,}){
final _that = this;
switch (_that) {
case TextBlock():
return text(_that);case MediaBlock():
return media(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextBlock value)?  text,TResult? Function( MediaBlock value)?  media,}){
final _that = this;
switch (_that) {
case TextBlock() when text != null:
return text(_that);case MediaBlock() when media != null:
return media(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( String kind,  String key,  String? url,  String? alt)?  media,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextBlock() when text != null:
return text(_that.text);case MediaBlock() when media != null:
return media(_that.kind,_that.key,_that.url,_that.alt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( String kind,  String key,  String? url,  String? alt)  media,}) {final _that = this;
switch (_that) {
case TextBlock():
return text(_that.text);case MediaBlock():
return media(_that.kind,_that.key,_that.url,_that.alt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( String kind,  String key,  String? url,  String? alt)?  media,}) {final _that = this;
switch (_that) {
case TextBlock() when text != null:
return text(_that.text);case MediaBlock() when media != null:
return media(_that.kind,_that.key,_that.url,_that.alt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextBlock implements Block {
  const TextBlock({required this.text,  String? $type}): $type = $type ?? 'text';
  factory TextBlock.fromJson(Map<String, dynamic> json) => _$TextBlockFromJson(json);

 final  String text;

@JsonKey(name: 't')
final String $type;


/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextBlockCopyWith<TextBlock> get copyWith => _$TextBlockCopyWithImpl<TextBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextBlockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TextBlock&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text);
}

@override
String toString() {
    return 'Block.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $TextBlockCopyWith<$Res> implements $BlockCopyWith<$Res> {
  factory $TextBlockCopyWith(TextBlock value, $Res Function(TextBlock) _then) = _$TextBlockCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$TextBlockCopyWithImpl<$Res>
    implements $TextBlockCopyWith<$Res> {
  _$TextBlockCopyWithImpl(this._self, this._then);

  final TextBlock _self;
  final $Res Function(TextBlock) _then;

/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(TextBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MediaBlock implements Block {
  const MediaBlock({required this.kind, required this.key, this.url, this.alt,  String? $type}): $type = $type ?? 'media';
  factory MediaBlock.fromJson(Map<String, dynamic> json) => _$MediaBlockFromJson(json);

 final  String kind;
 final  String key;
 final  String? url;
 final  String? alt;

@JsonKey(name: 't')
final String $type;


/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaBlockCopyWith<MediaBlock> get copyWith => _$MediaBlockCopyWithImpl<MediaBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaBlockToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaBlock&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.key, key) || other.key == key)&&(identical(other.url, url) || other.url == url)&&(identical(other.alt, alt) || other.alt == alt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,key,url,alt);
}

@override
String toString() {
    return 'Block.media(kind: $kind, key: $key, url: $url, alt: $alt)';
}


}

/// @nodoc
abstract mixin class $MediaBlockCopyWith<$Res> implements $BlockCopyWith<$Res> {
  factory $MediaBlockCopyWith(MediaBlock value, $Res Function(MediaBlock) _then) = _$MediaBlockCopyWithImpl;
@useResult
$Res call({
 String kind, String key, String? url, String? alt
});




}
/// @nodoc
class _$MediaBlockCopyWithImpl<$Res>
    implements $MediaBlockCopyWith<$Res> {
  _$MediaBlockCopyWithImpl(this._self, this._then);

  final MediaBlock _self;
  final $Res Function(MediaBlock) _then;

/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? key = null,Object? url = freezed,Object? alt = freezed,}) {
  return _then(MediaBlock(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,alt: freezed == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
