// 练习热力图的测试。
//
// 用户 2026-10-24 的明确口径：**按周分行、周一到周日从左到右**（原来的
// GitHub 式"一列一周、从上往下"被否掉了）。所以这里首先盯方向，其次盯配色分档：
// 方向错了整张图就不可读，深浅分不出来则失去了"答得越多越深"的意义。
//
// 格子尺寸不再按可用宽度拉伸（固定 26），所以旧的"铺满宽度"断言换成
// "12 周 × 7 列共 84 格、不溢出"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/practice_heatmap.dart';

void main() {
  testWidgets('按周分行：12 周 × 7 列 = 84 个格子', (tester) async {
    await _pump(
      tester,
      from: '2026-05-01',
      to: '2026-09-17',
      days: const [],
    );

    final cells = find.descendant(
      of: find.byType(PracticeHeatmap),
      matching: find.byType(Container),
    );
    expect(cells, findsNWidgets(PracticeHeatmap.maxWeeks * 7));
    expect(tester.takeException(), isNull);
  });

  testWidgets('周一到周日从左到右（x 递增、y 相同）', (tester) async {
    await _pump(
      tester,
      from: '2026-09-01',
      to: '2026-09-17',
      days: const [],
    );

    // 2026-09-14 是周一；14→17 在同一行
    final monday = tester.getTopLeft(find.byTooltip('2026-09-14 · 0 题'));
    final tuesday = tester.getTopLeft(find.byTooltip('2026-09-15 · 0 题'));
    final thursday = tester.getTopLeft(find.byTooltip('2026-09-17 · 0 题'));

    expect(tuesday.dx, greaterThan(monday.dx));
    expect(thursday.dx, greaterThan(tuesday.dx));
    expect(tuesday.dy, closeTo(monday.dy, 0.5));
    expect(thursday.dy, closeTo(monday.dy, 0.5));
  });

  testWidgets('颜色：没作答是空槽，作答越多越深', (tester) async {
    await _pump(tester, from: '2026-09-01', to: '2026-09-17', days: const []);

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
    // 暗色是另一套值（最深档反而更亮）
    expect(
      PracticeHeatmap.shadeOf(Brightness.dark, 0),
      const Color(0xFF161B22),
    );
    expect(
      PracticeHeatmap.shadeOf(Brightness.dark, 999),
      const Color(0xFF39D353),
    );
  });

  testWidgets('窄屏（320）不横向溢出', (tester) async {
    await _pump(
      tester,
      from: '2026-09-01',
      to: '2026-09-17',
      days: const [],
      width: 320,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('脏数据被忽略，不影响其余日子', (tester) async {
    await _pump(
      tester,
      from: '2026-09-01',
      to: '2026-09-17',
      days: const [
        DailyStat(date: '坏数据', count: 5),
        DailyStat(date: '2026-09-17', count: 7),
      ],
    );

    expect(find.byTooltip('2026-09-17 · 7 题'), findsOneWidget);
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
            child: PracticeHeatmap(days: days, from: from, to: to),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
