// 收藏按钮的动作：切换 + 把结果 toast 出来。
//
// 为什么是独立函数而不是各页写一遍：收藏按钮出现在题库列表、题目详情、练习反馈条
// 三处，文案（已收藏 / 已取消收藏）与失败处理必须逐字一致，
// 否则用户会以为在不同页面点击效果不同。
//
// **为什么 toggle 是回调参数，而不是在这里 context.read<FavoriteStore>()**：
// 本文件在 ui/core/，那一层禁止 import state/（AGENTS.md 二）。
// 那把"谁能切换收藏"交给调用方传进来，本函数只负责"怎么提示"——
// 共享 UI 只收数据与回调，正是这条分层规则想要的形状。
//
// await 之前先把 messenger 取出来：这样 await 之后不再碰 context，
// 天然满足 use_build_context_synchronously，调用方也不必再判 mounted。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';

Future<void> toggleFavoriteWithToast(
  BuildContext context, {
  required String questionId,
  required Future<bool> Function(String questionId) toggle,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final favorite = await toggle(questionId);
    messenger.showSnackBar(
      SnackBar(content: Text(favorite ? '已收藏' : '已取消收藏')),
    );
  } on AppException catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(error.message)));
  }
}
