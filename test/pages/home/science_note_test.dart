// 首页四张原理卡片：科学抽题 / FSRS / BKT / 遗忘曲线。
//
// 用户 2026-11-03：原理从打卡区拿出来，做成卡片排在热力图与连续打卡区域下方。
// 盯两件事：四张卡都在；窄屏单列、宽屏两列，且不出现布局溢出。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_note.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

const _titles = ['科学抽题', 'FSRS 复习排期', 'BKT 掌握度', '遗忘曲线'];

void main() {
  testWidgets('四张原理卡片都在，且窄屏单列排列', (tester) async {
    await _pump(tester, const Size(390, 844));

    for (final title in _titles) {
      expect(find.text(title), findsOneWidget);
    }
    final tops = [for (final title in _titles) tester.getTopLeft(find.text(title))];
    for (var i = 1; i < tops.length; i++) {
      expect(tops[i].dy, greaterThan(tops[i - 1].dy), reason: '窄屏应逐张向下排');
    }
    expect(find.byType(DuoCard), findsNWidgets(4));
    _expectEqualHeights(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('宽屏两列排列，不溢出', (tester) async {
    await _pump(tester, const Size(1280, 800));

    final first = tester.getTopLeft(find.text('科学抽题'));
    final second = tester.getTopLeft(find.text('FSRS 复习排期'));
    final third = tester.getTopLeft(find.text('BKT 掌握度'));

    expect(second.dx, greaterThan(first.dx));
    expect(second.dy, closeTo(first.dy, 0.5), reason: '前两张同一行');
    expect(third.dy, greaterThan(first.dy), reason: '第三张换到第二行');
    _expectEqualHeights(tester);
    expect(tester.takeException(), isNull);
  });
}

void _expectEqualHeights(WidgetTester tester) {
  final heights = [
    for (var i = 0; i < 4; i++)
      tester.getSize(find.byType(DuoCard).at(i)).height,
  ];
  for (final height in heights) {
    expect(height, closeTo(heights.first, 0.5), reason: '四张卡应等高');
  }
}

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: ScienceNote(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
