// 答题音效：答对一记上行"叮"、答错一记短"嗡"（学多邻国的即时反馈）。
//
// 三条设计约束：
//   · **默认开、可关**：偏好存本地（跨会话记住），开关在组卷页的练习方式里；
//   · **绝不打断答题**：播放失败（设备静音、插件缺失、测试环境没有音频通道）一律静默，
//     一个音效不该让判题结果弹不出来；
//   · **不预加载大文件**：两个 wav 各 ~20KB，交给 audioplayers 的 low-latency 模式即可。
//
// 音效文件是**程序合成**的（见 AGENTS.md：不引入外部素材，避免版权问题）。

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SfxService extends ChangeNotifier {
  SfxService({AudioPlayer? player}) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;
  static const _prefKey = 'practice.sound';

  bool _enabled = true;
  bool get enabled => _enabled;

  /// 从本地偏好恢复开关。启动时调一次即可（失败保持默认开）。
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_prefKey);
      if (saved != null && saved != _enabled) {
        _enabled = saved;
        notifyListeners();
      }
    } catch (_) {
      // 读不到偏好不影响任何功能
    }
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
    try {
      await (await SharedPreferences.getInstance()).setBool(_prefKey, value);
    } catch (_) {
      // 存不下只是"下次启动忘了"，不值得打扰用户
    }
  }

  /// 答对。
  Future<void> correct() => _play('sounds/correct.wav');

  /// 答错。**不是惩罚音**：短、低、不刺耳，配合界面上的正确答案一起看。
  Future<void> wrong() => _play('sounds/wrong.wav');

  Future<void> _play(String asset) async {
    if (!_enabled) return;
    try {
      // PlayerMode.lowLatency 走系统音效通道，答题时的延迟明显低于默认模式
      await _player.play(AssetSource(asset), mode: PlayerMode.lowLatency);
    } catch (_) {
      // 见文件头：播放失败静默
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
