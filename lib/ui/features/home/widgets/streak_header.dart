// 工作台顶部：问候 + 连续练习天数 + **本月答题热力图** + 今日进度。
//
// 游戏化只做**有数据支撑**的部分：streak_days / today_answers / month_daily 都来自
// practice_dashboard，不编造经验值/等级/体力这类后端没有的东西。
//
// 热力图是学生试用后点名要的（先说"改成日历签到"，看到日历后又要求 GitHub 热力图那种
// 按天染色、答得越多越深）。只给一个"连续 N 天"的数字看不出这个月哪天投入得多，深浅才看得出。
//
// **宽屏并排（2:1）、窄屏堆叠**：热力图占三分之二，连续天数与今日进度占三分之一。
// 热力图自己会按可用宽度算格子大小，所以给它多宽就用多宽，不会留白；
// 窄屏（手机上）堆叠，那时热力图本来就跟卡片差不多宽。
//
// 连续天数用暖色强调，今日进度用主色（"今天还没做完"），热力图用语义绿（"练过"）——
// 三者性质不同，不该长成一个样子。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/heatmap_block.dart';

class StreakHeader extends StatelessWidget {
  const StreakHeader({super.key, required this.name, required this.dashboard});

  final String name;
  final PracticeDashboard dashboard;

  /// 每日目标。后端没有这个概念，取一个固定值用于进度条——
  /// 它只影响"今天还差几题"的视觉提示，不参与任何统计与排行。
  static const int dailyGoal = 10;

  /// 并排所需的最小内容宽度：热力图约 150 + 间距 24 + 右侧至少 300 才不至于挤。
  /// 比全站那个 kWideBreakpoint(900) 小得多——那是"侧栏要不要收"的阈值，
  /// 这里问的是"这张卡内部够不够并排"，两件事。
  static const double _minWidthForRow = 480;

  @override
  Widget build(BuildContext context) {
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
        DuoCard(
          padding: const EdgeInsets.all(AppMetrics.gapLg),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final heatmap = HeatmapBlock(dashboard: dashboard);
              final stats = _TodayProgress(dashboard: dashboard, goal: dailyGoal);
              final title = _StreakTitle(dashboard: dashboard);

              if (constraints.maxWidth < _minWidthForRow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: AppMetrics.gapLg),
                    heatmap,
                    const SizedBox(height: AppMetrics.gapLg),
                    stats,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 热力图占三分之二：它自己会按拿到的宽度算格子大小，
                  // 给多少用多少，所以这么分就是"图上占三分之二"。
                  Expanded(flex: 2, child: heatmap),
                  SizedBox(width: AppMetrics.gapXl.r),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: AppMetrics.gapLg),
                        stats,
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 🔥 连续练习 N 天（没练过时是鼓励语）。
class _StreakTitle extends StatelessWidget {
  const _StreakTitle({required this.dashboard});

  final PracticeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasStreak = dashboard.streakDays > 0;

    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          size: 32.r,
          color: hasStreak ? context.semantic.warning : scheme.outlineVariant,
        ),
        const SizedBox(width: AppMetrics.gapMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasStreak ? '连续练习 ${dashboard.streakDays} 天' : '今天开始练习吧',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                hasStreak ? '保持下去，别断了' : '每天练几题，进步看得见',
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

/// 今日进度：一行文字 + 一根进度条。
class _TodayProgress extends StatelessWidget {
  const _TodayProgress({required this.dashboard, required this.goal});

  final PracticeDashboard dashboard;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final today = dashboard.todayAnswers;
    final goalReached = today >= goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          goalReached ? '今日已完成 $today 题 🎉' : '今日 $today / $goal 题',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppMetrics.gapSm),
        DuoProgressBar(value: (today / goal).clamp(0, 1).toDouble()),
      ],
    );
  }
}
