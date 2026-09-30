// 宽屏下的侧边导航栏。
//
// 与底部导航是同一份目标列表（nav_destinations.dart），只是形态不同：
// 宽屏上把主导航竖起来放左侧更符合桌面习惯，也把纵向空间全留给内容。
//
// 形态学多邻国 Web 端：左上是品牌区，下面是条目列表；选中项用浅色圆角块突出，
// 且图标换成实心版本——不只靠颜色区分选中态（色盲用户也看得出）。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_destinations.dart';
import 'package:mianyang_quiz/pages/shell/widgets/nav_shortcut.dart';
import 'package:mianyang_quiz/pages/shell/widgets/side_nav_item.dart';

class AppSideNav extends StatelessWidget {
  const AppSideNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  /// 侧栏宽度。定死而不是按比例：导航栏的宽度应当稳定，
  /// 跟着窗口变宽会让条目文字每次拖拽窗口都重排。
  static const double width = 232;

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Brand(theme: theme),
            const SizedBox(height: AppMetrics.gapSm),
            // 条目区**必须可滚动**：侧栏是"宽但可以很矮"的那一档，
            // 窗口被拖矮时固定高度的 Column 会直接 RenderFlex 溢出，
            // 整块导航跟着错位。条目从 5 个涨到 7 个之后这条更要紧。
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (var i = 0; i < kNavDestinations.length; i++)
                    SideNavItem(
                      label: kNavDestinations[i].label,
                      icon: kNavDestinations[i].icon,
                      activeIcon: kNavDestinations[i].activeIcon,
                      selected: i == currentIndex,
                      onTap: () => onSelect(i),
                    ),
                  if (kNavShortcuts.isNotEmpty) ...[
                    const SizedBox(height: AppMetrics.gapMd),
                    Divider(
                      height: 1,
                      indent: AppMetrics.gapLg,
                      endIndent: AppMetrics.gapLg,
                      color: scheme.outlineVariant,
                    ),
                    const SizedBox(height: AppMetrics.gapMd),
                    // 快捷入口：push 一个整页，不是切分支——
                    // 所以它们**永远不是选中态**（当前页不在这五项里）。
                    for (final shortcut in kNavShortcuts)
                      SideNavItem(
                        label: shortcut.label,
                        icon: shortcut.icon,
                        activeIcon: shortcut.icon,
                        selected: false,
                        onTap: () => context.push(shortcut.path),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppMetrics.gapLg,
        AppMetrics.gapLg,
        AppMetrics.gapLg,
        0,
      ),
      child: Row(
        children: [
          // 品牌标识直接用矢量图（与网页端侧栏同一张），不再用 Material 图标示意
          const BrandMark(size: 36),
          const SizedBox(width: AppMetrics.gapMd),
          Expanded(
            child: Text(
              '职教高考联盟',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
