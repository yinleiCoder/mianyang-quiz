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

  /// 答题区在宽屏上的上限。
  ///
  /// 考试页右侧常驻答题卡（260），1280 的窗口里留给题面的还有约 980 —— 仍按 640 居中，
  /// 两侧各空出 170，而练习页不限宽（同一台机器上是 1619），两页一对比就显得考试"太窄"
  /// （学生反馈）。640 是"单栏阅读"的舒适宽度，但卷面是**要扫读的结构化内容**，
  /// 放宽到 1080 仍有边界。窄屏不受影响：可用宽度本来就小于 640。
  static const double pageWideMaxWidth = 1080;

  /// 页面左右安全边距。
  static const double pagePadding = 20;

  /// 圆角按 **M3 的形状比例尺**（m3.material.io/foundations/shape）取，不要各页自己写数字。
  /// 下面五个名字就是规范里的五档，语义化的 radiusXxx 一律从它们派生。
  static const double radiusExtraSmall = 4; // 小控件
  static const double radiusSmall = 8; // 标签、小容器
  static const double radiusMedium = 12; // 卡片、对话框、菜单
  static const double radiusLarge = 16; // 大容器
  static const double radiusExtraLarge = 28; // 底部弹层、对话框的顶角
  static const double radiusFull = 999; // 胶囊（按钮、筛选条）

  /// 卡片圆角 = M3 的 medium。2026-10-12 起直接跟着规范走，不再单独调数值。
  static const double radiusCard = radiusMedium;

  /// **自绘控件**的圆角（输入框、自绘的方块按钮等）。
  ///
  /// ⚠ 名字里的「按钮」是历史包袱：真正的按钮（FilledButton 家族）已按 M3 改成
  /// **全圆角胶囊**（见 app_theme 的 buttonShape），不再读这个值。
  static const double radiusButton = radiusMedium;

  /// 标签圆角 = M3 的 small。**原来是 999（胶囊）**——那是多邻国那套的取法，
  /// M3 的 chip 明确是 8。
  static const double radiusChip = radiusSmall;

  /// 标准按钮高度。M3 的按钮档位里 56 属于 large，触控与桌面端都合适。
  /// （旧版这个高度里还含 4 的「厚度」，现在按钮没有厚度了。）
  static const double buttonHeight = 56;

  /// 紧凑按钮高度（仍不小于触控目标）。
  static const double buttonHeightCompact = 48;

  /// 进度条高度 = **M3 的 4dp 轨道**。原来是 14（多邻国那种"粗条"），
  /// 换成细轨是这次改版里最明显的一处观感变化，需要粗条的地方显式传 height。
  static const double progressHeight = 4;

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
