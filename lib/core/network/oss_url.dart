// OSS 对象展示地址合成。
//
// 职责：把库里存的媒体 key（`qbank/2026/09/<uuid>.png`、`avatars/…`）拼成可访问的 URL。
// 不负责：上传——见 data/services/oss_upload_service.dart。
//
// 规则必须与网页端 lib/oss-url.js **逐条一致**，否则两端对同一道题会显示不同的图：
//   · 空 key → 空串（调用方据此显示占位，不要显示 broken image）
//   · 已经是 http(s):// 开头的完整 URL → 原样透传（兼容历史数据里直接落库的完整地址）
//   · 其余 → `https://{OSS_PUBLIC_HOST}/{key}`
//
// 只读公网域名，不需要鉴权，因此可以直接交给 Image 组件与缓存库。

import 'package:mianyang_quiz/core/config/env.dart';

abstract final class OssUrl {
  static final _absolute = RegExp(r'^https?://', caseSensitive: false);

  /// 媒体 key 或完整 URL → 可展示地址。无法合成时返回空串。
  static String of(String? key) {
    if (key == null || key.isEmpty) return '';
    if (_absolute.hasMatch(key)) return key;
    if (Env.ossPublicHost.isEmpty) return '';
    return 'https://${Env.ossPublicHost}/$key';
  }
}
