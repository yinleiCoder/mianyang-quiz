// 遗忘曲线的**画布**：两条线画在一张 LineChart 上。
//
// 从 forgetting_curve_card.dart 拆出来只是因为单文件行数上限；
// 拆的边界是「**画什么**」与「**画不画**」——卡片管状态（样本够不够、
// 什么时候该说"还画不出来"），这里只管把给定的点画出来。
//
// 横轴是**距上次练同一道题的天数**，不是等距的：服务端按 0/1/2/3/5/7/14/30 分桶，
// 直接拿天数当 x 坐标才画得出真实的曲线形状（等距摆会把长间隔那几档挤在一起）。
//
// **纵轴从 0 起**：理论线会掉到 21%，只画实测线那一小段会让人以为"我掉得很厉害"。

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';

class ForgettingCurveChart extends StatelessWidget {
  const ForgettingCurveChart({super.key, required this.buckets, required this.height});

  /// **已经筛过的**点（每桶至少 3 次作答、按天数升序）。筛选不在这里做，
  /// 卡片那边已经决定过"该不该画"了。
  final List<ForgettingBucket> buckets;

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final axisStyle = theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant);

    return SizedBox(
      height: height.r,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 30,
          minY: 0,
          maxY: 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 0.25,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: scheme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.r,
                interval: 0.25,
                getTitlesWidget: (value, meta) =>
                    Text('${(value * 100).round()}%', style: axisStyle),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24.r,
                interval: 7,
                getTitlesWidget: (value, meta) =>
                    Text('${value.round()}天', style: axisStyle),
              ),
            ),
          ),
          // fl_chart 的默认 tooltip 把**折线色**当文字色（紫字压在深灰气泡上，糊成一团），
          // 底色也是写死的 blueGrey。按 M3 的 tooltip 配色显式指定。
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final spot in spots) _tooltipFor(spot, scheme),
              ],
            ),
          ),
          lineBarsData: [_measuredLine(scheme), _theoryLine(scheme)],
        ),
      ),
    );
  }

  LineTooltipItem _tooltipFor(LineBarSpot spot, ColorScheme scheme) {
    final style = TextStyle(
      color: scheme.onInverseSurface,
      fontWeight: FontWeight.w700,
      fontSize: 12.sp,
    );
    // 第 0 条是实测线，第 1 条是理论线（顺序见 lineBarsData）
    if (spot.barIndex == 1) {
      return LineTooltipItem('理论 ${(spot.y * 100).round()}%', style);
    }
    final bucket = buckets.firstWhere((b) => b.days.toDouble() == spot.x);
    // 带上 分子/分母：只说百分比看不出这个点有多可信
    return LineTooltipItem(
      '隔 ${bucket.days} 天 · ${(spot.y * 100).round()}%\n'
      '（${bucket.correct}/${bucket.attempts} 次答对）',
      style,
    );
  }

  /// 实测线：学生自己的保持率。
  LineChartBarData _measuredLine(ColorScheme scheme) => LineChartBarData(
    spots: [for (final b in buckets) FlSpot(b.days.toDouble(), b.accuracy)],
    isCurved: true,
    curveSmoothness: 0.2,
    color: scheme.primary,
    barWidth: 3.r,
    dotData: FlDotData(
      show: true,
      getDotPainter: (spot, _, _, _) =>
          FlDotCirclePainter(radius: 4.r, color: scheme.primary, strokeWidth: 0),
    ),
  );

  /// 理论线：虚线 + 中性色。它是参照物，不该跟"我"的数据抢视觉重量。
  LineChartBarData _theoryLine(ColorScheme scheme) => LineChartBarData(
    spots: [
      for (final (day, retention) in ebbinghausSamples(maxDays: 30))
        FlSpot(day, retention),
    ],
    isCurved: false,
    color: scheme.onSurfaceVariant.withValues(alpha: 0.55),
    barWidth: 2.r,
    dashArray: const [6, 4],
    dotData: const FlDotData(show: false),
  );
}
