// 底部导航条（窄屏形态）。
//
// 只画，不管路由——切换由 AppShell 通过 StatefulNavigationShell 完成。
// 这样本组件可以脱离路由单独测试。
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
//
// ⚠ **中间那一格是留给 FAB 的空位，不是导航目的地**：开始练习由 AppShell 的
// FloatingActionButton（floatingActionButtonLocation: centerDocked）承担，
// 这里只把位置让出来，免得 5 个 tab 中间那个被 FAB 压住。
// 因此本组件里的**下标与分支下标差一**：见 _branchIndexOf 与 selectedIndex 的换算。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_destinations.dart';

/// 练习键（FAB）坐在第几格：4 个分支夹一颗 FAB，它就是正中间那格。
const int _practiceSlot = 2;

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.onStartPractice,
  });

  /// 当前分支下标（0..4），**不含**中间那个练习键。
  final int currentIndex;

  /// 切分支（收的还是分支下标）。
  final ValueChanged<int> onSelect;

  /// 中间那颗下沉的练习键被按下。
  final VoidCallback onStartPractice;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      // 条上有 6 个位置、分支只有 5 个：练习键左边原样，右边整体 +1
      // currentIndex 是**分支**下标；条上还多一格 FAB。AI 答疑（分支 2）不在条上，
      // 若当前正停在它上面（宽屏切过来、或深链直达），就让"选中"落在 FAB 那格——
      // 反正那格是空的，视觉上等于"这一页不在底部导航里"。
      selectedIndex: _slotOf(currentIndex),
      onDestinationSelected: (slot) {
        if (slot == _practiceSlot) {
          onStartPractice();
        } else {
          // 槽位 → kBottomNavBranches 的下标 → 真正的分支下标（AI 答疑那一档不在条上）
          onSelect(kBottomNavBranches[_branchIndexOf(slot)]);
        }
      },
      destinations: [
        for (var slot = 0; slot <= kBottomNavBranches.length; slot++)
          _destinationAt(slot),
      ],
    );
  }

  /// 分支下标 → 条上槽位（跳过中间那格 FAB）。
  static int _slotOf(int branch) {
    if (!kBottomNavBranches.contains(branch)) return _practiceSlot;
    return branch < _practiceSlot ? branch : branch + 1;
  }

  /// 第 [slot] 个位置画什么：中间那格**留空**，让码头在缺口里；其余按分支顺序取。
  static NavigationDestination _destinationAt(int slot) {
    if (slot == _practiceSlot) {
      // 空的占位：只是把中间的位置**让出来**给 Scaffold 的 docked FAB
      //（AppShell 里 floatingActionButtonLocation: centerDocked）。
      // 这里什么都不画——按钮本身归框架，别在这儿再自绘一个（用户 2026-10-13 纠正过）。
      return const NavigationDestination(
        icon: SizedBox(width: 56, height: 24),
        label: '',
      );
    }
    final destination = kNavDestinations[kBottomNavBranches[_branchIndexOf(slot)]];
    return NavigationDestination(
      icon: Icon(destination.icon),
      selectedIcon: Icon(destination.activeIcon),
      label: destination.label,
    );
  }

  /// 条上的位置 → kBottomNavBranches 的下标（跳过中间那格 FAB）。
  static int _branchIndexOf(int slot) =>
      slot < _practiceSlot ? slot : slot - 1;
}
