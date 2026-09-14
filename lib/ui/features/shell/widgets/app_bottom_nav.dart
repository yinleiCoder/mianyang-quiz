// 底部导航条。
//
// 只画，不管路由——切换由 AppShell 通过 StatefulNavigationShell 完成。
// 这样本组件可以脱离路由单独预览与测试。
//
// 形态学多邻国：选中项图标加粗、未选中项弱化；整体是圆角浮起的一条，
// 而不是贴着屏幕底边的通栏。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/nav_destinations.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppMetrics.gapLg,
          0,
          AppMetrics.gapLg,
          AppMetrics.gapMd,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
            border: Border.all(color: scheme.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapSm),
          child: Row(
            children: [
              for (var i = 0; i < kNavDestinations.length; i++)
                Expanded(
                  child: _NavButton(
                    destination: kNavDestinations[i],
                    selected: i == currentIndex,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppMetrics.gapXs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? destination.activeIcon : destination.icon,
                size: (selected ? 26.0 : 24.0).r,
                color: color,
              ),
              SizedBox(height: 2.r),
              Text(
                destination.label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
