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
// ⚠ **中间那个「练习」位不是导航目的地**：它是一颗"挖进导航条里"的按钮
// （用户 2026-07-… 明确要的形态：像挖了一个洞），点它 push 整页的组卷页。
// 因此本组件里的**下标与分支下标差一**：见 _branchIndexOf 与 selectedIndex 的换算。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_destinations.dart';

/// 中央练习键插在第几个位置（两侧各两个导航项）。
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
      selectedIndex: currentIndex < _practiceSlot
          ? currentIndex
          : currentIndex + 1,
      onDestinationSelected: (slot) {
        if (slot == _practiceSlot) {
          onStartPractice();
        } else {
          onSelect(_branchIndexOf(slot));
        }
      },
      destinations: [
        for (var slot = 0; slot <= kNavDestinations.length; slot++)
          _destinationAt(slot),
      ],
    );
  }

  /// 第 [slot] 个位置画什么：中间那格是下沉的练习键，其余按分支顺序取。
  static NavigationDestination _destinationAt(int slot) {
    if (slot == _practiceSlot) {
      return const NavigationDestination(
        icon: _SunkenPracticeIcon(),
        label: '练习',
      );
    }
    final destination = kNavDestinations[_branchIndexOf(slot)];
    return NavigationDestination(
      icon: Icon(destination.icon),
      selectedIcon: Icon(destination.activeIcon),
      label: destination.label,
    );
  }

  /// 条上的位置 → 分支下标（跳过中间那颗练习键）。
  static int _branchIndexOf(int slot) =>
      slot < _practiceSlot ? slot : slot - 1;
}

/// 「挖进导航条里」的练习键。
///
/// M3 没有这种形态（它只有凸起的 docked FAB），这是用户点名要的：
/// **像在导航条上挖了一个洞**。做法是"凹面"的三件套——上沿一道暗边、
/// 自上而下的渐变（上暗下亮）、底色比导航条再深一档；再配一个主题色的播放键。
/// 全都是主题色派生的，暗色模式下自动反过来（暗色里"更深"本来就等于"更凹"）。
class _SunkenPracticeIcon extends StatelessWidget {
  const _SunkenPracticeIcon();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            // 上沿压暗：光进不到洞里
            Color.alphaBlend(scheme.shadow.withValues(alpha: 0.22), scheme.surfaceContainerHighest),
            scheme.surfaceContainerHighest,
          ],
        ),
        // 洞沿的一圈细边，让"挖"这件事有明确的边界
        border: Border.all(
          color: scheme.shadow.withValues(alpha: 0.10),
          width: AppMetrics.hairline.r,
        ),
      ),
      child: Icon(Icons.play_arrow_rounded, size: 24.r, color: scheme.primary),
    );
  }
}
