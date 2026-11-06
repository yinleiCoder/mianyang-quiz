// 练习偏好（本机记忆）：答对后是否自动跳下一题。
//
// 默认开（用户 2026-11-06 口径：默认跳转）。**只由即时练习消费**：
// 批量练习不逐题判定，顺序练习（0090）也刻意不自动跳——教师讲评时页面被抢走，
// 比多按一次「继续」更糟（见 pages/practice/state/auto_advance.dart）。
//
// 持久化照 ThemeStore / SfxService 那套：读不到 / 写不下一律静默。
// 一个偏好不该让练习页打不开。

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticePrefsStore extends ChangeNotifier {
  /// 可选的初值只给测试用（正常路径由 [load] 从本地偏好填）。
  /// 用位置参数是为了写成 initializing formal——私有字段没法做成命名参数
  /// （`this._autoAdvance` 只允许位置参数），命名参数形式会被
  /// prefer_initializing_formals 一直报（与 ThemeStore 同一条）。
  PracticePrefsStore([this._autoAdvance = true]);

  static const _autoAdvanceKey = 'practice.autoAdvance';

  bool _autoAdvance;

  /// 即时练习答对后是否自动进入下一题。默认开。
  bool get autoAdvance => _autoAdvance;

  /// 从本地偏好读一次（失败保持默认开）。启动时调一次即可。
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_autoAdvanceKey);
      if (saved == null || saved == _autoAdvance) return;
      _autoAdvance = saved;
      notifyListeners();
    } catch (_) {
      // 读不到偏好不影响任何功能
    }
  }

  Future<void> setAutoAdvance(bool value) async {
    if (_autoAdvance == value) return;
    _autoAdvance = value;
    notifyListeners();
    try {
      await (await SharedPreferences.getInstance()).setBool(
        _autoAdvanceKey,
        value,
      );
    } catch (_) {
      // 存不下只是"下次启动忘了"，不值得打扰用户
    }
  }
}
