// 崩溃上报：Sentry 的薄封装。
//
// 四条设计约束，每条都有理由：
//
// 1. **没配 DSN 就是彻底的空操作**——不初始化 SDK、不建 HTTP 客户端、什么都不发。
//    开发机与 CI 都不配它，不该因为"上报没配好"而多出一堆东西、多一次启动开销。
//
// 2. **上报失败绝不冒泡到应用**。SDK 的传输层自己就吞异常
//    （sentry 包的 http_transport.dart 里 send 外面包着 try/catch），
//    这里再兜一层，是为了"将来换实现"也不变脸。
//
// 3. **学生数据不出境**。截图与视图树里会有题干正文和学生的真实姓名，
//    `debugPrint` 的输出里有启动失败详情与题目 id——全部显式关掉。
//    SDK 的默认值本来就是关的（除了 `enablePrintBreadcrumbs`，它默认**开**），
//    显式写出来是防止有人"顺手打开看看效果"。
//
// 4. **本文件不装任何 Flutter 钩子**。`SentryFlutter.init` 自己会装
//    `FlutterError.onError` 与 `PlatformDispatcher.onError`，而且那两处 integration
//    是**链式**的（捕获之后仍会调用原来那个 handler）。所以：
//      · 全局钩子在 lib/error_handling.dart 里**先**装，Sentry **后**装并链住它们；
//      · **钩子里绝不能再调这里**，否则同一条错误会被上报两次。
//
// ⚠ 国内网络到 sentry.io 未必通。本仓已经因为同类问题踩过一次坑：
// PDF 中文字体原先从 fonts.gstatic.com 拉，国内到不了**且没有超时**，
// 点「打印」既不报错也不出对话框（2026-09-17）。所以这里的定位是
// **尽力而为**：发不出去就发不出去，绝不影响任何功能。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class CrashReporter {
  static bool _ready = false;

  /// 是否已启用（配了 DSN 且初始化没抛）。
  static bool get enabled => _ready;

  /// 装配上报。**必须在 installErrorHandling() 之后调用**——
  /// 顺序反了的话 Sentry 会把它的 integration 装在前面，链不到我们的钩子。
  static Future<void> init() async {
    if (!Env.crashReportingEnabled) return;
    try {
      await SentryFlutter.init((options) {
        options.dsn = Env.sentryDsn;
        // 版本号与包名一起进事件，便于"这个问题出在哪个包"；
        // 流水线按 tag 注入 APP_VERSION，与检查更新同源。
        options.release = Env.appVersion.isEmpty ? null : Env.appVersion;
        options.environment = kReleaseMode ? 'production' : 'debug';

        // ---- 隐私：学生数据不出境 ----
        options.sendDefaultPii = false;
        options.attachScreenshot = false;
        // 这个字段被标了 experimental，所以下面挂了 ignore——但**仍然要写**：
        // 视图树里同样有题干与姓名，而 experimental 意味着它的默认值将来
        // 随时可能变，"靠默认值"在这里不成立。宁可挂一个带理由的 ignore。
        // ignore: experimental_member_use
        options.attachViewHierarchy = false;
        // **这个默认是 true**，必须显式关：正式包里它会把这个项目所有
        // debugPrint（启动失败详情、题目 id、学校列表失败）收成面包屑。
        options.enablePrintBreadcrumbs = false;
        options.maxBreadcrumbs = 20;

        // ---- 不采样 ----
        // 崩溃要的是"全都要"，不是抽样；性能追踪（tracesSampleRate）
        // 保持 null = 完全不开，本仓没有那方面需求，开了纯属多传数据。
        options.sampleRate = 1.0;
      });
      _ready = true;
    } catch (error, stack) {
      // 见文件头第 2 条：装不上就不装，绝不拦住启动
      debugPrint('崩溃上报未启用：$error');
      debugPrintStack(stackTrace: stack);
    }
  }

  /// 手动上报一条**非致命**异常。
  ///
  /// 只给"意料之外、但被 catch 住了"的地方用（例如启动装配失败）。
  ///
  /// **不要用它上报 AppException**：网络断了、会话过期、服务端拒绝这些
  /// 都是预期内的，`error_mapper` 已经把它们变成给用户看的中文提示。
  /// 全报上去只会把真正的问题淹掉——上报的价值在于"没见过的那种错误"。
  static Future<void> report(
    Object error,
    StackTrace? stack, {
    String? during,
  }) async {
    if (!_ready) return;
    try {
      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          // 标一个"出在哪个环节"，比堆栈更快定位。
          // 只放开发者写的常量标识（如 'bootstrap'），**不放用户数据**。
          if (during != null) scope.setTag('during', during);
        },
      );
    } catch (_) {
      // 见文件头第 2 条
    }
  }
}
