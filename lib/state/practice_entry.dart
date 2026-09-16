// 「开始练习」的两步动作：先把来源写进组卷草稿，再进组卷页。
//
// 组卷页是五个入口共用的（错题本、收藏、练习记录、结果页的「练这些错题」、
// 首页的「开始一次练习」），它只能从草稿里知道自己是被谁打开的。
// 先跳转后写草稿的话，组卷页会拿着上一次的来源去抽题——本该练错题却抽了题库。
// 收敛成一个函数就是为了让这个顺序不可能写反。
//
// **为什么放在 state/ 而不是某个 feature 里**：调用方横跨 records 与 practice
// 两个 feature，而 ui/features/a/ 不准 import ui/features/b/（AGENTS.md 二）。
// 也不能放 ui/core/：那层禁止依赖 state/（共享 UI 只能收数据与回调），
// 而本函数必须读 PracticeDraftStore。
//
// 它不是组件而是动作函数：不需要状态，也不返回任何东西。

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:provider/provider.dart';

/// 以 [source] 为来源打开组卷页。调用方负责保证这个来源下有题可练
/// （空错题本/空收藏不要接这个入口——服务端抽不到题会报错）。
void startPracticeFrom(BuildContext context, PracticeSource source) {
  context.read<PracticeDraftStore>().startFrom(source: source);
  context.push(AppRoutes.composePath);
}
