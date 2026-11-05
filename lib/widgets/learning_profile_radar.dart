// 六轴学习画像雷达图（fl_chart）。
//
// 只由 learning_profile_view.dart 在“六轴齐全/半画像”时渲染；数据不足时由外层显示
// “成长中”，不画一个缺角的形状。颜色全部走主题色，深浅色自动适配。
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class LearningProfileRadar extends StatelessWidget {
  const LearningProfileRadar({super.key, required this.axes});

  final List<LearningProfileAxis> axes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labels = axes.map((axis) => axis.label).toList();

    return SizedBox(
      height: 240.r,
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              dataEntries: axes
                  .map((axis) => RadarEntry(value: axis.score ?? 0.0))
                  .toList(),
              fillColor: scheme.primary.withValues(alpha: 0.20),
              borderColor: scheme.primary,
              borderWidth: 2,
              entryRadius: 3,
            ),
          ],
          getTitle: (index, angle) => RadarChartTitle(text: labels[index]),
          titleTextStyle: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          titlePositionPercentageOffset: 0.12,
          tickCount: 4,
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
          tickBorderData: BorderSide(color: scheme.outlineVariant, width: 1),
          gridBorderData: BorderSide(color: scheme.outlineVariant, width: 1),
          radarBorderData: BorderSide(color: scheme.outlineVariant, width: 1),
          radarShape: RadarShape.polygon,
          isMinValueAtCenter: true,
        ),
      ),
    );
  }
}
