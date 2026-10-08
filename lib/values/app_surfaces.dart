// 平台相关的"底色"取值：同一块界面在不同平台上该铺什么底。
//
// 为什么单独一个文件，而不是塞进 AppTheme：一是 AppTheme 已经贴到架构守卫的
// 200 行上限；二是这里的规则严格来说不属于"主题"——用的是同一套 ColorScheme，
// 只是"取哪一格"随平台而变，混进主题工厂里会让主题看起来在两套配色之间摇摆。
//
// 平台判断一律用 `theme.platform`（默认即 defaultTargetPlatform），
// **不要用 dart:io 的 Platform.isWindows**：前者测试能覆写，也不必引 dart:io
// （同 bootstrap.dart 里 isDesktopPlatform 的取舍）。

import 'package:material_ui/material_ui.dart';

abstract final class AppSurfaces {
  /// 侧边导航栏的底色。
  ///
  /// **Windows 桌面端亮色下用纯白**：桌面窗口的侧栏是一整条常驻的竖带，而
  /// `surfaceContainer` 是 fromSeed 从种子色派生出来的近白色——单看一格没问题，
  /// 232 宽、满窗口高一整条铺开就明显"发灰发紫"，与右边纯白的页面底色对不上。
  /// 亮色下 AppTheme 已经把 `surface` 钉成纯白，所以这里取它就行，
  /// 组件里因此不出现任何写死的颜色。
  ///
  /// **暗色不改**：暗色主题下白侧栏会把整个界面掀翻（相邻的页面底色是深灰），
  /// 那一支继续用 surfaceContainer。
  static Color sideNav(ThemeData theme) {
    final isWindows = theme.platform == TargetPlatform.windows;
    if (isWindows && theme.brightness == Brightness.light) {
      return theme.colorScheme.surface;
    }
    return theme.colorScheme.surfaceContainer;
  }
}
