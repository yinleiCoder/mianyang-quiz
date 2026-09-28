// 品牌标识（assets/mianyang.svg）：登录页与侧栏共用一份，别各自抄一遍。
//
// 为什么用 SVG 而不是位图：这张图就是网页端侧栏用的那张（public/mianyang.svg），
// 一个源两端一致；而它在 36~56px 之间变化，矢量不必按尺寸各出一档。
//
// 注意：**应用图标**走的是另一条路（windows/runner/resources/app_icon.ico 与 android 的
// mipmap），那条链路只能吃位图，见 AGENTS.md 第七节「应用图标」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 36});

  /// 边长（正方形）。设计稿里侧栏 36、登录页 56。
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size.r,
    height: size.r,
    child: SvgPicture.asset('assets/mianyang.svg', fit: BoxFit.contain),
  );
}
