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

  /// 卡片底色：M3 的低彩度表面 + 一层 primary 轻染。
  ///
  /// 只用 `surfaceContainerLow` 时，换主题色几乎看不出变化（用户 2026-10-23
  /// 反馈"卡片仍是固定的淡紫色"）——M3 的 surface 系列本来就是低彩度。
  /// 2026-10-24 用户再次反馈"卡片还是固定色"，于是把轻染从 8% 提到
  /// **亮色 12% / 暗色 16%**：仍然保留 outlined card 的层次，但换绿/橙/粉时
  /// 一眼看得出卡片跟着变。
  static Color card(ColorScheme scheme) => Color.alphaBlend(
    scheme.primary.withValues(
      alpha: scheme.brightness == Brightness.dark ? 0.16 : 0.12,
    ),
    scheme.surfaceContainerLow,
  );

  /// "内容白卡"：题库列表、题目详情、记录页那几处原先显式传 `scheme.surface`
  /// 的位置。亮色下 surface 是纯白，直接用会让这几页完全不跟主题色走；
  /// 这里同样叠一层很薄的 primary（亮 6% / 暗 12%），让白卡也有主题色倾向，
  /// 同时仍比普通卡片更亮、文字对比更足。
  static Color contentCard(ColorScheme scheme) => Color.alphaBlend(
    scheme.primary.withValues(
      alpha: scheme.brightness == Brightness.dark ? 0.12 : 0.06,
    ),
    scheme.surface,
  );
}
