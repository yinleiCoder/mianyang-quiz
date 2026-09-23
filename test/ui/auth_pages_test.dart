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
import 'package:mianyang_quiz/data/repositories/password_repository.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/data/services/auth_service.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/auth/email_verify_page.dart';
import 'package:mianyang_quiz/ui/features/auth/forgot_password_page.dart';
import 'package:mianyang_quiz/ui/features/auth/login_page.dart';
import 'package:mianyang_quiz/ui/features/auth/register_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('登录页：空表单提交只提示字段错误，不发请求', (tester) async {
    await _pump(tester, '/login');

    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    expect(find.text('请输入手机号或邮箱'), findsOneWidget);
    expect(find.text('请输入密码'), findsOneWidget);
  });

  testWidgets('登录页：手机号少一位报"手机号格式不正确"，不能被当成邮箱查', (tester) async {
    await _pump(tester, '/login');

    await tester.enterText(find.byType(TextFormField).first, '1380013800');
    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    // 关键：**不能**放过去让服务端当邮箱查 —— 那样报回来的是「密码不正确」，
    // 用户根本想不到是自己号码少打了一位。
    expect(find.text('手机号格式不正确'), findsOneWidget);
  });

  testWidgets('登录页：合法手机号不再报标识错误', (tester) async {
    await _pump(tester, '/login');

    await tester.enterText(find.byType(TextFormField).first, '13800138000');
    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    expect(find.text('手机号格式不正确'), findsNothing);
    expect(find.text('请输入手机号或邮箱'), findsNothing);
  });

  testWidgets('登录页：邮箱走邮箱这条路（含 @ 时不按手机号校验）', (tester) async {
    await _pump(tester, '/login');

    await tester.enterText(find.byType(TextFormField).first, 'teacher@example.com');
    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    expect(find.text('手机号格式不正确'), findsNothing);
    expect(find.text('邮箱格式不正确'), findsNothing);
  });

  testWidgets('登录页：底部链接去注册', (tester) async {
    await _pump(tester, '/login');

    await tester.tap(find.text('还没有账号？去注册'));
    await tester.pumpAndSettle();

    expect(find.text('已有账号？去登录'), findsOneWidget);
  });

  testWidgets('登录页：底部入口去忘记密码', (tester) async {
    await _pump(tester, '/login');

    await tester.tap(find.text('忘记密码？用手机号/邮箱和姓名重置'));
    await tester.pumpAndSettle();

    expect(find.text('找回密码'), findsWidgets);
  });

  testWidgets('忘记密码页：空表单只提示字段错误，不发请求', (tester) async {
    await _pump(tester, '/forgot-password');

    final submit = find.widgetWithText(DuoButton, '重置密码');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('请输入手机号或邮箱'), findsOneWidget);
    expect(find.text('请输入姓名'), findsOneWidget);
    expect(find.text('密码长度至少 6 位'), findsOneWidget);
  });

  testWidgets('忘记密码页：两次密码不一致在本地拦下', (tester) async {
    await _pump(tester, '/forgot-password');

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '13800138000');
    await tester.enterText(fields.at(1), '张三');
    await tester.enterText(fields.at(2), 'newpass123');
    await tester.enterText(fields.at(3), 'newpass124');

    final submit = find.widgetWithText(DuoButton, '重置密码');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('两次输入的密码不一致'), findsOneWidget);
  });

  testWidgets('忘记密码页：25 个汉字（75 字节）在本地就被拦下', (tester) async {
    await _pump(tester, '/forgot-password');

    // bcrypt 是在 72 **字节**处截断的：25 个汉字 = 75 字节。
    // 按字符数判会放过去，学生以为设了 25 位长密码、实际只有前 24 个字生效。
    const long = '密密密密密密密密密密密密密密密密密密密密密密密密密';
    expect(long.length, 25);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '13800138000');
    await tester.enterText(fields.at(1), '张三');
    await tester.enterText(fields.at(2), long);
    await tester.enterText(fields.at(3), long);

    final submit = find.widgetWithText(DuoButton, '重置密码');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.textContaining('新密码过长'), findsOneWidget);
  });

  testWidgets('忘记密码页：返回登录', (tester) async {
    await _pump(tester, '/forgot-password');

    await tester.tap(find.text('想起密码了？返回登录'));
    await tester.pumpAndSettle();

    expect(find.text('还没有账号？去注册'), findsOneWidget);
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

    expect(find.text('注册账号：student@example.com'), findsOneWidget);
    expect(find.text('本项目已关闭邮箱验证，请直接登录。'), findsOneWidget);
  });

  testWidgets('验证页：合成邮箱还原成手机号，不把假地址印给学生', (tester) async {
    await _pump(tester, '/verify-email?email=13800138000%40phone.myquiz.cn');

    // 13800138000@phone.myquiz.cn 是实现细节（见 core/utils/phone.dart），
    // 学生看到只会困惑"我什么时候有这个邮箱了"
    expect(find.text('注册账号：138 0013 8000'), findsOneWidget);
    expect(find.textContaining('@phone.myquiz.cn'), findsNothing);
  });

  testWidgets('注册页：学生填邮箱会被拦下（学生必须用手机号）', (tester) async {
    await _pump(tester, '/register');

    await tester.enterText(find.byType(TextFormField).at(0), '张三');
    // 账号栏故意填邮箱：学生没有邮箱、也记不住邮箱，用邮箱注册等于给自己埋一个
    // 「找不回账号」的坑（何况免短信方案下密码只能找管理员重置）
    await tester.enterText(find.byType(TextFormField).at(1), 'zhangsan@example.com');
    // 注册表单很长，390×844 下按钮在折叠线以下 —— 不先滚过去，tap 会落在屏幕外
    await tester.ensureVisible(find.widgetWithText(DuoButton, '注册'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DuoButton, '注册'));
    await tester.pump();

    expect(find.text('请输入 11 位手机号'), findsOneWidget);
  });

  testWidgets('注册页：学生填手机号不报错', (tester) async {
    await _pump(tester, '/register');

    await tester.enterText(find.byType(TextFormField).at(0), '张三');
    await tester.enterText(find.byType(TextFormField).at(1), '13800138000');
    await tester.ensureVisible(find.widgetWithText(DuoButton, '注册'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(DuoButton, '注册'));
    await tester.pump();

    expect(find.text('请输入 11 位手机号'), findsNothing);
    expect(find.text('手机号格式不正确'), findsNothing);
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
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
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
          // 忘记密码页要它（页面直接用仓储，不进 AuthStore）
          Provider<PasswordRepository>(create: (_) => PasswordRepository(client)),
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
