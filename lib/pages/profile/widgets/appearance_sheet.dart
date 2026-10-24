// 外观设置（半屏）：明暗模式 + 主题色。
//
// 为什么是半屏而不是整页：只有两组开关，做整页要加路由、加返回键，收益不抵。
// 入口在「我的 → 其他 → 外观」（profile_actions_section.dart）。
//
// **改动即时生效**，没有「保存」按钮：外观是所见即所得的东西，改完还要再点一次保存，
// 反而让人看不到刚点的那下有什么变化。持久化在 setter 里顺手做掉。
//
// 本组件不持有任何状态：读 ThemeStore、调它的 setter（见 state/theme_store.dart）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';

/// 打开半屏。外部只需要这一句，Sheet 本体是私有的。
Future<void> showAppearanceSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _AppearanceSheet(),
    );

class _AppearanceSheet extends StatelessWidget {
  const _AppearanceSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // watch：换色/换模式后本半屏要立刻跟着变（用户就盯着它看效果）
    final appearance = context.watch<ThemeStore>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppMetrics.gapLg.r,
          0,
          AppMetrics.gapLg.r,
          AppMetrics.gapXl.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('外观', style: theme.textTheme.titleLarge),
            SizedBox(height: AppMetrics.gapLg.r),
            const _Label('明暗'),
            SizedBox(height: AppMetrics.gapSm.r),
            // 只写三个词，不带图标：390 宽的屏上「图标 + 四字标签」会挤成两行
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppThemeMode>(
                showSelectedIcon: false,
                segments: [
                  for (final mode in AppThemeMode.values)
                    ButtonSegment(value: mode, label: Text(mode.label)),
                ],
                selected: {appearance.mode},
                onSelectionChanged: (picked) => appearance.setMode(picked.first),
              ),
            ),
            SizedBox(height: AppMetrics.gapXl.r),
            const _Label('主题色'),
            SizedBox(height: AppMetrics.gapMd.r),
            Wrap(
              spacing: AppMetrics.gapMd.r,
              runSpacing: AppMetrics.gapMd.r,
              children: [
                for (final seed in ThemeSeed.values)
                  _SeedDot(
                    seed: seed,
                    selected: seed == appearance.seed,
                    onTap: () => appearance.setSeed(seed),
                  ),
              ],
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            Text(
              '主题色会应用到按钮、选中态、卡片底色与图表；明暗可以跟着系统走，也可以固定。',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.label(context).copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}

/// 一个主题色圆点。选中态用「外圈描边 + 中间对勾」表达——
/// 只描边的话，浅色底上的浅色种子（橙、青）看不出选没选中。
class _SeedDot extends StatelessWidget {
  const _SeedDot({
    required this.seed,
    required this.selected,
    required this.onTap,
  });

  final ThemeSeed seed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // 对勾的颜色：种子色本身的 onPrimary 对比度不一定够，用亮度自己挑黑白
    final check = ThemeData.estimateBrightnessForColor(seed.color) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Semantics(
      label: seed.label,
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: seed.label,
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: seed.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.onSurface : Colors.transparent,
                width: 2.r,
              ),
            ),
            child: selected
                ? Icon(Icons.check_rounded, size: 22.r, color: check)
                : null,
          ),
        ),
      ),
    );
  }
}
