// 真实账号的集成测试共用的东西：凭据读取、登录、真机上的等待。
//
// **不是 `_test.dart`**，所以不会被测试运行器当成用例收集。
//
// 凭据从 `--dart-define-from-file` 注入，**绝不写进仓库**：
//   config/test.local.json（已被 .gitignore 的 `config/*.local.json` 忽略）
// 没给凭据时调用方应当 skip，而不是失败——本地没配的人不该看到一片红。

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/app.dart';
import 'package:mianyang_quiz/bootstrap.dart';
import 'package:mianyang_quiz/dependencies.dart';
import 'package:mianyang_quiz/pages/pages.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

/// 测试账号。空串 = 没配。
const testPhone = String.fromEnvironment('TEST_PHONE');
const testPassword = String.fromEnvironment('TEST_PASSWORD');

/// 是否允许跑**会写生产库**的用例。默认关，要显式开。
const testWriteEnabled = bool.fromEnvironment('TEST_WRITE');

/// 没配凭据就跳过（返回 true 表示"已跳过，调用方直接 return"）。
bool skipUnlessAccountConfigured() {
  if (testPhone.isEmpty || testPassword.isEmpty) {
    markTestSkipped(
      '未提供测试账号 —— 用 --dart-define-from-file=config/test.local.json 传入 '
      'TEST_PHONE / TEST_PASSWORD（模板见 config/test.example.json）',
    );
    return true;
  }
  return false;
}

/// 真机上的等待：**不能用 `pumpAndSettle`**。
///
/// 加载态里的 `CircularProgressIndicator` 是无限动画，`pumpAndSettle`
/// 会一直等到超时（默认 10 分钟）才报 `timed out`——看上去像启动挂了，
/// 其实只是动画没停。
///
/// 这里一边 `pump` 让界面继续渲染，一边让**真实时间**流过：
/// 集成测试下的网络是真的，只在假时钟里打转永远等不到响应。
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  required String what,
  Duration timeout = const Duration(seconds: 45),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 100));
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  // 光说"没等到"没法排查。把屏幕上**实际**有的文字列出来：
  // 是卡在转圈、还是落了错误态、还是文案跟预期不一样，一眼就能分辨。
  fail('等了 ${timeout.inSeconds}s 仍未出现：$what\n屏幕上当前的文字：\n${screenText(tester)}');
}

/// 当前挂在树上的所有非空文字，去重后截断——超时排查用。
String screenText(WidgetTester tester) {
  final seen = <String>{};
  for (final widget in tester.widgetList<Text>(find.byType(Text))) {
    final data = widget.data?.trim();
    if (data != null && data.isNotEmpty) seen.add(data);
    if (seen.length >= 40) break;
  }
  return seen.isEmpty ? '（一个 Text 都没有）' : seen.join('  |  ');
}

/// 等若干个可能结果里**任意一个**出现，返回它的 key。
///
/// 真实后端的流程常有分支：点「开始练习」之后可能进练习页、可能弹
/// 「今天的题都练完了」、也可能先弹「有进行中的会话」。写死等其中一个，
/// 换个账号状态就红。这里把这些可能性一次列全，谁先来算谁。
///
/// [what] 描述的是"在等什么场景"，失败信息里会带上所有分支与屏幕现状。
Future<String> waitForAny(
  WidgetTester tester,
  Map<String, Finder> candidates, {
  required String what,
  Duration timeout = const Duration(seconds: 45),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    for (final entry in candidates.entries) {
      if (entry.value.evaluate().isNotEmpty) return entry.key;
    }
    await tester.pump(const Duration(milliseconds: 100));
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  fail(
    '等了 ${timeout.inSeconds}s，$what 的几种结局都没出现：'
    '${candidates.keys.join(' / ')}\n屏幕上当前的文字：\n${screenText(tester)}',
  );
}

/// 按 `InputDecoration.labelText` 定位输入框。
/// 比 `byType(TextFormField).at(n)` 稳：加一个字段不会让下标全错位。
Finder fieldWithLabel(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(TextFormField));

/// 起真实应用并确保处于**已登录**状态，返回装配好的依赖（用例收尾时会用到仓储）。
///
/// 会话可能已经在（同一次运行里前一个用例登过，或本地存了会话），
/// 那就直接复用——所以这个函数是幂等的。
Future<AppDependencies> launchAndLogin(WidgetTester tester) async {
  final startup = await bootstrap();
  final deps = startup.deps;
  if (deps == null) {
    fail(
      '需要真实配置（--dart-define-from-file=config/dev.json）。'
      'bootstrap 报的是：${startup.failure}',
    );
  }

  // **不要在这里 addTearDown(deps.dispose())**：MianyangQuizApp 自己持有依赖，
  // 它的 dispose() 里就会调 deps.dispose()（见 app.dart）。测试结束时 widget 树
  // 被拆掉，于是依赖已经被释放过一次，再释放一次会撞上
  //「A AuthStore was used after being disposed.」——而且报在 teardown 里，
  // 看上去像用例本体挂了，极难归因。谁创建谁释放，这里不插手。

  await tester.pumpWidget(MianyangQuizApp(startup: startup));
  await tester.pump(const Duration(milliseconds: 300));

  if (find.byType(AppShell).evaluate().isEmpty) {
    expect(
      find.byType(LoginPage),
      findsOneWidget,
      reason: '未登录时路由守卫应当停在登录页',
    );

    await tester.enterText(fieldWithLabel('手机号 / 邮箱'), testPhone);
    await tester.enterText(fieldWithLabel('密码'), testPassword);
    await tester.pump();

    await tester.tap(find.widgetWithText(DuoButton, '登录'));
    await tester.pump();

    await waitFor(tester, find.byType(AppShell), what: '登录成功后进入主壳');
  }

  return deps;
}
