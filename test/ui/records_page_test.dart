// 记录页的 widget 测试：三个 Tab 能渲染、能切换、拉不到数据时给出重试。
//
// 为什么值得测：TabBar/TabBarView 嵌在 Column 里，高度约束写错的表现是整页空白或
// "Vertical viewport was given unbounded height"——这种错只在真机上才暴露，测试里
// 一次就能钉住。桌面尺寸（1280×800）那一条还额外钉住「数据页铺满窗口宽度」：
// 内容区一旦被包进限宽盒，滚动条就会跑到内容区右边而不是窗口侧边。
//
// 依赖用真实的仓储，只是 client 指向一个假地址：flutter_test 会把 HTTP 拦成失败，
// 页面因此走 AsyncFailure 分支，正好验证「拉不到数据也要有重试」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:mianyang_quiz/ui/features/records/records_page.dart';
import 'package:mianyang_quiz/ui/features/records/session_review_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('记录页：三个 Tab 都能切换，失败时各自给出重试', (tester) async {
    await _pump(tester, const Size(390, 844));
    await tester.pumpAndSettle();

    expect(find.text('练习记录'), findsWidgets);
    expect(find.text('重试'), findsOneWidget);

    await tester.tap(find.text('错题本'));
    await tester.pumpAndSettle();
    expect(find.text('重试'), findsOneWidget);

    await tester.tap(find.text('收藏'));
    await tester.pumpAndSettle();
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('复盘页：拉不到会话时给出重试，而不是空白', (tester) async {
    await _pump(tester, const Size(390, 844), location: '/practice/s1/review');
    await tester.pumpAndSettle();

    expect(find.text('练习复盘'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('记录页：桌面 1280×800 下不出现布局异常', (tester) async {
    // 与 bootstrap 一样关掉线性缩放，否则 1280 宽会被放大 3.3 倍，
    // 那种"炸"是测试环境特有的，不是真实桌面端的样子。
    ScreenUtil.enableScale(enableWH: () => false, enableText: () => false);
    addTearDown(
      () =>
          ScreenUtil.enableScale(enableWH: () => true, enableText: () => true),
    );

    await _pump(tester, const Size(1280, 800));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('我的记录'), findsOneWidget);
    // 铺满窗口宽度：内容区（TabBarView）应等于窗口宽度，而不是被限宽在 640。
    expect(tester.getSize(find.byType(TabBarView)).width, 1280);
  });
}

Future<void> _pump(
  WidgetTester tester,
  Size size, {
  String location = '/records',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // autoRefreshToken 必须关掉：它起的是周期定时器，flutter_test 会因为
  // 「widget 树销毁后仍有 pending timer」判失败（与 auth_pages_test 同一个坑）。
  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MultiProvider(
        providers: [
          Provider<PracticeRepository>(
            create: (_) => PracticeRepository(client),
          ),
          Provider<ListRepository>(create: (_) => ListRepository(client)),
          ChangeNotifierProvider(
            create: (_) => FavoriteStore(FavoriteRepository(client)),
          ),
          ChangeNotifierProvider(create: (_) => PracticeDraftStore()),
        ],
        // 空态里的「去组卷」「去题库」都用 context.push，需要有路由。
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: location,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Text('首页占位'),
              ),
              GoRoute(
                path: '/records',
                builder: (context, state) => const RecordsPage(),
              ),
              GoRoute(
                path: '/practice/:sessionId/review',
                builder: (context, state) => SessionReviewPage(
                  sessionId: state.pathParameters['sessionId']!,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
