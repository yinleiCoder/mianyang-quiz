// 练习偏好：答对后是否自动跳题。
//
// 为什么值得测：默认值决定**用户第一次练习的手感**，而持久化决定关掉之后
// 下次启动还记不记得。读写失败在 Store 里是静默的（一个偏好不该挡住练习页），
// 所以读错/漏存都不会有人报错——只能靠这里钉住。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('默认开：用户没设过时答对自动跳下一题', () {
    expect(PracticePrefsStore().autoAdvance, isTrue);
  });

  test('改了就通知，并且能持久化（新建的 store 读得回来）', () async {
    final store = PracticePrefsStore();
    var notified = 0;
    store.addListener(() => notified++);

    await store.setAutoAdvance(false);
    expect(store.autoAdvance, isFalse);
    expect(notified, 1);

    final restored = PracticePrefsStore();
    await restored.load();
    expect(restored.autoAdvance, isFalse, reason: '关过一次就该记住');
  });

  test('设成同一个值不重复通知', () async {
    final store = PracticePrefsStore();
    var notified = 0;
    store.addListener(() => notified++);

    await store.setAutoAdvance(true);
    expect(notified, 0);
  });

  test('没存过 / 存的不是 bool 都回落默认开', () async {
    final missing = PracticePrefsStore();
    await missing.load();
    expect(missing.autoAdvance, isTrue);

    // 用户从更新的版本降级回来、或本地被工具改坏时，不该崩也不该变成关
    SharedPreferences.setMockInitialValues({'practice.autoAdvance': '关'});
    final broken = PracticePrefsStore();
    await broken.load();
    expect(broken.autoAdvance, isTrue);
  });
}
