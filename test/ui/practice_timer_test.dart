// 练习计时器的 widget 测试：显示已花费时间、每秒真的在跳、时间倒流不倒扣。
//
// 为什么值得测：计时器"看起来在动"很容易骗过人——定时器没接上、或者只算了一次
// 就再也不更新，界面第一眼都长得一样。这里用注入的假时钟（不是真实时间）走一遍，
// 才能确定它每秒读的是"现在 - 起算点"，而不是一个冻住的初值。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_timer.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_top_bar.dart';

void main() {
  final start = DateTime(2026, 9, 16, 10, 0, 0);

  testWidgets('初始显示起算点到现在的时长', (tester) async {
    await _pump(tester, start: start, now: start.add(const Duration(seconds: 42)));

    expect(find.text('00:42'), findsOneWidget);
    expect(find.byType(PracticeTimer), findsOneWidget);
  });

  testWidgets('每秒刷新一次（假时钟前进，界面跟着变）', (tester) async {
    var now = start;
    await _pump(tester, start: start, nowOf: () => now, pump: false);

    expect(find.text('00:00'), findsOneWidget);

    now = start.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);

    now = start.add(const Duration(minutes: 2, seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('02:03'), findsOneWidget);
  });

  testWidgets('超过一小时显示 时:分:秒', (tester) async {
    await _pump(tester, start: start, now: start.add(const Duration(hours: 1, minutes: 2, seconds: 3)));

    expect(find.text('1:02:03'), findsOneWidget);
  });

  testWidgets('起算点在将来（时钟偏差）时显示 00:00，不出现负数', (tester) async {
    await _pump(tester, start: start, now: start.subtract(const Duration(seconds: 5)));

    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('顶栏里计时排在题号右侧', (tester) async {
    await _pumpTopBar(tester, start: start);

    final count = tester.getRect(find.text('7/20'));
    final timer = tester.getRect(find.byType(PracticeTimer));
    expect(timer.left, greaterThan(count.right), reason: '计时要在题号右边');
  });

  testWidgets('窄屏（有答题卡按钮）时计时仍在题号与按钮之间', (tester) async {
    await _pumpTopBar(tester, start: start, withAnswerSheet: true);

    final count = tester.getRect(find.text('7/20'));
    final timer = tester.getRect(find.byType(PracticeTimer));
    final sheet = tester.getRect(find.byIcon(Icons.grid_view_rounded));
    expect(timer.left, greaterThan(count.right));
    expect(timer.right, lessThan(sheet.left));
  });
}

Future<void> _pumpTopBar(
  WidgetTester tester, {
  required DateTime start,
  bool withAnswerSheet = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PracticeTopBar(
            index: 7,
            total: 20,
            progress: 0.35,
            startedAt: start,
            onExit: () {},
            onOpenAnswerSheet: withAnswerSheet ? () {} : null,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pump(
  WidgetTester tester, {
  required DateTime start,
  DateTime? now,
  DateTime Function()? nowOf,
  bool pump = true,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final clock = nowOf ?? () => now!;

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: PracticeTimer(startedAt: start, clock: clock))),
      ),
    ),
  );
  if (pump) await tester.pump();
}
