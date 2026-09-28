// 两个「结算类」返回体：单题提交的结果、整卷交卷的汇总。
//
// 单题结果是**服务端判分的权威**——本地镜像只用于抢先显示，最终以这里的 isCorrect 为准。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'practice_results.freezed.dart';
part 'practice_results.g.dart';

@freezed
abstract class SubmitResult with _$SubmitResult {
  const factory SubmitResult({
    /// 服务端判定。主观题由自评决定；`{"type":"unknown"}` 一律 false。
    @JsonKey(name: 'is_correct') required bool isCorrect,

    /// 'auto' 机器判分 / 'self' 主观题自评。
    @Default('auto') String grading,

    /// 该版本 content 里的标准答案**原文**（未加工）。
    ///
    /// 陷阱：复合题这里是 **null**——它的答案在 content.sub[].answer，顶层没有 answer。
    /// 展示标准答案时必须对复合题逐子题渲染，不能只读这个字段。
    @JsonKey(name: 'correct_answer') Map<String, dynamic>? correctAnswer,
  }) = _SubmitResult;

  factory SubmitResult.fromJson(Map<String, dynamic> json) =>
      _$SubmitResultFromJson(json);
}

extension SubmitResultX on SubmitResult {
  /// 是否为主观题自评结果（此时答案展示应走参考样例而非"正确答案"）。
  bool get isSelfAssessed => grading == 'self';
}

@freezed
abstract class FinishSummary with _$FinishSummary {
  const factory FinishSummary({
    @Default(0) int total,
    @Default(0) int answered,
    @Default(0) int correct,
    @Default(0) int wrong,

    /// 未作答数 = total - answered。
    @Default(0) int omitted,

    /// 正确率 = correct / **total**（分母是总题数，不是已答数——与看板口径不同）。
    @Default(0) double accuracy,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
  }) = _FinishSummary;

  factory FinishSummary.fromJson(Map<String, dynamic> json) =>
      _$FinishSummaryFromJson(json);
}
