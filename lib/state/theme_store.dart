// 外观偏好：主题色（种子色）+ 明暗模式。跨页 ChangeNotifier + 本地持久化。
//
// 为什么放 state/ 而不是 values/：它要通知界面重画，是个 Store；
// 与 SfxService（同样"偏好 + 持久化"）的区别是那个是"服务"（有可执行的动作），
// 这里只是一份被读的状态。
//
// 持久化照 SfxService 那套：读不到 / 写不下一律静默——外观偏好出问题最多表现为
// "下次启动忘了"，不该弹错误、更不该挡住启动。
//
// ⚠ **启动时先把值读出来再建 Store**（见 bootstrap 里那次 await）：MaterialApp
// 若先拿默认值渲染一帧，深色用户会看到一帧白色闪屏。那次 await 是本地读，
// 与随后的 Supabase.initialize（要走网络）比可以忽略。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStore extends ChangeNotifier {
  /// 可选的初值只给测试用（正常路径是 AppDependencies 建空的、再由 load() 填）。
  /// 用位置参数是为了写成 initializing formal——私有字段没法做成命名参数
  /// （`this._seed` 只允许位置参数），命名参数形式会被 prefer_initializing_formals 一直报。
  ThemeStore([this._seed = ThemeSeed.purple, this._mode = AppThemeMode.system]);

  static const _seedKey = 'theme.seed';
  static const _modeKey = 'theme.mode';

  ThemeSeed _seed;
  AppThemeMode _mode;

  ThemeSeed get seed => _seed;
  AppThemeMode get mode => _mode;

  /// 从本地偏好读一次（失败保持默认）。启动时调，**要 await**（见文件头）。
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seed = themeSeedFrom(prefs.getString(_seedKey));
      final mode = appThemeModeFrom(prefs.getString(_modeKey));
      if (seed == _seed && mode == _mode) return;
      _seed = seed;
      _mode = mode;
      notifyListeners();
    } catch (_) {
      // 读不到偏好不影响任何功能
    }
  }

  Future<void> setSeed(ThemeSeed value) async {
    if (_seed == value) return;
    _seed = value;
    notifyListeners();
    await _write(_seedKey, value.wire);
  }

  Future<void> setMode(AppThemeMode value) async {
    if (_mode == value) return;
    _mode = value;
    notifyListeners();
    await _write(_modeKey, value.wire);
  }

  /// 先改内存再落盘：界面立刻响应，写失败只是"下次启动忘了"。
  Future<void> _write(String key, String value) async {
    try {
      await (await SharedPreferences.getInstance()).setString(key, value);
    } catch (_) {
      // 见文件头：静默
    }
  }
}
