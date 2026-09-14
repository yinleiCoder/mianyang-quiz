// 块数组渲染：题干、选项文字、解析都走这里。
//
// 内容契约：`[{t:'text',text}|{t:'media',kind,key,url,alt}]`
// 文本块空串会被跳过（出题端可能留下空段落），避免渲染出一堆空白间距。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/ui/core/question/block_media_view.dart';

class BlockListView extends StatelessWidget {
  const BlockListView({
    super.key,
    required this.blocks,
    this.textStyle,
    this.compact = false,
    this.placeholder,
  });

  final List<Block> blocks;
  final TextStyle? textStyle;

  /// 紧凑模式：媒体限高更小、段落间距更紧（选项文字用）。
  final bool compact;

  /// 内容全空时显示的占位文案（如「（题干为空）」）。
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = textStyle ?? theme.textTheme.bodyLarge;
    // Block 是 sealed，这里可以直接模式匹配，不必强转
    final visible = blocks.where((block) => switch (block) {
      TextBlock(:final text) => text.trim().isNotEmpty,
      MediaBlock() => true,
    }).toList();

    if (visible.isEmpty) {
      if (placeholder == null) return const SizedBox.shrink();
      return Text(
        placeholder!,
        style: style?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in visible)
          switch (block) {
            TextBlock(:final text) => Padding(
              padding: EdgeInsets.only(bottom: compact ? 2.r : AppMetrics.gapSm),
              child: Text(text, style: style),
            ),
            MediaBlock() => BlockMediaView(block: block, compact: compact),
          },
      ],
    );
  }
}
