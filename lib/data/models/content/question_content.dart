// 一道题的完整内容（question_versions.content）。
//
// 线格式（format_version=1，见网页端 lib/question-model.js 与迁移 0003）：
//   {
//     "format_version": 1,
//     "stem": [block,…],              // 必填非空
//     "analysis": [block,…],          // 解析
//     "options": [{"key":"A","label":[block]}],   // 仅单选/多选
//     "answer": {…},                  // 复合题**根节点没有** answer
//     "sub": [{"type":"…", …}]        // 仅复合题，1~20 个
//   }
//
// toJson() 与上面逐字一致（含 format_version 的下划线命名），
// 因此可以直接把它喂给 domain/answer_grader.dart 的 gradeAnswer——判分需要原样的 map。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/data/models/content/sub_question.dart';

part 'question_content.freezed.dart';
part 'question_content.g.dart';

@freezed
abstract class QuestionContent with _$QuestionContent {
  const factory QuestionContent({
    @JsonKey(name: 'format_version') @Default(1) int formatVersion,
    @Default(<Block>[]) List<Block> stem,

    /// 解析。网页端出题时强制填写，但数据库不强制，历史数据可能缺失。
    @Default(<Block>[]) List<Block> analysis,

    @Default(<QuestionOption>[]) List<QuestionOption> options,

    /// 标准答案。复合题根节点为 null——各子题自带 answer。
    ServerAnswer? answer,

    /// 子题（仅复合题）。**不可嵌套复合题**（数据库约束）。
    @Default(<SubQuestion>[]) List<SubQuestion> sub,
  }) = _QuestionContent;

  factory QuestionContent.fromJson(Map<String, dynamic> json) =>
      _$QuestionContentFromJson(json);
}

extension QuestionContentX on QuestionContent {
  /// 题干纯文本——列表摘要、搜索回显用。
  String get stemText => stem.plainText;

  /// 填空题的空位数（题干里连续 3 个以上下划线）。
  /// 作答框数量以此为准，而不是以标准答案的长度为准：
  /// 标准答案可能有缺失，题干才是学生看到的那个。
  int get blankCount => countBlanks(stemText);

  bool get hasOptions => options.isNotEmpty;

  bool get isComposite => sub.isNotEmpty;
}
