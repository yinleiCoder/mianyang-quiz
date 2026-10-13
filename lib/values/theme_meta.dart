// 主题元数据：种子色清单 + 明暗模式。全站配色的**唯一入口**。
//
// ⚠ 明暗模式**用的是本文件自己的枚举**，不是 Flutter 的 ThemeMode：
// ThemeStore 在 lib/state/，而那一层禁止依赖 UI 库（tool/check_architecture.dart：
// "Store 必须无 UI 依赖"）。到 app.dart 才映射成 ThemeMode（见 AppThemeMode.flutter）。
// 想省掉这层映射而直接把 ThemeMode 塞进 Store 的话，守卫会挡住——别绕。
//
// 每个色都只是"种子"——真正的色板由 `ColorScheme.fromSeed` 派生。
// **不要在这里手写第二套色板**（比如"主色 + 它的深色变体"）：那等于扔掉 M3 的
// 对比度保证，暗色下必然失配（文字压不住底色、错误色与主色撞车）。
//
// wire 名会写进本地偏好（shared_preferences）。**改名等于让老用户的偏好失效**
// ——回落默认不会崩，但用户会发现"我设的颜色自己变回去了"。

import 'package:material_ui/material_ui.dart';

enum ThemeSeed {
  /// 品牌紫（默认）：就是 Colors.deepPurple。
  /// **不要改这个值**：改造前全站用的就是它，改了等于所有老用户第二天打开发现换了色。
  purple('purple', '紫', Color(0xFF673AB7)),
  indigo('indigo', '靛蓝', Color(0xFF3F51B5)),
  blue('blue', '蓝', Color(0xFF1565C0)),
  teal('teal', '青', Color(0xFF00796B)),
  green('green', '绿', Color(0xFF2E7D32)),
  orange('orange', '橙', Color(0xFFEF6C00)),
  pink('pink', '粉', Color(0xFFC2185B)),
  graphite('graphite', '石墨', Color(0xFF455A64));

  const ThemeSeed(this.wire, this.label, this.color);

  /// 持久化用的稳定名字（**不是** enum 名，也不给用户看）。
  final String wire;

  /// 选择器上显示的中文名。
  final String label;

  final Color color;
}

/// wire 名 → 枚举。认不出的一律回落默认（我们改过名、或用户从更新的版本降级回来）。
ThemeSeed themeSeedFrom(String? wire) {
  for (final seed in ThemeSeed.values) {
    if (seed.wire == wire) return seed;
  }
  return ThemeSeed.purple;
}

/// 明暗模式的三个选项。**顺序即选择器上的顺序**，也是用户最可能选的顺序。
enum AppThemeMode {
  system('system', '系统', Icons.brightness_auto_outlined),
  light('light', '浅色', Icons.light_mode_outlined),
  dark('dark', '深色', Icons.dark_mode_outlined);

  const AppThemeMode(this.wire, this.label, this.icon);

  /// 持久化用的稳定名字。**改名等于让老用户的偏好失效**（回落"系统"，不崩）。
  final String wire;

  final String label;
  final IconData icon;

  /// 映射到 Flutter 的 ThemeMode —— 只有 app.dart 需要它。
  ThemeMode get flutter => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

/// wire 名 → 枚举。认不出的回落「系统」（与 ThemeSeed 同一条约定）。
AppThemeMode appThemeModeFrom(String? wire) {
  for (final mode in AppThemeMode.values) {
    if (mode.wire == wire) return mode;
  }
  return AppThemeMode.system;
}
