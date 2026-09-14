// 错题本与收藏列表的行。
//
// 两个 RPC 都是 `returns table(...)`，字段高度相似但有差别：
//   list_my_wrong_questions → 多一个 wrong_count（累计答错次数）
//   list_my_favorites       → 多一个 created_at（收藏时间）
// 因此是两个类而不是一个带可空字段的类——可空字段会让"这个字段在这个场景有没有意义"
// 变成调用方每次都要猜的问题。
//
// 共同点：题目已下线/删除时都会返回**占位行**（available=false，stem_text 为 null），
// 界面要显示"题目已不可用"而不是空行，也不能点击进详情。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';

part 'question_row.freezed.dart';
part 'question_row.g.dart';

@freezed
abstract class WrongQuestion with _$WrongQuestion {
  const factory WrongQuestion({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'version_id') String? versionId,
    String? qtype,
    int? difficulty,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,

    /// 这道题历史上被判错的总次数（不是本次连续错）。
    @JsonKey(name: 'wrong_count') @Default(1) int wrongCount,
    @JsonKey(name: 'stem_text') String? stemText,
    @Default(true) bool available,
  }) = _WrongQuestion;

  factory WrongQuestion.fromJson(Map<String, dynamic> json) =>
      _$WrongQuestionFromJson(json);
}

extension WrongQuestionX on WrongQuestion {
  QuestionType get type => questionTypeFrom(qtype);

  /// 题型未知（占位行）时不要拿去渲染题型徽标。
  bool get hasMeta => qtype != null && available;
}

@freezed
abstract class FavoriteQuestion with _$FavoriteQuestion {
  const factory FavoriteQuestion({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'version_id') String? versionId,
    String? qtype,
    int? difficulty,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'stem_text') String? stemText,
    @Default(true) bool available,
  }) = _FavoriteQuestion;

  factory FavoriteQuestion.fromJson(Map<String, dynamic> json) =>
      _$FavoriteQuestionFromJson(json);
}

extension FavoriteQuestionX on FavoriteQuestion {
  QuestionType get type => questionTypeFrom(qtype);
}
