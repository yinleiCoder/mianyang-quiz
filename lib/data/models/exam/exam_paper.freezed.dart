// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_paper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamItem {

/// paper_items.id。**作答按它索引**（不是 question_id——同一份卷里题目不重复，
/// 但跨版本复用时 question_id 可能相同而题项不同）。
 String get id; int get seq; String get qtype; int? get difficulty; double get score;/// 计分点明细：[3] / [2,2,2,2] / [3,3,4]。长度就是"这题有几个给分点"，
/// 阅卷按它逐点给分，填空题答对几空就得几个点的分。
@JsonKey(name: 'score_units') List<double> get scoreUnits; QuestionContent get content;
/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamItemCopyWith<ExamItem> get copyWith => _$ExamItemCopyWithImpl<ExamItem>(this as ExamItem, _$identity);

  /// Serializes this ExamItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.qtype, _this.qtype) || other.qtype == _this.qtype)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.score, _this.score) || other.score == _this.score)&&const DeepCollectionEquality().equals(other.scoreUnits, _this.scoreUnits)&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamItem;
  return Object.hash(runtimeType,_this.id,_this.seq,_this.qtype,_this.difficulty,_this.score,const DeepCollectionEquality().hash(_this.scoreUnits),_this.content);
}

@override
String toString() {
  final _this = this as ExamItem;
  return 'ExamItem(id: ${_this.id}, seq: ${_this.seq}, qtype: ${_this.qtype}, difficulty: ${_this.difficulty}, score: ${_this.score}, scoreUnits: ${_this.scoreUnits}, content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $ExamItemCopyWith<$Res>  {
  factory $ExamItemCopyWith(ExamItem value, $Res Function(ExamItem) _then) = _$ExamItemCopyWithImpl;
@useResult
$Res call({
 String id, int seq, String qtype, int? difficulty, double score,@JsonKey(name: 'score_units') List<double> scoreUnits, QuestionContent content
});


$QuestionContentCopyWith<$Res> get content;

}
/// @nodoc
class _$ExamItemCopyWithImpl<$Res>
    implements $ExamItemCopyWith<$Res> {
  _$ExamItemCopyWithImpl(this._self, this._then);

  final ExamItem _self;
  final $Res Function(ExamItem) _then;

/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seq = null,Object? qtype = null,Object? difficulty = freezed,Object? score = null,Object? scoreUnits = null,Object? content = null,}) {
  return _then(ExamItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,scoreUnits: null == scoreUnits ? _self.scoreUnits : scoreUnits // ignore: cast_nullable_to_non_nullable
as List<double>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as QuestionContent,
  ));
}
/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionContentCopyWith<$Res> get content {
  
  return $QuestionContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExamItem].
extension ExamItemPatterns on ExamItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamItem value)  $default,){
final _that = this;
switch (_that) {
case _ExamItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamItem value)?  $default,){
final _that = this;
switch (_that) {
case _ExamItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int seq,  String qtype,  int? difficulty,  double score, @JsonKey(name: 'score_units')  List<double> scoreUnits,  QuestionContent content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamItem() when $default != null:
return $default(_that.id,_that.seq,_that.qtype,_that.difficulty,_that.score,_that.scoreUnits,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int seq,  String qtype,  int? difficulty,  double score, @JsonKey(name: 'score_units')  List<double> scoreUnits,  QuestionContent content)  $default,) {final _that = this;
switch (_that) {
case _ExamItem():
return $default(_that.id,_that.seq,_that.qtype,_that.difficulty,_that.score,_that.scoreUnits,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int seq,  String qtype,  int? difficulty,  double score, @JsonKey(name: 'score_units')  List<double> scoreUnits,  QuestionContent content)?  $default,) {final _that = this;
switch (_that) {
case _ExamItem() when $default != null:
return $default(_that.id,_that.seq,_that.qtype,_that.difficulty,_that.score,_that.scoreUnits,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamItem implements ExamItem {
  const _ExamItem({required this.id, required this.seq, required this.qtype, this.difficulty, this.score = 0, @JsonKey(name: 'score_units')  List<double> scoreUnits = const <double>[0], required this.content}): _scoreUnits = scoreUnits;
  factory _ExamItem.fromJson(Map<String, dynamic> json) => _$ExamItemFromJson(json);

/// paper_items.id。**作答按它索引**（不是 question_id——同一份卷里题目不重复，
/// 但跨版本复用时 question_id 可能相同而题项不同）。
@override final  String id;
@override final  int seq;
@override final  String qtype;
@override final  int? difficulty;
@override@JsonKey() final  double score;
/// 计分点明细：[3] / [2,2,2,2] / [3,3,4]。长度就是"这题有几个给分点"，
/// 阅卷按它逐点给分，填空题答对几空就得几个点的分。
 final  List<double> _scoreUnits;
/// 计分点明细：[3] / [2,2,2,2] / [3,3,4]。长度就是"这题有几个给分点"，
/// 阅卷按它逐点给分，填空题答对几空就得几个点的分。
@override@JsonKey(name: 'score_units') List<double> get scoreUnits {
  if (_scoreUnits is EqualUnmodifiableListView) return _scoreUnits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scoreUnits);
}

@override final  QuestionContent content;

/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamItemCopyWith<_ExamItem> get copyWith => __$ExamItemCopyWithImpl<_ExamItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamItem&&(identical(other.id, id) || other.id == id)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.qtype, qtype) || other.qtype == qtype)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.scoreUnits, _scoreUnits)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,seq,qtype,difficulty,score,const DeepCollectionEquality().hash(_scoreUnits),content);
}

@override
String toString() {
    return 'ExamItem(id: $id, seq: $seq, qtype: $qtype, difficulty: $difficulty, score: $score, scoreUnits: $scoreUnits, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ExamItemCopyWith<$Res> implements $ExamItemCopyWith<$Res> {
  factory _$ExamItemCopyWith(_ExamItem value, $Res Function(_ExamItem) _then) = __$ExamItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int seq, String qtype, int? difficulty, double score,@JsonKey(name: 'score_units') List<double> scoreUnits, QuestionContent content
});


@override $QuestionContentCopyWith<$Res> get content;

}
/// @nodoc
class __$ExamItemCopyWithImpl<$Res>
    implements _$ExamItemCopyWith<$Res> {
  __$ExamItemCopyWithImpl(this._self, this._then);

  final _ExamItem _self;
  final $Res Function(_ExamItem) _then;

/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seq = null,Object? qtype = null,Object? difficulty = freezed,Object? score = null,Object? scoreUnits = null,Object? content = null,}) {
  return _then(_ExamItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,qtype: null == qtype ? _self.qtype : qtype // ignore: cast_nullable_to_non_nullable
as String,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int?,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,scoreUnits: null == scoreUnits ? _self._scoreUnits : scoreUnits // ignore: cast_nullable_to_non_nullable
as List<double>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as QuestionContent,
  ));
}

/// Create a copy of ExamItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionContentCopyWith<$Res> get content {
  
  return $QuestionContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$ExamSection {

 String get id;@JsonKey(name: 'sort_order') int get sortOrder;/// 中文序号（一、二、…），服务端算好的，别在客户端再写一套。
@JsonKey(name: 'seq_label') String get seqLabel; String? get title;/// 大题作答说明（「本大题共 10 小题，每题 2 分」）。
 String? get instruction;@JsonKey(name: 'section_score') double get sectionScore; List<ExamItem> get items;
/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSectionCopyWith<ExamSection> get copyWith => _$ExamSectionCopyWithImpl<ExamSection>(this as ExamSection, _$identity);

  /// Serializes this ExamSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.seqLabel, _this.seqLabel) || other.seqLabel == _this.seqLabel)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.instruction, _this.instruction) || other.instruction == _this.instruction)&&(identical(other.sectionScore, _this.sectionScore) || other.sectionScore == _this.sectionScore)&&const DeepCollectionEquality().equals(other.items, _this.items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamSection;
  return Object.hash(runtimeType,_this.id,_this.sortOrder,_this.seqLabel,_this.title,_this.instruction,_this.sectionScore,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ExamSection;
  return 'ExamSection(id: ${_this.id}, sortOrder: ${_this.sortOrder}, seqLabel: ${_this.seqLabel}, title: ${_this.title}, instruction: ${_this.instruction}, sectionScore: ${_this.sectionScore}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ExamSectionCopyWith<$Res>  {
  factory $ExamSectionCopyWith(ExamSection value, $Res Function(ExamSection) _then) = _$ExamSectionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'seq_label') String seqLabel, String? title, String? instruction,@JsonKey(name: 'section_score') double sectionScore, List<ExamItem> items
});




}
/// @nodoc
class _$ExamSectionCopyWithImpl<$Res>
    implements $ExamSectionCopyWith<$Res> {
  _$ExamSectionCopyWithImpl(this._self, this._then);

  final ExamSection _self;
  final $Res Function(ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sortOrder = null,Object? seqLabel = null,Object? title = freezed,Object? instruction = freezed,Object? sectionScore = null,Object? items = null,}) {
  return _then(ExamSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,seqLabel: null == seqLabel ? _self.seqLabel : seqLabel // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,sectionScore: null == sectionScore ? _self.sectionScore : sectionScore // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ExamItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSection].
extension ExamSectionPatterns on ExamSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSection value)  $default,){
final _that = this;
switch (_that) {
case _ExamSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'seq_label')  String seqLabel,  String? title,  String? instruction, @JsonKey(name: 'section_score')  double sectionScore,  List<ExamItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.sortOrder,_that.seqLabel,_that.title,_that.instruction,_that.sectionScore,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'seq_label')  String seqLabel,  String? title,  String? instruction, @JsonKey(name: 'section_score')  double sectionScore,  List<ExamItem> items)  $default,) {final _that = this;
switch (_that) {
case _ExamSection():
return $default(_that.id,_that.sortOrder,_that.seqLabel,_that.title,_that.instruction,_that.sectionScore,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'sort_order')  int sortOrder, @JsonKey(name: 'seq_label')  String seqLabel,  String? title,  String? instruction, @JsonKey(name: 'section_score')  double sectionScore,  List<ExamItem> items)?  $default,) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.sortOrder,_that.seqLabel,_that.title,_that.instruction,_that.sectionScore,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSection implements ExamSection {
  const _ExamSection({required this.id, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'seq_label') this.seqLabel = '', this.title, this.instruction, @JsonKey(name: 'section_score') this.sectionScore = 0,  List<ExamItem> items = const <ExamItem>[]}): _items = items;
  factory _ExamSection.fromJson(Map<String, dynamic> json) => _$ExamSectionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'sort_order') final  int sortOrder;
/// 中文序号（一、二、…），服务端算好的，别在客户端再写一套。
@override@JsonKey(name: 'seq_label') final  String seqLabel;
@override final  String? title;
/// 大题作答说明（「本大题共 10 小题，每题 2 分」）。
@override final  String? instruction;
@override@JsonKey(name: 'section_score') final  double sectionScore;
 final  List<ExamItem> _items;
@override@JsonKey() List<ExamItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSectionCopyWith<_ExamSection> get copyWith => __$ExamSectionCopyWithImpl<_ExamSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSection&&(identical(other.id, id) || other.id == id)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.seqLabel, seqLabel) || other.seqLabel == seqLabel)&&(identical(other.title, title) || other.title == title)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.sectionScore, sectionScore) || other.sectionScore == sectionScore)&&const DeepCollectionEquality().equals(other.items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sortOrder,seqLabel,title,instruction,sectionScore,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ExamSection(id: $id, sortOrder: $sortOrder, seqLabel: $seqLabel, title: $title, instruction: $instruction, sectionScore: $sectionScore, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ExamSectionCopyWith<$Res> implements $ExamSectionCopyWith<$Res> {
  factory _$ExamSectionCopyWith(_ExamSection value, $Res Function(_ExamSection) _then) = __$ExamSectionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'sort_order') int sortOrder,@JsonKey(name: 'seq_label') String seqLabel, String? title, String? instruction,@JsonKey(name: 'section_score') double sectionScore, List<ExamItem> items
});




}
/// @nodoc
class __$ExamSectionCopyWithImpl<$Res>
    implements _$ExamSectionCopyWith<$Res> {
  __$ExamSectionCopyWithImpl(this._self, this._then);

  final _ExamSection _self;
  final $Res Function(_ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sortOrder = null,Object? seqLabel = null,Object? title = freezed,Object? instruction = freezed,Object? sectionScore = null,Object? items = null,}) {
  return _then(_ExamSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,seqLabel: null == seqLabel ? _self.seqLabel : seqLabel // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,instruction: freezed == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String?,sectionScore: null == sectionScore ? _self.sectionScore : sectionScore // ignore: cast_nullable_to_non_nullable
as double,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExamItem>,
  ));
}


}


/// @nodoc
mixin _$ExamPaper {

@JsonKey(name: 'version_id') String get versionId;@JsonKey(name: 'paper_id') String get paperId; String get title;@JsonKey(name: 'exam_name') String? get examName;@JsonKey(name: 'subject_label') String? get subjectLabel;@JsonKey(name: 'duration_minutes') int get durationMinutes;@JsonKey(name: 'total_score') double get totalScore;/// 卷首说明（Block 数组，与题干同一套块模型）。
 List<Block> get instructions; List<ExamSection> get sections;
/// Create a copy of ExamPaper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamPaperCopyWith<ExamPaper> get copyWith => _$ExamPaperCopyWithImpl<ExamPaper>(this as ExamPaper, _$identity);

  /// Serializes this ExamPaper to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamPaper;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamPaper&&(identical(other.versionId, _this.versionId) || other.versionId == _this.versionId)&&(identical(other.paperId, _this.paperId) || other.paperId == _this.paperId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.examName, _this.examName) || other.examName == _this.examName)&&(identical(other.subjectLabel, _this.subjectLabel) || other.subjectLabel == _this.subjectLabel)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.totalScore, _this.totalScore) || other.totalScore == _this.totalScore)&&const DeepCollectionEquality().equals(other.instructions, _this.instructions)&&const DeepCollectionEquality().equals(other.sections, _this.sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamPaper;
  return Object.hash(runtimeType,_this.versionId,_this.paperId,_this.title,_this.examName,_this.subjectLabel,_this.durationMinutes,_this.totalScore,const DeepCollectionEquality().hash(_this.instructions),const DeepCollectionEquality().hash(_this.sections));
}

@override
String toString() {
  final _this = this as ExamPaper;
  return 'ExamPaper(versionId: ${_this.versionId}, paperId: ${_this.paperId}, title: ${_this.title}, examName: ${_this.examName}, subjectLabel: ${_this.subjectLabel}, durationMinutes: ${_this.durationMinutes}, totalScore: ${_this.totalScore}, instructions: ${_this.instructions}, sections: ${_this.sections})';
}


}

/// @nodoc
abstract mixin class $ExamPaperCopyWith<$Res>  {
  factory $ExamPaperCopyWith(ExamPaper value, $Res Function(ExamPaper) _then) = _$ExamPaperCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'version_id') String versionId,@JsonKey(name: 'paper_id') String paperId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'total_score') double totalScore, List<Block> instructions, List<ExamSection> sections
});




}
/// @nodoc
class _$ExamPaperCopyWithImpl<$Res>
    implements $ExamPaperCopyWith<$Res> {
  _$ExamPaperCopyWithImpl(this._self, this._then);

  final ExamPaper _self;
  final $Res Function(ExamPaper) _then;

/// Create a copy of ExamPaper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? versionId = null,Object? paperId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? durationMinutes = null,Object? totalScore = null,Object? instructions = null,Object? sections = null,}) {
  return _then(ExamPaper(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<Block>,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamPaper].
extension ExamPaperPatterns on ExamPaper {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamPaper value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamPaper() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamPaper value)  $default,){
final _that = this;
switch (_that) {
case _ExamPaper():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamPaper value)?  $default,){
final _that = this;
switch (_that) {
case _ExamPaper() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'total_score')  double totalScore,  List<Block> instructions,  List<ExamSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamPaper() when $default != null:
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.durationMinutes,_that.totalScore,_that.instructions,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'total_score')  double totalScore,  List<Block> instructions,  List<ExamSection> sections)  $default,) {final _that = this;
switch (_that) {
case _ExamPaper():
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.durationMinutes,_that.totalScore,_that.instructions,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'version_id')  String versionId, @JsonKey(name: 'paper_id')  String paperId,  String title, @JsonKey(name: 'exam_name')  String? examName, @JsonKey(name: 'subject_label')  String? subjectLabel, @JsonKey(name: 'duration_minutes')  int durationMinutes, @JsonKey(name: 'total_score')  double totalScore,  List<Block> instructions,  List<ExamSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _ExamPaper() when $default != null:
return $default(_that.versionId,_that.paperId,_that.title,_that.examName,_that.subjectLabel,_that.durationMinutes,_that.totalScore,_that.instructions,_that.sections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamPaper implements ExamPaper {
  const _ExamPaper({@JsonKey(name: 'version_id') required this.versionId, @JsonKey(name: 'paper_id') required this.paperId, this.title = '', @JsonKey(name: 'exam_name') this.examName, @JsonKey(name: 'subject_label') this.subjectLabel, @JsonKey(name: 'duration_minutes') this.durationMinutes = 90, @JsonKey(name: 'total_score') this.totalScore = 0,  List<Block> instructions = const <Block>[],  List<ExamSection> sections = const <ExamSection>[]}): _instructions = instructions,_sections = sections;
  factory _ExamPaper.fromJson(Map<String, dynamic> json) => _$ExamPaperFromJson(json);

@override@JsonKey(name: 'version_id') final  String versionId;
@override@JsonKey(name: 'paper_id') final  String paperId;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'exam_name') final  String? examName;
@override@JsonKey(name: 'subject_label') final  String? subjectLabel;
@override@JsonKey(name: 'duration_minutes') final  int durationMinutes;
@override@JsonKey(name: 'total_score') final  double totalScore;
/// 卷首说明（Block 数组，与题干同一套块模型）。
 final  List<Block> _instructions;
/// 卷首说明（Block 数组，与题干同一套块模型）。
@override@JsonKey() List<Block> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

 final  List<ExamSection> _sections;
@override@JsonKey() List<ExamSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of ExamPaper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamPaperCopyWith<_ExamPaper> get copyWith => __$ExamPaperCopyWithImpl<_ExamPaper>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamPaperToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamPaper&&(identical(other.versionId, versionId) || other.versionId == versionId)&&(identical(other.paperId, paperId) || other.paperId == paperId)&&(identical(other.title, title) || other.title == title)&&(identical(other.examName, examName) || other.examName == examName)&&(identical(other.subjectLabel, subjectLabel) || other.subjectLabel == subjectLabel)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&const DeepCollectionEquality().equals(other.instructions, _instructions)&&const DeepCollectionEquality().equals(other.sections, _sections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,versionId,paperId,title,examName,subjectLabel,durationMinutes,totalScore,const DeepCollectionEquality().hash(_instructions),const DeepCollectionEquality().hash(_sections));
}

@override
String toString() {
    return 'ExamPaper(versionId: $versionId, paperId: $paperId, title: $title, examName: $examName, subjectLabel: $subjectLabel, durationMinutes: $durationMinutes, totalScore: $totalScore, instructions: $instructions, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$ExamPaperCopyWith<$Res> implements $ExamPaperCopyWith<$Res> {
  factory _$ExamPaperCopyWith(_ExamPaper value, $Res Function(_ExamPaper) _then) = __$ExamPaperCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'version_id') String versionId,@JsonKey(name: 'paper_id') String paperId, String title,@JsonKey(name: 'exam_name') String? examName,@JsonKey(name: 'subject_label') String? subjectLabel,@JsonKey(name: 'duration_minutes') int durationMinutes,@JsonKey(name: 'total_score') double totalScore, List<Block> instructions, List<ExamSection> sections
});




}
/// @nodoc
class __$ExamPaperCopyWithImpl<$Res>
    implements _$ExamPaperCopyWith<$Res> {
  __$ExamPaperCopyWithImpl(this._self, this._then);

  final _ExamPaper _self;
  final $Res Function(_ExamPaper) _then;

/// Create a copy of ExamPaper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? versionId = null,Object? paperId = null,Object? title = null,Object? examName = freezed,Object? subjectLabel = freezed,Object? durationMinutes = null,Object? totalScore = null,Object? instructions = null,Object? sections = null,}) {
  return _then(_ExamPaper(
versionId: null == versionId ? _self.versionId : versionId // ignore: cast_nullable_to_non_nullable
as String,paperId: null == paperId ? _self.paperId : paperId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,examName: freezed == examName ? _self.examName : examName // ignore: cast_nullable_to_non_nullable
as String?,subjectLabel: freezed == subjectLabel ? _self.subjectLabel : subjectLabel // ignore: cast_nullable_to_non_nullable
as String?,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as double,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<Block>,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,
  ));
}


}

// dart format on
