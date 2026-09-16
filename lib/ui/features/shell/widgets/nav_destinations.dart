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
  // 题库用「摊开的书」而不是 menu_book：menu_book 在 22px 下是一整块实心黑，
  // 旁边 home/person 都是细描边，四个图标摆一起时它明显偏重。
  // auto_stories 线宽与另外三个一致，选中态的实心版本反差也够。
  NavDestination(
    label: '题库',
    icon: Icons.auto_stories_outlined,
    activeIcon: Icons.auto_stories,
  ),
  // 记录用「打勾的清单」。原来是 insights（锯齿趋势线），既像股票图又和首页
  // 那张趋势图语义打架；fact_check 的选中态是实心块，不靠颜色也分得清选中。
  NavDestination(
    label: '记录',
    icon: Icons.fact_check_outlined,
    activeIcon: Icons.fact_check,
  ),
  NavDestination(
    label: '我的',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];
