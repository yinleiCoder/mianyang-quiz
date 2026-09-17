// 主题工厂：亮色 / 暗色两套 ThemeData。
//
// 职责：把配色、圆角、触控尺寸这些全局约定一次性装进 ThemeData，
// 页面里裸用 ElevatedButton / TextField / Card 时默认就是对的。
// 不负责：具体组件的形态——立体按钮、统计卡、粗进度条在 ui/core/design 里自己画，
// 它们只从 colorScheme 取色，不依赖这里的按钮主题。
//
// 配色是 M3 从 deepPurple 派生的方案。要「绿」「红」请走 semantic_colors.dart，
// 不要用 tertiary 顶替（它是色相旋转出来的粉色），也不要自己写死颜色——否则暗色会失配。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_navigation_bar_theme.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

abstract final class AppTheme {
  /// 品牌种子色：全站颜色都由它派生，换这里等于换肤。
  static const Color _seed = Colors.deepPurple;

  /// 中文字体回退栈（按平台常见字体依次尝试，找不到就跳到下一个）。
  ///
  /// **刻意不设 `fontFamily`**：拉丁字形交给平台默认（Windows 是 Segoe UI、
  /// Android 是 Roboto），中文由这里的栈兜底。若把 `fontFamily` 写死成某个
  /// Windows 字体，Android 上会整体退化——比现在更乱。
  static const List<String> _cjkFallback = [
    'Microsoft YaHei UI', // Windows 中文界面字体
    'Microsoft YaHei',
    'Noto Sans CJK SC', // Android / Linux 的系统中文字体
    'Noto Sans SC',
    'Source Han Sans SC',
    'PingFang SC', // macOS / iOS
  ];

  /// 允许使用的字重。**只有这两档。**
  ///
  /// 中文字体（雅黑、Noto Sans CJK、苹方等）普遍只提供 Regular(400) 与 Bold(700)；
  /// 写 w500/w600/w800 会让引擎**合成伪粗体**，而合成结果在不同字号、不同字形上
  /// 并不一致——表现就是"有些标题很粗、有些该粗的却发虚"。
  ///
  /// 这条约束由 tool/check_architecture.dart 强制，不要绕过。
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;

  /// 亮色主题（默认）。
  static ThemeData light() => _build(Brightness.light);

  /// 暗色主题。
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    ).copyWith(
      // 亮色下把 surface 定成**纯白**（学生反馈"背景应该是白的"）：fromSeed 从
      // deepPurple 派生的 surface 是带紫的近白色，整屏铺开就是"发灰发紫"。
      // 只动亮色——暗色的 surface 本来就是深灰，换成白色会把暗色模式掀翻；
      // 卡片仍走 surfaceContainerLow，白底上照样分得出层次。
      surface: brightness == Brightness.light ? Colors.white : null,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamilyFallback: _cjkFallback,
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
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          foreground: scheme.onPrimary,
          background: scheme.primary,
          shape: buttonShape,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          foreground: scheme.onPrimary,
          background: scheme.primary,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            _buttonStyle(
              foreground: scheme.primary,
              background: scheme.surface,
              shape: buttonShape,
            ).copyWith(
              side: WidgetStatePropertyAll(
                BorderSide(
                  color: scheme.outlineVariant,
                  width: AppMetrics.stroke.r,
                ),
              ),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(foreground: scheme.primary, shape: buttonShape),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppMetrics.gapLg.r,
          vertical: AppMetrics.gapMd.r,
        ),
        border: _inputBorder(scheme.outlineVariant, AppMetrics.hairline),
        enabledBorder: _inputBorder(scheme.outlineVariant, AppMetrics.hairline),
        focusedBorder: _inputBorder(scheme.primary, AppMetrics.stroke),
        errorBorder: _inputBorder(scheme.error, AppMetrics.hairline),
        focusedErrorBorder: _inputBorder(scheme.error, AppMetrics.stroke),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15.sp),
      ),
      chipTheme: ChipThemeData(
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
      ),
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
  }

  /// Material 系按钮的统一外形：高度不低于触控目标、16 圆角、无阴影、加粗文字。
  /// 立体按压只有 DuoButton 有，这里**不**模仿——Material 的按钮不该被改造成另一种物理隐喻。
  static ButtonStyle _buttonStyle({
    required Color foreground,
    Color? background,
    required OutlinedBorder shape,
  }) => ButtonStyle(
    backgroundColor: background == null ? null : WidgetStatePropertyAll(background),
    foregroundColor: WidgetStatePropertyAll(foreground),
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

  static OutlineInputBorder _inputBorder(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
        borderSide: BorderSide(color: color, width: width.r),
      );
}
