// 工作台顶部：问候 + **云端连续打卡** + 今日进度 + 答题热力图。
//
// 打卡口径（2026-10-24 用户定）：**进入软件就算当天打卡**，数据存云端（0107），
// 不再是"练过题才算连续"。连续天数优先读 CheckinStore；云端没取到时回落到
// 看板里的练习天数（老数据、断网都能显示一个合理的数字）。
//
// 布局：宽屏是"热力图 + 右侧打卡/进度"两栏，**两栏等高、右侧纵向分摊**：
// 连续天数在上、今日进度在下，中间留白自然撑开。热力图是固定 7 列（周一→周日），
// 宽度由格子决定，所以不再按 2:1 分——右侧拿剩下的全部空间。
//
// 火苗随连续天数变化：0 天是灰色描边，1~2 天小火焰，3~6 天更亮，
// 7~13 天换 whatshot，14 天以上最大最亮。学生很在意这个数字，反馈要"看得出来在涨"。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/home/widgets/heatmap_block.dart';
import 'package:provider/provider.dart';

class StreakHeader extends StatelessWidget {
  const StreakHeader({super.key, required this.name, required this.dashboard});

  final String name;
  final PracticeDashboard dashboard;

  /// 并排所需的最小内容宽度：热力图约 210 + 间距 + 右侧至少 260。
  static const double _minWidthForRow = 480;

  @override
  Widget build(BuildContext context) {
    // 只订阅需要的两个数字：CheckinStore 的目标变化会重建打卡区，但不该牵动整页。
    final checkin = context.select<CheckinStore, CheckinStatus?>(
      (store) => store.data,
    );
    final streak = checkin?.streakDays ?? dashboard.streakDays;
    final goal = checkin?.dailyGoal ?? 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你好，$name',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppMetrics.gapLg),
        LayoutBuilder(
          builder: (context, constraints) {
            final heatmap = HeatmapBlock(dashboard: dashboard);
            final stats = Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StreakTitle(streak: streak),
                _TodayProgress(dashboard: dashboard, goal: goal),
              ],
            );

            if (constraints.maxWidth < _minWidthForRow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StreakTitle(streak: streak),
                  const SizedBox(height: AppMetrics.gapLg),
                  heatmap,
                  const SizedBox(height: AppMetrics.gapLg),
                  _TodayProgress(dashboard: dashboard, goal: goal),
                ],
              );
            }
            // 两栏等高：热力图的固有高度就是行数 × 格子高度；
            // 右侧 spaceBetween 把标题与进度摊到上下两端（用户要的"分摊孩子组件空间"）。
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  heatmap,
                  SizedBox(width: AppMetrics.gapXl.r),
                  Expanded(child: stats),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 🔥 连续打卡 N 天（没打卡时是鼓励语）。火苗的大小与形态随天数变化。
class _StreakTitle extends StatelessWidget {
  const _StreakTitle({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    final active = streak > 0;
    // 14 天封顶：再往大就压到标题行了；封顶后仍然换更亮的图标。
    final flameSize = 28 + math.min(streak, 14) / 14 * 12;
    final icon = streak >= 14
        ? Icons.whatshot_rounded
        : Icons.local_fire_department_rounded;
    final color = !active
        ? scheme.outlineVariant
        : streak >= 7
        ? scheme.error
        : semantic.warning;

    return Row(
      children: [
        Icon(icon, size: flameSize.r, color: color),
        const SizedBox(width: AppMetrics.gapMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                active ? '连续打卡 $streak 天' : '今天开始打卡吧',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                active ? '每天打开软件就算打卡，保持下去别断了' : '每天打开软件就算打卡',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 今日进度：一行文字 + 一根进度条。目标题数由「我的」设置（云端，默认 20）。
class _TodayProgress extends StatelessWidget {
  const _TodayProgress({required this.dashboard, required this.goal});

  final PracticeDashboard dashboard;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final today = dashboard.todayAnswers;
    final safeGoal = goal <= 0 ? 20 : goal;
    final goalReached = today >= safeGoal;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          goalReached ? '今日已完成 $today 题 🎉' : '今日 $today / $safeGoal 题',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppMetrics.gapSm.r),
        DuoProgressBar(value: (today / safeGoal).clamp(0, 1).toDouble()),
        SizedBox(height: AppMetrics.gapXs.r),
        Text(
          goalReached ? '目标达成，还可以继续加练' : '今天还差 ${safeGoal - today} 题到目标',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
