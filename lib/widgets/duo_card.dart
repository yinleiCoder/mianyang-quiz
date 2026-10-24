// 卡片：页面里「一块内容」的容器，按 M3 的 **outlined card** 画。
//
// 职责：统一圆角、底色、1dp 描边与内边距，并可选地让整块可点。
// 不负责：列表的滚动与分页（那是页面的骨架），也不负责卡片内部的排版。
//
// **没有阴影**：M3 的 outlined / filled 卡片都是平的，层级由**表面色阶**表达
// （surfaceContainerLow 比背景深一点 / 暗色下浅一点），不靠投影。旧版那圈
// 0.04 的柔光正是"多邻国味"的一部分——它让每张卡都像贴纸，一屏十几张就发脏。
// 底色再由 AppSurfaces.card 叠一层很薄的 primary：M3 的 surface 系列彩度过低，
// 不叠的话换主题色时卡片几乎看不出变化（用户 2026-10-23 反馈"仍是淡紫色"）。
//
// emphasized 用 primaryContainer：M3 里表达"这一块被选中/被强调"的正是**色调容器**，
// 而不是加粗描边（旧版是 2dp 的主题色边，规范里没有这种画法）。
//
// 例外：题库列表、题目详情、记录页那几处**显式要白卡**，现在传
// `AppSurfaces.contentCard(scheme)`（纯白 + 6% primary 轻染），不再直接传
// `scheme.surface` —— 后者在换主题色时完全不变，正是用户两次反馈的"固定色"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

class DuoCard extends StatelessWidget {
  const DuoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.emphasized = false,
    this.color,
  });

  /// 卡片内容。
  final Widget child;

  /// 整卡可点（如「继续练习」）；为 null 时是纯展示卡。
  final VoidCallback? onTap;

  /// 内边距，默认 gapLg。
  final EdgeInsetsGeometry? padding;

  /// 强调卡：换 primaryContainer 底色，一屏最多一张。
  final bool emphasized;

  /// 覆盖底色。为 null 时走 AppSurfaces.card（surfaceContainerLow + 主题色轻染）。
  ///
  /// **只接受主题色**（调用点传 `Theme.of(context).colorScheme.surface`），
  /// 不要在调用点写死 Colors.white —— 暗色模式下会变成白底黑字的瞎眼卡片。
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppMetrics.radiusCard.r);
    final content = Padding(
      padding: padding ?? EdgeInsets.all(AppMetrics.gapLg.r),
      child: child,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ??
            (emphasized ? scheme.primaryContainer : AppSurfaces.card(scheme)),
        borderRadius: radius,
        // 强调卡是色调容器，不再描边（色调本身就是分界）
        border: emphasized
            ? null
            : Border.all(
                color: scheme.outlineVariant,
                width: AppMetrics.hairline.r,
              ),
      ),
      // 可点时才引入 Material/InkWell：状态层提供反馈，也顺带补上无障碍语义。
      child: onTap == null
          ? content
          : ClipRRect(
              borderRadius: radius,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap, child: content),
              ),
            ),
    );
  }
}
