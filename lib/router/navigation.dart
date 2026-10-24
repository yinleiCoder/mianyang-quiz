// 全屏页的安全跳转：避开"正在切导航分支"的那一小段时间，并吞掉导航异常。
//
// 背景（用户 2026-10-24）：在底部/侧边导航之间快速切换时，偶尔会在点「参加考试」
// 的瞬间闪退。考试页是 push 出来的全屏页，而点导航项走的是 goBranch；两者在
// 同一帧里撞上时，部分 Flutter 版本会在 Navigator 锁内重建路由（debug 下是红屏，
// release 下可能直接终止进程）。
//
// 这里不做"猜根因"的复杂修复，只做两件确定有用的事：
//   1. **切分支后 400ms 内先等一等再 push**：把两次导航错开，用户不会感觉到；
//   2. **同一段短时间内的重复 push 只执行一次**，并把 GoError 之类吞成一行日志，
//      不让它冒到全局错误处理（那才是"闪退"的最后一跳）。
//
// 这不是万能药：如果崩溃来自原生层（驱动/渲染），它挡不住；但导航层的异常
// 从此不会再被当成未捕获错误抛出去。

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract final class NavGuard {
  static DateTime? _lastBranchSwitch;
  static DateTime? _lastPush;

  /// 切分支时调一次（AppShell 的 select）。
  static void markBranchSwitch() {
    _lastBranchSwitch = DateTime.now();
  }

  /// 切分支后需要等的剩余时间；没切过或已经过了就返回零。
  static Duration get _branchSettle {
    final at = _lastBranchSwitch;
    if (at == null) return Duration.zero;
    const settle = Duration(milliseconds: 400);
    final elapsed = DateTime.now().difference(at);
    return elapsed >= settle ? Duration.zero : settle - elapsed;
  }
}

/// push 一个整页；自动避让分支切换，并忽略 350ms 内的重复调用。
Future<T?> safePush<T>(
  BuildContext context,
  String location, {
  Object? extra,
}) async {
  final now = DateTime.now();
  final last = NavGuard._lastPush;
  if (last != null && now.difference(last) < const Duration(milliseconds: 350)) {
    return null;
  }
  NavGuard._lastPush = now;

  final wait = NavGuard._branchSettle;
  if (wait > Duration.zero) {
    await Future<void>.delayed(wait);
    if (!context.mounted) return null;
  }

  try {
    return await GoRouter.of(context).push<T>(location, extra: extra);
  } catch (error, stack) {
    // 导航失败（路由不存在、Navigator 锁、页面已销毁）不该终止应用。
    // 只留一行日志，用户停在原页面，再点一次即可。
    debugPrint('导航失败（$location）：$error');
    debugPrintStack(stackTrace: stack);
    return null;
  }
}
