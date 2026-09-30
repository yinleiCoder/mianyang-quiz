// 崩溃上报：Sentry 的薄封装。
//
// 用的是**官方的 `sentry_flutter`**。这不是随手挑的——`sentry` 包自己的 README 就写着
// 「For Flutter consider sentry_flutter instead」，而 `sentry_flutter` 多给这些：
//   · **原生崩溃捕获**（Android 的 Java/Kotlin/C/C++，iOS 的 Objective-C/Swift）
//   · release health、离线缓存
//   · 自动挂 `PlatformDispatcher.onError` 等错误钩子
//
// ⚠ **版本必须是 10.x，不能回退到 9.x 或 8.x。** 它前面两个稳定版各自废掉一个平台：
//   · 9.30.1 精确锁 `jni: 0.14.2`，而那个版本的 `jni.h` 用了 MSVC 不认的
//     `__attribute__`，**Windows 包编不出来**。本项目的 `path_provider_android`
//     本来就把 jni 拉到 1.0.3（已修 MSVC），**是 sentry_flutter 把它降级回坏版本的**。
//   · 8.14.2 把整套 Android 工具链钉在两年多前（kotlin_version 1.8.0 / AGP 7.4.2 /
//     compileSdk 34 / languageVersion "1.6"），与 Kotlin 2.4 + AGP 9.1 + compileSdk 36
//     全对不上，**Android 包编不出来**。
// 10.0.0-rc.1 把 jni 放开成 `>=1.0.0 <1.1.0`、compileSdk 提到 36、删掉了
// languageVersion —— 两个平台才同时编得过。详见 AGENTS.md 第九节。
//
// 三条设计约束：
//
// 1. **没配 DSN 就是彻底的空操作**——不初始化 SDK、不建 HTTP 客户端、什么都不发。
//    开发机与 CI 都不配它，不该因为"上报没配好"而多出一堆东西、多一次启动开销。
//
// 2. **上报失败绝不冒泡到应用**。SDK 的传输层自己就吞异常，这里再兜一层，
//    是为了"将来换实现"也不变脸。
//
// 3. **学生数据不出境**。截图、视图树、`debugPrint` 面包屑里都会有题干正文、
//    学生真实姓名与题目 id——全部显式关掉（SDK 默认大多是关的，
//    **但 `enablePrintBreadcrumbs` 默认是开的**）。
//
// 4. **本文件不装任何 Flutter 钩子**。`SentryFlutter.init` 自己会装
//    `FlutterError.onError` 与 `PlatformDispatcher.onError`，而且那两处 integration
//    是**链式**的（捕获之后仍会调用原来那个 handler）。所以：
//      · 全局钩子在 lib/error_handling.dart 里**先**装，Sentry **后**装并链住它们；
//      · **钩子里绝不能再调这里**，否则同一条错误会被上报两次。
//
// ⚠ 国内网络到 sentry.io **实测是通的**（2026-09-28：TLS 0.3s、event 投递 HTTP 200），
// 但仍定位成**尽力而为**：发不出去就发不出去，绝不影响任何功能。
// 本仓被境外域名坑过一次（PDF 字体走 fonts.gstatic.com 且没超时，点「打印」毫无反应）。

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
      // **不传 appRunner**：本应用的启动顺序（配置校验 → Supabase → 依赖装配）
      // 有自己的讲究，不要为了上报去重排它。
      await SentryFlutter.init((options) {
        options.dsn = Env.sentryDsn;
        // 版本号与包名一起进事件，便于判断"这个问题出在哪个包"；
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
