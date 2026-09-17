// 练习热力图的测试。
//
// 老师/学生要的是"答得越多颜色越深"，所以这里盯的**不是"画出来了"，而是颜色与格子尺寸对不对**：
// 空格子必须是空槽色、答 1 题要看得见、答得越多越深、**格子要正好填满自己的框**、脏数据不崩。
// 这一层靠肉眼很难验——深浅差一点点、格子少填 10px，屏幕上根本分不出来。

import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/practice_heatmap.dart';

void main() {
  testWidgets('按窗口起止铺格子，并把有作答的日子交给热力图', (tester) async {
    await _pump(
      tester,
      from: '2026-06-08',
      to: '2026-09-17',
      days: const [
        DailyStat(date: '2026-09-17', count: 14),
        DailyStat(date: '2026-07-01', count: 3),
      ],
    );

    final heatmap = _heatmapOf(tester);
    expect(heatmap.minDate, DateTime(2026, 6, 8));
    expect(heatmap.maxDate, DateTime(2026, 9, 17));
    expect(heatmap.entries.length, 2);
    expect(heatmap.entries.first.count, 14);
  });

  testWidgets('格子尺寸填满可用宽度（20 周在宽框里就该铺满）', (tester) async {
    await _pump(
      tester,
      from: '2026-05-01',
      to: '2026-09-17',
      days: const [],
      width: 640,
    );

    final heatmap = _heatmapOf(tester);
    // 2026-05-01(周五) 到 2026-09-17(周四) 对齐到周后是 21 列
    const weeks = 21;
    final grid = heatmap.cellSize * weeks + heatmap.cellSpacing * (weeks - 1);
    // 网格 + 左边的星期标签才是整块占的宽度，必须装得进给定的框
    // （标签约占 30px；装不下就会画到右边那一栏上，老师反馈的"遮挡"）
    expect(grid, lessThan(640), reason: '要把星期标签的地方留出来');
    expect(
      grid + _labelWidth,
      closeTo(640, 1.0),
      reason: '标签 + 网格应当正好等于可用宽度',
    );
    expect(heatmap.cellSize, greaterThan(20), reason: '宽框里格子要够大才像 GitHub');
  });

  testWidgets('窄屏（手机）不横向溢出：格子自动缩小', (tester) async {
    await _pump(
      tester,
      from: '2026-05-01',
      to: '2026-09-17',
      days: const [],
      width: 320,
    );

    final heatmap = _heatmapOf(tester);
    expect(heatmap.cellSize, lessThan(16), reason: '窄屏上要缩到放得下 21 列');
    expect(heatmap.cellSize, greaterThan(4));
    expect(tester.takeException(), isNull, reason: '不该溢出');
  });

  testWidgets('超宽屏上格子不再放大（否则一格能到 100px）', (tester) async {
    await _pump(
      tester,
      from: '2026-05-01',
      to: '2026-09-17',
      days: const [],
      width: 3000,
    );

    expect(_heatmapOf(tester).cellSize, lessThanOrEqualTo(34));
  });

  testWidgets('颜色：没作答是空槽，作答越多越深', (tester) async {
    await _pump(tester, from: '2026-09-01', to: '2026-09-17', days: const []);
    final scale = _heatmapOf(tester).customColorScale!;

    final scheme = Theme.of(_context(tester)).colorScheme;
    expect(scale(0), scheme.surfaceContainerHighest, reason: '没作答的日子是空槽色');

    // 亮度必须单调下降 = 颜色越来越深
    final luminances = [1, 3, 8, 20].map((n) => scale(n).computeLuminance()).toList();
    for (var i = 1; i < luminances.length; i++) {
      expect(
        luminances[i],
        lessThan(luminances[i - 1]),
        reason: '第 ${[1, 3, 8, 20][i]} 题应当比上一档更深',
      );
    }
    expect(scale(1), isNot(scheme.surfaceContainerHighest), reason: '答过题就要看得出来');
  });

  testWidgets('深浅取自语义绿（不是主题里那个会被当成"成功"的第三色）', (tester) async {
    await _pump(tester, from: '2026-09-01', to: '2026-09-17', days: const []);
    final scale = _heatmapOf(tester).customColorScale!;

    expect(scale(999), _context(tester).semantic.success);
  });

  testWidgets('窗口缺失或格式不对时整块不画（宁可不显示，也不显示错位的图）', (tester) async {
    await _pump(tester, from: null, to: '2026-09-17', days: const []);
    expect(find.byType(ContributionHeatmap), findsNothing);

    await _pump(tester, from: '2026-09-17', to: null, days: const []);
    expect(find.byType(ContributionHeatmap), findsNothing);

    await _pump(tester, from: '不是日期', to: '2026-09-17', days: const []);
    expect(find.byType(ContributionHeatmap), findsNothing);

    // 起止颠倒（服务端不该给，但给了也不能画）
    await _pump(tester, from: '2026-09-17', to: '2026-06-01', days: const []);
    expect(find.byType(ContributionHeatmap), findsNothing);
  });

  testWidgets('脏数据（日期形状不对）被丢掉，不影响其余日子', (tester) async {
    await _pump(
      tester,
      from: '2026-09-01',
      to: '2026-09-17',
      days: const [
        DailyStat(date: '坏数据', count: 5),
        DailyStat(date: '2026-09-17', count: 7),
      ],
    );

    expect(_heatmapOf(tester).entries.length, 1);
    expect(tester.takeException(), isNull);
  });
}

/// 星期标签占的宽（Mon/Wed/Fri 里最宽的一个 + 包自己留的 8px 间隙）。
/// 与 PracticeHeatmap 内部量的是同一套，这里重算一遍是为了让测试独立于实现。
final _labelWidth = _measureLabelWidth();

double _measureLabelWidth() {
  var widest = 0.0;
  for (final label in const ['Mon', 'Wed', 'Fri']) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    if (painter.width > widest) widest = painter.width;
  }
  return widest + 8;
}

ContributionHeatmap _heatmapOf(WidgetTester tester) =>
    tester.widget<ContributionHeatmap>(find.byType(ContributionHeatmap));

BuildContext _context(WidgetTester tester) =>
    tester.element(find.byType(PracticeHeatmap));

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
          body: PracticeHeatmap(days: days, from: from, to: to),
        ),
      ),
    ),
  );
  await tester.pump();
}
