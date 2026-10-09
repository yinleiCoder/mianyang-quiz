// 成绩单上的「下一轮 / 上一轮 / 重讲本轮」三个入口（0095）。
//
// 只给不计分的课堂讲练（顺序练习）用：一轮最多 100 道，讲完一轮要能接着讲下一轮。
// 在此之前成绩单上只有一个「再来一轮」，而它每次都从第 1 道重新开始——
// 题库里第 101 道之后的题，在讲练模式下根本到不了。
//
// 这里**只挪轮次并回到组卷页**，不在本页直接开练，两个理由：
//   1. 抽题的完整流程（等看板、处理进行中的会话、今天练完了的重试）在组卷页那一侧
//      （pages/compose/start_practice_flow.dart）。而 pages/practice 不准 import
//      pages/compose —— 跨模块复用必须上提到 widgets/ 或 state/，由
//      tool/check_architecture.dart 强制；那个流程又依赖 material_ui 与两个弹层，
//      上提不进 state/（Store 必须无 UI 依赖）。所以正确的落点就是"回组卷页再开"。
//   2. 顺带也是好事：教师能在组卷页看清这一轮覆盖第几道到第几道，再按开始。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RoundNavButtons extends StatelessWidget {
  const RoundNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = context.watch<PracticeDraftStore>();
    final total = draft.totalAvailable;

    // 回组卷页用 replace：本页（成绩单）在讲完这一轮后已经翻篇了，
    // 留在返回栈里只会让"返回"退回到一份过期的成绩。
    void toCompose(VoidCallback move) {
      move();
      context.pushReplacement(AppRoutes.composePath);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (total != null) ...[
          Text(
            '第 ${draft.round} 轮 · 第 ${draft.roundFrom}–${draft.roundTo} 题'
            ' · 符合条件的共 $total 道',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppMetrics.gapMd.r),
        ],
        // 下一轮：唯一"要不要继续"的入口，所以放在最显眼的位置。
        // 已经到最后一轮时不显示——比亮着却点不动更少歧义。
        if (draft.hasNextRound) ...[
          DuoButton(
            label: '下一轮讲练',
            icon: Icons.arrow_forward,
            onPressed: () => toCompose(draft.nextRound),
          ),
          SizedBox(height: AppMetrics.gapMd.r),
        ],
        Row(
          children: [
            Expanded(
              child: DuoButton(
                label: '上一轮',
                icon: Icons.arrow_back,
                variant: DuoButtonVariant.outline,
                compact: true,
                onPressed: draft.hasPrevRound
                    ? () => toCompose(draft.prevRound)
                    : null,
              ),
            ),
            SizedBox(width: AppMetrics.gapMd.r),
            Expanded(
              child: DuoButton(
                label: '重讲本轮',
                icon: Icons.replay,
                variant: DuoButtonVariant.outline,
                compact: true,
                // 轮次不动，回组卷页按开始就是同一批题再讲一遍。
                onPressed: () => context.pushReplacement(AppRoutes.composePath),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
