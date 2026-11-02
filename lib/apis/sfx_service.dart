// 答题音效：点选项、答对、答错、整场结束、中途退出，各有一记提示音。
//
// 三条设计约束：
//   · **默认开、可关**：偏好存本地（跨会话记住），开关在组卷页的练习方式里；
//   · **绝不打断答题**：播放失败（设备静音、插件缺失、测试环境没有音频通道）一律静默，
//     一个音效不该让判题结果弹不出来；
//   · **每个音效一个 AudioPlayer，音源只设置一次**（2026-11-02 改）。
//
// 最后一条是修 Windows 崩溃才改成这样的。原先全站共用一个 AudioPlayer：
// 选完选项放「选择一个选项」，紧接着答对/答错又要切到另一个 asset，插件会在
// **同一个 MediaEngine 上反复 SetSourceUrl**；而 audioplayers_windows 的
// `SetSourceUrl` 是 `std::thread(...).detach()` 出去的，与主线程的 Play/Stop
// 没有同步。学生点得快时（尤其是"选项音 → 判定音"这一两百毫秒内）就是两个线程
// 同时动同一套 Media Foundation 对象——Sentry 里
// `CMediaEngine::CompleteSourceCreation` 的崩溃和 32 个用户的
// `RtlpFreeHeapInternal` 堆崩溃都指向这里（堆损坏是"崩在 free，坏在更早的写"）。
//
// 改成每个 asset 一个 player 后，`AudioPlayer::SetSourceUrl` 里的
// `if (_url != url)` 会让同一音效的后续播放直接走 Play/Resume，**不再重建音源**；
// 不同音效也落在不同的 player/MediaEngine 上，互不共享状态。
//
// 音频文件是**老师提供的**（2026-09-17 换掉了原先程序合成的 wav），
// 文件名是中文，走 assets/sounds/ 整目录打包（见 pubspec.yaml）。
// 中文资源名在 Windows/Android 上都能正常解析，但**测试里会真的去 load 一遍**
// （test/data/sfx_assets_test.dart）——名字打错或漏打包在运行时是静默的。

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SfxService extends ChangeNotifier {
  /// [playerFactory] 只给测试注入用；生产走默认的 [AudioPlayer.new]。
  SfxService({AudioPlayer Function()? playerFactory})
    : _newPlayer = playerFactory ?? AudioPlayer.new;

  final AudioPlayer Function() _newPlayer;

  /// 每个 asset 一个 player。键是资源路径（如 `sounds/答对.mp3`）。
  final Map<String, AudioPlayer> _players = {};
  static const _prefKey = 'practice.sound';

  /// 资源目录前缀。AudioCache 默认会再加一层 `assets/`。
  static const _dir = 'sounds/';

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

  /// 点了一个选项（选择/判断题的按钮）。**填空与主观题不放**——那是逐键上抛的，
  /// 每敲一个字响一下会变成噪音。
  Future<void> selectOption() => _play('$_dir选择一个选项.mp3');

  /// 答对。
  Future<void> correct() => _play('$_dir答对.mp3');

  /// 答错。**不是惩罚音**：短、低、不刺耳，配合界面上的正确答案一起看。
  Future<void> wrong() => _play('$_dir答错.mp3');

  /// 一场练习/考试结束（交卷结算）。
  Future<void> finish() => _play('$_dir测验全部结束.mp3');

  /// 答题中途退出（练习页或考试页离开）。
  Future<void> quit() => _play('$_dir退出答题.mp3');

  Future<void> _play(String asset) async {
    if (!_enabled) return;
    try {
      // 同一个 asset 永远复用同一个 player：插件的 SetSourceUrl 会在
      // `_url == url` 时短路，不会重建 Media Foundation 音源。
      final player = _players[asset] ??= _newPlayer();
      // PlayerMode.lowLatency 走系统音效通道，答题时的延迟明显低于默认模式
      await player.play(AssetSource(asset), mode: PlayerMode.lowLatency);
    } catch (_) {
      // 见文件头：播放失败静默
    }
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    super.dispose();
  }
}
