// 全站网络图片的统一入口：磁盘缓存 + 解码尺寸 + 三态兜底。
//
// 用户 2026-10-24 要求"软件中涉及的图片都应当缓存"。cached_network_image 默认
// 确实会缓存，但默认配置是 **30 天 / 200 个对象**（flutter_cache_manager 的默认
// Config），题库插图、头像、讲义截图加起来很容易把旧对象挤掉，于是同一张图过几天
// 又走一遍流量。这里统一换成一个更长、更大的缓存池。
//
// 所有 CachedNetworkImage 调用点都应改走本组件：一个是缓存配置只有一份，
// 另一个是占位/失败态不再各画一套（漏了 errorWidget 的地方会是一片空白）。
//
// 注意 cacheKey 用完整 URL：OSS 的 `x-oss-process` 是查询参数，不同档位（thumb/full）
// 必须是不同的缓存对象，不能按去参后的路径合并。

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:material_ui/material_ui.dart';

/// 媒体图片共用的磁盘缓存池：半年、3000 个对象。
final CacheManager appImageCacheManager = CacheManager(
  Config(
    'mianyang_media_v1',
    stalePeriod: const Duration(days: 180),
    maxNrOfCacheObjects: 3000,
  ),
);

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.memCacheWidth,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// 解码宽度上限。大图（1600 档）建议显式传，避免按原图解出几十 MB 的位图。
  final int? memCacheWidth;

  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, Object)? errorWidget;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
    imageUrl: imageUrl,
    cacheManager: appImageCacheManager,
    fit: fit,
    width: width,
    height: height,
    memCacheWidth: memCacheWidth,
    fadeInDuration: const Duration(milliseconds: 150),
    placeholder: placeholder ??
        (context, _) => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
    errorWidget: errorWidget ??
        (context, _, _) => Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
  );
}
