// 近 14 天答题趋势。
//
// 数据来自 practice_dashboard 的 daily：数据库**已经补零并升序排列**，
// 所以这里不做任何填充或排序——服务端给的就是可以直接画的点。
//
// 用 LineChart（折线）而不是柱状：服务端返回的是"连续 14 天"的等间隔序列，
// 折线能让人一眼看出趋势走向；柱状更适合展示不连续的离散分类。
//
// 只画"答题数"，正确率用点的颜色深浅隐含表达——把两条量纲不同的曲线压在
// 一张图上（数量 vs 百分比）反而两边都读不准。

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';

class DailyTrendChart extends StatelessWidget {
  const DailyTrendChart({super.key, required this.daily, this.height = 180});

  final List<DailyStat> daily;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (daily.isEmpty) {
      return SizedBox(
        height: height.r,
        child: Center(
          child: Text(
            '还没有练习记录',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    /// tooltip 里显示 MM-DD（库里是 YYYY-MM-DD）；越界（浮点取整到边界外）时留空。
    String shortDate(double x) {
      final index = x.round();
      if (index < 0 || index >= daily.length) return '';
      final date = daily[index].date;
      return date.length >= 10 ? date.substring(5) : date;
    }

    final maxCount = daily.fold<int>(0, (max, d) => d.count > max ? d.count : max);
    // 全为 0 时也要给出一个有意义的纵轴上限，否则图表会退化成一个点
    final maxY = (maxCount == 0 ? 1 : maxCount).toDouble() * 1.2;

    return SizedBox(
      height: height.r,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (daily.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY / 2).clamp(1, double.infinity),
            getDrawingHorizontalLine: (_) => FlLine(
              color: scheme.outlineVariant,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.r,
                interval: (maxY / 2).clamp(1, double.infinity),
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24.r,
                // 14 个点全标会糊成一片，只标首、中、尾
                interval: (daily.length - 1) / 2,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= daily.length) {
                    return const SizedBox.shrink();
                  }
                  final date = daily[index].date;
                  // 数据库给的是 YYYY-MM-DD，只显示 MM-DD
                  final short = date.length >= 10 ? date.substring(5) : date;
                  return Text(
                    short,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          ),
          // fl_chart 的默认 tooltip 把**折线色**当文字色（紫字压在深灰气泡上，糊成一团），
          // 底色也是写死的 blueGrey。按 M3 的 tooltip 配色显式指定：inverseSurface 底 +
          // onInverseSurface 字，亮暗两套主题都跟着变。
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  LineTooltipItem(
                    '${shortDate(spot.x)} · ${spot.y.toInt()} 题',
                    TextStyle(
                      color: scheme.onInverseSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < daily.length; i++)
                  FlSpot(i.toDouble(), daily[i].count.toDouble()),
              ],
              isCurved: true,
              curveSmoothness: 0.25,
              color: scheme.primary,
              barWidth: 3.r,
              dotData: FlDotData(
                show: daily.length <= 14,
                getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                  radius: 3.r,
                  color: scheme.primary,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: scheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
