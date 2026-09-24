// 考试页顶栏：退出按钮 + 进度条 + **倒计时** + 「7/20」计数 +（窄屏）答题卡入口。
//
// 与练习顶栏（PracticeTopBar）的差别只有一处，但很要紧：那里显示的是"已经花了多久"，
// 这里显示的是"还剩多久"，而且它是**这场考试里最重要的一行字**——所以它排在题号右边、
// 加粗、最后五分钟变红，并且到点会触发自动交卷（见 ExamTimer）。
//
// 退出按钮是 ×（同练习）：考试中途退出的代价比练习大得多，所以点它要过一道确认
// （见 ExamStage），而确认框里会明说"作答已保存在本机"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_timer.dart';

class ExamTopBar extends StatelessWidget {
  const ExamTopBar({
    super.key,
    required this.index,
    required this.total,
    required this.progress,
    required this.deadline,
    required this.onExit,
    required this.onExpired,
    this.onOpenAnswerSheet,
    this.clock,
  });

  /// 当前题号，**从 1 开始**（界面不显示 0/20 这种）。
  final int index;
  final int total;

  /// 0~1，已作答占比（不是"看到第几题"）。
  final double progress;

  final DateTime deadline;
  final VoidCallback onExit;

  /// 倒计时归零。页面据此自动交卷。
  final VoidCallback onExpired;

  /// 打开答题卡（窄屏传；宽屏为 null，因为答题卡常驻在右侧）。
  final VoidCallback? onOpenAnswerSheet;

  /// 测试注入的假时钟，透传给倒计时。
  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: onExit,
          icon: Icon(Icons.close, size: 24.r),
          color: theme.colorScheme.onSurfaceVariant,
          tooltip: '退出考试',
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
        // 右边留一口气：宽屏时它右边就是答题卡的那条竖分割线（ExamStage 的
        // VerticalDivider），不留白的话倒计时数字直接贴上去（学生反馈）。
        // 窄屏时右边是答题卡图标按钮，多这 12 也只是把图标往左挪一点，无害。
        Padding(
          padding: const EdgeInsets.only(right: AppMetrics.gapMd),
          child: ExamTimer(deadline: deadline, onExpired: onExpired, clock: clock),
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
