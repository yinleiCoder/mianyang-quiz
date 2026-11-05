// 底部导航的槽位换算。
//
// 背景（2026-11-05 用户实测崩溃）：点「我的」时报
//   '0 <= selectedIndex && selectedIndex < destinations.length' is not true
// 根因是 _slotOf 把**分支号**当成了**分支在 kBottomNavBranches 里的序号**：
// 条上只有 5 格（0..4），分支 4（我的）被算成槽位 5 就越界了。
//
// 这里锁两件事：
//   1. 五个分支下标都能换算出**合法**的槽位（这一条就足以拦住那次崩溃）；
//   2. 换算结果必须与条上实际的摆放顺序一致（错一格会高亮错 tab）。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/shell/widgets/app_bottom_nav.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_destinations.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  testWidgets('每个分支的选中槽位都落在合法范围，且与条上顺序一致', (tester) async {
    // 条上的顺序：0 首页 / 1 题库 / 2 练习键（空的占位）/ 3 错题本 / 4 我的
    const expected = {0: 0, 1: 1, 2: 2, 3: 3, 4: 4};

    for (final entry in expected.entries) {
      await _pump(tester, entry.key);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));

      expect(
        bar.selectedIndex,
        entry.value,
        reason: '分支 ${entry.key}（${kNavDestinations[entry.key].label}）应落在槽位 ${entry.value}',
      );
      expect(
        bar.selectedIndex >= 0 && bar.selectedIndex < bar.destinations.length,
        isTrue,
        reason: '分支 ${entry.key} 的槽位越界，NavigationBar 会断言崩溃',
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('点底部导航回传的是分支下标，不是槽位', (tester) async {
    final picked = <int>[];
    await _pump(tester, 0, onSelect: picked.add);

    // 条上依次是 首页 / 题库 / [FAB 空位] / 错题本 / 我的；AI 答疑不在条上。
    for (final entry in {1: '题库', 3: '错题本', 4: '我的'}.entries) {
      await tester.tap(find.text(entry.value));
      await tester.pump();
      expect(picked.last, entry.key, reason: '点「${entry.value}」应回传分支 ${entry.key}');
    }
  });

  testWidgets('条上不重复画 AI 答疑，也画满 5 格', (tester) async {
    await _pump(tester, 0);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.destinations, hasLength(kBottomNavBranches.length + 1));
    expect(find.text('AI 答疑'), findsNothing);
  });
}

Future<void> _pump(
  WidgetTester tester,
  int branch, {
  ValueChanged<int>? onSelect,
}) async {
  // AppTheme 里用了 .r，必须先初始化 ScreenUtil；两个 enable* 都要显式关掉，
  // 否则桌面尺寸下按 390 的基准放大（见 flutter-screenutil-test-trap）。
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: const SizedBox.shrink(),
          bottomNavigationBar: AppBottomNav(
            currentIndex: branch,
            onSelect: onSelect ?? (_) {},
            onStartPractice: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
