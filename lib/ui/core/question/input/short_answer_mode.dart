// 主观题的两种作答方式。**只有主观题受它影响**，客观题两种模式下长得一模一样。
//
// 单独一个文件是因为它被三处共用：分发点（QuestionView）、两个主观题作答区
// （ShortAnswerInputView / EssayInputView）、以及往下传参的复合题链路。
// 挂在 QuestionView 里会让"作答区反过来 import 分发点"变成常态。

/// 主观题怎么答。客观题不受影响。
enum ShortAnswerMode {
  /// 练习：不写内容，学生自评「我会了 / 没掌握」（自评就是对错）。
  selfAssess,

  /// 考试：学生写下答案，交给教师判分。
  essay,
}
