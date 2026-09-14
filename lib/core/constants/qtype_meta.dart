// 题型元数据：线格式字符串 ↔ 枚举 ↔ 中文名 ↔ 图标。
//
// 线格式（wire）必须与数据库 question_versions.qtype 的取值逐字一致：
//   single_choice / multiple_choice / true_false / fill_blank / short_answer / composite
// 判分函数 grade_answer 收的就是这些字符串，所以 domain 层直接用 String，
// 枚举只服务于 UI 分支与展示。
//
// 不知道的取值一律落到 unknown，**不要抛异常**：题库将来加了新题型时，
// 旧客户端应当能显示"未知题型"而不是整页崩溃。

import 'package:material_ui/material_ui.dart';

enum QuestionType {
  singleChoice('single_choice', '单选题', Icons.radio_button_checked),
  multipleChoice('multiple_choice', '多选题', Icons.check_box_outlined),
  trueFalse('true_false', '判断题', Icons.check_circle_outline),
  fillBlank('fill_blank', '填空题', Icons.short_text),
  shortAnswer('short_answer', '主观题', Icons.edit_note),
  composite('composite', '复合题', Icons.layers_outlined),
  unknown('unknown', '未知题型', Icons.help_outline);

  const QuestionType(this.wire, this.label, this.icon);

  /// 与数据库一致的字符串。
  final String wire;
  final String label;
  final IconData icon;

  /// 选择题（单选+多选）共用同一套选项与答案契约。
  bool get isChoice => this == singleChoice || this == multipleChoice;

  /// 主观题由自评决定对错，不由判分函数判定。
  bool get isSelfAssessed => this == shortAnswer;

  /// 复合题可以包含子题；子题不能是复合题（数据库约束）。
  bool get isComposite => this == composite;

  /// 可以作为子题的题型（复合题不能嵌套）。
  static List<QuestionType> get subTypes =>
      values.where((t) => t != composite && t != unknown).toList();
}

QuestionType questionTypeFrom(String? wire) {
  if (wire == null) return QuestionType.unknown;
  for (final type in QuestionType.values) {
    if (type.wire == wire) return type;
  }
  return QuestionType.unknown;
}
