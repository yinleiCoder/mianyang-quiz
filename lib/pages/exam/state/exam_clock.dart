// 考试倒计时的状态：剩余时间、截止时刻、已用时长。
//
// 从 ExamRunner 拆出来（架构检查的 200 行上限），也把"计时"从"作答怎么推进"
// 里分开：作答逻辑不该碰 deadline 的换算。
//
// **2026-11-06 起的口径**（0144）：
//   · 切后台 / 回前台**不停表**，时间照走；
//   · **离开考试页**才暂停：服务端把剩余时间冻结成 `remaining_ms`，
//     下次进来读考试时自动接回去（见迁移里的 _resume_exam_attempt_if_paused）。
// 所以本类只管"现在还剩多少、已经用了多少"，不负责暂停——那是服务端的事。

class ExamClock {
  ExamClock({required this._deadlineAt, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  final DateTime? _deadlineAt;

  /// 剩余时间；截止时刻缺失（脏数据）时返回 null，界面按"不限时"处理。
  Duration? get remaining {
    final deadline = _deadlineAt;
    if (deadline == null) return null;
    final left = deadline.difference(_clock());
    return left.isNegative ? Duration.zero : left;
  }

  /// 倒计时用的截止时刻。
  ///
  /// 缺失时退化成"十年后"而不是"现在"：_clock() 当截止会让倒计时一进页面就归零、
  /// 立刻自动交卷——一个空字段不该把学生的卷子交掉。**宁可永不到点，也不要误交。**
  DateTime get deadline =>
      _deadlineAt ?? _clock().add(const Duration(days: 3650));

  /// 已用时长 = 总时长 - 剩余。**不能拿墙钟差算**：0144 起离开考试页会暂停，
  /// 学生隔天回来，`now - startedAt` 会变成"答了 10 小时"。
  /// 截止时刻缺失（脏数据）时返回 null，调用方退回墙钟口径。
  Duration? elapsedOf(Duration full) {
    final left = remaining;
    if (left == null || full <= Duration.zero) return null;
    return full - left;
  }
}
