// 启动冒烟：在**真实设备**上走一遍真实的 bootstrap() 与真实的根组件。
//
// 与 test/ 下的 widget 测试差在哪：那边 HTTP 被 flutter_test 拦掉、插件是假的；
// 这里 IntegrationTestWidgetsFlutterBinding 的 `overrideHttpClient` 是 false ——
// **真网络、真插件、真平台通道**。所以它回答的是
// 「这个包在这台设备上能不能起来」，而不是「某个组件渲染对不对」。
// 这两件事一样重要，但只有前者能发现插件没注册、原生资源缺失这类问题。
//
// **配置有没有都能跑**，两种结局都断言，所以不会因为环境不同而红：
//   · 没给 --dart-define-from-file → 启动页显示「需要先完成配置」（这本身就是要验的路径）
//   · 给了 → 路由守卫把用户送到登录页（没有会话）或主壳（恢复了会话）
//
// 跑法（Windows 桌面）：
//   flutter test integration_test/app_boot_test.dart -d windows
// 带真实配置跑：
//   flutter test integration_test/app_boot_test.dart -d windows \
//     --dart-define-from-file=config/dev.json

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/app.dart';
import 'package:mianyang_quiz/bootstrap.dart';
import 'package:mianyang_quiz/pages/pages.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('启动：真实 bootstrap() 之后落在可交互的首屏', (tester) async {
    final startup = await bootstrap();
    // **不要 addTearDown(startup.deps!.dispose())**：MianyangQuizApp 自己持有依赖，
    // 它的 dispose() 里已经调过一次（见 app.dart）。再释放一次会在 teardown 里
    // 抛「A AuthStore was used after being disposed.」，看着像用例本体挂了。

    await tester.pumpWidget(MianyangQuizApp(startup: startup));

    // **不要用 pumpAndSettle**：加载态里的 CircularProgressIndicator 是无限动画，
    // pumpAndSettle 会一直等到超时（默认 10 分钟）才失败——
    // 报出来的是「timed out」，看上去像启动挂了，其实只是动画没停。
    await tester.pump(const Duration(milliseconds: 300));

    if (startup.deps == null) {
      // 没配配置：必须给出可读的提示，而不是崩溃页或白屏
      expect(startup.failure, isNotNull, reason: '没有依赖时应当带回失败原因');
      expect(find.text('需要先完成配置'), findsOneWidget);
      return;
    }

    // 配了配置：根组件挂上了，且路由守卫解析到了一个真实页面
    expect(find.byType(MaterialApp), findsWidgets);
    final landed =
        find.byType(LoginPage).evaluate().isNotEmpty ||
        find.byType(AppShell).evaluate().isNotEmpty;
    expect(landed, isTrue, reason: '应当落在登录页或主壳，而不是空白');
  });

  testWidgets('根组件挂载不抛异常（装配顺序 + ScreenUtil 都在真机上过一遍）', (tester) async {
    final startup = await bootstrap();
    // 同上：依赖由 MianyangQuizApp 释放，这里不插手

    await tester.pumpWidget(MianyangQuizApp(startup: startup));
    await tester.pump(const Duration(milliseconds: 300));

    // app.dart 的层序（MultiProvider → ScreenUtilInit → MaterialApp.router）
    // 错一步就会在**构建期**抛 LateInitializationError；桌面端缩放开关写错
    // 则是 RenderFlex 溢出。这类问题 widget 测试碰不到，只有真机跑得出来。
    expect(tester.takeException(), isNull);
  });
}
