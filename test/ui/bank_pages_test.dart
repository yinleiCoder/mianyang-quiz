// 题库两页的 widget 测试：列表页的失败态与桌面布局、详情页的失败态。
//
// 为什么值得测：列表页是 SafeArea + Column + Expanded + ListView 的骨架，
// 高度约束写错的典型表现是 "Vertical viewport was given unbounded height"（整页空白），
// 而这种错只在真机/桌面上才暴露；1280×800 再跑一遍是因为 AGENTS.md 要求每页都在
// 这个窗口里过一遍（桌面端缩放关掉之后，看到的才是真实像素）。
//
// 依赖用真实仓储、client 指向假地址：flutter_test 把 HTTP 拦成失败，
// 页面因此走 AsyncFailure 分支，正好验证「拉不到数据也要给出重试」。
// 题库页不自己建 Scaffold（由 AppShell 提供），所以这里用一个 Scaffold 模拟外壳。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/features/bank/bank_page.dart';
import 'package:mianyang_quiz/ui/features/bank/question_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('题库页：拉不到题目时给出重试，标题与筛选条仍在', (tester) async {
    await _pump(tester, const Size(390, 844), AppRoutes.bankPath);

    expect(find.text('题库'), findsOneWidget);
    expect(find.text('筛选'), findsOneWidget);
    expect(find.text('未设置筛选条件'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('题库页：桌面 1280×800 下铺满窗口宽度且无布局异常', (tester) async {
    // 桌面端关掉线性缩放（与 bootstrap 一致），否则 1280 宽会被放大 3.3 倍，
    // 那种"炸"是测试环境特有的，不是真实桌面端的样子。
    await _pump(tester, const Size(1280, 800), AppRoutes.bankPath, desktop: true);

    expect(tester.takeException(), isNull);
    expect(find.text('题库'), findsOneWidget);

    // 数据页**不套 MaxWidthBox**：内容区要铺满窗口宽度（只留左右内边距），
    // 否则限宽那一条会把滚动条推到内容区右边而不是窗口侧边。
    final header = find
        .ancestor(of: find.text('题库'), matching: find.byType(Row))
        .first;
    expect(
      tester.getSize(header).width,
      1280 - AppMetrics.pagePadding * 2,
    );
  });

  testWidgets('题目详情页：取不到题目时给出重试而不是白屏', (tester) async {
    await _pump(tester, const Size(390, 844), '/bank/question-1');

    expect(find.text('题目详情'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });
}

/// 桌面端关闭缩放（与 bootstrap 的 `_configureScreenScaling` 同义）。
bool _noScale() => false;

Future<void> _pump(
  WidgetTester tester,
  Size size,
  String location, {
  bool desktop = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // autoRefreshToken 必须关掉：它起的是周期定时器，flutter_test 会因为
  // 「widget 树销毁后仍有 pending timer」判失败。
  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      // 缩放开关必须**传给 ScreenUtilInit**：它在 didChangeDependencies 里会用这两个
      // 回调覆盖掉之前调用的 ScreenUtil.enableScale（包内 screenutil_init.dart:117）。
      // 传 null 即恢复默认的"照常缩放"，所以每个用例都会回到手机端口径。
      enableScaleWH: desktop ? _noScale : null,
      enableScaleText: desktop ? _noScale : null,
      builder: (context, child) => MultiProvider(
        providers: [
          Provider<SubjectRepository>(
            create: (_) => SubjectRepository(client),
          ),
          Provider<QuestionRepository>(
            create: (_) => QuestionRepository(client),
          ),
          ChangeNotifierProvider(
            create: (_) => FavoriteStore(FavoriteRepository(client)),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: location,
            routes: [
              GoRoute(path: '/', builder: (_, _) => const Text('首页占位')),
              GoRoute(
                path: AppRoutes.bankPath,
                // 题库页是底部导航的一个 tab，Scaffold 由外壳提供
                builder: (_, _) => const Scaffold(body: BankPage()),
              ),
              GoRoute(
                path: AppRoutes.questionDetailPath,
                builder: (_, state) => QuestionDetailPage(
                  questionId: state.pathParameters['questionId']!,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
