// 练习热力图的测试（2026-10-24 改为按月）。
//
// 盯三件事：
//   · 宽屏并排 3 个月、中宽 2 个、窄屏 1 个；
//   · 每个月是真正的日历：周一→周日从左到右，跨周另起一行；
//   · 配色分档与脏数据兜底不退化。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/month_heatmap_grid.dart';
import 'package:mianyang_quiz/pages/home/widgets/practice_heatmap.dart';

void main() {
  testWidgets('只显示本月：宽屏与窄屏都只有一张月历', (tester) async {
    await _pump(tester, from: '2026-06-01', to: '2026-09-30', days: const [], width: 1200);
    expect(find.byType(MonthHeatmapGrid), findsOneWidget);
    expect(find.text('2026年9月'), findsOneWidget);
    expect(find.text('2026年8月'), findsNothing);

    await _pump(tester, from: '2026-06-01', to: '2026-09-30', days: const [], width: 390);
    expect(find.byType(MonthHeatmapGrid), findsOneWidget);
    expect(find.text('2026年9月'), findsOneWidget);
    expect(find.text('2026年8月'), findsNothing);
  });

  testWidgets('本月按天从左到右铺两行，第 17 天换行', (tester) async {
    await _pump(tester, from: '2026-09-01', to: '2026-09-30', days: const [], width: 390);

    final first = tester.getTopLeft(find.byTooltip('2026-09-01 · 0 题'));
    final second = tester.getTopLeft(find.byTooltip('2026-09-02 · 0 题'));
    final sixteenth = tester.getTopLeft(find.byTooltip('2026-09-16 · 0 题'));
    final seventeenth = tester.getTopLeft(find.byTooltip('2026-09-17 · 0 题'));

    expect(second.dx, greaterThan(first.dx));
    expect(second.dy, closeTo(first.dy, 0.5));
    expect(sixteenth.dy, closeTo(first.dy, 0.5));
    expect(seventeenth.dy, greaterThan(sixteenth.dy), reason: '第 17 天换到第二行');
    expect(find.text('1 日 → 30 日，从左到右'), findsOneWidget);
  });

  testWidgets('颜色：没作答是空槽，作答越多越深', (tester) async {
    await _pump(tester, from: '2026-09-01', to: '2026-09-30', days: const []);

    expect(
      PracticeHeatmap.shadeOf(Brightness.light, 0),
      const Color(0xFFEBEDF0),
    );
    final luminances = [1, 3, 8, 20]
        .map((n) => PracticeHeatmap.shadeOf(Brightness.light, n).computeLuminance())
        .toList();
    for (var i = 1; i < luminances.length; i++) {
      expect(luminances[i], lessThan(luminances[i - 1]));
    }
    expect(
      PracticeHeatmap.shadeOf(Brightness.light, 999),
      const Color(0xFF216E39),
    );
    expect(
      PracticeHeatmap.shadeOf(Brightness.dark, 999),
      const Color(0xFF39D353),
    );
  });

  testWidgets('脏数据被忽略，不影响其余日子', (tester) async {
    await _pump(
      tester,
      from: '2026-09-01',
      to: '2026-09-30',
      days: const [
        DailyStat(date: '坏数据', count: 5),
        DailyStat(date: '2026-09-30', count: 7),
      ],
    );

    expect(find.byTooltip('2026-09-30 · 7 题'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('窗口缺失时不崩（回落到今天）', (tester) async {
    await _pump(tester, from: null, to: null, days: const []);
    expect(tester.takeException(), isNull);
    expect(find.byType(PracticeHeatmap), findsOneWidget);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required String? from,
  required String? to,
  required List<DailyStat> days,
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: PracticeHeatmap(
              days: days,
              from: from,
              to: to,
              width: width,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
