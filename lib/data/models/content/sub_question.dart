// 复合题的子题。
//
// 比 QuestionContent 多一个 `type` 判别字段（数据库按 s->>'type' 分发校验），
// 少一个 analysis（子题没有独立解析）与 sub（**不可嵌套**，数据库约束）。
//
// 单独成类而不是复用 QuestionContent 带可选 type：根节点没有 type、
// 子题必须有 type，用同一个类会让"根节点能不能有 type"变成没人能回答的问题。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';

part 'sub_question.freezed.dart';
part 'sub_question.g.dart';

@freezed
abstract class SubQuestion with _$SubQuestion {
  const factory SubQuestion({
    /// 题型线格式（single_choice / true_false / fill_blank / short_answer…）。
    /// 不做成枚举：未知题型要能原样透传，让判分函数去决定怎么处理。
    required String type,
    @JsonKey(name: 'format_version') @Default(1) int formatVersion,
    @Default(<Block>[]) List<Block> stem,
    @Default(<QuestionOption>[]) List<QuestionOption> options,
    ServerAnswer? answer,
  }) = _SubQuestion;

  factory SubQuestion.fromJson(Map<String, dynamic> json) =>
      _$SubQuestionFromJson(json);
}
