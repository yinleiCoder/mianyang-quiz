// 「开始练习」的两步动作：先把来源写进组卷草稿，再进组卷页。
//
// 错题本与收藏两个 Tab 共用，所以收在一处——这两步的顺序有讲究：
// 组卷页是四个入口共用的，它只能从草稿里知道自己是被谁打开的；
// 先跳转后写草稿的话，组卷页会拿着上一次的来源去抽题（比如本该练错题却抽了题库）。
//
// 这不是组件，而是一个动作函数：它不需要状态，也不返回任何东西。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
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
