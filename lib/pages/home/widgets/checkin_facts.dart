// 打卡区的三个辅助数字：累计打卡 / 今日目标 / 今日已答。
//
// 宽屏下它夹在「连续打卡 N 天」和今日进度之间，把右侧那一栏的高度填满
// （用户 2026-10-24：打卡区域要与热力图等高，并分摊孩子组件的空间）。
// 单独成文件是因为 streak_header.dart 已接近 200 行上限。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class CheckinFacts extends StatelessWidget {
  const CheckinFacts({
    super.key,
    required this.totalDays,
    required this.goal,
    required this.todayAnswers,
  });

  final int totalDays;
  final int goal;
  final int todayAnswers;

  @override
  Widget build(BuildContext context) {
    return DuoCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapMd.r,
        vertical: AppMetrics.gapMd.r,
      ),
      child: Row(
        children: [
          Expanded(
            child: _Fact(
              icon: Icons.calendar_month_outlined,
              label: '累计打卡',
              value: '$totalDays 天',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _Fact(
              icon: Icons.flag_outlined,
              label: '今日目标',
              value: '$goal 题',
            ),
          ),
          const _Divider(),
          Expanded(
            child: _Fact(
              icon: Icons.task_alt_rounded,
              label: '今日已答',
              value: '$todayAnswers 题',
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 22.r, color: scheme.primary),
        SizedBox(width: AppMetrics.gapSm.r),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: scheme.onSurfaceVariant),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36.r,
    child: VerticalDivider(
      width: AppMetrics.gapMd.r * 2,
      color: Theme.of(context).colorScheme.outlineVariant,
    ),
  );
}
