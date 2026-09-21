// 「开始练习」这个动作的完整流程，从组卷页的按钮里抽出来。
//
// 抽出来的理由是它已经不只一步了：等看板 → 处理进行中的会话 → 组卷 → 处理「今天练完了」→
// 进练习页。堆在组卷页的 _start() 里会把那个本来只管"选什么练"的页面撑爆
//（AGENTS.md 三：单文件 ≤200 行，上个版本练习页涨到 1379 行就是这么来的）。
//
// 返回 true = 已经跳进练习页（调用方不要再动状态，那个页面马上就要被替换掉）；
// false = 停在组卷页（用户取消、或今天没题可练）。
//
// **它自己弹提示与报错**：这些后果（进行中会话将被作废、今天练完了、抽不到题）
// 都只有在这里才知道，回抛给页面再弹一次等于把同一个判断写两遍。

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/practice/start_outcome.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/active_session_banner.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/nothing_due_sheet.dart';
import 'package:provider/provider.dart';

Future<bool> startPracticeFlow(
  BuildContext context, {
  required PracticeDraftStore draft,
}) async {
  // 看板还没到手就先等它一次。**没有这张看板就看不见进行中的会话**，
  // 而开始新练习会把那场练习静默作废 —— 冷启动直奔组卷页时（看板还挂在
  // 第一个请求上）正好落在这个窗口里。宁可多等一个往返，也不能在用户
  // 不知情时丢掉进度。
  //
  // 「看板有数据但已经过期」这一种窗口仍在（静默刷新失败时 Store 会保留旧数据）。
  // 兜它的是练习页那一侧：会话被作废之后再打开看到的是「已作废」，而不是接着答题。
  final dashboard = context.read<DashboardStore>();
  if (dashboard.data == null) await dashboard.refresh(silent: true);
  if (!context.mounted) return false;

  final active = dashboard.data?.activeSession;
  if (active != null) {
    final choice = await showActiveSessionBanner(context, active);
    if (!context.mounted || choice == null) return false;
    if (choice == ActiveSessionChoice.resume) {
      context.pushReplacement(AppRoutes.practiceOf(active.sessionId));
      return true;
    }
    // 重新开始：继续往下走，服务端会作废旧会话
  }

  final repository = context.read<PracticeRepository>();
  try {
    var outcome = await repository.startSession(
      filter: draft.filter,
      limit: draft.limit,
      source: draft.source,
    );
    if (!context.mounted) return false;

    // 今天该练的都练完了（0069）：服务端一道都没发，也没建会话。
    // 面板上那个「仍然加练」就是带开关再调一次 —— 只有学生自己按了才放宽到重复。
    if (outcome is PracticeNothingDue) {
      final again = await showNothingDueSheet(context, outcome);
      if (!context.mounted || !again) return false;
      outcome = await repository.startSession(
        filter: draft.filter,
        limit: draft.limit,
        source: draft.source,
        allowSameDay: true,
      );
      if (!context.mounted) return false;
      if (outcome is! PracticeStarted) {
        // 加练之后仍然一道都发不出来。正常到不了（加练的含义就是"今天练过的也发"），
        // 留着是为了不让按钮永远卡在 loading 上。
        return false;
      }
    }
    if (outcome is! PracticeStarted) return false;

    // 看板刷新不 await：练习页根本不显示看板，交卷后的结果页还会再刷一次。
    // 等它等于把一次 practice_dashboard RPC 塞进「开始练习」的等待路径，
    // 用户多等一个往返才进题。refresh 自己吞掉异常，这里不会产生未处理的错误。
    unawaited(context.read<DashboardStore>().refresh(silent: true));
    context.pushReplacement(
      AppRoutes.practiceOf(outcome.snapshot.sessionId),
      extra: (mode: draft.mode, shuffle: draft.shuffleOptions),
    );
    return true;
  } catch (error) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      // 不要插值原始异常：AppException.toString() 是 '$runtimeType: $message'，
      // 用户会看到「ServerException: …」而不是给用户看的那句中文。
      SnackBar(content: Text(mapError(error).message)),
    );
    return false;
  }
}
