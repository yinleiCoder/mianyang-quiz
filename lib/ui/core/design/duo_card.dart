// 大圆角卡片：页面里「一块内容」的容器。
//
// 职责：统一圆角、底色、极淡描边与内边距，并可选地让整块可点。
// 不负责：列表的滚动与分页（那是页面的骨架），也不负责卡片内部的排版。
//
// 底色用 surfaceContainerLow 而不是纯 surface：亮色下它比背景略深、暗色下略浅，
// 两种模式都让「卡片浮在背景上」成立，因此不需要堆阴影。
//
// 例外：题库列表、题目详情、记录页那几处**显式要白卡**（传 color: scheme.surface），
// 见各调用点的注释——那几页学生看的是"内容"，白卡让文字最清楚，代价是只剩描边分界。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

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

  /// 强调卡：换 primaryContainer 底色与更重的描边，一屏最多一张。
  final bool emphasized;

  /// 覆盖底色。为 null 时走默认的 surfaceContainerLow。
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
            (emphasized ? scheme.primaryContainer : scheme.surfaceContainerLow),
        borderRadius: radius,
        border: Border.all(
          color: emphasized ? scheme.primary : scheme.outlineVariant,
          width: emphasized ? AppMetrics.stroke.r : AppMetrics.hairline.r,
        ),
        boxShadow: [
          BoxShadow(
            // 只做一点点浮起暗示；阴影色也取自主题，暗色下自然变淡。
            color: scheme.shadow.withValues(alpha: emphasized ? 0.08 : 0.04),
            offset: Offset(0, 2.r),
            blurRadius: 8.r,
          ),
        ],
      ),
      // 可点时才引入 Material/InkWell：水波纹提供反馈，也顺带补上无障碍语义。
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
