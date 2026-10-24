// 答题热力图 + 它下面那行小字（「近 20 周 · 已练 12 天，共 268 题」）。
//
// 从 streak_header 里拆出来：那边管"这张卡怎么排版"（宽屏并排、窄屏堆叠），
// 这边管"图长什么样"。单文件行数上限是硬约束（tool/check_architecture.dart）。
//
// 中文月份只能从这里给——热力图那个包自带的标签只有 en/de/fr/es
// （见 practice_heatmap.dart）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/practice_heatmap.dart';

/// 热力图 + 它下面那行小字。
class HeatmapBlock extends StatelessWidget {
  const HeatmapBlock({super.key, required this.dashboard});

  final PracticeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        PracticeHeatmap(
          days: dashboard.heatmapDaily,
          from: dashboard.heatmapFrom,
          to: dashboard.heatmapTo,
        ),
        SizedBox(height: AppMetrics.gapSm.r),
        Text(
          _caption(dashboard),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  /// 「近 12 周 · 已练 12 天，共 268 题」。深浅是相对的，具体数字才让人心里有数。
  ///
  /// 只统计**图上真正画出来的窗口**（最近 12 周），不是服务端给的 20 周：
  /// 否则说明里说 268 题、图上却少了一半，看起来像数字错了。
  static String _caption(PracticeDashboard dashboard) {
    final rawTo = DateTime.tryParse(dashboard.heatmapTo ?? '') ?? DateTime.now();
    final to = DateTime(rawTo.year, rawTo.month, rawTo.day);
    // 与 PracticeHeatmap 的窗口对齐：周一开头，往前数 maxWeeks-1 周
    final monday = to.subtract(Duration(days: to.weekday - 1));
    final windowStart = monday.subtract(
      const Duration(days: (PracticeHeatmap.maxWeeks - 1) * 7),
    );
    final active = dashboard.heatmapDaily.where((day) {
      final date = DateTime.tryParse(day.date);
      return day.count > 0 && date != null && !date.isBefore(windowStart);
    });
    final total = active.fold<int>(0, (sum, day) => sum + day.count);
    return '近 ${PracticeHeatmap.maxWeeks} 周 · 已练 ${active.length} 天，共 $total 题';
  }
}

