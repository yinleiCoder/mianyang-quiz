// 练习方式：子模式、题量、是否打乱选项。
//
// 三项都是"一次设定、整轮生效"的偏好，所以用紧凑的单卡布局，
// 不铺开成大表单——用户的注意力应该花在选题上，不是调参数。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/limit_slider.dart';

class ComposeOptions extends StatelessWidget {
  const ComposeOptions({
    super.key,
    required this.mode,
    required this.limit,
    required this.shuffle,
    required this.sound,
    required this.onModeChanged,
    required this.onLimitChanged,
    required this.onShuffleChanged,
    required this.onSoundChanged,
  });

  final PracticeMode mode;
  final int limit;
  final bool shuffle;

  /// 答题音效开关（存在本地偏好里，跨会话记住）。
  final bool sound;
  final ValueChanged<PracticeMode> onModeChanged;
  final ValueChanged<int> onLimitChanged;
  final ValueChanged<bool> onShuffleChanged;
  final ValueChanged<bool> onSoundChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DuoCard(
      padding: const EdgeInsets.all(AppMetrics.gapLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final value in PracticeMode.values) ...[
            _ModeOption(
              mode: value,
              selected: value == mode,
              onTap: () => onModeChanged(value),
            ),
            if (value != PracticeMode.values.last)
              const SizedBox(height: AppMetrics.gapSm),
          ],
          Divider(height: AppMetrics.gapXl * 2, color: theme.colorScheme.outlineVariant),
          LimitSlider(limit: limit, onChanged: onLimitChanged),
          const SizedBox(height: AppMetrics.gapMd),
          // ListTile 的水波纹画在最近的 Material 上，而卡片是个带底色的 DecoratedBox，
          // 中间没有 Material 时框架会断言 "ListTile background color or ink splashes
          // may be invisible"（debug 下这里会变成红框）。垫一层透明 Material 即可。
          Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: shuffle,
                  onChanged: onShuffleChanged,
                  title: const Text('打乱选项顺序'),
                  subtitle: Text(
                    '同一道题反复练时，记住「A 是对的」没有意义',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: sound,
                  onChanged: onSoundChanged,
                  title: const Text('答题音效'),
                  subtitle: Text(
                    '答对、答错各有一记提示音（开关记在这台设备上）',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final PracticeMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
      child: Container(
        padding: const EdgeInsets.all(AppMetrics.gapMd),
        decoration: BoxDecoration(
          // 未选中时不填色（沿用卡片底色），不写死颜色
          color: selected ? scheme.primaryContainer : null,
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20.r,
              color: selected ? scheme.primary : scheme.outline,
            ),
            const SizedBox(width: AppMetrics.gapMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    mode.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
