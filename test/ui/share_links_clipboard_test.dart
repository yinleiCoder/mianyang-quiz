// 分享链接的解析 × 剪贴板识别的端到端（widget 级）测试。
//
// 为什么值得测：这条链路两头都在"看不见"的地方——链接格式（网页端路由）、
// 剪贴板内容（用户复制什么都可能）。识别错了的后果是弹窗骚扰（把无关文本当链接）
// 或者功能失效（真链接认不出来）。这里把剪贴板打成桩，走一遍
// 「复制链接 → 回到前台 → 弹窗 → 打开题目」的完整路径。

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/clipboard_link_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _questionId = '0e5afb50-37e7-4e96-9a4e-f57362898a73';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('ShareLinks 文本解析', () {
    // 纯解析在 test/ 的另一条用例里覆盖（core 层）；这里只确认端到端认得出

    testWidgets('整条链接 → 弹窗 → 打开题目详情', (tester) async {
      await _setClipboard('https://myquiz.cn/bank/$_questionId');
      await _pump(tester);

      expect(find.text('检测到题目链接'), findsOneWidget);

      await tester.tap(find.text('打开题目'));
      await tester.pumpAndSettle();

      // 路由到了详情页（占位页把 id 打出来，证明带对了）
      expect(find.text('详情 $_questionId'), findsOneWidget);
    });

    testWidgets('带一句话的分享文案也认得出', (tester) async {
      await _setClipboard('这道题来自绵阳市中职共建题库：https://myquiz.cn/bank/$_questionId 快看');
      await _pump(tester);

      expect(find.text('检测到题目链接'), findsOneWidget);
    });

    testWidgets('不是题目链接就不打扰', (tester) async {
      await _setClipboard('随手复制的普通文本');
      await _pump(tester);

      expect(find.text('检测到题目链接'), findsNothing);
    });

    testWidgets('同一段内容只弹一次（重新复制会再弹）', (tester) async {
      await _setClipboard('https://myquiz.cn/bank/$_questionId');
      await _pump(tester);
      await tester.tap(find.text('不用了'));
      await tester.pumpAndSettle();
      expect(find.text('检测到题目链接'), findsNothing);

      // 同一条内容：再次回到前台不该再弹
      await _resume(tester);
      expect(find.text('检测到题目链接'), findsNothing);

      // 用户重新复制（内容相同但有过变化）→ 认得出，但内容没变所以仍然不弹；
      // 这里换个新链接，等价于"又复制了一条"→ 应该弹
      await _setClipboard('https://myquiz.cn/bank/3d61e0fe-a8cc-455d-aa5e-6a2062e6c2b9');
      await _resume(tester);
      expect(find.text('检测到题目链接'), findsOneWidget);
    });
  });
}

Future<void> _setClipboard(String text) async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.getData') return {'text': text};
        if (call.method == 'Clipboard.setData') return null;
        return null;
      });
}

Future<void> _resume(WidgetTester tester) async {
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pumpAndSettle();
}

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        // 与 AppShell 的位置一致：在 Navigator 之内，showDialog / context.push 都能用
        builder: (_, _) => const ClipboardLinkListener(child: Text('首页占位')),
      ),
      GoRoute(
        path: '/bank/:questionId',
        builder: (_, state) => Text('详情 ${state.pathParameters['questionId']}'),
      ),
    ],
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    ),
  );
  // 首帧 + 剪贴板读取（initState 里挂在 postFrameCallback 上）
  await tester.pumpAndSettle();
}
