// 考试里的一道题的作答与判分（exam_answers 的一行）。
//
// 与练习的 PracticeAnswerRecord 分开：练习的判定是"对/错"两态（外加自评），
// 考试是**逐计分点**的分（units + score），而且还有一个"待教师阅卷"的中间态。
//
// answer 保持原样的 Map：它的形状由 domain/submitted_answer.dart 定义，
// 用 submittedAnswerFrom 还原成 SubmittedAnswer 才能交给 QuestionView 渲染。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_answer.freezed.dart';
part 'exam_answer.g.dart';

/// 一个计分点的得分：对没对 + 给了几分。
///
/// 自动判分时 score 只有"该点满分"或 0；教师阅卷时可以给到 0~满分之间的任意值
/// （答对一半的简答题就是这么给分的），所以这里不要假设它是二值的。
@freezed
abstract class ScoreUnit with _$ScoreUnit {
  const factory ScoreUnit({
    @Default(false) bool ok,
    @Default(0) double score,
  }) = _ScoreUnit;

  factory ScoreUnit.fromJson(Map<String, dynamic> json) =>
      _$ScoreUnitFromJson(json);
}

@freezed
abstract class ExamAnswerRecord with _$ExamAnswerRecord {
  const factory ExamAnswerRecord({
    @JsonKey(name: 'paper_item_id') required String paperItemId,
    @Default(0) int seq,

    /// 学生提交上去的那份 JSON（形状见 domain/submitted_answer.dart）。
    /// 未作答是空 Map，不是 null。
    @Default(<String, dynamic>{}) Map<String, dynamic> answer,

    @Default(<ScoreUnit>[]) List<ScoreUnit> units,

    /// 本题得分。主观题在教师给分前恒为 0（**不是**"答错了"）。
    @Default(0) double score,

    /// auto（机器判）/ manual（教师判）/ pending（待教师判）。
    @Default('auto') String grading,

    /// 机器或教师判定的对错。主观题判分前是 null。
    @JsonKey(name: 'is_correct') bool? isCorrect,

    /// 教师评语（可选）。
    String? comment,
  }) = _ExamAnswerRecord;

  factory ExamAnswerRecord.fromJson(Map<String, dynamic> json) =>
      _$ExamAnswerRecordFromJson(json);
}

extension ExamAnswerRecordX on ExamAnswerRecord {
  /// 还在等教师给分。
  bool get isPending => grading == 'pending';

  /// 学生答过没有。空 Map / 只有 type 的标记都算没答。
  bool get isAnswered => answer.isNotEmpty && answer['type'] != 'unknown';
}
