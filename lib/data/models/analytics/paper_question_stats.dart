// 试题分析的根对象（paper_question_stats，迁移 0078）。
//
// 三道口径门禁都在服务端：只统计官方场次、只看当前入库版本、
// **学生必须自己已出分**（否则选项分布 + 标准答案就是答案本身，等于提前泄题）。
// 客户端因此不做任何权限判断，拿到 42501 就显示"出分后可见"。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/analytics/question_stats.dart';

part 'paper_question_stats.freezed.dart';
part 'paper_question_stats.g.dart';

/// 这次统计覆盖了多少场次（payload 里的 stats 子对象）。
@freezed
abstract class QuestionStatsTotals with _$QuestionStatsTotals {
  const factory QuestionStatsTotals({
    /// 参与统计的场次数（含待阅卷）。
    @Default(0) int attempts,
    /// 其中主观题还没判完的场次数。
    @Default(0) int ungraded,
    /// 考的是旧版卷面、未计入的场次数。
    @JsonKey(name: 'other_version_skipped') @Default(0) int otherVersionSkipped,
  }) = _QuestionStatsTotals;

  factory QuestionStatsTotals.fromJson(Map<String, dynamic> json) =>
      _$QuestionStatsTotalsFromJson(json);
}

/// 一份卷子的试题分析（整页一次取齐）。
@freezed
abstract class PaperQuestionStats with _$PaperQuestionStats {
  const factory PaperQuestionStats({
    @Default(<QuestionStat>[]) List<QuestionStat> items,
    @JsonKey(name: 'student_limit') @Default(50) int studentLimit,
    /// 字段名与 payload 的 stats 子对象对应，**不拍平**：自定义 fromJson 会让
    /// json_serializable 干脆不生成这个类（吃过这个亏）。
    @JsonKey(name: 'stats') @Default(QuestionStatsTotals()) QuestionStatsTotals totals,
  }) = _PaperQuestionStats;

  factory PaperQuestionStats.fromJson(Map<String, dynamic> json) =>
      _$PaperQuestionStatsFromJson(json);
}
