// 图片块：内联显示一档（720），点开全屏看另一档（1600）。
//
// 原图直出时一张题干插图实测 7.6MB，缩过之后内联只有 38KB —— 差一个数量级。
// 所以两档宽度取自 OssUrl.thumbWidth / OssUrl.fullWidth，不要在这里另写数字。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/app_network_image.dart';
import 'package:mianyang_quiz/widgets/media_fallback.dart';

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
          child: AppNetworkImage(
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
    // **整屏**看，四周不留 Dialog 的内边距（用户 2026-10-24：图片区域太小了）。
    // 黑底 + 右上角关闭 + InteractiveViewer：题干里的示意图经常要看小字，
    // 之前的 insetPadding 让 1600 的图在桌面上还没题干区大。
    showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: SizedBox.expand(
                  child: AppNetworkImage(
                    imageUrl: fullUrl,
                    fit: BoxFit.contain,
                    // 解码尺寸锁在请求档位上：源图可能远大于 1600（例如非图片扩展名
                    // 走不了 OSS 处理），不限制的话会按原图解出几十 MB 的位图。
                    memCacheWidth: OssUrl.fullWidth,
                    placeholder: (context, _) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, _, _) =>
                        const MediaFallback(block: null, reason: '图片加载失败'),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: IconButton.filled(
                  tooltip: '关闭',
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
