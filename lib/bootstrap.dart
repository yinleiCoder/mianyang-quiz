// 启动装配：框架级初始化 + 依赖图构建。main.dart 只负责调用。
//
// 顺序有讲究：
//   1. ensureInitialized —— 之后才能用平台通道（Supabase 的会话存储要用）
//   2. 关闭桌面端缩放 —— 必须在任何用 .w/.sp 的 widget 构建之前
//   3. Supabase 初始化 + 依赖装配 —— 失败不抛，交给调用方显示提示页
//
// 返回值刻意不是「成功/抛异常」而是「依赖 或 原因」：
// 配置缺失、后端不可达这类问题应当**显示成界面上的提示**，而不是让用户看到崩溃页。

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mianyang_quiz/core/config/env.dart';
import 'package:mianyang_quiz/core/network/auth_refresh_client.dart';
import 'package:mianyang_quiz/dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 设计稿基准尺寸（逻辑像素）。手机竖屏的主流宽度。
const Size designSize = Size(390, 844);

/// 当前是否桌面平台。
///
/// 用 defaultTargetPlatform 而不是 Platform.isWindows：前者可以被测试覆写，
/// 也不必引入 dart:io。
bool get isDesktopPlatform => defaultTargetPlatform == TargetPlatform.windows;

/// 是否启用屏幕线性缩放。
///
/// **必须传给 `ScreenUtilInit(enableScaleWH:, enableScaleText:)`，不能只在
/// bootstrap 里调 `ScreenUtil.enableScale`。** 后者会被 ScreenUtilInit 在初始化时
/// 用它的同名参数覆盖（widget 参数为 null 时按 `?? () => true` 重置为"开"）——
/// 结果就是桌面端仍然按 390 的设计宽度线性放大：1280 宽的窗口把 `.sp(16)` 变成 52px，
/// 界面直接炸掉。这个坑只有在真机上跑起来才看得见。
bool Function() get screenScaleEnabled => () => !isDesktopPlatform;

/// 启动结果：要么拿到依赖，要么拿到无法启动的原因。
typedef StartupResult = ({AppDependencies? deps, String? failure});

Future<StartupResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Env.isConfigured) {
    // 不是错误，是"还没配"——提示页会列出缺哪几项
    return (
      deps: null,
      failure: '缺少配置：${Env.missingKeys.join("、")}\n'
          '请复制 config/dev.example.json 为 config/dev.json 并填入真实值，'
          '然后用 --dart-define-from-file=config/dev.json 启动。',
    );
  }

  try {
    // 令牌过期自愈：收到 401 就刷新会话并重放一次（见 auth_refresh_client.dart）。
    // 必须在 Supabase.initialize 之前建好并传进去——它要包住整个 http 通道。
    final authClient = AuthRefreshClient(http.Client());
    final supabase = await Supabase.initialize(
      url: Env.supabaseUrl,
      // 本项目用的是 sb_publishable_… 格式的密钥，对应 publishableKey 参数
      // （anonKey 参数已废弃，传它会被忽略并告警）
      publishableKey: Env.supabaseAnonKey,
      httpClient: authClient,
      // 会话在本地存储里的 key，SDK 默认按**域名第一段**算：
      //   `sb-${Uri.parse(url).host.split(".").first}-auth-token`
      // （supabase_flutter 的 supabase.dart:133，且只在没传 localStorage 时才自动推导）。
      //
      // 所以**换域名 = 换 key = 所有人的本地会话丢失、被登出一次**。我们为了绕开 SNI 拦截
      // 把 SUPABASE_URL 换成了 api.myquiz.cn，这个 key 就会从 sb-jwbczaoevrcrdqqvkfaz-…
      // 变成 sb-api-…。这里显式钉住旧 key，让会话存储与域名解耦：这次换域名用户毫无感知，
      // 以后再有下一次也一样。
      //
      // ⚠️ 这个值是**第一次上线时**那个域名算出来的，**以后不许再改** —— 改了就是又一次
      // 全体登出，而且这次不会有人提醒你，因为代码看起来完全正常。
      authOptions: FlutterAuthClientOptions(
        localStorage: SharedPreferencesLocalStorage(
          persistSessionKey: 'sb-jwbczaoevrcrdqqvkfaz-auth-token',
        ),
      ),
    );
    // 接上刷新回调。**在 initialize 之后**：它需要 client.auth，
    // 而 client 正是用这个 httpClient 造出来的（构造期拿不到，会造成循环依赖）。
    // 返回**新令牌**而不是空：重放时要拿它换掉请求头里那个过期的（见 auth_refresh_client）。
    authClient.onExpired = () async {
      // SDK 可能刚好自己刷过了，那就直接用现成的，不必再刷一次
      // （刷新令牌是一次性的，多刷一次会把会话刷没）
      final refreshed = await supabase.client.auth.refreshSession();
      return refreshed.session?.accessToken ??
          supabase.client.auth.currentSession?.accessToken;
    };
    final deps = AppDependencies.create(supabase.client);
    // 会话恢复不 await：要走网络，等它会让首屏白屏。
    // 路由守卫在 isReady 为 false 时挂起，页面自己显示加载态。
    deps.startSession();
    return (deps: deps, failure: null);
  } catch (error, stack) {
    debugPrint('启动失败：$error');
    debugPrintStack(stackTrace: stack);
    return (deps: null, failure: '无法连接后端服务，请检查网络与配置。\n$error');
  }
}
