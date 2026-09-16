// 认证三页的 widget 测试：渲染、校验、跳转、身份切换。
//
// 为什么值得测：
//   · 「选教师→就读信息消失」这条分支的错法是静默的——字段还在，只是提交时被丢掉，
//     用户会以为自己填了；
//   · 错误条必须出现在**表单上方**而不是只弹 toast，这条只有渲染出来才看得见；
//   · 验证页是深链可达的，query 里的 email 读不到就是空白页。
//
// 这里用真实的 SupabaseClient（假地址）而不是 mock：AuthStore / UserRepository 都要求
// 一个 client，而本组用例只关心渲染与本地校验，不发成功请求。
// 学校列表请求会失败——测试环境下 HttpClient 被 flutter_test 拦成 400——
// 页面因此走 AsyncFailure 分支，正好顺带验证「拉不到学校也不影响注册表单」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/data/services/auth_service.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/auth/email_verify_page.dart';
import 'package:mianyang_quiz/ui/features/auth/login_page.dart';
import 'package:mianyang_quiz/ui/features/auth/register_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('登录页：空表单提交只提示字段错误，不发请求', (tester) async {
    await _pump(tester, '/login');

    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    expect(find.text('请输入邮箱'), findsOneWidget);
    expect(find.text('请输入密码'), findsOneWidget);
  });

  testWidgets('登录页：底部链接去注册', (tester) async {
    await _pump(tester, '/login');

    await tester.tap(find.text('还没有账号？去注册'));
    await tester.pumpAndSettle();

    expect(find.text('已有账号？去登录'), findsOneWidget);
  });

  testWidgets('注册页：选教师后就读信息整块消失', (tester) async {
    await _pump(tester, '/register');

    expect(find.text('就读信息'), findsOneWidget);

    await tester.tap(find.text('教师'));
    await tester.pumpAndSettle();

    expect(find.text('就读信息'), findsNothing);
    expect(find.text('教师身份需学校管理员审核，审核期间可正常刷题'), findsOneWidget);
  });

  testWidgets('注册页：学校拉取失败时给出重试，表单照常可用', (tester) async {
    await _pump(tester, '/register');
    await tester.pumpAndSettle();

    // 测试环境里所有 HTTP 都返回 400，所以学校那一格必定走失败分支：
    // 关键是没有把整个表单带崩，也没有把选择框画成一个空框。
    expect(find.text('重试'), findsOneWidget);
    expect(find.text('姓名'), findsOneWidget);
    expect(find.widgetWithText(DuoButton, '注册'), findsOneWidget);
  });

  testWidgets('验证页：显示 query 里的邮箱与关闭说明', (tester) async {
    await _pump(tester, '/verify-email?email=student%40example.com');

    expect(find.text('注册邮箱：student@example.com'), findsOneWidget);
    expect(find.text('本项目已关闭邮箱验证，请直接登录。'), findsOneWidget);
  });

  testWidgets('验证页：回登录页', (tester) async {
    await _pump(tester, '/verify-email');

    await tester.tap(find.widgetWithText(DuoButton, '去登录'));
    await tester.pumpAndSettle();

    expect(find.text('还没有账号？去注册'), findsOneWidget);
  });
}

/// 起一个只含认证三页的路由树（与 app_router 的登记方式一致：页面不自己拿参数）。
/// 依赖用真实的 Store 与仓储，只是 client 指向一个假地址。
Future<void> _pump(WidgetTester tester, String location) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // autoRefreshToken 必须关掉：它会起一个 10 秒的周期定时器，
  // 而 flutter_test 会因「widget 树销毁后仍有 pending timer」判测试失败。
  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Text('首页占位')),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const EmailVerifyPage(),
      ),
    ],
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthStore(AuthService(client), UserRepository(client)),
          ),
          Provider<UserRepository>(create: (_) => UserRepository(client)),
          // 注册页的专业大类/专业下拉要读科目树（迁移 0039 对 anon 开放只读）
          Provider<SubjectRepository>(create: (_) => SubjectRepository(client)),
        ],
        // 必须用 MaterialApp.router：三页都靠 context.go 跳转。
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
    ),
  );
  await tester.pump();
}
