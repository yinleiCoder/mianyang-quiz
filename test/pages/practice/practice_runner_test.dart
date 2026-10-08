// 练习状态机的**计时语义**（暂停相关）。
//
// 为什么单独立一个文件：顶栏那个数字与交卷送上去的用时必须是同一个来源。
// 两边各算各的话，"暂停"就会变成两个数字之间的偏差——而这种偏差在界面上
// 表现为"顶栏说 12 分钟、成绩单写 25 分钟"，两个数都"没错"，根本没法归因。
// 所以这里直接断言 finish() 送出去的 durationMs 等于 runner.elapsed。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final start = DateTime(2026, 9, 16, 10, 0, 0);

  test('暂停期间时间不流逝；恢复后接着走（多次暂停累计）', () {
    var now = start;
    final runner = _runner(() => now);

    now = start.add(const Duration(minutes: 1));
    expect(runner.elapsed, const Duration(minutes: 1));

    // 第一次暂停 10 分钟
    runner.pause();
    expect(runner.isPaused, isTrue);
    now = start.add(const Duration(minutes: 11));
    expect(runner.elapsed, const Duration(minutes: 1), reason: '暂停中显示必须冻住');

    runner.resume();
    expect(runner.isPaused, isFalse);
    now = start.add(const Duration(minutes: 11, seconds: 30));
    expect(runner.elapsed, const Duration(minutes: 1, seconds: 30));

    // 第二次暂停 20 分钟
    runner.togglePause();
    now = start.add(const Duration(minutes: 31, seconds: 30));
    expect(runner.elapsed, const Duration(minutes: 1, seconds: 30));
    runner.togglePause();

    now = start.add(const Duration(minutes: 32, seconds: 30));
    // 2 分 30 秒 = 真正在题上的那一段时间（1 分 + 30 秒 + 1 分），
    // 两次暂停（10 分 + 20 分）一分钟都不算
    expect(runner.elapsed, const Duration(minutes: 2, seconds: 30));
  });

  test('重复 pause 不重复计时；未暂停时 resume 是空操作', () {
    var now = start;
    final runner = _runner(() => now);

    now = start.add(const Duration(minutes: 1));
    runner.pause();
    now = start.add(const Duration(minutes: 5));
    runner.pause(); // 第二次点击不该把"暂停起点"挪到 5 分钟处
    runner.resume();
    now = start.add(const Duration(minutes: 6));
    expect(runner.elapsed, const Duration(minutes: 2)); // 1 分 + 恢复后的 1 分

    runner.resume(); // 本来就没暂停
    expect(runner.isPaused, isFalse);
    expect(runner.elapsed, const Duration(minutes: 2));
  });

  test('交卷送上去的用时扣掉暂停，与顶栏读的是同一个数', () async {
    var now = start;
    final repository = _RecordingRepository();
    final runner = _runner(() => now, repository: repository);

    now = start.add(const Duration(minutes: 3));
    runner.pause();
    now = start.add(const Duration(hours: 1, minutes: 3)); // 接了个小时的电话
    runner.resume();
    now = start.add(const Duration(hours: 1, minutes: 5));

    await runner.finish();

    expect(
      repository.finishedWith,
      5 * 60 * 1000,
      reason: '整卷用时必须是 5 分钟（3 分 + 2 分），而不是 65 分钟',
    );
    expect(runner.elapsed.inMilliseconds, repository.finishedWith);
  });

  test('会话已结束时交卷不发送请求', () async {
    final now = start;
    final repository = _RecordingRepository();
    final runner = _runner(() => now, repository: repository, ended: true);

    expect(await runner.finish(), isNull);
    expect(repository.finishedWith, isNull);
  });
}

PracticeRunner _runner(
  DateTime Function() clock, {
  _RecordingRepository? repository,
  bool ended = false,
}) => PracticeRunner(
  repository:
      repository ??
      _RecordingRepository(),
  snapshot: PracticeSessionSnapshot(
    sessionId: 's1',
    source: 'all',
    status: ended ? 'submitted' : 'active',
    items: const [
      PracticeItem(
        seq: 1,
        questionId: 'q1',
        versionId: 'v1',
        qtype: 'single_choice',
        content: QuestionContent(stem: [Block.text(text: '第 1 题')]),
      ),
    ],
  ),
  mode: PracticeMode.instant,
  clock: clock,
);

/// 只记"交卷时送了多久"的仓储。本文件一条网络都不发：所有方法都不碰 client。
class _RecordingRepository extends PracticeRepository {
  _RecordingRepository()
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'sb_publishable_x',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  int? finishedWith;

  @override
  Future<FinishSummary> finishSession({
    required String sessionId,
    int? durationMs,
  }) async {
    finishedWith = durationMs;
    return const FinishSummary();
  }
}
