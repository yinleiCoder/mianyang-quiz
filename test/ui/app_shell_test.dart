// 外壳的响应式行为测试。
//
// 锁住四件事：
//   1. 跨过断点时导航形态确实切换（宽→侧边、窄→底部）
//   2. 页面内状态不因跨断点而丢失（自增计数器跨断点后数值不变）
//   3. 停在非首个分支时跨断点，不会被弹回首页
//   4. 切分支再切回来，各分支自己的状态还在
//
// 一条**重要且反直觉**的实测结论（决定了本文件的鉴别力边界）：
// 第 2、3 条**无法区分外壳的两种写法**。我特意把 AppShell 临时改成"宽窄两套结构"
// （宽屏 Row[SideNav, Expanded(shell)]、窄屏 Scaffold(body: shell)）重跑，
// 结果同样全绿。原因是 StatefulShellRoute 的分支导航器由路由代理用 GlobalKey 持有，
// 外壳的 Element 即便被替换，navigator 子树也是被**重新挂载**而不是重建 ——
// 状态因此照样保住。
//
// 所以：本测试能证明"行为正确"，但**不能**证明"外壳的树形结构必须恒定的那个理由"。
// app_shell.dart 里仍然采用恒定骨架，是因为它避免无谓的重新挂载开销，
// 而不是修复一个可复现的状态丢失。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/ui/features/shell/app_shell.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/app_bottom_nav.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/app_side_nav.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/nav_destinations.dart';

void main() {
  /// 每个分支一个极简页面；第一个带一个计数器用来观察状态是否存活。
  GoRouter buildRouter() {
    return GoRouter(
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
                    builder: (context, state) =>
                        i == 0 ? const _CounterPage() : Text('页面 $i'),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Future<void> pumpAt(WidgetTester tester, GoRouter router, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('宽屏出侧边导航、窄屏出底部导航', (tester) async {
    addTearDown(tester.view.reset);

    await pumpAt(tester, buildRouter(), const Size(1200, 800));
    expect(find.byType(AppSideNav), findsOneWidget);
    expect(find.byType(AppBottomNav), findsNothing);

    // 跨过断点
    tester.view.physicalSize = const Size(500, 800);
    await tester.pumpAndSettle();
    expect(find.byType(AppSideNav), findsNothing);
    expect(find.byType(AppBottomNav), findsOneWidget);

    // 「在树里」不等于「在屏幕上」——断言它真的被布局在屏幕底部且有高度。
    // 截图对 GPU 合成窗口的底部区域不可靠，只能靠这一条。
    final rect = tester.getRect(find.byType(AppBottomNav));
    expect(rect.height, greaterThan(0), reason: '底部导航被布局成了零高度');
    expect(rect.width, greaterThan(0));
    expect(
      rect.bottom,
      closeTo(800, 1),
      reason: '底部导航应当贴着屏幕底边，实际 bottom=${rect.bottom}',
    );
  });

  testWidgets('跨断点切换导航形态时，页面状态不丢', (tester) async {
    addTearDown(tester.view.reset);

    await pumpAt(tester, buildRouter(), const Size(1200, 800));

    // 累加到 3，作为"页面状态"的代表
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(_CounterPage.buttonKey));
      await tester.pump();
    }
    expect(find.text('计数 3'), findsOneWidget);

    // 拉窄：底部导航接管
    tester.view.physicalSize = const Size(500, 800);
    await tester.pumpAndSettle();
    expect(find.byType(AppBottomNav), findsOneWidget);

    // **关键断言**：计数没有回到 0 —— 说明 navigationShell 的 Element 被复用了
    expect(
      find.text('计数 3'),
      findsOneWidget,
      reason: '跨断点切换导航形态不该重建页面；重建说明外壳的树形结构不稳定',
    );

    // 再拉宽：侧栏回来，状态仍应在
    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();
    expect(find.byType(AppSideNav), findsOneWidget);
    expect(find.text('计数 3'), findsOneWidget);
  });

  testWidgets('停在非首个分支时跨断点，仍停在原分支', (tester) async {
    addTearDown(tester.view.reset);

    await pumpAt(tester, buildRouter(), const Size(1200, 800));

    // 切到第二个分支
    await tester.tap(find.text('题库'));
    await tester.pumpAndSettle();
    expect(find.text('页面 1'), findsOneWidget);

    // 跨断点：这一条才是真正的风险点——重建外壳时若 currentIndex 取错，
    // 用户会被悄悄弹回首页
    tester.view.physicalSize = const Size(500, 800);
    await tester.pumpAndSettle();
    expect(
      find.text('页面 1'),
      findsOneWidget,
      reason: '跨断点不该把用户从当前分支弹走',
    );

    tester.view.physicalSize = const Size(1200, 800);
    await tester.pumpAndSettle();
    expect(find.text('页面 1'), findsOneWidget);
  });

  testWidgets('切换分支保留各分支自己的状态', (tester) async {
    addTearDown(tester.view.reset);

    await pumpAt(tester, buildRouter(), const Size(1200, 800));

    await tester.tap(find.byKey(_CounterPage.buttonKey));
    await tester.pump();
    expect(find.text('计数 1'), findsOneWidget);

    // 切到第二个分支再切回来
    await tester.tap(find.text('题库'));
    await tester.pumpAndSettle();
    expect(find.text('页面 1'), findsOneWidget);

    await tester.tap(find.text('首页'));
    await tester.pumpAndSettle();
    expect(
      find.text('计数 1'),
      findsOneWidget,
      reason: 'indexedStack 应保留每个分支的页面状态',
    );
  });
}

/// 带计数器的分支页：用自增计数代表"用户在这个页面上积累的状态"。
class _CounterPage extends StatefulWidget {
  const _CounterPage();

  static const buttonKey = Key('counter-button');

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('计数 $_count'),
          FilledButton(
            key: _CounterPage.buttonKey,
            onPressed: () => setState(() => _count++),
            child: const Text('加一'),
          ),
        ],
      ),
    );
  }
}
