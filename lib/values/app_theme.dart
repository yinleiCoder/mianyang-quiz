// 主题工厂：亮色 / 暗色两套 ThemeData。
//
// 职责：把配色、圆角、触控尺寸这些全局约定一次性装进 ThemeData，
// 页面里裸用 ElevatedButton / TextField / Card 时默认就是对的。
// 不负责：具体组件的形态——立体按钮、统计卡、粗进度条在 widgets/design 里自己画，
// 它们只从 colorScheme 取色，不依赖这里的按钮主题。
//
// 配色由**种子色**派生（见 theme_seed.dart，用户在设置里可换）。
// 要「绿」「红」请走 semantic_colors.dart，不要用 tertiary 顶替（它是色相旋转出来的粉色），
// 也不要自己写死颜色——否则暗色会失配。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/app_field_theme.dart';
import 'package:mianyang_quiz/values/app_metrics.dart';
import 'package:mianyang_quiz/values/app_navigation_bar_theme.dart';
import 'package:mianyang_quiz/values/app_surfaces.dart';
import 'package:mianyang_quiz/values/app_typography.dart';
import 'package:mianyang_quiz/values/semantic_colors.dart';
import 'package:mianyang_quiz/values/theme_meta.dart';

abstract final class AppTheme {
  /// 字体回退栈与字重都在 app_typography.dart（那个文件还留着放 M3 字阶）。
  /// 这两个别名保留旧入口——全仓几十处写着 AppTheme.bold。
  static const FontWeight regular = AppTypography.regular;
  static const FontWeight bold = AppTypography.bold;

  /// 亮色主题。[seed] 是主题色，默认靛蓝（2026-10-21 起）。
  static ThemeData light({ThemeSeed seed = ThemeSeed.indigo}) =>
      _build(Brightness.light, seed);

  /// 暗色主题。
  static ThemeData dark({ThemeSeed seed = ThemeSeed.indigo}) =>
      _build(Brightness.dark, seed);

  static ThemeData _build(Brightness brightness, ThemeSeed seed) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed.color,
      brightness: brightness,
    ).copyWith(
      // 亮色下把 surface 定成**纯白**（学生反馈"背景应该是白的"）：fromSeed 从
      // deepPurple 派生的 surface 是带紫的近白色，整屏铺开就是"发灰发紫"。
      // 只动亮色——暗色的 surface 本来就是深灰，换成白色会把暗色模式掀翻；
      // 卡片仍走 surfaceContainerLow，白底上照样分得出层次。
      surface: brightness == Brightness.light ? Colors.white : null,
    );
    // 按钮圆角：M3 的形状比例尺里给 common buttons 的默认档是 **full（胶囊）**，
    // 但**比例尺本身就是让你挑的**（4 / 8 / 12 / 16 / 28 / full），选哪一档是主题级决定。
    // 用户 2026-10-12 看过实机后明确嫌"全圆角太空太软"，于是收回到 **medium（12）**：
    // 与卡片同一档，整屏才是同一种圆角语言。（Material 3 Expressive 自己也在往收的方向调。）
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamilyFallback: AppTypography.cjkFallback,
      // 语义色：M3 的 ColorScheme 没有「成功」「警告」，见 semantic_colors.dart
      extensions: [
        brightness == Brightness.dark ? SemanticColors.dark : SemanticColors.light,
      ],
      // 触控优先：桌面端默认的 compact + shrinkWrap 会把可点区域压到 48 以下，
      // 而平板与触屏一体机是主要设备，统一拉回触控基线。
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarThemeData(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppSurfaces.card(scheme),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          foreground: scheme.onPrimary,
          background: scheme.primary,
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          foreground: scheme.onPrimary,
          background: scheme.primary,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            // 底色不设：M3 的描边按钮是**透明**容器。写死 surface 的话，
            // 它在卡片（surfaceContainerLow）上也铺一层 surface，看着像贴了块补丁。
            _buttonStyle(
              scheme: scheme,
              foreground: scheme.primary,
              shape: buttonShape,
            ).copyWith(
              // M3：描边按钮的边是 **1dp 的 outline**（不是 2dp 的 outlineVariant）
              side: WidgetStatePropertyAll(
                BorderSide(
                  color: scheme.outline,
                  width: AppMetrics.hairline.r,
                ),
              ),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          foreground: scheme.primary,
          shape: buttonShape,
        ),
      ),
      // 输入框与标签的外形在 app_field_theme.dart（理由比配置长，拆开了）
      inputDecorationTheme: AppFieldTheme.inputDecoration(scheme),
      chipTheme: AppFieldTheme.chip(scheme),
      // 底部导航的定制在 app_navigation_bar_theme.dart（理由比配置长，拆开了）
      navigationBarTheme: AppNavigationBarTheme.build(scheme),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: AppMetrics.progressHeight.r,
        borderRadius: BorderRadius.circular(AppMetrics.progressHeight.r / 2),
        strokeWidth: 3.r,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppMetrics.hairline.r,
        space: AppMetrics.hairline.r,
      ),
    );
    // 字阶里 M3 的 w500 档要收敛掉，见 _cjkWeights。
    // 用 copyWith 而不是在构造函数里传 textTheme：这样拿到的是**平台默认那一套**
    //（字体回退栈已经在 base 里应用过），只在字重上做减法。
    return base.copyWith(textTheme: _cjkWeights(base.textTheme));
  }

  /// 把字阶里 M3 的 w500 档收敛到本仓允许的 w400/w700。
  ///
  /// **为什么必须在主题这一层做**：AGENTS.md 二·五禁止 w500（中文字体没有这一档，
  /// 引擎会合成伪粗体，且合成结果在不同字号上不一致）。`tool/check_architecture.dart`
  /// 只能盯**代码里写死的字面量**，盯不到从主题继承来的字重——而全仓 137 处
  /// `theme.textTheme.xxx` 里，titleMedium/titleSmall/label* 这五档全都是 M3 的 w500。
  ///
  /// 收敛方向一律 **w700**：M3 用 500 表达"标题 / 标签"的中等强调，只剩两档时该走强的一侧
  ///（正文系列本来就是 400，不动）。
  static TextTheme _cjkWeights(TextTheme t) => t.copyWith(
    titleMedium: t.titleMedium?.copyWith(fontWeight: bold),
    titleSmall: t.titleSmall?.copyWith(fontWeight: bold),
    labelLarge: t.labelLarge?.copyWith(fontWeight: bold),
    labelMedium: t.labelMedium?.copyWith(fontWeight: bold),
    labelSmall: t.labelSmall?.copyWith(fontWeight: bold),
  );

  /// Material 系按钮的统一外形：高度不低于触控目标、胶囊形、无阴影、加粗文字。
  /// 立体按压只有 DuoButton 有，这里**不**模仿——Material 的按钮不该被改造成另一种物理隐喻。
  ///
  /// **禁用态必须单独给**（M3 规范：底 = onSurface 12%、字 = onSurface 38%）：
  /// 用 `WidgetStatePropertyAll` 一把梭的话，禁用时字还是主题色，灰底上顶着一行
  /// 高饱和的紫字，看起来像"能点但坏了"。背景返回 null 即交回组件自己的默认禁用色。
  static ButtonStyle _buttonStyle({
    required ColorScheme scheme,
    required Color foreground,
    Color? background,
    required OutlinedBorder shape,
  }) => ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? null : background,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? scheme.onSurface.withValues(alpha: 0.38)
          : foreground,
    ),
    elevation: const WidgetStatePropertyAll(0),
    minimumSize: WidgetStatePropertyAll(Size(64, AppMetrics.touchTarget.r)),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppMetrics.gapXl.r),
    ),
    textStyle: WidgetStatePropertyAll(
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
    ),
    shape: WidgetStatePropertyAll(shape),
  );
}
