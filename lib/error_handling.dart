// 全局错误处理：把"没人接住"的错误统一收口。
//
// 与既有的错误体系怎么分工——这是两件不同的事，别混：
//   · **预期内的失败**（网络断了、会话过期、服务端拒绝）走 AppException →
//     error_mapper → AsyncView，用户看到一句中文提示。它们**不该**被当 bug 上报，
//     否则真正的问题会被淹掉。
//   · **没人接住的**（build 里抛的、异步里漏 catch 的）才是这里管的。
//
// 装三个钩子：
//   1. `FlutterError.onError` —— 框架在 build / layout / paint 里捕获到的错误
//   2. `PlatformDispatcher.instance.onError` —— 当前 zone 里没人处理的异步错误
//   3. `ErrorWidget.builder` —— 某棵子树 build 失败时**画什么**
//
// **必须在 runApp 之前、CrashReporter.init() 之前装**：Sentry 的那两个
// integration 是**链式**的（先捕获，再调用原来那个 handler），它会包住这里装的
// 东西；顺序反了它就链不上，钩子会被顶掉。
//
// 放在 lib/ 根下而不是 utils/ 或 widgets/：
//   · utils/ 被架构守卫禁止 import Flutter（它必须能脱离 Flutter 单测）；
//   · 它既不是组件也不是取数，而是**启动装配**的一环，与 bootstrap.dart 同类。

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 装全局错误钩子。幂等（重复调用只是把同样的函数再赋一遍）。
void installErrorHandling() {
  // ---- 1) 框架错误（build / layout / paint） ----
  FlutterError.onError = (details) {
    // 保留框架自己的输出：调试期那套红屏 + 控制台堆栈是 Flutter 最好用的
    // 诊断信息，为了"统一"把它盖掉是净亏。
    FlutterError.presentError(details);

    // **这里刻意不再上报**。`SentryFlutter.init` 的 FlutterErrorIntegration
    // 已经先捕获过一遍了，这里再调一次 captureException 会让同一条错误
    // 上报两次。它装钩子时会把我们上面这个函数存下来、捕获完再调用，
    // 所以这里的 presentError 在开与不开上报时都会照常执行。
  };

  // ---- 2) 异步错误（当前 zone 里没人处理） ----
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('未捕获的异步错误：$error');
    debugPrintStack(stackTrace: stack);
    // 返回 true = "我处理了"。返回 false 会让错误继续上抛，
    // 在 release 里那等于直接终止进程——用户看到的是"应用闪退"，
    // 而我们连一句日志都留不下。
    return true;
  };

  // ---- 3) build 失败时画什么 ----
  ErrorWidget.builder = buildErrorFallback;
}

/// 某棵子树构建失败时顶替它的东西。
///
/// **它必须极简，而且绝不能抛**。官方 API 文档的原话是：它被调用时
/// "系统通常处于不稳定状态……框架本身（尤其是 BuildOwner）可能已经混乱，
/// 很可能再抛异常"，所以"强烈建议返回的 widget 做尽可能少的事"。
/// 出错的地方可能就是 MaterialApp 本身——那时没有主题、没有 Directionality、
/// 没有 MediaQuery；它自己再抛一次就是无限递归，整个应用直接白屏。
/// 所以这里只用 widgets 层最基础的东西，一个主题/字体族都不碰。
/// （指南页里那个 `Scaffold(body: Center(...))` 的示例与这条 API 文档相矛盾，
/// 以 API 文档为准。）
///
/// 调试期仍用框架默认的红框：信息量最大，而且调试的人本来就该看到它。
/// 正式包换成一句人话——红框会把内部结构画在用户面前，既吓人，
/// 也等于把实现细节亮给了每一个遇到它的人。
///
/// [release] 只为可测而存在：`kReleaseMode` 是编译期常量，测试跑在 debug 下
/// 永远够不到正式分支，没法验证"正式包里到底画了什么"。
@visibleForTesting
Widget buildErrorFallback(FlutterErrorDetails details, {bool? release}) {
  if (!(release ?? kReleaseMode)) return ErrorWidget(details.exception);
  return const _QuietFallback();
}

class _QuietFallback extends StatelessWidget {
  const _QuietFallback();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      // 写死颜色是刻意的：这里拿不到主题（见 buildErrorFallback 的说明），
      // 而这块东西本来就该是"最不显眼"的存在，不该跟着品牌色走。
      color: Color(0xFFF2F2F2),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '这一块内容没能显示出来',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF767676)),
          ),
        ),
      ),
    ),
  );
}
