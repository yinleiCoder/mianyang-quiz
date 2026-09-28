// 侧栏快捷入口：「开始练习」「参加考试」只在**宽屏侧栏**出现，不进底部导航。
//
// 为什么值得单独测：这两条要求是**相反**的，很容易在某次"顺手把首页入口也搬过来"
// 的改动里同时打破——
//   · 侧栏多了它们 → 宽屏用户不用先回首页再点，这是要的；
//   · 底部导航多了它们 → 涨到第 6 个，每个 tab 都被压窄（Material 的上限是 5）。
// 侧栏能放是因为它竖排、不受这个限制，而且这两个入口本身是 push 整页、
// 不是外壳的分支（不占 tab 名额）。
//
// 另：点它们必须是 **push 整页**，不是切分支——切分支的话页面会被套进
// 带底部导航的壳里，而练习/组卷是需要专注的全屏页。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/pages.dart';
import 'package:mianyang_quiz/pages/shell/widgets/app_bottom_nav.dart';
import 'package:mianyang_quiz/pages/shell/widgets/app_side_nav.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_destinations.dart';
import 'package:mianyang_quiz/router/router.dart';

void main() {
  /// 与真实路由同构：五个分支挂在外壳下，组卷/考试是**壳之外**的整页。
  GoRouter buildRouter() => GoRouter(
    initialLocation: '/0',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          for (var i = 0; i < kNavDestinations.length; i++)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/$i',
                  builder: (context, state) => Text('页面 $i'),
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: AppRoutes.composePath,
        builder: (context, state) => const Text('组卷页'),
      ),
      GoRoute(
        path: AppRoutes.examsPath,
        builder: (context, state) => const Text('考试页'),
      ),
    ],
  );

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        // 桌面端关掉线性缩放，与 bootstrap 同源——否则 1280 宽会被放大 3.3 倍
        enableScaleWH: () => size.width < 900,
        enableScaleText: () => size.width < 900,
        builder: (context, child) =>
            MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('宽屏侧栏里有「开始练习」与「参加考试」', (tester) async {
    await pumpAt(tester, const Size(1280, 800));

    expect(find.byType(AppSideNav), findsOneWidget);
    expect(find.text('开始练习'), findsOneWidget);
    expect(find.text('参加考试'), findsOneWidget);
  });

  testWidgets('窄屏底部导航里**没有**这两个入口（仍是 5 项）', (tester) async {
    await pumpAt(tester, const Size(430, 900));

    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.text('开始练习'), findsNothing);
    expect(find.text('参加考试'), findsNothing);
    // 分支目标一个不少，也一个不多
    for (final d in kNavDestinations) {
      expect(find.text(d.label), findsWidgets, reason: '底部导航少了 ${d.label}');
    }
  });

  testWidgets('点侧栏「开始练习」push 到组卷页，且不带底部导航', (tester) async {
    await pumpAt(tester, const Size(1280, 800));

    await tester.tap(find.text('开始练习'));
    await tester.pumpAndSettle();

    expect(find.text('组卷页'), findsOneWidget);
    // 关键：整页替换，壳（连同底部/侧边导航）不该跟着过来
    expect(find.byType(AppSideNav), findsNothing);
    expect(find.byType(AppBottomNav), findsNothing);
  });

  testWidgets('窗口很矮时侧栏不溢出（条目区可滚动）', (tester) async {
    // 侧栏是"宽但可以很矮"的那一档。条目从 5 个涨到 7 个之后，
    // 固定高度的 Column 在这种窗口里会直接 RenderFlex 溢出、整块导航错位。
    // 真机上调窗口高度就能撞到，测试里给个极端值把它钉住。
    await pumpAt(tester, const Size(1280, 320));

    expect(find.byType(AppSideNav), findsOneWidget);
    expect(tester.takeException(), isNull, reason: '侧栏在矮窗口下溢出了');

    // 溢出的条目仍要够得着——把它们滚进视野
    await tester.drag(find.byType(AppSideNav), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.text('参加考试'), findsOneWidget);
  });

  testWidgets('侧栏快捷入口不会被标成选中态', (tester) async {
    await pumpAt(tester, const Size(1280, 800));

    // 快捷入口是 push 整页，当前页永远不在这五项里，
    // 所以它们不该出现 Semantics(selected: true) —— 高亮了就等于谎报"你正在这页"。
    final selected = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .where((s) => s.properties.selected ?? false)
        .length;
    // 首页分支被选中，正好 1 个
    expect(selected, 1, reason: '只有当前分支该是选中态');
  });
}
