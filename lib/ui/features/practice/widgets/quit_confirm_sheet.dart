// 退出练习的确认面板，以及"退出"这个动作本身。
//
// 为什么不是"退出即放弃"：用户可能只是想先看看题库再回来。
// 但也不能不提醒——**开始新练习会静默作废旧的进行中会话**，
// 所以"保留会话"这条路必须说清楚它只在"不再开新练习"的前提下有效。
//
// 面板（[showQuitConfirmSheet]）返回 null 表示用户取消了退出；
// 整个流程（弹面板 → 处理选择 → 离开）是 [confirmQuitPractice]，
// 它放在这里而不是练习舞台里：这些后果就是下面那两个按钮的语义，分在两处读不出完整意图。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:provider/provider.dart';

enum QuitAction {
  /// 放弃本次练习（已作答的记录仍计入统计）。
  abandon,

  /// 保留会话，先离开。下次可从首页「继续练习」回来。
  keepAndLeave,
}

/// 走完"退出练习"这件事：弹面板 → 按选择作废或保留 → 离开练习页。
///
/// 放弃分支里那次看板刷新**不是顺手做的**：首页「继续练习」卡是看板画的，
/// 不刷新的话它还指着这场刚作废的练习，用户一点进去就是一场答不了题的练习
/// —— 线上「本次练习已结束，无法继续作答」的主要来路正是这里。
Future<void> confirmQuitPractice(BuildContext context, PracticeRunner runner) async {
  final action = await showQuitConfirmSheet(context);
  if (!context.mounted || action == null) return;

  // 两条分支都是"离开答题"，都放退出音（用户选完才响，取消不响）
  unawaited(context.read<SfxService>().quit());

  if (action == QuitAction.abandon) {
    await runner.abandon();
    if (!context.mounted) return;
    unawaited(context.read<DashboardStore>().refresh(silent: true));
  }
  if (context.mounted) Navigator.of(context).pop();
}

Future<QuitAction?> showQuitConfirmSheet(BuildContext context) {
  return showModalBottomSheet<QuitAction>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.pagePadding,
            0,
            AppMetrics.pagePadding,
            AppMetrics.pagePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '要退出练习吗？',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              Text(
                '这次的进度可以保留，下次从首页「继续练习」回来接着做。\n'
                '放弃的话本次不算完成，但已作答的记录仍会计入统计。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapXl),
              DuoButton(
                label: '保留进度，先离开',
                variant: DuoButtonVariant.primary,
                icon: Icons.bookmark_outline,
                onPressed: () => Navigator.of(context).pop(QuitAction.keepAndLeave),
              ),
              const SizedBox(height: AppMetrics.gapMd),
              DuoButton(
                label: '放弃本次练习',
                variant: DuoButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(QuitAction.abandon),
              ),
              SizedBox(height: 4.r),
              DuoButton(
                label: '继续做题',
                variant: DuoButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
