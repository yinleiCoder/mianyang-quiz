// 文字样式：全站字号的唯一出处。
//
// 职责：把 M3 的字阶（display / headline / title / body / label）派生为**角色**——
// 「页面标题 / 区块标题 / 正文 / 说明 / 数字 / 标签」，页面按角色取，不再各自挑档位。
// 不负责：颜色——返回值一律不带 color，正文继承主题默认前景色，弱化文字由调用点
// 用 colorScheme.onSurfaceVariant 表达（这样亮暗色跟着一起变）。
// 也不负责局部微调：个别地方要改字重/字距，请在自己的调用点 copyWith。
//
// **每一档都对着 M3 的字阶取值**（m3.material.io/styles/typography/type-scale-tokens），
// 与规范的差异只有一处、且是必须的：**字重**。M3 的字阶里 title/label 系列是 w500，
// 而中文字体只有 400/700 两档，w500 会走引擎合成的伪粗体（AGENTS.md 二·五）。
// 所以这些档位一律落 **w700**（M3 用 500 表达"中等强调"，只剩两档时就该走强的那一侧）；
// 正文系列 M3 本来就是 400，原样。
//
// 为什么不直接用 textTheme：headlineSmall / titleMedium 表达的是「尺寸档位」而不是
// 「这是页面标题还是卡片标题」，页面代码里一旦混用，字号就会各自漂移。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppTextStyles {
  /// 页面主标题：一屏一个，如「今日练习」「错题本」。
  ///
  /// M3 的 headlineSmall（24 / 行高 32）。M3 这一档是 w400——**页面标题不改**：
  /// 中文没有字形上的粗细对比（西文的 cap-height 抬升、衬线在中文里都没有），
  /// 24 的汉字在 w400 下会糊成一团，这是中文排版惯例，不是偷懒。
  static TextStyle pageTitle(BuildContext context) => _theme(context)
      .headlineSmall!
      .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, height: 32 / 24);

  /// 区块标题：卡片标题、分组小标题。M3 的 titleMedium（16 / 24）。
  static TextStyle sectionTitle(BuildContext context) => _theme(context)
      .titleMedium!
      .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, height: 24 / 16);

  /// 正文：题干、说明段落。M3 的 bodyLarge（16 / 24）——行高宽，中文长句才不挤。
  static TextStyle body(BuildContext context) =>
      _theme(context).bodyLarge!.copyWith(fontSize: 16.sp, height: 24 / 16);

  /// 说明文字：时间戳、辅助信息。M3 的 bodySmall（12 / 16）。
  /// 配色请搭 onSurfaceVariant。
  static TextStyle caption(BuildContext context) =>
      _theme(context).bodySmall!.copyWith(fontSize: 12.sp, height: 16 / 12);

  /// 数字：统计卡里的大数字。M3 的 headlineMedium（28 / 36），字重压过正文，
  /// 视线先落在数字上。
  static TextStyle number(BuildContext context) => _theme(context)
      .headlineMedium!
      .copyWith(fontSize: 28.sp, fontWeight: FontWeight.w700, height: 36 / 28);

  /// 按钮与标签用的小号粗体文字。M3 的 labelLarge（14 / 20 / w500 → 见文件头的 w700）。
  static TextStyle label(BuildContext context) => _theme(context)
      .labelLarge!
      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700, height: 20 / 14);

  static TextTheme _theme(BuildContext context) => Theme.of(context).textTheme;
}
