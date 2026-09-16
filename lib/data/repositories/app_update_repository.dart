// 查最新版本：读 GitHub Releases 的 latest（匿名接口，60 次/小时/IP，够用）。
//
// 为什么直连 GitHub 而不是自建接口：发布流水线已经把包挂在 Release 上（见
// .github/workflows/release.yml），版本号就是 tag，"最新的 tag"天然是权威来源，
// 不需要再维护一个"当前版本"的接口。
//
// 失败一律返回 null（没发过版、限流、断网、公司网屏蔽 github）：调用方据此**静默跳过**——
// 更新提示是锦上添花，绝不能因为它把启动流程搞出一个错误弹窗。

import 'package:dio/dio.dart';
import 'package:mianyang_quiz/core/config/env.dart';

/// 一次 Release 的关键信息。
typedef AppRelease = ({
  /// 形如 `v1.0.1`。
  String tag,
  /// Release 页面地址（兜底：当前平台没有预置资产时打开它）。
  String pageUrl,
  /// 当前平台对应的直接下载地址（Android→apk，Windows→zip）；没有则为 null。
  String? assetUrl,
});

class AppUpdateRepository {
  const AppUpdateRepository(this._dio);

  final Dio _dio;

  /// 当前平台的安装包资产名。与流水线里的资产名**逐字一致**（那边特意不带版本号，
  /// 这样 /releases/latest/download/<名字> 永远指向最新版）。
  static String? assetNameFor(String platform) => switch (platform) {
    'android' => 'mianyang_quiz-android.apk',
    'windows' => 'mianyang_quiz-windows-x64.zip',
    _ => null,
  };

  Future<AppRelease?> fetchLatest({required String platform}) async {
    final repo = Env.updateRepo;
    if (repo.isEmpty) return null;
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        'https://api.github.com/repos/$repo/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github+json'},
          // 别把 GitHub 的 Error 转成 DioException 抛出来：这里只关心拿没拿到
          validateStatus: (code) => code != null && code >= 200 && code < 300,
        ),
      );
      final data = res.data;
      final tag = data?['tag_name'] as String?;
      if (tag == null || tag.isEmpty) return null;
      final pageUrl = (data?['html_url'] as String?) ?? 'https://github.com/$repo/releases';
      final assetName = assetNameFor(platform);
      final assets = (data?['assets'] as List?) ?? const [];
      String? assetUrl;
      if (assetName != null) {
        for (final a in assets) {
          if (a is Map && a['name'] == assetName) {
            assetUrl = a['browser_download_url'] as String?;
            break;
          }
        }
      }
      return (tag: tag, pageUrl: pageUrl, assetUrl: assetUrl);
    } catch (_) {
      return null;
    }
  }
}
