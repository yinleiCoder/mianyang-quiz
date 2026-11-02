// 查最新版本：读 OSS 上的 client/latest.json（与网页端 /download 同一份清单）。
//
// 为什么不再读 GitHub API：GitHub 在国内取不到字节，版本检查也会跟着超时/静默失败，
// 于是出现"网页端已经 v2.8.1、客户端还说没有新版本"。发布流水线把清单写到 OSS，
// 版本号与下载直链都在里面，客户端读它就是与网页端同源。
//
// APK 的下载地址由清单直接给出：指向网页端的 `/download/apk` 自动下载页。阿里云默认域名
// 不能分发 .apk（key 后缀 / Content-Type / 文件名三条都挡），所以那一页由**浏览器**
// 直连 OSS 的 `.bin` 副本、转 Blob 存成 `.apk`；客户端这里只负责把用户送过去。
// Windows 直接用清单里的 OSS 直链。失败一律返回 null（没发过版、断网、清单还没写）：
// 调用方静默跳过——更新提示是锦上添花，绝不能因为它把启动流程搞出一个错误弹窗。

import 'package:dio/dio.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 一次发布的关键信息。
typedef AppRelease = ({
  /// 形如 `v1.0.1`。
  String tag,
  /// 下载页地址（没有当前平台的直链时打开它）。
  String pageUrl,
  /// 当前平台对应的直接下载地址（Android→apk，Windows→安装包）；没有则为 null。
  String? assetUrl,
});

class AppUpdateRepository {
  const AppUpdateRepository(this._dio);

  final Dio _dio;

  /// 当前平台**可能**用到的资产名，按优先级排；第一个在清单里出现的那个胜出。
  ///
  /// Windows 给**安装包**而不是 zip：让用户下载完还要自己解压、自己建桌面快捷方式，
  /// 是这一整套体验里最别扭的一环。zip 仍在 OSS 上，只是不再推荐给普通用户。
  ///
  /// Android 给**自己实际在跑的那个 ABI** 的包，后面再跟一个兜底：
  /// 更新必须与安装时同一个 ABI，否则那份包在用户的机器上根本装不上
  /// （32 位设备装不了 arm64；64 位-only 的系统装不了只有 armv7 的包）。
  /// 详见 `lib/utils/android_abi.dart` 的说明。清单里没有匹配的那份时退到兜底，
  /// 绝不因为"找不到资产"就把更新提示整个吞掉——界面还有下载页那条退路。
  ///
  /// 名字对不上时 [fetchLatest] 会拿不到 assetUrl，界面退回下载页 —— 是有意留的兜底：
  /// 万一某次发布没构建出安装包，用户还能从下载页自己找 zip，而不是卡在一个死链上。
  static List<String> assetNamesFor(String platform) => switch (platform) {
        'android' => _androidAssetNames(),
        'windows' => const ['mianyang_quiz-windows-x64-setup.exe'],
        _ => const [],
      };

  static List<String> _androidAssetNames() {
    final matched = AndroidAbi.assetForAbi(AndroidAbi.detect());
    if (matched == AndroidAbi.fallbackAsset) return const [AndroidAbi.fallbackAsset];
    return [matched, AndroidAbi.fallbackAsset];
  }

  Future<AppRelease?> fetchLatest({required String platform}) async {
    final host = Env.ossPublicHost;
    if (host.isEmpty) return null;
    try {
      // 清单只有几十 KB；带时间戳绕开 CDN/客户端缓存，保证版本号与网页端同步。
      final res = await _dio.get<Map<String, dynamic>>(
        'https://$host/client/latest.json?t=${DateTime.now().millisecondsSinceEpoch}',
        options: Options(
          // 别把非 2xx 转成 DioException 抛出来：这里只关心拿没拿到
          validateStatus: (code) => code != null && code >= 200 && code < 300,
        ),
      );
      final data = res.data;
      final tag = data?['tag'] as String?;
      if (tag == null || tag.isEmpty) return null;
      // 没有资产直链时退回网页端下载页（它同样只读 OSS 清单）
      final pageUrl = '${Env.shareBaseUrl}/download';
      final assetNames = assetNamesFor(platform);
      final assets = (data?['assets'] as List?) ?? const [];
      String? assetUrl;
      // 按优先级找：自己那个 ABI 的包 → 兜底包 → （都没有就退回下载页）
      for (final name in assetNames) {
        for (final a in assets) {
          if (a is Map && a['name'] == name) {
            final url = a['url'];
            if (url is String && url.isNotEmpty) assetUrl = url;
            break;
          }
        }
        if (assetUrl != null) break;
      }
      // 清单里的 url 为空（旧清单、还没回填）就让它空着：调用方会退回下载页
      //（pageUrl），页面上那颗按钮会直连 OSS 取包。
      return (tag: tag, pageUrl: pageUrl, assetUrl: assetUrl);
    } catch (_) {
      return null;
    }
  }
}
