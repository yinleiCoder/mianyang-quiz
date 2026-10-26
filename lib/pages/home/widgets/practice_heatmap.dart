// 练习热力图：**只画本月**的日历小方格，答得越多颜色越深。
//
// 用户 2026-10-24：只要本月。每个月是周一→周日的日历，按天染色；不再并排多个月。
// 日历在分到的宽度里居中，格子最大 64（超宽屏也不至于变成一块块大色板）。
//
// 起止以服务端给的 to 为准，不自己推日期——本机时区与服务器差一天时两边各算一次
// 就会错位。配色沿用 GitHub primer 的五档绿；分档用固定阈值，避免按最大值切把
// 绝大多数日子压进同一档。

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/month_heatmap_grid.dart';

class PracticeHeatmap extends StatelessWidget {
  const PracticeHeatmap({
    super.key,
    required this.days,
    required this.from,
    required this.to,
    required this.width,
  });

  /// 逐日答题数（只含有作答的日子）。
  final List<DailyStat> days;
  final String? from;
  final String? to;

  /// 这块区域被分配到的宽度（由外层算好，避免在 IntrinsicHeight 里用 LayoutBuilder）。
  final double width;

  /// 只画本月；保留这个函数是为了外层的说明文字不用自己算月份。
  static int monthsForWidth(double width) => 1;

  /// 这块宽度下显示的第一个月（就是 to 所在月的 1 号）。
  static DateTime firstMonthFor(double width, DateTime to) =>
      DateTime(to.year, to.month, 1);

  static const _githubLight = [
    Color(0xFFEBEDF0),
    Color(0xFF9BE9A8),
    Color(0xFF40C463),
    Color(0xFF30A14E),
    Color(0xFF216E39),
  ];
  static const _githubDark = [
    Color(0xFF161B22),
    Color(0xFF0E4429),
    Color(0xFF006D32),
    Color(0xFF26A641),
    Color(0xFF39D353),
  ];

  @override
  Widget build(BuildContext context) {
    final end = _parseDate(to) ?? _today();
    final month = firstMonthFor(width, end);
    final counts = {
      for (final day in days)
        if (day.count > 0) day.date: day.count,
    };
    final today = _today();
    // 16 列 × 2 行：宽度用满、高度只有两格（用户 2026-10-25：日历式太高太窄）。
    const maxCell = 48.0;
    final gridWidth = math.min(
      width,
      MonthHeatmapGrid.columns * maxCell +
          (MonthHeatmapGrid.columns - 1) * MonthHeatmapGrid.gap,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: gridWidth,
        child: MonthHeatmapGrid(
          month: month,
          counts: counts,
          today: today,
          width: gridWidth,
          maxCell: maxCell,
          shade: (n) => shadeOf(Theme.of(context).brightness, n),
        ),
      ),
    );
  }

  /// 某一档的颜色。测试直接断言它，避免从渲染树里反推。
  @visibleForTesting
  static Color shadeOf(Brightness brightness, int count) {
    final palette = brightness == Brightness.dark
        ? _githubDark
        : _githubLight;
    final level = switch (count) {
      <= 0 => 0,
      <= 2 => 1,
      <= 5 => 2,
      <= 10 => 3,
      _ => 4,
    };
    return palette[level];
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime? _parseDate(String? raw) {
    if (raw == null) return null;
    final parts = raw.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }
}
