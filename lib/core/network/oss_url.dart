// OSS 对象展示地址合成。
//
// 职责：把库里存的媒体 key（`qbank/2026/09/<uuid>.png`、`avatars/…`）拼成可访问的 URL。
// 不负责：上传——见 data/services/oss_upload_service.dart。
//
// 规则必须与网页端 lib/oss-url.js **逐条一致**，否则两端对同一道题会显示不同的图：
//   [of] 原始合成
//     · 空 key → 空串（调用方据此显示占位，不要显示 broken image）
//     · 已经是 http(s):// 开头的完整 URL → 原样透传（兼容历史数据里直接落库的完整地址）
//     · 其余 → `https://{OSS_PUBLIC_HOST}/{key}`
//   [media] 在 of 之上叠加 OSS 图片处理（x-oss-process），与网页端同一套规则
//     · 只有图片扩展名才附加：非图片带上会得到 HTTP 400「This image format is not
//       supported.」，附件整条打不开（实测 .xlsx 即如此）
//     · GIF 只缩放、不转 webp —— 动图会被转成静态图，动画丢失
//     · 档位宽度与网页端 MEDIA_WIDTHS 一一对应
//
// 只读公网域名，不需要鉴权，因此可以直接交给 Image 组件与缓存库。
// cached_network_image 按 URL 做磁盘缓存，改档位后旧缓存自然过期，无需迁移。

import 'package:mianyang_quiz/core/config/env.dart';

abstract final class OssUrl {
  static final _absolute = RegExp(r'^https?://', caseSensitive: false);

  /// 展示档位宽度，与网页端 MEDIA_WIDTHS 一一对应。
  ///   avatar 96   头像最大显示 44px，覆盖 2x 屏
  ///   thumb  720  题干/选项内联插图
  ///   full   1600 全屏查看，需要细节
  static const int avatarWidth = 96;
  static const int thumbWidth = 720;
  static const int fullWidth = 1600;

  /// 能被 OSS 图片处理接受的扩展名，与网页端 IMAGE_EXTS 及 lib/media-spec.js 一致。硬边界，别扩。
  static const _imageExts = {'png', 'jpg', 'jpeg', 'webp', 'gif'};

  /// 动图：只缩放，绝不 format 转换。
  static const _animatedExts = {'gif'};

  /// 媒体 key 或完整 URL → 可展示地址（**不做图片处理**）。无法合成时返回空串。
  static String of(String? key) {
    if (key == null || key.isEmpty) return '';
    if (_absolute.hasMatch(key)) return key;
    if (Env.ossPublicHost.isEmpty) return '';
    return 'https://${Env.ossPublicHost}/$key';
  }

  /// 头像：固定小尺寸档。
  static String avatar(String? key) => media(key, width: avatarWidth);

  /// 图片 → 带 OSS 图片处理的展示地址；非图片、非自有域名一律退化为 [of]。
  static String media(String? key, {int width = thumbWidth}) {
    if (key == null || key.isEmpty) return '';
    final base = of(key);
    if (base.isEmpty || Env.ossPublicHost.isEmpty) return base;
    // 只处理自家 OSS 域名：库里兼容历史完整 URL，那些可能指向别处或自带签名，
    // 贸然追加查询参数会破坏它们。
    if (!base.startsWith('https://${Env.ossPublicHost}/')) return base;
    final ext = _extOf(key);
    if (!_imageExts.contains(ext)) return base;
    // 不要加 limit_0：它的语义是「允许放大」，带上会把小图拉大（更糊也更慢）；
    // 缺省的 limit_1 才是「只缩不放」，正是我们要的。
    // quality 用绝对质量 Q_80 而非相对 q_80：相对质量 = 原图质量 × q%，对已被压过的图会二次劣化。
    final w = width.clamp(1, 16384);
    final resize = 'image/resize,w_$w';
    final spec = _animatedExts.contains(ext)
        ? resize
        : '$resize/quality,Q_80/format,webp';
    return '$base?x-oss-process=$spec';
  }

  static String _extOf(String key) {
    final path = key.split(RegExp(r'[?#]')).first;
    final dot = path.lastIndexOf('.');
    return dot < 0 ? '' : path.substring(dot + 1).toLowerCase();
  }
}
