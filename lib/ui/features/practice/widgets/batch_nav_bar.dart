// 批量模式的底部导航：上一题 / 题号 / 下一题 / 交卷。
//
// 与即时模式的差别：这里不判题，用户自由翻页、随时改答案，交卷才提交。
// 所以底部条要表达的是"你在整卷的哪个位置"，而不是"这题对不对"。
//
// 未作答的题在交卷时要提醒——但不阻止（真实考试也允许弃答，弃答在结算里是 omitted）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';

class BatchNavBar extends StatelessWidget {
  const BatchNavBar({
    super.key,
    required this.runner,
    required this.onFinish,
    this.busy = false,
  });

  final PracticeRunner runner;
  final VoidCallback onFinish;

  /// 交卷在途：右按钮转圈并挡住重复点击（见 PracticeStage._finishing）。
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unanswered = runner.total - runner.answeredCount;

    return Padding(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unanswered > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AppMetrics.gapMd),
              child: Text(
                '还有 $unanswered 道题没作答，交卷后将计入未作答',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: DuoButton(
                  label: '上一题',
                  variant: DuoButtonVariant.outline,
                  icon: Icons.arrow_back,
                  compact: true,
                  onPressed: runner.isFirst ? null : runner.retreat,
                ),
              ),
              Expanded(
                child: DuoButton(
                  label: runner.isLast ? '交卷' : '下一题',
                  variant: runner.isLast
                      ? DuoButtonVariant.primary
                      : DuoButtonVariant.outline,
                  icon: runner.isLast ? Icons.flag_outlined : Icons.arrow_forward,
                  compact: true,
                  // 只有交卷那一档会转圈：翻页是本地动作，不该被交卷的在途状态拖住
                  loading: runner.isLast && busy,
                  // 最后一题时右按钮变成交卷；否则到末题前都能往后
                  onPressed: runner.isLast ? onFinish : runner.advance,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
