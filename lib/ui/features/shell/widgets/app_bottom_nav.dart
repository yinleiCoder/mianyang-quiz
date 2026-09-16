// 底部导航条（窄屏形态）。
//
// 只画，不管路由——切换由 AppShell 通过 StatefulNavigationShell 完成。
// 这样本组件可以脱离路由单独预览与测试。
//
// **直接用 Material 的 NavigationBar，不自己画。** 之前是自己拼的圆角浮起条
// （左右留 gapLg、上下留 gapMd、外加描边），窄屏上看着像个卡片而不是系统导航。
// 换成框架实现后有四个好处：
//   · 通栏到底、无左右留白，与 Android/桌面平台的底部导航一致；
//   · 底部安全区由 NavigationBar **内部的 SafeArea** 处理（见其 build），
//     所以这里**不能再包一层 SafeArea**，否则底部内边距会翻倍；
//   · 选中指示器、水波纹、无障碍语义都由框架给，不必自己维护；
//   · 高度、标签行为有 M3 默认值，不再散落魔法数。
//
// 本项目的两处定制（配色对齐侧栏、字重只用 w400/w700）统一放在
// AppTheme.navigationBarTheme 里，**不写在这个组件上**——组件只负责结构。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/nav_destinations.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelect,
      destinations: [
        for (final destination in kNavDestinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.activeIcon),
            label: destination.label,
          ),
      ],
    );
  }
}
