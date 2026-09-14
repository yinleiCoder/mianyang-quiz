// 顶部粗进度条：练习进度、正确率、完成度都用它。
//
// 职责：一条高 progressHeight 的全圆角进度条，数值变化带轻微动画（不做弹跳，
// 刷题时进度条乱跳很干扰）。越界的脏值会被夹回 0~1。
// 不负责：不确定进度的转圈（那种用 CircularProgressIndicator）、也不负责百分比口径——
// showLabel 只负责把数值画出来，怎么算由调用方决定。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';

class DuoProgressBar extends StatelessWidget {
  const DuoProgressBar({
    super.key,
    required this.value,
    this.height,
    this.showLabel = false,
  });

  /// 进度，0~1。
  final double value;

  /// 条高，默认 progressHeight（14）。
  final double? height;

  /// 是否在右侧显示百分比。
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clamped = value.clamp(0.0, 1.0);
    final barHeight = (height ?? AppMetrics.progressHeight).r;

    final bar = TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: clamped),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, animated, child) => LinearProgressIndicator(
        value: animated,
        minHeight: barHeight,
        borderRadius: BorderRadius.circular(barHeight / 2),
        backgroundColor: scheme.surfaceContainerHighest,
        color: scheme.primary,
      ),
    );

    if (!showLabel) return bar;

    return Row(
      children: [
        Expanded(child: bar),
        SizedBox(width: AppMetrics.gapSm.r),
        Text(
          '${(clamped * 100).round()}%',
          style: AppTextStyles.caption(context).copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
