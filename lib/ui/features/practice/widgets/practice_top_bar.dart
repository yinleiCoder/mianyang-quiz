// 练习页顶栏：退出按钮 + 进度条 + 计时 + 「7/20」计数 +（窄屏）答题卡入口。
//
// 学多邻国：进度条在最上方且很粗，退出按钮是一个不抢眼的 ×，
// 计数只在右侧小字显示——用户主要看的是"还剩多少"的视觉长度，不是数字。
//
// 答题卡入口只在窄屏出现：宽屏下它是右侧常驻面板（见 PracticeStage），
// 同一个东西给两个入口只会让人以为点了会去不同地方。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_timer.dart';

class PracticeTopBar extends StatelessWidget {
  const PracticeTopBar({
    super.key,
    required this.index,
    required this.total,
    required this.progress,
    required this.startedAt,
    required this.onExit,
    this.onOpenAnswerSheet,
  });

  /// 当前题号，**从 1 开始**（界面不显示 0/20 这种）。
  final int index;
  final int total;

  /// 0~1，已作答占比（不是"看到第几题"——这样进度条只在真正完成时走满）。
  final double progress;

  /// 计时起点（练习页打开的时刻）。
  final DateTime startedAt;

  final VoidCallback onExit;

  /// 打开答题卡（窄屏传；宽屏为 null，因为答题卡常驻在右侧）。
  final VoidCallback? onOpenAnswerSheet;

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
        // 计时在题号**右侧**：左侧留给"还剩多少"（进度条 + 计数），
        // 时间属于"已经过去"的信息，跟它们分开摆不容易读串
        //
        // 右边留一口气：宽屏时右边紧挨着答题卡栏的竖分割线（PracticeLayout），
        // 不留白数字就贴上去——与考试页同一条（学生反馈的是考试页）。
        Padding(
          padding: const EdgeInsets.only(right: AppMetrics.gapMd),
          child: PracticeTimer(startedAt: startedAt),
        ),
        if (onOpenAnswerSheet != null)
          IconButton(
            onPressed: onOpenAnswerSheet,
            icon: Icon(Icons.grid_view_rounded, size: 20.r),
            color: theme.colorScheme.onSurfaceVariant,
            tooltip: '答题卡',
          ),
      ],
    );
  }
}
