// 查最新版本：读 OSS 上的 client/latest.json（与网页端 /download 同一份清单）。
//
// 为什么不再读 GitHub API：GitHub 在国内取不到字节，版本检查也会跟着超时/静默失败，
// 于是出现"网页端已经 v2.8.1、客户端还说没有新版本"。发布流水线把清单写到 OSS，
// 版本号与下载直链都在里面，客户端读它就是与网页端同源。
//
// APK 的下载地址在清单里可能是 null（阿里云禁止 .apk 从 OSS 默认域名分发），
// 这时用 `Env.ghProxy` + tag + 固定资产名拼 gh-proxy 地址；Windows 直接用清单里的
// OSS 直链。失败一律返回 null（没发过版、断网、清单还没写）：调用方静默跳过——
// 更新提示是锦上添花，绝不能因为它把启动流程搞出一个错误弹窗。

import 'package:dio/dio.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 客户端仓库（资产名与流水线逐字一致）。只用于拼 gh-proxy 的 Release 地址。
const _repo = 'yinleiCoder/mianyang-quiz';

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
        // 清单没有 OSS 直链（典型是 APK，阿里云默认域名不允许下载 .apk）：
        // 用 gh-proxy + 清单里的 tag 拼 Release 地址，版本与网页端同源。
        if (assetUrl == null && Env.ghProxy.isNotEmpty) {
          final proxy = Env.ghProxy.endsWith('/')
              ? Env.ghProxy
              : '${Env.ghProxy}/';
          assetUrl =
              '${proxy}https://github.com/$_repo/releases/download/'
              '${Uri.encodeComponent(tag)}/$assetName';
        }
      }
      return (tag: tag, pageUrl: pageUrl, assetUrl: assetUrl);
    } catch (_) {
      return null;
    }
  }
}
