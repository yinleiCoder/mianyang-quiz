// 标准答案（**读取侧**，即 content.answer）。
//
// 与写入侧的 SubmittedAnswer 形状不同，不要合并（见 domain/submitted_answer.dart 的说明）：
// 这里是"题目自带的正确答案"，那里是"学生提交的作答"。
//
// 复合题**根节点没有 answer**——各子题各自带 answer，所以这里可空。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_answer.freezed.dart';
part 'server_answer.g.dart';

// sealed：与 Block 同理，让"展示标准答案"的分发点在新增答案类型时编译失败，
// 而不是漏掉一个分支导致某种题型的答案显示为空。
@Freezed(unionKey: 'type')
sealed class ServerAnswer with _$ServerAnswer {
  /// 单选/多选：keys 是选项原始 key（A/B/C…），顺序无意义（判分会排序后比）。
  @FreezedUnionValue('choice')
  const factory ServerAnswer.choice({@Default(<String>[]) List<String> keys}) =
      ChoiceServerAnswer;

  @FreezedUnionValue('tf')
  const factory ServerAnswer.trueFalse({required bool value}) =
      TrueFalseServerAnswer;

  /// 填空：与题干中的空位**逐位对应**。
  @FreezedUnionValue('blank')
  const factory ServerAnswer.blank({@Default(<String>[]) List<String> values}) =
      BlankServerAnswer;

  /// 主观题：参考答案（可多条）。判分不走这里，仅供参考展示。
  @FreezedUnionValue('text')
  const factory ServerAnswer.text({@Default(<String>[]) List<String> samples}) =
      TextServerAnswer;

  factory ServerAnswer.fromJson(Map<String, dynamic> json) =>
      _$ServerAnswerFromJson(json);
}
