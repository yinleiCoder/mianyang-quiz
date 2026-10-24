// 练习热力图：按天染色的小方格，答得越多颜色越深。
//
// **按周分行、周一→周日从左到右**（用户 2026-10-24 反馈：原来的 GitHub 式
// "一列一周、星期从上往下"看着像竖着数天数）。现在每一行是一周，7 个格子
// 从左到右就是周一到周日；行从上到下是更早的周到更近的周。
//
// 窗口取**近 12 周**（数据端给的是 20 周，这里只画最近 12 周）：12 行 × 7 列
// 在一屏里放得下，再长首页就要为一张图滚很久。窗口起止以服务端给的 to 为准，
// 不自己推日期——本机时区与服务器差一天时两边各算一次就会错位。
//
// 配色沿用 GitHub primer 的五档绿（亮暗各一套）。分档用固定阈值而不是按最大值
// 分位：学生一天的题量普遍在 20 以内，按最大值切会把绝大多数日子压进同一档。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class PracticeHeatmap extends StatelessWidget {
  const PracticeHeatmap({
    super.key,
    required this.days,
    required this.from,
    required this.to,
  });

  /// 逐日答题数（只含有作答的日子）。
  final List<DailyStat> days;

  /// 窗口起止（`YYYY-MM-DD`，含两端）。
  final String? from;
  final String? to;

  /// 最多画 12 周（约三个月）。外层的说明文字要按同一个窗口统计。
  static const int maxWeeks = 12;

  /// 格子边长与间距（逻辑像素，屏幕适配由 .r 处理）。
  static const double _cell = 26;
  static const double _gap = 4;

  static const _weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];

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
    final rawStart = _parseDate(from) ?? end.subtract(const Duration(days: 83));
    final alignedStart = rawStart.subtract(Duration(days: rawStart.weekday - 1));
    final availableWeeks = math
        .max(1, (end.difference(alignedStart).inDays / DateTime.daysPerWeek).ceil())
        .toInt();
    final weeks = math.min(maxWeeks, availableWeeks);
    // 从**最近**的周往前数：取最后 weeks 周，而不是最早的 weeks 周。
    final start = alignedStart.add(
      Duration(days: DateTime.daysPerWeek * (availableWeeks - weeks)),
    );
    final counts = {
      for (final day in days)
        if (day.count > 0) day.date: day.count,
    };
    final today = _today();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _weekdayHeader(context),
        SizedBox(height: _gap.r),
        for (var week = 0; week < weeks; week++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var weekday = 0; weekday < 7; weekday++)
                _Cell(
                  date: start.add(Duration(days: week * 7 + weekday)),
                  count: counts[_key(start.add(Duration(days: week * 7 + weekday)))] ?? 0,
                  future: start
                      .add(Duration(days: week * 7 + weekday))
                      .isAfter(today),
                ),
            ],
          ),
          if (week < weeks - 1) SizedBox(height: _gap.r),
        ],
      ],
    );
  }

  Widget _weekdayHeader(BuildContext context) {
    final style = TextStyle(
      fontSize: 10.sp,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final label in _weekdayLabels) ...[
          // 与格子用同一套 width + 间距，标签才和下面那一列对得齐
          SizedBox(
            width: _cell.r,
            child: Center(child: Text(label, style: style)),
          ),
          SizedBox(width: _gap.r),
        ],
      ],
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

  static String _key(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

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

/// 一个格子。未来的日期画成透明（本周还没到的几天），其余按题量取色。
class _Cell extends StatelessWidget {
  const _Cell({
    required this.date,
    required this.count,
    required this.future,
  });

  final DateTime date;
  final int count;
  final bool future;

  @override
  Widget build(BuildContext context) {
    final cell = Container(
      width: PracticeHeatmap._cell.r,
      height: PracticeHeatmap._cell.r,
      margin: EdgeInsets.only(right: PracticeHeatmap._gap.r),
      decoration: BoxDecoration(
        color: future
            ? Colors.transparent
            : PracticeHeatmap.shadeOf(Theme.of(context).brightness, count),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
    if (future) return cell;
    return Tooltip(
      message: '${PracticeHeatmap._key(date)} · $count 题',
      child: cell,
    );
  }
}
