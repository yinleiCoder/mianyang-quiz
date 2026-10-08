// 侧栏的一行：图标 + 文字，选中时换成实心图标并铺一层浅色圆角块。
//
// 从 app_side_nav.dart 拆出来，有两个原因，都不是"为了好看"：
//   · 单文件行数上限是硬约束（tool/check_architecture.dart），
//     侧栏加了快捷入口之后那个文件已经贴到上限；
//   · **分支目标与快捷入口共用同一套排版**。分支会被高亮，快捷入口不会
//     （点它是 push 一个整页，当前页不在这五项里，没有"选中"可言）。
//     把两者收在一个组件里，视觉上就不可能漂移。
//
// 参数故意只收**展示用的字段**而不是一个 NavDestination：
// 硬塞一个 destination 会在类型上假装快捷入口也有选中态。
//
// 悬停高亮**只在鼠标真的进来时**出现（MouseRegion 的 onEnter/onExit）：侧栏是宽屏
// 桌面端的形态，触屏与键盘用户不会经过那条路径，所以它只是"锦上添花"，
// 不能是唯一的选中提示——选中态另有实心图标 + 浅色底 + 加粗三层表达。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

class SideNavItem extends StatefulWidget {
  const SideNavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;

  /// 未选中时的图标（细描边）。
  final IconData icon;

  /// 选中时的图标（实心）。与 [icon] 成对给——
  /// 只靠颜色区分选中态的话，色盲用户看不出来。
  final IconData activeIcon;

  final bool selected;
  final VoidCallback onTap;

  @override
  State<SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<SideNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = widget.selected
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;
    // 悬停底比选中底淡一档：让人看出"这里可以点"，又不至于误以为已经选中
    final background = widget.selected
        ? scheme.primaryContainer
        : (_hovered ? scheme.surfaceContainerHighest : null);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.gapMd,
        vertical: 2,
      ),
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.label,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppMotion.standard,
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.gapMd,
                vertical: AppMetrics.gapMd,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.selected ? widget.activeIcon : widget.icon,
                    size: 22.r,
                    color: color,
                  ),
                  const SizedBox(width: AppMetrics.gapMd),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: color,
                        fontWeight: widget.selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
