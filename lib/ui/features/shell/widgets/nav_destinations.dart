// 主导航的目标列表。底部导航与侧边导航共用同一份——
// 两套导航各自维护一份的话，加一个页面就会只加上一半。

import 'package:material_ui/material_ui.dart';

/// 一个导航目标：图标 + 文案。
///
/// 顺序即分支顺序，必须与 core/router/app_router.dart 里
/// StatefulShellRoute 的 branches 一一对应。
class NavDestination {
  const NavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

const List<NavDestination> kNavDestinations = [
  NavDestination(label: '首页', icon: Icons.home_outlined, activeIcon: Icons.home),
  NavDestination(
    label: '题库',
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book,
  ),
  NavDestination(
    label: '记录',
    icon: Icons.insights_outlined,
    activeIcon: Icons.insights,
  ),
  NavDestination(
    label: '我的',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];
