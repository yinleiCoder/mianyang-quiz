// 内容限宽盒：桌面端页面的「正文栏」。
//
// 职责：把内容限制在 pageMaxWidth 内并居中，让宽屏上不会出现一行 200 个字的题干。
// 不负责：背景与滚动——需要通栏背景时把背景铺在外层，这个盒子只管内容。
//
// 手机端 maxWidth 通常大于屏宽，等于什么都不做；所以页面可以无脑套一层。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    super.key,
    required this.child,
    this.maxWidth = AppMetrics.pageMaxWidth,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;

  /// 内容最大宽度，默认 pageMaxWidth（640）。
  final double maxWidth;

  /// 限宽后在剩余空间里的对齐方式；默认顶对齐居中（页面从顶部开始长）。
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth.r),
        child: child,
      ),
    );
  }
}
