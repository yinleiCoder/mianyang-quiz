// 考试计时的口径（0144）。
//
// 用户口径（2026-11-06）：**离开考试页暂停、下次进来接着剩余时间考**；
// 切后台/回前台不等于离开，时间照走。暂停/恢复本身由服务端做，本类只负责算：
//   · 剩余 = deadline - now；
//   · 已用 = 总时长 - 剩余（**不能用墙钟差**，否则隔天回来会显示"答了 10 小时"）；
//   · 截止时刻缺失（脏数据）时按"不限时"兜底，不能把卷子误交掉。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/pages/exam/state/exam_clock.dart';

void main() {
  final start = DateTime(2026, 11, 6, 10, 0, 0);

  test('剩余时间随墙钟减少，过点归零而不是负数', () {
    var now = start;
    final clock = ExamClock(
      deadlineAt: start.add(const Duration(minutes: 60)),
      clock: () => now,
    );

    expect(clock.remaining, const Duration(minutes: 60));
    now = start.add(const Duration(minutes: 25));
    expect(clock.remaining, const Duration(minutes: 35));

    now = start.add(const Duration(hours: 2));
    expect(clock.remaining, Duration.zero);
  });

  test('已用时长 = 总时长 - 剩余（中途离开一晚也只算真正答题的时间）', () {
    var now = start;
    final clock = ExamClock(
      deadlineAt: start.add(const Duration(minutes: 90)),
      clock: () => now,
    );

    now = start.add(const Duration(minutes: 20));
    expect(
      clock.elapsedOf(const Duration(minutes: 90)),
      const Duration(minutes: 20),
    );

    // 离开考试页 → 服务端冻结 70 分钟；第二天回来，deadline 被换成"现在 + 70"
    now = start.add(const Duration(hours: 10));
    final resumed = ExamClock(
      deadlineAt: now.add(const Duration(minutes: 70)),
      clock: () => now,
    );
    expect(
      resumed.elapsedOf(const Duration(minutes: 90)),
      const Duration(minutes: 20),
      reason: '离开的那一晚不能算进答题时间',
    );
  });

  test('截止时刻缺失（脏数据）：按不限时兜底，不能把卷子误交掉', () {
    final now = start;
    final clock = ExamClock(deadlineAt: null, clock: () => now);

    expect(clock.remaining, isNull);
    expect(clock.elapsedOf(const Duration(minutes: 90)), isNull);
    expect(clock.deadline.isAfter(now.add(const Duration(days: 3000))), isTrue);
  });
}
