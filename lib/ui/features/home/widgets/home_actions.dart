// 工作台的三个入口：开始练习 / 参加考试 / 去错题本。
//
// 顺序有两处讲究，都不是排版口味：
//   · 排在统计卡**之前**：新用户首页三项统计全是 0、趋势图也是空的，
//     把入口压在下面等于让他先滚过两块空内容才找得到按钮。先给动作，再给数据。
//   · 排在 ActiveSessionCard **之后**（由 HomePage 保证）：那张卡是护栏，不是便利入口——
//     服务端每人只允许一套进行中的会话，无视它去点「开始一次练习」会静默作废当前进度。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DuoButton(
          label: '开始一次练习',
          icon: Icons.play_arrow,
          onPressed: () => context.push(AppRoutes.composePath),
        ),
        const SizedBox(height: AppMetrics.gapSm),
        DuoButton(
          // 考试入口放首页而不是底部导航：考试是"被安排的事"（老师入库了卷子才有得考），
          // 不像刷题那样随时发生，占一个常驻 tab 会把刷题挤下去。
          label: '参加考试',
          icon: Icons.assignment_outlined,
          variant: DuoButtonVariant.outline,
          onPressed: () => context.push(AppRoutes.examsPath),
        ),
        const SizedBox(height: AppMetrics.gapSm),
        DuoButton(
          // 复习资料入口同样放首页而不是底部导航（与考试同一个判断）：
          // 底部导航已经 5 个（Material 的上限），再挤一个每个都变窄；
          // 资料是"考前集中看"的东西，不像刷题那样天天点。
          label: '复习资料',
          icon: Icons.folder_open_outlined,
          variant: DuoButtonVariant.outline,
          onPressed: () => context.push(AppRoutes.materialsPath),
        ),
        const SizedBox(height: AppMetrics.gapSm),
        DuoButton(
          label: '去错题本看看',
          icon: Icons.history_edu_outlined,
          variant: DuoButtonVariant.outline,
          // 直接用查询参数落到错题本页签，不必新建路由
          onPressed: () => context.go(
            AppRoutes.recordsOf(AppRoutes.recordsTabWrong),
          ),
        ),
        const SizedBox(height: AppMetrics.gapSm),
        DuoButton(
          // 「我的处境」同样放首页：它是"偶尔看一眼"的东西（考完试、想找差距时），
          // 天天点的是"开始练习"，不该占底部导航
          label: '我的处境',
          icon: Icons.leaderboard_outlined,
          variant: DuoButtonVariant.outline,
          onPressed: () => context.push(AppRoutes.myStandingPath),
        ),
      ],
    );
  }
}
