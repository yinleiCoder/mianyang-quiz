// 练习热力图：GitHub 贡献图那种按天染色的小方格，答得越多颜色越深。
//
// 窗口是**近 20 周（一个学期）**，不是一个月：一个月只有 5 列，要占满卡片的三分之二
// 就得把每格放大到 127px——那是马赛克不是热力图。GitHub 那种饱满感来自列数，20 列刚好。
//
// 用 pub.dev 的 contribution_heatmap：它是自定义 RenderBox，**不读 Material 主题**
// （源码里 Theme.of 零处，只有工具类用了 Colors 常量），所以不会踩本项目
// "两套 Material" 那个坑；颜色由 customColorScale 从我们的语义色算出来。
// 代价是它的标签只有 en/de/fr/es，所以这里**关掉它自带的月份标签**，
// 中文说明由外层那行小字给（见 heatmap_block.dart）。
//
// **格子尺寸按可用宽度算**，让它永远正好填满自己的框：桌面宽窗上每格约 26-32px
// （就是 GitHub 的观感），手机上自动缩到 12px 左右仍然放得下 20 列，不必横向滚动。
// 上限 34 是防止超宽屏上格子大到失真。
//
// 配色分档而不是线性：题库里一天做 3 题和一天做 400 题都可能有，
// 按最大值线性铺开的话，绝大多数日子会被压成同一个浅色。

import 'dart:math' as math;

import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';

class PracticeHeatmap extends StatelessWidget {
  const PracticeHeatmap({
    super.key,
    required this.days,
    required this.from,
    required this.to,
  });

  /// 逐日答题数（只含有作答的日子）。
  final List<DailyStat> days;

  /// 窗口起止（`YYYY-MM-DD`，含两端）。缺一个或格式不对就不画——
  /// 宁可少一块，也不要画一张日期错位的图。
  final String? from;
  final String? to;

  /// 每列（一周）连间距的宽度上限。超过就不再放大，免得超宽屏上格子大到失真。
  static const double _maxUnit = 34;

  /// 间距占一列宽的比例。格子与间距都从"一列宽"里分，这样两端对齐得很干净。
  static const double _gapRatio = 0.22;

  @override
  Widget build(BuildContext context) {
    final start = _parseDate(from);
    final end = _parseDate(to);
    if (start == null || end == null || end.isBefore(start)) {
      return const SizedBox.shrink();
    }

    // 与包内部的对齐规则保持一致（周一开头、周日结尾），否则算出来的列数对不上，
    // 格子就填不满或溢出。见源码 _computeAlignedDateRange。
    final alignedStart = start.subtract(Duration(days: start.weekday - 1));
    final alignedEnd = end.add(
      Duration(days: DateTime.daysPerWeek - end.weekday),
    );
    // 向上取整：起止经过对齐后**不一定是整周**（周一→周日是 6 天差、7 天跨度），
    // 整除会少算一列，格子就会比可用宽度大一点、右侧被切掉。
    final weeks = math.max(
      1,
      (alignedEnd.difference(alignedStart).inDays / DateTime.daysPerWeek).ceil(),
    );

    final weekdayStyle = TextStyle(
      fontSize: 10.sp,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    // 星期标签画在网格**左边**，而且包把它算进总宽（见源码 performLayout：
    // `padding + leftLabelWidth + gridWidth`）。这里不先扣掉它的话，总宽会比框宽出
    // 一个标签的宽度，多出来的部分正好**画到右边那一栏上**——老师反馈的"有遮挡"就是这个。
    final labelWidth = _weekdayLabelsWidth(weekdayStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = (constraints.maxWidth - labelWidth).clamp(1.0, double.infinity);
        // `weeks` 格里只有 `weeks - 1` 个间距，所以要按 (weeks - 比例) 反推列宽，
        // 算出来的总宽才**正好**等于可用宽度（否则每张图右边都会空出半个间距）。
        final unit = (gridWidth / (weeks - _gapRatio)).clamp(1.0, _maxUnit);
        final spacing = unit * _gapRatio;
        final cell = unit - spacing;

        assert(
          labelWidth + cell * weeks + spacing * (weeks - 1) <=
              constraints.maxWidth + 0.5,
          '热力图比可用宽度还宽，多出来的会画到右边那一栏上',
        );

        return ContributionHeatmap(
          entries: [
            for (final day in days)
              if (_parseDate(day.date) case final date?)
                ContributionEntry(date, day.count),
          ],
          minDate: start,
          maxDate: end,
          cellSize: cell,
          cellSpacing: spacing,
          cellRadius: (cell * 0.2).clamp(1.0, 4.0),
          padding: EdgeInsets.zero,
          // 自带标签只有英文，中文由外层那行小字给
          showMonthLabels: false,
          weekdayLabel: WeekdayLabel.githubLike,
          weekdayTextStyle: weekdayStyle,
          // 颜色全由我们给（包本身不读主题）
          customColorScale: (count) => _shadeOf(context, count),
        );
      },
    );
  }

  /// 星期标签占的宽度。与包自己的算法对齐（见它的 _measureWeekdayLabelsWidth）：
  /// 取最宽的那一个标签，再加 8px 间隙。
  ///
  /// 标签文案是包按 locale 给的英文缩写，中文没有，所以回落成 Mon/Wed/Fri
  /// （githubLike 取第 1/3/5 行）。这里跟着量同样的三个词。
  static double _weekdayLabelsWidth(TextStyle style) {
    var widest = 0.0;
    for (final label in const ['Mon', 'Wed', 'Fri']) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      widest = math.max(widest, painter.width);
    }
    return widest + 8;
  }

  /// GitHub 贡献图的五档配色，**逐字取自 GitHub 的 primer 变量**
  /// （`--color-calendar-graph-day-bg` 与 `-L1-bg` … `-L4-bg`）。
  ///
  /// 不再像原来那样从语义色 lerp 出来：需求就是"要 GitHub 那个绿"，
  /// 而算出来的绿和这一套对不上，摆在一起一眼看得出不是。
  ///
  /// 亮暗各一套 —— GitHub 自己也分两套，深色下那五个绿是完全不同的值
  /// （最深档在亮色里是近黑的墨绿，在暗色里反而最亮）。
  static const _githubLight = [
    Color(0xFFEBEDF0), // 0 题
    Color(0xFF9BE9A8),
    Color(0xFF40C463),
    Color(0xFF30A14E),
    Color(0xFF216E39), // 最深
  ];
  static const _githubDark = [
    Color(0xFF161B22),
    Color(0xFF0E4429),
    Color(0xFF006D32),
    Color(0xFF26A641),
    Color(0xFF39D353),
  ];

  /// 0 题 = 空槽；1 题起明显可见，越多越深，10 题以上到最深档。
  ///
  /// **分档沿用本项目的固定阈值，没照搬 GitHub 的分位法**：GitHub 是按当天最大值
  /// 的四分位切档，而学生一天的题量普遍在 20 以内，按最大值切会把绝大多数日子
  /// 压进同一档、看不出差别。固定阈值在这个量级上区分度更好。
  Color _shadeOf(BuildContext context, int count) {
    final palette = Theme.of(context).brightness == Brightness.dark
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

  /// `YYYY-MM-DD` → DateTime。形状不对返回 null（脏数据不该让热力图崩掉）。
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
