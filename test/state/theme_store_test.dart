// 外观偏好：默认值、持久化、认不出的值回落。
//
// 为什么值得测：这两个值决定**每次启动的第一帧**长什么样。存不下只表现为"下次忘了"（静默），
// 但**读错**会让用户看到一帧刺眼的白（深色用户）或整套配色变回紫色（选了别的主题色的人）——
// 而这两种都只在真机上、只在启动那一瞬间看得出来。

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('默认：品牌紫 + 跟随系统', () {
    final store = ThemeStore();
    expect(store.seed, ThemeSeed.purple);
    expect(store.mode, AppThemeMode.system);
  });

  test('改了就通知，并且能持久化（新建的 store 读得回来）', () async {
    final store = ThemeStore();
    var notified = 0;
    store.addListener(() => notified++);

    await store.setMode(AppThemeMode.dark);
    await store.setSeed(ThemeSeed.teal);
    expect(notified, 2, reason: '两个 setter 各通知一次');

    final restored = ThemeStore();
    await restored.load();
    expect(restored.mode, AppThemeMode.dark);
    expect(restored.seed, ThemeSeed.teal);
  });

  test('设成同一个值不重复通知（否则整棵树白重建一次）', () async {
    final store = ThemeStore();
    var notified = 0;
    store.addListener(() => notified++);

    await store.setMode(AppThemeMode.system);
    await store.setSeed(ThemeSeed.purple);
    expect(notified, 0);
  });

  test('认不出的偏好回落默认：改过名、或用户从更新的版本降级回来都不该崩', () async {
    SharedPreferences.setMockInitialValues({
      'theme.seed': '荧光绿',
      'theme.mode': 'sepia',
    });
    final store = ThemeStore();
    await store.load();
    expect(store.seed, ThemeSeed.purple);
    expect(store.mode, AppThemeMode.system);
  });

  test('明暗模式映射到 ThemeMode 一一对应（app.dart 全靠它）', () {
    expect(AppThemeMode.system.flutter, ThemeMode.system);
    expect(AppThemeMode.light.flutter, ThemeMode.light);
    expect(AppThemeMode.dark.flutter, ThemeMode.dark);
  });

  test('wire 名稳定：主题色只认自己写进去的那串', () {
    for (final seed in ThemeSeed.values) {
      expect(themeSeedFrom(seed.wire), seed, reason: '${seed.label} 的 wire 名对不上自己');
    }
    // wire 名不许重复（重复了选择器上就会有两个永远选不中的）
    final wires = ThemeSeed.values.map((s) => s.wire).toSet();
    expect(wires.length, ThemeSeed.values.length);
  });
}
