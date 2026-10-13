// 底部导航（窄屏）主题。
//
// 从 app_theme.dart 拆出来：那边的职责是"把配色装进 ThemeData"，而这里两条定制
// 各有各的理由、注释比配置还长，留在装配文件里会把 app_theme.dart 顶过
// 单文件 200 行上限（tool/check_architecture.dart 强制）。
//
// 结构不在这里——NavigationBar 本身由 pages/shell/widgets/app_bottom_nav.dart
// 直接使用框架实现，本文件只改它的外观。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppNavigationBarTheme {
  /// 只做两件事：
  ///
  /// ① **字重只允许 w400/w700**。M3 的 labelMedium 是 w500，中文会走引擎合成的
  ///    伪粗体，正是 AGENTS.md 点名禁止的那一档。
  /// ② **选中态用 secondaryContainer**——这就是 M3 给底部导航规定的角色。
  ///    （2026-10-12 改版前我们用的是 primaryContainer，理由是"跟宽屏侧栏一致"；
  ///    现在侧栏也改用 secondaryContainer 了，两边仍然一致，而且这次是照着规范走。）
  static NavigationBarThemeData build(ColorScheme scheme) {
    return NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      // 本项目的观感是平的（appBar / card 都是 0）。M3 默认的 3 因为
      // shadowColor 与 surfaceTintColor 默认透明而看不出差别，仍显式归零，
      // 免得日后有人给 surfaceTintColor 填了色，导航栏突然浮起来。
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12.sp,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 24.r,
          color: states.contains(WidgetState.selected)
              ? scheme.onSecondaryContainer
              : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
