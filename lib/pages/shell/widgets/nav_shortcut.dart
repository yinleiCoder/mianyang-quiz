// 侧栏独有的一级入口：**它们不是外壳的分支**。
//
// 点下去是 push 一个整页（`/compose`、`/exams`），不是切到一个带底部导航的 tab，
// 所以不进 nav_destinations.dart 的 kNavDestinations——
// 那条"目标列表与 StatefulShellRoute 的 branches 一一对应"的约束因此不受影响，
// 底部导航也不会被撑到第 6 个。
//
// **为什么只放侧栏**：底部导航已经 5 个（Material 的上限），再挤一个每个都变窄；
// 宽屏侧栏是竖排的，没有这个限制。这与"考试入口放首页"是同一个判断——
// 首页那两处入口**照旧保留**，侧栏只是给宽屏用户多一条捷径，不是把它们搬走。
//
// 单独成文件是因为一个文件只许有一个 public class（tool/check_architecture.dart）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/router/router.dart';

class NavShortcut {
  const NavShortcut({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;

  /// 目标路由。是**整页**（push），不是分支路径。
  final String path;
}

const List<NavShortcut> kNavShortcuts = [
  NavShortcut(
    label: '开始练习',
    icon: Icons.play_circle_outline,
    path: AppRoutes.composePath,
  ),
  NavShortcut(
    label: '参加考试',
    icon: Icons.assignment_outlined,
    path: AppRoutes.examsPath,
  ),
];
