// 尺寸常量：圆角、间距、按钮厚度、内容限宽。
//
// 职责：给「多大、隔多远」一个唯一出口，页面里不再散落魔法数字。
// 不负责：颜色（在 AppTheme 里）、字号（在 AppTextStyles 里）、屏幕缩放——
// 缩放由调用点补 .r / .sp 完成（flutter_screenutil；桌面端框架关闭缩放后退化为恒等映射）。
//
// 这里刻意保存**设计稿原始值**并保持 const：const 才能在 const 构造里用。
// 需要跟随屏幕缩放的场合写 AppMetrics.gapMd.r 这样。

/// 全站尺寸常量。与主题无关，亮暗色共用。
abstract final class AppMetrics {
  /// 内容限宽：桌面端把页面内容居中在这个宽度内，避免一行文字长到读不下去。
  static const double pageMaxWidth = 640;

  /// 页面左右安全边距。
  static const double pagePadding = 20;

  /// 卡片圆角。18 → 12：18 在宽屏上接近"药丸"观感，卡片一多整页显得软塌塌；
  /// 12 仍明显是圆角，但更接近工具类应用的克制感。
  static const double radiusCard = 12;

  /// 按钮圆角。跟着卡片一起收 —— 卡片 12 而按钮仍是 16 的话，
  /// 同一屏里两种圆角会显得没对齐。
  static const double radiusButton = 12;

  /// 标签圆角（999 = 胶囊形）。
  static const double radiusChip = 999;

  /// 立体按钮底部的「厚度」：按下时按钮下沉这么多，厚度随之消失。
  static const double buttonDepth = 4;

  /// 标准按钮总高（含厚度）。
  static const double buttonHeight = 56;

  /// 紧凑按钮总高（含厚度），仍不小于触控目标。
  static const double buttonHeightCompact = 48;

  /// 顶部粗进度条的高度。
  static const double progressHeight = 14;

  /// 细描边：卡片、分隔线。
  static const double hairline = 1;

  /// 粗描边：描边按钮、聚焦输入框。
  static const double stroke = 2;

  /// 最小触控目标：任何可点元素的可点区域都不应小于它。
  static const double touchTarget = 48;

  /// 间距梯度，页面里只允许用这五档。
  static const double gapXs = 4;
  static const double gapSm = 8;
  static const double gapMd = 12;
  static const double gapLg = 16;
  static const double gapXl = 24;
}
