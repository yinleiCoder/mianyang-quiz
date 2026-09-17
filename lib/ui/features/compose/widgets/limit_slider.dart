// 题量选择：滑杆，1~100 题（上下限取自服务端约束，见 0043）。
//
// 为什么是滑杆而不是 ±5 的步进器：题量跨度 1~100，步进器要点二十下才到头，
// 拖动一次就能落在想要的数字上。一题一档，拖动时 Material 会在滑块上方显示当前数值。
//
// 抽成独立文件是为了单文件行数（AGENTS.md 第三条），与 source_selector 同一形态：
// 只认"当前值 + 回调"，不碰 store。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';

class LimitSlider extends StatelessWidget {
  const LimitSlider({super.key, required this.limit, required this.onChanged});

  final int limit;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const min = PracticeDraftStore.minLimit;
    const max = PracticeDraftStore.maxLimit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('题量', style: theme.textTheme.titleSmall),
            const Spacer(),
            Text(
              '$limit 题',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            // 一题一档 = 99 个刻痕，画出来轨道像条虚线；隐去刻痕，只留滑块与数值气泡
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: Slider(
            // 越界值先夹住：Slider 对 value 超出 min/max 是直接断言失败的
            value: limit.toDouble().clamp(min.toDouble(), max.toDouble()),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            label: '$limit 题',
            onChanged: (value) => onChanged(value.round()),
          ),
        ),
      ],
    );
  }
}
