// 「开始练习」的两种结局：开起来了 / 今天该练的都练完了。
//
// 为什么第二种不是异常：题库现在只有 152 道，学生一天能做 200+ 次作答，
// 「今天不重复」的闸门一上（0069），池子干了就是**常态**而不是错误。
// 用异常表达它，调用方只能从中文错误文案里反推，也拿不到「下次什么时候到期」。
//
// 与 PracticeSessionSnapshot 的分工：那个描述"已经开起来的会话"，
// 这个多包一层是为了让"没开起来"也能带回信息（下次到期时刻、今天练过多少道）。

import 'package:mianyang_quiz/data/models/practice/practice_session.dart';

sealed class StartPracticeOutcome {
  const StartPracticeOutcome();
}

/// 开起来了：拿到完整题面快照，可以进练习页。
class PracticeStarted extends StartPracticeOutcome {
  const PracticeStarted(this.snapshot);

  final PracticeSessionSnapshot snapshot;
}

/// 没开起来：符合条件的题**今天都练过了**。
///
/// 服务端此时既没有建会话，也没有动进行中的那场练习（0069 特意把判断放在作废之前）。
///
/// [nextDueAt] 是下一批题按遗忘曲线到期的时刻（解析不出来时为 null，
/// 例如服务端没给这个字段）。[sameDayCount] 是今天已经练过的题数 ——
/// 点「仍然加练」就能拿到手的那批。
class PracticeNothingDue extends StartPracticeOutcome {
  const PracticeNothingDue({required this.nextDueAt, required this.sameDayCount});

  final DateTime? nextDueAt;
  final int sameDayCount;
}
