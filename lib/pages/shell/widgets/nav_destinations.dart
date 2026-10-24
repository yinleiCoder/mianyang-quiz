// 主导航的目标列表。底部导航与侧边导航共用同一份——
// 两套导航各自维护一份的话，加一个页面就会只加上一半。

import 'package:material_ui/material_ui.dart';

/// 一个导航目标：图标 + 文案。
///
/// 顺序即分支顺序，必须与 router/app_router.dart 里
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

/// 底部导航（窄屏）按这个顺序摆**分支下标**，中间那一格留给 docked FAB。
///
/// **AI 答疑（分支 2）不在底部导航里**（用户 2026-10-13 要求）：窄屏把它的位置
/// 让给了正中间那颗「开始练习」的 FAB——4 个 tab 夹一颗 FAB，才是对称的。
/// 窄屏进 AI 答疑改走首页的快捷入口（home_actions）；宽屏侧栏照旧是全部五项。
const List<int> kBottomNavBranches = [0, 1, 3, 4];

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
  // AI 答疑：站外能力（duck.ai），放在题库旁边——学生查问题的手势就是"看完题顺手问一句"
  NavDestination(
    label: 'AI 答疑',
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
  ),
  // 记录用「打勾的清单」。原来是 insights（锯齿趋势线），既像股票图又和首页
  // 那张趋势图语义打架；fact_check 的选中态是实心块，不靠颜色也分得清选中。
  // 用户 2026-10-24 要求：导航里的「记录」改叫「错题本」，与页内第一个页签同名。
  NavDestination(
    label: '错题本',
    icon: Icons.fact_check_outlined,
    activeIcon: Icons.fact_check,
  ),
  NavDestination(
    label: '我的',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  ),
];
