// 考试页底部操作区：上一题 / 下一题（末题变交卷）/ 提前交卷。
//
// 与练习的批量模式底部条几乎一样（考试也是"自由翻页、最后统一提交"），
// 差别只在**提前交卷必须随时可达**：一场 90 分钟的卷子，答完的人凭什么要按 20 次
// "下一题"才能交？所以非末题时右侧多一颗 ghost 的「交卷」。
//
// **三颗按钮都不带图标**：加上图标后，手机上（400 逻辑像素宽）这一行放不下三个
// 图标 + 三组文字，前两颗会被压成「上…」「下…」——真机联调时就是这样。
// 图标在这里只是装饰，文字才是意思，所以砍图标留文字。
//
// 未作答的题只提醒、不阻止——真实考试也允许弃答，弃答在服务端就是空作答。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';

class ExamBottomBar extends StatelessWidget {
  const ExamBottomBar({
    super.key,
    required this.runner,
    required this.onFinish,
  });

  final ExamRunner runner;

  /// 交卷（确认框由舞台弹出，这里只负责发信号）。
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unanswered = runner.total - runner.answeredCount;
    final busy = runner.submitting;
    final isLast = runner.isLast;

    return Padding(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (unanswered > 0 && !busy)
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
                  compact: true,
                  onPressed: busy || runner.isFirst ? null : runner.retreat,
                ),
              ),
              SizedBox(width: AppMetrics.gapMd.r),
              Expanded(
                child: DuoButton(
                  label: isLast ? '交卷' : '下一题',
                  variant: isLast
                      ? DuoButtonVariant.primary
                      : DuoButtonVariant.outline,
                  compact: true,
                  loading: isLast && busy,
                  // 末题时右按钮就是交卷；否则往后翻
                  onPressed: busy
                      ? null
                      : (isLast ? onFinish : runner.advance),
                ),
              ),
              // 非末题时的提前交卷。末题已经有一颗主色交卷了，不再重复。
              if (!isLast) ...[
                SizedBox(width: AppMetrics.gapMd.r),
                DuoButton(
                  label: '交卷',
                  variant: DuoButtonVariant.ghost,
                  compact: true,
                  expand: false,
                  loading: busy,
                  onPressed: busy ? null : onFinish,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
