// 进入软件即打卡：外壳挂载后的第一帧记一次（迁移 0107）。
//
// 为什么挂在 AppShell 而不是首页：深链接（通知/分享链接）可能直接落到某个子页面，
// "打开软件"这件事仍然发生了。放在外壳上，登录后的任何入口都会记到。
//
// 失败静默：打卡是激励，不是门槛。断网时首页照常显示本地默认值（连续天数回落到
// 看板的练习天数、目标 20），不会因为它弹错误。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:provider/provider.dart';

class DailyCheckinTracker extends StatefulWidget {
  const DailyCheckinTracker({super.key, required this.child});

  final Widget child;

  @override
  State<DailyCheckinTracker> createState() => _DailyCheckinTrackerState();
}

class _DailyCheckinTrackerState extends State<DailyCheckinTracker> {
  AppLifecycleListener? _lifecycle;
  AuthStore? _auth;

  @override
  void initState() {
    super.initState();
    // 冷启动时 AppShell 可能比会话恢复更早挂载（路由守卫在 isReady=false 时只是
    // 不下结论，已经渲染了首页分支）。此时直接调 RPC 会 401，而且之后再没人补——
    // 所以先盯住 AuthStore，等它变成「已就绪且已登录」再记。
    try {
      _auth = context.read<AuthStore>()..addListener(_tryRecord);
    } catch (_) {
      // 页面测试可能没注册 AuthStore；退化成"首帧直接试一次"（下面仍会兜住）
    }
    // 首帧之后再发：启动路径上不挡首屏；RPC 很快，首页打卡区会自己重建。
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryRecord());
    // 从后台回来也算"进入软件"：跨过午夜后回到前台，今天这一格要立刻补上。
    // CheckinStore 自己会判断"今天已经记过"，重复调用是幂等的。
    _lifecycle = AppLifecycleListener(onResume: _tryRecord);
  }

  void _tryRecord() {
    final auth = _auth;
    // 没有 AuthStore（测试装配）时不拦，交给 _record 里对 CheckinStore 的兜底
    if (auth != null && (!auth.isReady || !auth.isSignedIn)) return;
    _record();
  }

  void _record() {
    if (!mounted) return;
    try {
      context.read<CheckinStore>().recordToday();
    } catch (_) {
      // 页面测试会单独 pump AppShell（不注册完整依赖树）；打卡是锦上添花，
      // 拿不到 Store 就跳过，绝不能让外壳因此报错。
    }
  }

  @override
  void dispose() {
    _auth?.removeListener(_tryRecord);
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
