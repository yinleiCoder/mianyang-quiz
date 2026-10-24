// 能在应用内直接看的两种格式的正文：PDF 与图片。
//
// PDF 走 pdfrx（PDFium）：直接吃网络地址边下边看（内部是 Range 请求，不必先整份下完），
// 六端一致。**不要改用 WebView**：Android 的系统 WebView 没有内置 PDF 阅读器，
// 拿它开 PDF 只会白屏——这是选 pdfrx 的直接原因（见 pubspec 里那条注释）。
//
// 图片走 cached_network_image：按 URL 做磁盘缓存，第二次打开不再走流量；
// 外面套 InteractiveViewer 让它能捏合放大（复习资料常是讲义截图，看不清要点一下就放大）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:pdfrx/pdfrx.dart';

class MaterialInlineBody extends StatelessWidget {
  const MaterialInlineBody({super.key, required this.material});

  final MaterialBrief material;

  @override
  Widget build(BuildContext context) {
    // opensInline 只对 pdf/image 为真，调用方已经判过；这里只分这两种
    return material.type.wire == 'image' ? _buildImage() : _buildPdf(context);
  }

  Widget _buildPdf(BuildContext context) {
    return PdfViewer.uri(
      Uri.parse(material.fileUrl),
      params: PdfViewerParams(
        margin: 8,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: AppMetrics.gapMd.r),
              Text(
                totalBytes == null
                    ? '正在打开…'
                    : '正在打开… ${(bytesDownloaded / 1024 / 1024).toStringAsFixed(1)}'
                          ' / ${(totalBytes / 1024 / 1024).toStringAsFixed(1)} MB',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        // 打不开多半是网络（资料是边下边看的），也可能是文件本身坏了。
        // 两句话都要给：只报"失败"会让学生反复重试同一件没用的事。
        errorBannerBuilder: (context, error, stackTrace, documentRef) => Center(
          child: Padding(
            padding: EdgeInsets.all(AppMetrics.gapXl.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, size: 48.r),
                SizedBox(height: AppMetrics.gapMd.r),
                Text('这份 PDF 打不开', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: AppMetrics.gapSm.r),
                Text(
                  '可以试试「保存到本地」后用别的程序打开，或者检查一下网络。',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // **不再套 MaxWidthBox**：讲义截图经常是整页表格，640 的上限让字小到看不清
    // （用户 2026-10-24：图片区域太小）。现在铺满阅读区，靠 InteractiveViewer 放大。
    return InteractiveViewer(
      maxScale: 6,
      child: SizedBox.expand(
        child: AppNetworkImage(
          // 预览走图片处理档，不是原件（见 MaterialBrief.previewUrl）
          imageUrl: material.previewUrl,
          fit: BoxFit.contain,
          placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
          errorWidget: (_, _, _) => const Center(child: Text('图片加载失败')),
        ),
      ),
    );
  }
}
