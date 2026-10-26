// 工作台顶部：问候 + **云端连续打卡** + 今日进度 + 答题热力图。
// 打卡口径（2026-10-24）：**进入软件就算当天打卡**，数据存云端（0107）；连续天数
// 优先读 CheckinStore，取不到才回落到看板的练习天数。宽屏两栏等高、右侧纵向分摊。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/home/widgets/checkin_facts.dart';
import 'package:mianyang_quiz/pages/home/widgets/heatmap_block.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_note.dart';
import 'package:provider/provider.dart';

class StreakHeader extends StatelessWidget {
  const StreakHeader({super.key, required this.name, required this.dashboard});

  final String name;
  final PracticeDashboard dashboard;

  /// 并排所需的最小内容宽度：低于它时热力图铺满整行、下面的说明跟着堆叠。
  static const double _minWidthForRow = 900;

  @override
  Widget build(BuildContext context) {
    // 只订阅需要的两个数字：CheckinStore 的目标变化会重建打卡区，但不该牵动整页。
    final checkin = context.select<CheckinStore, CheckinStatus?>(
      (store) => store.data,
    );
    final streak = checkin?.streakDays ?? dashboard.streakDays;
    final goal = checkin?.dailyGoal ?? 20;
    final totalDays = checkin?.totalDays ?? 0;

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
            final wide = constraints.maxWidth >= _minWidthForRow;
            // 5:5 分：热力图两行已经够宽，右侧打卡/原理说明需要更多横向空间
            final heatmapWidth = wide
                ? constraints.maxWidth * 0.5
                : constraints.maxWidth;
            final heatmap = HeatmapBlock(
              dashboard: dashboard,
              width: heatmapWidth,
            );
            final stats = Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StreakTitle(streak: streak),
                CheckinFacts(
                  totalDays: totalDays,
                  goal: goal,
                  todayAnswers: dashboard.todayAnswers,
                ),
                const ScienceNote(),
              ],
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StreakTitle(streak: streak),
                  const SizedBox(height: AppMetrics.gapMd),
                  CheckinFacts(
                    totalDays: totalDays,
                    goal: goal,
                    todayAnswers: dashboard.todayAnswers,
                  ),
                  const SizedBox(height: AppMetrics.gapLg),
                  // 原理说明放在热力图之前：在连续打卡区域就能直接看到
                  const ScienceNote(),
                  const SizedBox(height: AppMetrics.gapLg),
                  heatmap,
                ],
              );
            }
            // 两栏等高：右侧 spaceBetween 把标题、打卡数、原理与进度摊开。
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: heatmapWidth, child: heatmap),
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

