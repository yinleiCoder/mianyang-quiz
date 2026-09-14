// 工作台顶部：问候 + 连续练习天数 + 今日进度。
//
// 游戏化只做**有数据支撑**的部分：streak_days 与 today_answers 都来自
// practice_dashboard，不编造经验值/等级/体力这类后端没有的东西。
//
// 连续天数用暖色强调（它是"别断"的动机），今日进度用主色（它是"今天还没做完"的提醒）——
// 两者性质不同，不该长成一个样子。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class StreakHeader extends StatelessWidget {
  const StreakHeader({super.key, required this.name, required this.dashboard});

  final String name;
  final PracticeDashboard dashboard;

  /// 每日目标。后端没有这个概念，取一个固定值用于进度条——
  /// 它只影响"今天还差几题"的视觉提示，不参与任何统计与排行。
  static const int dailyGoal = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = dashboard.todayAnswers;
    final goalReached = today >= dailyGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你好，$name',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppMetrics.gapLg),
        DuoCard(
          padding: const EdgeInsets.all(AppMetrics.gapLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 32.r,
                    color: dashboard.streakDays > 0
                        ? context.semantic.warning
                        : scheme.outlineVariant,
                  ),
                  const SizedBox(width: AppMetrics.gapMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dashboard.streakDays > 0
                              ? '连续练习 ${dashboard.streakDays} 天'
                              : '今天开始练习吧',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          dashboard.streakDays > 0
                              ? '保持下去，别断了'
                              : '每天练几题，进步看得见',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.gapLg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goalReached
                          ? '今日已完成 $today 题 🎉'
                          : '今日 $today / $dailyGoal 题',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.gapSm),
              DuoProgressBar(
                value: (today / dailyGoal).clamp(0, 1).toDouble(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
