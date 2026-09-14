// 意见反馈页的 widget 测试：类型选择/表单渲染齐全，太短的正文不发请求。
//
// 为什么值得测：这一页是用户够到系统管理员的唯一入口，四项校验里的第一道
// （至少 5 个字）在端上，写错就是白跑一趟网络再被服务端拒；类型 chips 少一个
// 就等于少一类反馈进不了收件箱。
//
// 与 profile_pages_test 同一套路：真实仓储 + 假地址 client。
// 提交成功那条路走不到——测试环境的 HTTP 一律失败，这正是我们要的：
// 本文件只断言渲染与本地校验，不假装服务端可用。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/repositories/feedback_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/profile/feedback_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('意见反馈页：四个反馈类型与提交按钮都在', (tester) async {
    await _pump(tester, '/profile/feedback');
    await tester.pumpAndSettle();

    for (final label in ['问题反馈', '功能建议', '使用咨询', '其他']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('问题描述'), findsOneWidget);
    expect(find.text('联系方式（选填）'), findsOneWidget);
    expect(find.widgetWithText(DuoButton, '提交反馈'), findsOneWidget);
  });

  testWidgets('意见反馈页：正文太短只给本地提示，不发请求', (tester) async {
    await _pump(tester, '/profile/feedback');
    await tester.pumpAndSettle();

    // 第一个输入框是正文（第二个是联系方式）
    await tester.enterText(find.byType(TextField).first, '不行');
    await tester.tap(find.widgetWithText(DuoButton, '提交反馈'));
    await tester.pump();

    expect(find.text('请把问题描述得再具体一些（至少 5 个字）'), findsOneWidget);

    // 让 SnackBar 的自动消失计时器跑完，否则测试结束时会报「Timer is still pending」
    await tester.pump(const Duration(seconds: 5));
  });
}

Future<void> _pump(WidgetTester tester, String location) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MultiProvider(
        providers: [Provider<FeedbackRepository>(create: (_) => FeedbackRepository(client))],
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
                path: '/profile/feedback',
                builder: (context, state) => const FeedbackPage(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
