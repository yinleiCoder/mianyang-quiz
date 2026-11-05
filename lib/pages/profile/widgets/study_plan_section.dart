// 「我的 → 学习计划」：今日目标题数 + 科学抽题原则 + FSRS / BKT + 遗忘曲线。
//
// 用户口径（2026-10-24）：默认 20 题，可在「我的」里设置；目标下方要展示
// 本软件的科学抽题原则与遗忘曲线原理，让学生知道"为什么今天给我这些题"。
//
// 文案与实现同源（迁移 0122 的 BKT + 0125/0126 的 FSRS 抽题 + 0067 的遗忘曲线）：
// 不写"AI 智能推送"这类没有实现支撑的话。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/profile/widgets/profile_entry_tile.dart';
import 'package:mianyang_quiz/pages/profile/widgets/study_goal_sheet.dart';
import 'package:provider/provider.dart';

class StudyPlanSection extends StatelessWidget {
  const StudyPlanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final goal = context.select<CheckinStore, int>((store) => store.dailyGoal);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: '学习计划'),
        ProfileEntryTile(
          icon: Icons.flag_outlined,
          label: '今日目标题数',
          subtitle: '每天 $goal 题 · 点击调整',
          onTap: () => showStudyGoalSheet(context),
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        const _PrincipleCard(),
      ],
    );
  }
}

/// 抽题原则 + FSRS / BKT + 遗忘曲线原理。四条都是产品真实在做的事，不写成营销文案。
class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
      height: 1.5,
    );

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Point(
            icon: Icons.filter_alt_outlined,
            title: '科学抽题原则',
            body: '${ScienceNotes.selection}需要加练时可以在组卷页手动打开。',
            style: muted,
            scheme: scheme,
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          _Point(
            icon: Icons.event_repeat_outlined,
            title: 'FSRS 复习排期',
            body: '${ScienceNotes.fsrs}「到期复习」就是按它排出来的。',
            style: muted,
            scheme: scheme,
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          _Point(
            icon: Icons.insights_rounded,
            title: 'BKT 掌握度',
            body: '${ScienceNotes.bkt}「AI 学习路径」里的掌握度与推荐顺序由它决定。',
            style: muted,
            scheme: scheme,
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          _Point(
            icon: Icons.timeline_rounded,
            title: '艾宾浩斯遗忘曲线',
            body: '${ScienceNotes.forgetting}首页会画出你的实测保持率与理论线对比。',
            style: muted,
            scheme: scheme,
          ),
        ],
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({
    required this.icon,
    required this.title,
    required this.body,
    required this.style,
    required this.scheme,
  });

  final IconData icon;
  final String title;
  final String body;
  final TextStyle? style;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: scheme.primary),
        SizedBox(width: AppMetrics.gapSm.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(body, style: style),
            ],
          ),
        ),
      ],
    );
  }
}
