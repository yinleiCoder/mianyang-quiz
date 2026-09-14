// 应用根：依赖注册、主题、屏幕适配、路由挂载。
//
// 层序不能颠倒：
//   MultiProvider（依赖）
//     └ ScreenUtilInit（设计稿尺寸与缩放开关）
//         └ MaterialApp.router（主题在这里构建 —— 主题里用了 .r/.sp，
//                              必须在 ScreenUtilInit 之下求值，否则抛 LateInitializationError）
//
// 关于 UI 库：theme 与 MaterialApp 都来自 material_ui。
// 必须与 go_router 18 依赖的是同一个包，否则路由转场静默失效（见 AGENTS.md 第一条）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/bootstrap.dart';
import 'package:mianyang_quiz/core/router/app_router.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class MianyangQuizApp extends StatefulWidget {
  const MianyangQuizApp({super.key, required this.startup});

  final StartupResult startup;

  @override
  State<MianyangQuizApp> createState() => _MianyangQuizAppState();
}

class _MianyangQuizAppState extends State<MianyangQuizApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    final deps = widget.startup.deps;
    if (deps != null) {
      // 守卫要监听登录态，所以路由必须拿到 AuthStore
      _router = createAppRouter(deps.authStore);
    }
  }

  @override
  void dispose() {
    _router?.dispose();
    widget.startup.deps?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.startup.deps;
    final router = _router;

    return ScreenUtilInit(
      designSize: designSize,
      // 字号取宽高缩放中较小的那个，避免窄屏上字被撑得过大
      minTextAdapt: true,
      // 分屏（Windows 窗口并排 / 平板浮窗）时按分屏后的尺寸计算
      splitScreenMode: true,
      // 桌面端必须在这两个参数上关掉缩放：ScreenUtilInit 初始化时会用它们
      // 覆盖全局设置，只在 bootstrap 里调 ScreenUtil.enableScale 是无效的
      enableScaleWH: screenScaleEnabled,
      enableScaleText: screenScaleEnabled,
      builder: (context, child) => deps == null || router == null
          ? _StartupMessage(failure: widget.startup.failure)
          : MultiProvider(
              providers: [
                // 数据层：仓储与服务
                Provider.value(value: deps.userRepository),
                Provider.value(value: deps.subjectRepository),
                Provider.value(value: deps.questionRepository),
                Provider.value(value: deps.practiceRepository),
                Provider.value(value: deps.statsRepository),
                Provider.value(value: deps.listRepository),
                Provider.value(value: deps.favoriteRepository),
                Provider.value(value: deps.feedbackRepository),
                Provider.value(value: deps.ossUploadService),
                // 跨页状态：只有这四个进全局
                ChangeNotifierProvider.value(value: deps.authStore),
                ChangeNotifierProvider.value(value: deps.dashboardStore),
                ChangeNotifierProvider.value(value: deps.favoriteStore),
                ChangeNotifierProvider.value(value: deps.practiceDraftStore),
              ],
              child: MaterialApp.router(
                title: '绵阳题库',
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                routerConfig: router,
                debugShowCheckedModeBanner: false,
              ),
            ),
    );
  }
}

/// 起不来时的提示页。把原因摆到台面上——最常见的是 config/dev.json 没填。
class _StartupMessage extends StatelessWidget {
  const _StartupMessage({required this.failure});

  final String? failure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      title: '绵阳题库',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings_suggest_outlined,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text('需要先完成配置', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(
                    failure ?? '启动失败，请检查配置后重试。',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
