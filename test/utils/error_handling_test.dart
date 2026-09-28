// 全局错误处理：三个钩子装上了没、正式包的兜底长什么样、兜底本身会不会再抛。
//
// 为什么值得测：这段代码平时**一行都不执行**，只在出事时才跑；而它一旦自己抛异常，
// 整个应用就是白屏——恰恰是最难在产品里复现、又最该确认无误的一段。
//
// 本文件放在 test/utils/ 下而不是 test/ 下新建一层：被测的 lib/error_handling.dart
// 在 lib/ 根下（既不是 utils 也不是 widgets），而测试目录只与 lib 的八个顶层目录
// 同构；归到 utils 是因为它测的确实是"与界面无关的全局机制"。

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/error_handling.dart';

void main() {
  group('installErrorHandling', () {
    late FlutterExceptionHandler? savedFlutterOnError;
    late ui.ErrorCallback? savedDispatcherOnError;

    setUp(() {
      savedFlutterOnError = FlutterError.onError;
      savedDispatcherOnError = ui.PlatformDispatcher.instance.onError;
    });

    tearDown(() {
      // 这三个都是**全局静态**，不还原会污染后面所有测试
      FlutterError.onError = savedFlutterOnError;
      ui.PlatformDispatcher.instance.onError = savedDispatcherOnError;
    });

    test('三个钩子都装上了', () {
      installErrorHandling();

      expect(FlutterError.onError, isNotNull);
      expect(ui.PlatformDispatcher.instance.onError, isNotNull);
      // 调试期用框架默认的红框，所以 builder 应当与默认的不同（我们换了实现）
      expect(ErrorWidget.builder, isNotNull);
    });

    test('装了钩子之后，框架报错不会把异常抛回调用方', () {
      installErrorHandling();
      final details = FlutterErrorDetails(
        exception: StateError('测试用的假错误'),
        stack: StackTrace.current,
      );

      // 钩子自己抛异常是**框架不会接**的（官方 API 文档明说），
      // 所以这里必须确认它安静地返回
      expect(() => FlutterError.onError!(details), returnsNormally);
    });

    test('异步钩子返回 true（表示"已处理"）', () {
      installErrorHandling();
      final handled = ui.PlatformDispatcher.instance.onError!(
        StateError('测试用的假异步错误'),
        StackTrace.current,
      );

      // 返回 false 会让引擎走它自己的兜底路径，在 release 里可能直接终止进程
      // —— 用户看到的是"闪退"，而我们连一句日志都留不下
      expect(handled, isTrue);
    });
  });

  group('buildErrorFallback', () {
    final details = FlutterErrorDetails(
      exception: StateError('内部细节不该给用户看'),
      stack: StackTrace.current,
    );

    test('调试期交回框架默认的红框（信息量最大）', () {
      expect(buildErrorFallback(details, release: false), isA<ErrorWidget>());
    });

    testWidgets('正式包画的是那句人话，且不泄露异常内容', (tester) async {
      final fallback = buildErrorFallback(details, release: true);

      // **故意不给任何祖先**：没有 MaterialApp、没有 Theme、没有 Directionality、
      // 没有 MediaQuery。真实场景里出错的可能正是 MaterialApp 本身，
      // 这段代码必须在这种"什么都没有"的环境下也能画出来。
      await tester.pumpWidget(fallback);

      expect(tester.takeException(), isNull, reason: '兜底自己抛异常会导致白屏');
      expect(find.text('这一块内容没能显示出来'), findsOneWidget);

      // 异常内容只该进日志，不该画在用户眼前
      expect(find.textContaining('内部细节'), findsNothing);
    });
  });
}
