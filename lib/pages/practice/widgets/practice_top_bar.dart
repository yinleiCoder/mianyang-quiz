// 练习页顶栏：退出按钮 + 进度条 + 计时 + 「7/20」计数 +（窄屏）答题卡入口。
//
// 学多邻国：进度条在最上方且很粗，退出按钮是一个不抢眼的 ×，
// 计数只在右侧小字显示——用户主要看的是"还剩多少"的视觉长度，不是数字。
//
// 答题卡入口只在窄屏出现：宽屏下它是右侧常驻面板（见 PracticeStage），
// 同一个东西给两个入口只会让人以为点了会去不同地方。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_timer.dart';

class PracticeTopBar extends StatelessWidget {
  const PracticeTopBar({
    super.key,
    required this.index,
    required this.total,
    required this.progress,
    required this.runner,
    required this.onExit,
    this.onOpenAnswerSheet,
  });

  /// 当前题号，**从 1 开始**（界面不显示 0/20 这种）。
  final int index;
  final int total;

  /// 0~1，已作答占比（不是"看到第几题"——这样进度条只在真正完成时走满）。
  final double progress;

  /// 计时的事实来源。计时器要能暂停，而暂停状态在 Runner 里（见 PracticeRunner）——
  /// 所以这里传整个 runner，而不是一个 startedAt 快照。
  final PracticeRunner runner;

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
        // 不计分的那一轮（课堂讲练 / 顺序练习）在这里挂一枚小标：学生答错一堆之后
        // 回头翻错题本找不到，会以为软件坏了——**在错的那一刻就告诉他这一轮不入库**。
        if (!runner.mode.countsTowardStats)
          const Padding(
            padding: EdgeInsets.only(right: AppMetrics.gapSm),
            child: DuoChip(
              label: '不计分',
              tone: DuoChipTone.neutral,
              dense: true,
            ),
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
        // 时间属于"已经过去"的信息，跟它们分开摆不容易读串。
        // 它同时是暂停按钮——学生接电话、被叫走时点一下，那段时间不走进任何用时。
        //
        // 右边留一口气：宽屏时右边紧挨着答题卡栏的竖分割线（PracticeLayout），
        // 不留白数字就贴上去——与考试页同一条（学生反馈的是考试页）。
        Padding(
          padding: const EdgeInsets.only(right: AppMetrics.gapMd),
          child: PracticeTimer(runner: runner),
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
