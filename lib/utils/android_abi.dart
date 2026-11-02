// 当前装的是哪个 ABI 的包（arm64-v8a / armeabi-v7a / x86_64 …），以及它对应哪个发布资产。
//
// **为什么需要它**：装与更新必须落在**同一个 ABI** 上，两边的可装性是不对称的。
//   · 32 位 ARM 设备装不了只有 arm64-v8a 的包（INSTALL_FAILED_NO_MATCHING_ABIS）；
//   · 反过来，**64 位-only 的系统**（Pixel 7 起那批只暴露 64 位 ABI 的镜像）
//     也装不了只有 armeabi-v7a 的包——CPU 跑得动 32 位 ARM，是系统不提供 32 位 ABI。
// 所以"更新推哪个包"不能写死：写死的话，走了备用链接装了 arm64 的用户会被推 armv7
// （或反过来），那份包在他的机器上根本装不上，等于把更新这条路堵死。
//
// **怎么知道自己是什么 ABI**：读 `/proc/self/maps`。应用读自己的进程不需要任何权限，
// 里面每条映射的路径都带 `lib/<abi>/`，例如
//   `/data/app/~~xxx==/com.mianyang.quiz-yyy==/lib/arm64/libflutter.so`
// Android 上 `libapp.so`（Dart AOT）与 `libflutter.so`（引擎）在同一个 ABI 目录里，
// 撞到哪个都行。
//
// Windows / 桌面端没有这个文件（读不到就返回 null），那边本来也只有一份安装包，
// 不需要按 ABI 分。
//
// 纯 Dart，不 import Flutter —— 因此可以在纯 Dart 单测里跑（见 test/utils/android_abi_test.dart）。

import 'dart:io';

/// Android 端的 ABI 识别与「ABI → 发布资产名」映射。
class AndroidAbi {
  const AndroidAbi._();

  /// ABI 目录名 → 发布资产名。
  ///
  /// **必须与网页端 `lib/client-assets.mjs` 的 `APK_ASSET`（arm64）/ `APK_ARMV7_ASSET` /
  /// `APK_X86_64_ASSET` 逐字一致**，改一处必须改另一处，否则更新页给的是 404。
  static const Map<String, String> assetByAbi = {
    'arm64-v8a': 'mianyang_quiz-android.apk',
    'armeabi-v7a': 'mianyang_quiz-android-armv7.apk',
    'x86_64': 'mianyang_quiz-android-x86_64.apk',
  };

  /// 认不出 ABI 时的兜底资产。**与网页端默认下发的那份一致**（arm64-v8a）：
  /// 认不出来时就不猜，跟着网页端走——两边口径不同的话，更新推的包和
  /// 新装拿到的包会对不上。
  static const String fallbackAsset = 'mianyang_quiz-android.apk';

  /// 当前进程的 ABI；读不到（非 Android、或读文件失败）返回 null。
  ///
  /// 结果**缓存**：一次进程生命周期内 ABI 不会变，别每次查更新都读一遍文件。
  static String? detect() => _cached ??= _detectFromMaps();

  static String? _cached;

  static String? _detectFromMaps() {
    try {
      final file = File('/proc/self/maps');
      if (!file.existsSync()) return null;
      return abiFromMaps(file.readAsStringSync());
    } catch (_) {
      // 读不到就算了：调用方会退到兜底资产，不该因为它把更新流程整个搞坏。
      return null;
    }
  }

  /// 从 `/proc/self/maps` 的内容里解析出 ABI。
  ///
  /// **单独拆出来是为了能单测**——真机上那个文件长什么样，测试里造不出来。
  /// 解析不出来返回 null（走兜底），不抛异常。
  static String? abiFromMaps(String content) {
    final match = RegExp(
      r'/lib/([a-z0-9_-]+)/lib(app|flutter)\.so',
    ).firstMatch(content);
    if (match == null) return null;
    // group(1) 一定非空：正则里那一段是必需捕获组，匹配不上就不会走到这里。
    return normalizeAbi(match.group(1)!);
  }

  /// 把目录名归一成**发布资产名里用的那个 ABI 名**。
  ///
  /// APK 里的目录名是 `arm64-v8a` / `armeabi-v7a`，但个别系统镜像里
  /// 解包出来的是 `arm64` / `armeabi`。认错的后果是**更新推的包装不上**
  /// （armv7 的包在 64 位-only 的系统上装不了），所以这里显式归一，
  /// 不靠"大概率是 arm64-v8a"。
  static String normalizeAbi(String dir) => switch (dir) {
        'arm64' => 'arm64-v8a',
        'armeabi' => 'armeabi-v7a',
        _ => dir,
      };

  /// 这个 ABI 对应的资产名；不认识（null 或新 ABI）就用兜底那份。
  static String assetForAbi(String? abi) =>
      (abi == null ? null : assetByAbi[abi]) ?? fallbackAsset;
}
