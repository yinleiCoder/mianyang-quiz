// 看板保鲜期的回归（2026-11-06）。
//
// 背景：`practice_dashboard` 是全站调用量最大的 RPC（历史 11,584 次），首页每次进入
// 都会刷一次。45 秒内重复打开复用内存里那份；改数据的入口传 force 绕过。
// 这条测试守三件事：保鲜期内不发请求、force 一定发、失败不缓存。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';

/// 只用到 fetchDashboard；其余成员走 noSuchMethod（不会被调用）。
class _FakeStatsRepository implements StatsRepository {
  int calls = 0;
  bool failNext = false;

  @override
  Future<PracticeDashboard> fetchDashboard() async {
    calls += 1;
    if (failNext) {
      failNext = false;
      throw StateError('boom');
    }
    return const PracticeDashboard();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DateTime now;
  late _FakeStatsRepository repo;
  late DashboardStore store;

  setUp(() {
    now = DateTime(2026, 11, 6, 8);
    repo = _FakeStatsRepository();
    store = DashboardStore(repo, now: () => now);
  });

  test('保鲜期内重复 refresh 不再打 RPC', () async {
    await store.refresh();
    expect(repo.calls, 1);

    now = now.add(const Duration(seconds: 30));
    await store.refresh(silent: true);
    expect(repo.calls, 1, reason: '保鲜期内不该再请求');

    now = now.add(const Duration(seconds: 31)); // 累计 61 秒
    await store.refresh(silent: true);
    expect(repo.calls, 2, reason: '过期后要重新拉');
  });

  test('force 绕过保鲜期（交卷/放弃/开始新一轮要用它）', () async {
    await store.refresh();
    await store.refresh(silent: true, force: true);
    expect(repo.calls, 2);
  });

  test('失败不写缓存：下一次仍会重试', () async {
    repo.failNext = true;
    await store.refresh();
    expect(repo.calls, 1);
    expect(store.error, isNotNull);

    await store.refresh(silent: true);
    expect(repo.calls, 2, reason: '上一次失败，不能拿"刚拉过"当借口');
    expect(store.data, isNotNull);
  });

  test('clear 之后不再复用上一个账号的数据', () async {
    await store.refresh();
    store.clear();
    await store.refresh(silent: true);
    expect(repo.calls, 2);
  });
}
