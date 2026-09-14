// 题干。复合题的**材料**也走这里（QuestionView 会传 label: '材料'）。
//
// 职责：渲染块数组形式的题干 —— 文字段落 + 内联媒体；内容全空时给一句占位文案，
// 而不是留一片让人以为「加载失败」的空白。可选的小标签用来区分「材料」与「子题题干」。
// 不负责：解析（AnalysisView）、选项与作答（input/*）、取数。
// 题干的媒体规则全在 BlockListView / BlockMediaView 里，这里不重复实现。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/question/block_list_view.dart';

class StemView extends StatelessWidget {
  const StemView({
    super.key,
    required this.blocks,
    this.label,
    this.textStyle,
    this.placeholder,
  });

  final List<Block> blocks;

  /// 可选小标签（如「材料」）。null 时不占位。
  final String? label;

  /// 正文样式，默认 AppTextStyles.body。子题卡里会传小一号的样式。
  final TextStyle? textStyle;

  /// 内容为空时的占位文案。null = 什么都不显示。
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          DuoChip(label: label!, tone: DuoChipTone.brand, dense: true),
          SizedBox(height: AppMetrics.gapSm.r),
        ],
        BlockListView(
          blocks: blocks,
          textStyle: textStyle ?? AppTextStyles.body(context),
          placeholder: placeholder,
        ),
      ],
    );
  }
}
