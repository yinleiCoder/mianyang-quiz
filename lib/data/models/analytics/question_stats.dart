// 一道题的统计（paper_question_stats 的 items 元素，迁移 0078）。
//
// 整卷的根对象在 paper_question_stats.dart —— 拆开是因为架构守卫限制
// **每个 data 层文件最多 3 个 public class**，而这里加上根对象就 4 个了。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/analytics/option_stats.dart';

part 'question_stats.freezed.dart';
part 'question_stats.g.dart';

/// 答错的人。label 只在选择题/判断题上有值（他那题选了什么）；填空/主观题为空——
/// 那两类要把学生写的原文贴出来，与"不暴露自由文本"那条口径冲突（0078）。
@freezed
abstract class WrongStudent with _$WrongStudent {
  const factory WrongStudent({
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @JsonKey(name: 'class_name') String? className,
    String? label,
  }) = _WrongStudent;

  factory WrongStudent.fromJson(Map<String, dynamic> json) => _$WrongStudentFromJson(json);
}

/// 一道题。correctRate 为 null = 还没有已判分的作答（**不是 0%**，同 lib/accuracy.js 的规矩）。
@freezed
abstract class QuestionStat with _$QuestionStat {
  const factory QuestionStat({
    @JsonKey(name: 'item_id') required String itemId,
    @Default(0) int seq,
    @Default('') String qtype,
    @Default(0) double score,
    /// 参与统计的场次里，有多少人这题有作答记录（含未作答）。
    @Default(0) int total,
    @Default(0) int blank,
    @Default(0) int graded,
    @Default(0) int correct,
    @Default(0) int pending,
    @JsonKey(name: 'correct_rate') double? correctRate,
    @Default(<QuestionOptionStat>[]) List<QuestionOptionStat> options,
    @JsonKey(name: 'text_counts') @Default(<TextCount>[]) List<TextCount> textCounts,
    @JsonKey(name: 'wrong_students') @Default(<WrongStudent>[]) List<WrongStudent> wrongStudents,
    @JsonKey(name: 'wrong_total') @Default(0) int wrongTotal,
  }) = _QuestionStat;

  factory QuestionStat.fromJson(Map<String, dynamic> json) => _$QuestionStatFromJson(json);
}
