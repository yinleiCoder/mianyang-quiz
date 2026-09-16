// 底部导航（窄屏）主题。
//
// 从 app_theme.dart 拆出来：那边的职责是"把配色装进 ThemeData"，而这里两条定制
// 各有各的理由、注释比配置还长，留在装配文件里会把 app_theme.dart 顶过
// 单文件 200 行上限（tool/check_architecture.dart 强制）。
//
// 结构不在这里——NavigationBar 本身由 ui/features/shell/widgets/app_bottom_nav.dart
// 直接使用框架实现，本文件只改它的外观。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppNavigationBarTheme {
  /// 只做两件事，都是把 M3 默认值拉回本项目已有的约定：
  ///
  /// ① **字重只允许 w400/w700**。M3 的 labelMedium 是 w500，中文会走引擎合成的
  ///    伪粗体，正是 AGENTS.md 点名禁止的那一档。
  /// ② **选中态配色对齐宽屏侧栏**（AppSideNav 用的是 primaryContainer /
  ///    onPrimaryContainer）。不跟 M3 默认的 secondaryContainer 走：同一个 app
  ///    在窄屏和宽屏下选中项是两种颜色，用户只会读成 bug。
  static NavigationBarThemeData build(ColorScheme scheme) {
    return NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.primaryContainer,
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
              ? scheme.onPrimaryContainer
              : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
