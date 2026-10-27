// 查最新版本：读 OSS 上的 client/latest.json（与网页端 /download 同一份清单）。
//
// 为什么不再读 GitHub API：GitHub 在国内取不到字节，版本检查也会跟着超时/静默失败，
// 于是出现"网页端已经 v2.8.1、客户端还说没有新版本"。发布流水线把清单写到 OSS，
// 版本号与下载直链都在里面，客户端读它就是与网页端同源。
//
// APK 的下载地址由清单直接给出：指向本站的 `/api/client/download` 路由。阿里云默认域名
// 不能分发 .apk（key 后缀 / Content-Type / 文件名三条都挡），那条路由取 OSS 里的
// `.bin` 副本、补上正确的文件名与类型再吐给浏览器。万一清单里的 url 还是空的
//（旧清单、还没回填），这里按同一个口径自己拼一条路由地址。Windows 直接用清单里的
// OSS 直链。失败一律返回 null（没发过版、断网、清单还没写）：调用方静默跳过——
// 更新提示是锦上添花，绝不能因为它把启动流程搞出一个错误弹窗。

import 'package:dio/dio.dart';
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

  /// 当前平台的安装包资产名。与流水线里的资产名**逐字一致**（那边特意不带版本号，
  /// 这样同一个 OSS key 永远指向最新版）。
  ///
  /// Windows 给**安装包**而不是 zip：让用户下载完还要自己解压、自己建桌面快捷方式，
  /// 是这一整套体验里最别扭的一环。zip 仍在 OSS 上，只是不再推荐给普通用户。
  ///
  /// 名字对不上时 [fetchLatest] 会拿不到 assetUrl，界面退回下载页 —— 是有意留的兜底：
  /// 万一某次发布没构建出安装包，用户还能从下载页自己找 zip，而不是卡在一个死链上。
  static String? assetNameFor(String platform) => switch (platform) {
    'android' => 'mianyang_quiz-android.apk',
    'windows' => 'mianyang_quiz-windows-x64-setup.exe',
    _ => null,
  };

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
      final assetName = assetNameFor(platform);
      final assets = (data?['assets'] as List?) ?? const [];
      String? assetUrl;
      if (assetName != null) {
        for (final a in assets) {
          if (a is Map && a['name'] == assetName) {
            final url = a['url'];
            if (url is String && url.isNotEmpty) assetUrl = url;
            break;
          }
        }
        // 清单里的 url 为空（旧清单）时按同一个口径拼本站下载路由：路由只按资产名
        // 取对象，不依赖清单内容。版本号只用于缓存键，缺了也能下。
        // **只对 Android 这样做**：路由只认 APK，Windows 资产名传进去只会得到 404，
        // 那种情况应该退回下载页（pageUrl）。
        if (assetUrl == null && platform == 'android') {
          final base = Env.shareBaseUrl.endsWith('/')
              ? Env.shareBaseUrl.substring(0, Env.shareBaseUrl.length - 1)
              : Env.shareBaseUrl;
          assetUrl =
              '$base/api/client/download?name=${Uri.encodeComponent(assetName)}';
        }
      }
      return (tag: tag, pageUrl: pageUrl, assetUrl: assetUrl);
    } catch (_) {
      return null;
    }
  }
}
