// 一个选项的分布，以及填空的答案频次（paper_question_stats 的一部分，见 0078）。
//
// 服务端只下发**计数 + 姓名 + 选项字母/文本**；题干与解析由页面从卷面快照取
// （学生端本来就有那份快照）。这条分工让返回体里不含任何作答原文。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'option_stats.freezed.dart';
part 'option_stats.g.dart';

/// 选了某个选项的人。**只有姓名与班级**，没有别的字段可带。
@freezed
abstract class OptionStudent with _$OptionStudent {
  const factory OptionStudent({
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String name,
    @JsonKey(name: 'class_name') String? className,
  }) = _OptionStudent;

  factory OptionStudent.fromJson(Map<String, dynamic> json) => _$OptionStudentFromJson(json);
}

/// 一个选项的分布。isAnswer = 它是正确答案（学生已出分才会拿到这份数据）。
@freezed
abstract class QuestionOptionStat with _$QuestionOptionStat {
  const factory QuestionOptionStat({
    required String key,
    @Default('') String text,
    @JsonKey(name: 'is_answer') @Default(false) bool isAnswer,
    @Default(0) int count,
    @Default(<OptionStudent>[]) List<OptionStudent> students,
    @JsonKey(name: 'students_truncated') @Default(false) bool studentsTruncated,
  }) = _QuestionOptionStat;

  factory QuestionOptionStat.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionStatFromJson(json);
}

/// 填空题的答案频次。**没有姓名**：自由文本可能被敲进手机号之类（0078 的刻意收窄）。
@freezed
abstract class TextCount with _$TextCount {
  const factory TextCount({
    @Default('') String text,
    @Default(0) int count,
  }) = _TextCount;

  factory TextCount.fromJson(Map<String, dynamic> json) => _$TextCountFromJson(json);
}
