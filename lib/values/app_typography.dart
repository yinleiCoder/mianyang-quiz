// 字体口径：中文字体回退栈（以及后续的 M3 字阶）。
//
// 从 app_theme.dart 拆出来是因为那个文件撞着 200 行上限（tool/check_architecture.dart），
// 而主题工厂还要往下长（主题色、字阶）。这里放"与 ThemeData 无关、但到处都要用"的字体约定。

import 'package:material_ui/material_ui.dart';

abstract final class AppTypography {
  /// 中文字体回退栈（按平台常见字体依次尝试，找不到就跳到下一个）。
  ///
  /// **刻意不设 `fontFamily`**：拉丁字形交给平台默认（Windows 是 Segoe UI、
  /// Android 是 Roboto），中文由这里的栈兜底。若把 `fontFamily` 写死成某个
  /// Windows 字体，Android 上会整体退化——比现在更乱。
  static const List<String> cjkFallback = [
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
  /// （AppTheme.regular / AppTheme.bold 是同一对常量，保留旧入口不迁调用方。）
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight bold = FontWeight.w700;
}
