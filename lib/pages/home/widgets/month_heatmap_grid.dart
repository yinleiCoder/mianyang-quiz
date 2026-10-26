// 本月热力图：把 1 号到月末按天铺成两行（16 列 × 2 行），答得越多颜色越深。
//
// 2026-10-25 用户反馈：日历式 7 列太高、太窄。改成横向铺开的两行：
// 天数从左到右连续排，第一行 1~16 日、第二行 17~月末，宽度用满、高度只有两格。
// 仍保留月份标题；不再画星期表头（两行并不是按星期对齐的）。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

class MonthHeatmapGrid extends StatelessWidget {
  const MonthHeatmapGrid({
    super.key,
    required this.month,
    required this.counts,
    required this.today,
    required this.width,
    required this.shade,
    this.maxCell = 48,
  });

  /// 这个月的 1 号。
  final DateTime month;

  /// `YYYY-MM-DD` → 当天题量。
  final Map<String, int> counts;

  /// 今天（本地日）；之后的日期画成透明。
  final DateTime today;

  /// 本块分到的宽度。
  final double width;

  /// 题量 → 颜色（由外层传入，避免两个文件各维护一套配色）。
  final Color Function(int count) shade;

  final double maxCell;

  /// 格子间距（用户 2026-10-25：每行有点挤，4 → 8）。
  static const double gap = 8;

  /// 每行 16 天：31 天正好两行，横向铺得开。
  static const int columns = 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cols = math.min(columns, daysInMonth);
    // 每格右侧由 Wrap 的 spacing 负责，不再给格子自己加 margin
    final cell = ((width - gap * (cols - 1)) / cols)
        .clamp(8.0, maxCell)
        .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${month.year}年${month.month}月'
          '${month.year == today.year && month.month == today.month ? '（本月）' : ''}',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppMetrics.gapSm.r),
        Wrap(
          spacing: gap.r,
          runSpacing: gap.r,
          children: [
            for (var day = 1; day <= daysInMonth; day++)
              _Cell(
                date: DateTime(month.year, month.month, day),
                count: counts[_key(DateTime(month.year, month.month, day))] ?? 0,
                future: DateTime(month.year, month.month, day).isAfter(today),
                cell: cell,
                shade: shade,
              ),
          ],
        ),
        SizedBox(height: AppMetrics.gapSm.r),
        Text(
          '1 日 → $daysInMonth 日，从左到右',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  static String _key(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.date,
    required this.count,
    required this.future,
    required this.cell,
    required this.shade,
  });

  final DateTime date;
  final int count;
  final bool future;
  final double cell;
  final Color Function(int count) shade;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: cell.r,
      height: cell.r,
      decoration: BoxDecoration(
        color: future ? Colors.transparent : shade(count),
        borderRadius: BorderRadius.circular(
          (cell * 0.18).clamp(2.0, 6.0).toDouble().r,
        ),
      ),
    );
    if (future) return box;
    return Tooltip(
      message: '${MonthHeatmapGrid._key(date)} · $count 题',
      child: box,
    );
  }
}
