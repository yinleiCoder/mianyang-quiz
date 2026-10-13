// 输入框与标签（chip）的默认外形。
//
// 从 app_theme.dart 拆出来：那边是"配色 + 核心组件"的装配台，已贴到 200 行上限
//（tool/check_architecture.dart 强制），而这两个主题各有各的取舍，单独成篇更清楚。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/app_metrics.dart';

abstract final class AppFieldTheme {
  /// 输入框：M3 的 **outlined** 变体（透明底 + 1dp 描边 + 4dp 圆角）。
  ///
  /// 旧版是"填充底 + 描边"的混血——规范里没有这一种，M3 只有两种：outlined（就是这里）
  /// 与 filled（填充底 + 只在底部留一条指示线）。挑一个才是 M3，混着来谁都不像。
  /// 选 outlined 是因为表单里这一格往往要跟旁边的按钮、下拉框对齐，描边比填充更容易对齐。
  ///
  /// 聚焦/出错时描边加粗到 2dp 并换色，这是 M3 规定的那两处状态变化。
  static InputDecorationThemeData inputDecoration(ColorScheme scheme) =>
      InputDecorationThemeData(
        filled: false,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppMetrics.gapLg.r,
          vertical: AppMetrics.gapMd.r,
        ),
        border: _border(scheme.outline, AppMetrics.hairline),
        enabledBorder: _border(scheme.outline, AppMetrics.hairline),
        focusedBorder: _border(scheme.primary, AppMetrics.stroke),
        errorBorder: _border(scheme.error, AppMetrics.hairline),
        focusedErrorBorder: _border(scheme.error, AppMetrics.stroke),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15.sp),
      );

  /// 标签：M3 的 chip 是 **8dp 圆角**（不是胶囊），底色走中性容器色。
  ///
  /// 只读标签（DuoChip）走的是各自语气的色调容器，不经过这里——这里管的是框架
  /// Chip 组件（筛选、选择）的默认外观。
  static ChipThemeData chip(ColorScheme scheme) => ChipThemeData(
    backgroundColor: scheme.surfaceContainerHighest,
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
    ),
    labelStyle: TextStyle(
      color: scheme.onSurfaceVariant,
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: AppMetrics.gapSm.r,
      vertical: AppMetrics.gapXs.r,
    ),
  );

  static OutlineInputBorder _border(Color color, double width) =>
      OutlineInputBorder(
        // M3 的形状比例尺里输入框是 extra small（4）
        borderRadius: BorderRadius.circular(AppMetrics.radiusExtraSmall.r),
        borderSide: BorderSide(color: color, width: width.r),
      );
}
