// 选择题的一个选项。
//
// 线格式：{"key":"A","label":[block,…]}——label 是**块数组**（选项文字也可含媒体，
// 虽然出题端目前只允许纯文字，但读取端必须能处理）。
//
// key 是数据库认可的原始标识（A/B/C…），提交作答时必须用它。
// 界面上的"显示字母"由乱序决定，是另一回事（见 ui/core/question/question_host.dart）。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';

part 'question_option.freezed.dart';
part 'question_option.g.dart';

@freezed
abstract class QuestionOption with _$QuestionOption {
  const factory QuestionOption({
    required String key,
    @Default(<Block>[]) List<Block> label,
  }) = _QuestionOption;

  factory QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);
}

extension QuestionOptionX on QuestionOption {
  /// 选项的纯文本（媒体块跳过），用于列表摘要与无障碍朗读。
  String get plainText => label.plainText;
}
