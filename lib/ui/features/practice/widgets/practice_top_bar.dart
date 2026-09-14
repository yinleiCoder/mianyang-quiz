// 练习页顶栏：退出按钮 + 进度条 + 「7/20」计数。
//
// 学多邻国：进度条在最上方且很粗，退出按钮是一个不抢眼的 ×，
// 计数只在右侧小字显示——用户主要看的是"还剩多少"的视觉长度，不是数字。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';

class PracticeTopBar extends StatelessWidget {
  const PracticeTopBar({
    super.key,
    required this.index,
    required this.total,
    required this.progress,
    required this.onExit,
  });

  /// 当前题号，**从 1 开始**（界面不显示 0/20 这种）。
  final int index;
  final int total;

  /// 0~1，已作答占比（不是"看到第几题"——这样进度条只在真正完成时走满）。
  final double progress;

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: onExit,
          icon: Icon(Icons.close, size: 24.r),
          color: theme.colorScheme.onSurfaceVariant,
          tooltip: '退出练习',
        ),
        Expanded(
          child: DuoProgressBar(value: progress),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppMetrics.gapMd),
          child: Text(
            '$index/$total',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
