// 单个媒体块的渲染入口：按 kind 分发到具体视图。
//
// 四类（对应 content 里的 kind）：
//   image  内联显示，可点开缩放（题干里的示意图很常见，必须内联）
//   audio / video / file  不做内嵌播放器，改为"可打开的条目标"交给系统程序
//
// 各分支的实现拆在同目录的 image_block_view.dart / external_media_row.dart /
// media_fallback.dart：本文件只负责"选哪个"，改一类媒体的排版不必翻整份分发逻辑。
//
// 地址合成统一走 OssUrl（与网页端 lib/oss-url.js 同规则）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/ui/core/question/external_media_row.dart';
import 'package:mianyang_quiz/ui/core/question/image_block_view.dart';
import 'package:mianyang_quiz/ui/core/question/media_fallback.dart';

class BlockMediaView extends StatelessWidget {
  const BlockMediaView({super.key, required this.block, this.compact = false});

  final MediaBlock block;

  /// 紧凑模式：用在选项等空间受限处（图片限高更小）。
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // 同一个 key 出两档地址：内联显示用 720，点开全屏用 1600。
    final key = block.key.isNotEmpty ? block.key : block.url;
    final url = OssUrl.of(key);
    final thumbUrl = OssUrl.media(key);
    final fullUrl = OssUrl.media(key, width: OssUrl.fullWidth);

    // 地址合成不出来（配置缺失或 key 为空）时给出可读提示，而不是 broken image
    if (url.isEmpty) {
      return MediaFallback(block: block, reason: '媒体地址无效');
    }

    return switch (block.kind) {
      'image' => ImageBlockView(
        thumbUrl: thumbUrl,
        fullUrl: fullUrl,
        compact: compact,
      ),
      _ => ExternalMediaRow(block: block, url: url),
    };
  }
}
