// 宽屏下的侧边导航栏。
//
// 与底部导航是同一份目标列表（nav_destinations.dart），只是形态不同：
// 宽屏上把主导航竖起来放左侧更符合桌面习惯，也把纵向空间全留给内容。
//
// 形态学多邻国 Web 端：左上是品牌区，下面是条目列表；选中项用浅色圆角块突出，
// 且图标换成实心版本——不只靠颜色区分选中态（色盲用户也看得出）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/brand_mark.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/nav_destinations.dart';

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
            for (var i = 0; i < kNavDestinations.length; i++)
              _NavItem(
                destination: kNavDestinations[i],
                selected: i == currentIndex,
                onTap: () => onSelect(i),
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
              '绵阳市中职共建题库',
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.gapMd,
        vertical: 2,
      ),
      child: Semantics(
        button: true,
        selected: selected,
        label: destination.label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.gapMd,
              vertical: AppMetrics.gapMd,
            ),
            decoration: BoxDecoration(
              color: selected ? scheme.primaryContainer : null,
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? destination.activeIcon : destination.icon,
                  size: 22.r,
                  color: color,
                ),
                const SizedBox(width: AppMetrics.gapMd),
                Expanded(
                  child: Text(
                    destination.label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
