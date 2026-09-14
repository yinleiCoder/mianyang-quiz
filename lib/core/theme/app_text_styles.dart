// 文字样式：全站字号的唯一出处。
//
// 职责：把主题的 textTheme 派生为「页面标题 / 区块标题 / 正文 / 说明 / 数字 / 标签」
// 这几个**角色**，页面按角色取样式，不再各自挑档位。
// 不负责：颜色——返回值一律不带 color，正文继承主题默认前景色，弱化文字由调用点
// 用 colorScheme.onSurfaceVariant 表达（这样亮暗色跟着一起变）。
// 也不负责局部微调：个别地方要改字重/字距，请在自己的调用点 copyWith。
//
// 为什么不直接用 textTheme：headlineSmall / titleMedium 表达的是「尺寸档位」而不是
// 「这是页面标题还是卡片标题」，页面代码里一旦混用，字号就会各自漂移。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppTextStyles {
  /// 页面主标题：一屏一个，如「今日练习」「错题本」。
  static TextStyle pageTitle(BuildContext context) =>
      _theme(context).headlineSmall!
          .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700, height: 1.25);

  /// 区块标题：卡片标题、分组小标题。
  static TextStyle sectionTitle(BuildContext context) =>
      _theme(context).titleMedium!
          .copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700, height: 1.3);

  /// 正文：题干、说明段落。行高给得宽，中文长句才不挤。
  static TextStyle body(BuildContext context) =>
      _theme(context).bodyMedium!.copyWith(fontSize: 15.sp, height: 1.6);

  /// 说明文字：时间戳、辅助信息（配色请搭 onSurfaceVariant）。
  static TextStyle caption(BuildContext context) =>
      _theme(context).bodySmall!.copyWith(fontSize: 12.sp, height: 1.4);

  /// 数字：统计卡里的大数字。字重压过正文，视线先落在数字上。
  static TextStyle number(BuildContext context) =>
      _theme(context).headlineMedium!
          .copyWith(fontSize: 28.sp, fontWeight: FontWeight.w700, height: 1.15);

  /// 按钮与标签用的小号粗体文字。
  static TextStyle label(BuildContext context) => _theme(context).titleSmall!
      .copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      );

  static TextTheme _theme(BuildContext context) => Theme.of(context).textTheme;
}

