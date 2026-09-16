// 图片块：内联显示一档（720），点开全屏看另一档（1600）。
//
// 原图直出时一张题干插图实测 7.6MB，缩过之后内联只有 38KB —— 差一个数量级。
// 所以两档宽度取自 OssUrl.thumbWidth / OssUrl.fullWidth，不要在这里另写数字。

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/question/media_fallback.dart';

class ImageBlockView extends StatelessWidget {
  const ImageBlockView({
    super.key,
    required this.thumbUrl,
    required this.fullUrl,
    required this.compact,
  });

  /// 内联显示的一档（720）。
  final String thumbUrl;

  /// 点开全屏的一档（1600）。
  final String fullUrl;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final maxHeight = compact ? 120.0 : 240.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapSm),
      child: GestureDetector(
        // 题干里的示意图常常有细节，点开全屏看
        onTap: () => _showFullscreen(context),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight.r),
          child: CachedNetworkImage(
            imageUrl: thumbUrl,
            fit: BoxFit.contain,
            placeholder: (context, _) => SizedBox(
              height: 80.r,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, _, _) =>
                const MediaFallback(block: null, reason: '图片加载失败'),
          ),
        ),
      ),
    );
  }

  void _showFullscreen(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(AppMetrics.gapXl),
        child: InteractiveViewer(
          // 全屏这一档同样要接住三种状态。这是 1600 的大图，首次打开必须现拉：
          // 少了 placeholder，慢网下用户看到的是一个纯白弹窗——既不知道在加载，
          // 也不知道是不是自己点错了；少了 errorWidget，失败后就是一片空白。
          child: CachedNetworkImage(
            imageUrl: fullUrl,
            fit: BoxFit.contain,
            // 解码尺寸锁在请求档位上：源图可能远大于 1600（例如非图片扩展名走不了
            // OSS 处理），不限制的话会按原图解出几十 MB 的位图。
            memCacheWidth: OssUrl.fullWidth,
            placeholder: (context, _) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, _, _) =>
                const MediaFallback(block: null, reason: '图片加载失败'),
          ),
        ),
      ),
    );
  }
}
