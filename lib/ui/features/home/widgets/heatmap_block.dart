// 答题热力图 + 它下面那行小字（「近 20 周 · 已练 12 天，共 268 题」）。
//
// 从 streak_header 里拆出来：那边管"这张卡怎么排版"（宽屏并排、窄屏堆叠），
// 这边管"图长什么样"。单文件行数上限是硬约束（tool/check_architecture.dart）。
//
// 中文月份只能从这里给——热力图那个包自带的标签只有 en/de/fr/es
// （见 practice_heatmap.dart）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/practice_heatmap.dart';

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

  /// 「近 20 周 · 已练 12 天，共 268 题」。深浅是相对的，具体数字才让人心里有数。
  static String _caption(PracticeDashboard dashboard) {
    final active = dashboard.heatmapDaily.where((day) => day.count > 0);
    final total = active.fold<int>(0, (sum, day) => sum + day.count);
    return '近 ${_windowWeeks(dashboard)} 周 · 已练 ${active.length} 天，共 $total 题';
  }

  /// 窗口几周。用起止日期算，别写死 20——服务端改窗口时这里要跟着对。
  static int _windowWeeks(PracticeDashboard dashboard) {
    final from = DateTime.tryParse(dashboard.heatmapFrom ?? '');
    final to = DateTime.tryParse(dashboard.heatmapTo ?? '');
    if (from == null || to == null) return 20;
    return (to.difference(from).inDays / 7).round().clamp(1, 999);
  }
}

