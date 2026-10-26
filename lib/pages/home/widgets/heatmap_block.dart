// 答题热力图 + 它下面那行小字（「近 3 个月 · 已练 12 天，共 268 题」）。
//
// 从 streak_header 里拆出来：那边管"这张卡怎么排版"（宽屏并排、窄屏堆叠），
// 这边管"图长什么样"。单文件行数上限是硬约束（tool/check_architecture.dart）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/practice_heatmap.dart';

/// 热力图 + 它下面那行小字。
class HeatmapBlock extends StatelessWidget {
  const HeatmapBlock({
    super.key,
    required this.dashboard,
    required this.width,
  });

  final PracticeDashboard dashboard;

  /// 外层分配到的宽度（宽屏 14 列 / 窄屏 7 列由 PracticeHeatmap 自己选）。
  final double width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      // 单月日历在分到的宽度里居中，说明文字也跟着居中
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        PracticeHeatmap(
          days: dashboard.heatmapDaily,
          from: dashboard.heatmapFrom,
          to: dashboard.heatmapTo,
          width: width,
        ),
        SizedBox(height: AppMetrics.gapSm.r),
        Text(
          _caption(dashboard),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// 「近 3 个月 · 已练 12 天，共 268 题」。只统计**图上真正画出来的月份**。
  String _caption(PracticeDashboard dashboard) {
    final rawTo = DateTime.tryParse(dashboard.heatmapTo ?? '') ?? DateTime.now();
    final to = DateTime(rawTo.year, rawTo.month, rawTo.day);
    final months = PracticeHeatmap.monthsForWidth(width);
    final windowStart = PracticeHeatmap.firstMonthFor(width, to);
    final active = dashboard.heatmapDaily.where((day) {
      final date = DateTime.tryParse(day.date);
      return day.count > 0 && date != null && !date.isBefore(windowStart);
    });
    final total = active.fold<int>(0, (sum, day) => sum + day.count);
    final label = months == 1 ? '本月' : '近 $months 个月';
    return '$label · 已练 ${active.length} 天，共 $total 题';
  }
}

