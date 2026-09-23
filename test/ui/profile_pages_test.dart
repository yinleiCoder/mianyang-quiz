// 个人资料两页的 widget 测试：能渲染、学校拉不到时表单照常可用。
//
// 为什么值得测：编辑页把「头像选择 + 姓名输入 + 学校选择 + 可选的就读信息」
// 摞在一屏里，任何一处高度约束写错（或就读信息在教师身份下没被收起）都会
// 让页面在真机上才炸；资料页在没有档案时必须是加载态而不是空白。
//
// 与 auth_pages_test 同一套路：真实的 Store 与仓储，client 指向假地址——
// 测试环境的 HTTP 一律失败，正好把「学校列表拉不到」这条分支走一遍。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/data/repositories/password_repository.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/data/services/auth_service.dart';
import 'package:mianyang_quiz/data/services/oss_upload_service.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/profile/change_password_page.dart';
import 'package:mianyang_quiz/ui/features/profile/edit_profile_page.dart';
import 'package:mianyang_quiz/ui/features/profile/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('编辑资料页：字段齐全，学校列表拉不到时仍可填表', (tester) async {
    await _pump(tester, '/profile/edit');
    await tester.pumpAndSettle();

    expect(find.text('姓名'), findsOneWidget);
    expect(find.text('学校'), findsOneWidget);
    expect(find.text('更换头像'), findsOneWidget);
    // 没有档案（未登录/拉取失败）时身份取不到，按学生处理：就读信息照常显示。
    expect(find.text('就读信息'), findsOneWidget);
    // 未绑定学校时显示占位；列表拉不到也不该把整格画成空白（点击是重试）。
    expect(find.text('暂不绑定'), findsOneWidget);
    expect(find.widgetWithText(DuoButton, '保存'), findsOneWidget);
  });

  testWidgets('修改密码页：两次新密码不一致时本地提示，不发请求', (tester) async {
    await _pump(tester, '/profile/password');

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'oldpass123');
    await tester.enterText(fields.at(1), 'newpass123');
    await tester.enterText(fields.at(2), 'newpass124');

    final submit = find.widgetWithText(DuoButton, '修改密码');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();

    expect(find.text('两次输入的新密码不一致'), findsOneWidget);
    // 让 SnackBar 的计时器跑完，否则测试报 pending timer（与其他页测试同套路）
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('个人资料页：没有档案时是加载态，不是空白页', (tester) async {
    await _pump(tester, '/profile');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
  final users = UserRepository(client);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthStore(AuthService(client), users),
          ),
          Provider<UserRepository>.value(value: users),
          // 修改密码页要它（页面直接用仓储，不进 AuthStore）
          Provider<PasswordRepository>(create: (_) => PasswordRepository(client)),
          Provider<OssUploadService>(create: (_) => OssUploadService(client)),
          // 就读信息的专业大类/专业下拉要读科目树
          Provider<SubjectRepository>(create: (_) => SubjectRepository(client)),
        ],
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
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: '/profile/edit',
                builder: (context, state) => const EditProfilePage(),
              ),
              GoRoute(
                path: '/profile/password',
                builder: (context, state) => const ChangePasswordPage(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
