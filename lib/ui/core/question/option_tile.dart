// 单个选项。刷题、背题、题目详情、复盘四处共用。
//
// 四种视觉态：
//   idle     未选中
//   selected 已选中，尚未判定
//   correct  判定为对（或标准答案，在背题/复盘时揭示）
//   wrong    判定为错
//
// 交互形态学多邻国：圆角粗边、下沿有一条"厚度"，按下时下沉且厚度消失。
//
// **显示字母由调用方给出**——乱序之后用户看到的 A 可能对应原始 C。
// 本组件只负责画，不认识原始 key，也不参与作答构造。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/ui/core/question/block_list_view.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

enum OptionState { idle, selected, correct, wrong }

class OptionTile extends StatefulWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.label,
    required this.state,
    this.multiple = false,
    this.onTap,
    this.enabled = true,
  });

  /// 显示字母（A/B/C…）。由调用方按显示顺序给出，不是原始 key。
  final String letter;

  final List<Block> label;
  final OptionState state;

  /// 多选用方框、单选用圆点——形状本身就在提示可多选。
  final bool multiple;

  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    final (border, background) = switch (widget.state) {
      OptionState.idle => (scheme.outlineVariant, scheme.surface),
      OptionState.selected => (scheme.primary, scheme.primaryContainer),
      OptionState.correct => (semantic.success, semantic.successContainer),
      OptionState.wrong => (scheme.error, scheme.errorContainer),
    };
    final interactive = widget.enabled && widget.onTap != null;
    final depth = interactive && !_pressed ? AppMetrics.buttonDepth.r : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.gapMd + AppMetrics.buttonDepth),
      child: GestureDetector(
        onTapDown: interactive ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: interactive ? () => setState(() => _pressed = false) : null,
        onTapUp: interactive
            ? (_) {
                setState(() => _pressed = false);
                widget.onTap!();
              }
            : null,
        child: Transform.translate(
          offset: Offset(0, _pressed ? AppMetrics.buttonDepth.r : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.gapLg,
              vertical: AppMetrics.gapMd,
            ),
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: border, width: AppMetrics.stroke.r),
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
              boxShadow: depth > 0
                  ? [BoxShadow(color: border, offset: Offset(0, depth), blurRadius: 0)]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Marker(
                  letter: widget.letter,
                  multiple: widget.multiple,
                  state: widget.state,
                ),
                const SizedBox(width: AppMetrics.gapMd),
                Expanded(
                  child: BlockListView(
                    blocks: widget.label,
                    compact: true,
                    textStyle: theme.textTheme.bodyLarge,
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

/// 选项左侧的圆形/方形标记，内含显示字母。
class _Marker extends StatelessWidget {
  const _Marker({required this.letter, required this.multiple, required this.state});

  final String letter;
  final bool multiple;
  final OptionState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final filled = state == OptionState.selected ||
        state == OptionState.correct ||
        state == OptionState.wrong;
    final color = switch (state) {
      OptionState.idle => scheme.outline,
      OptionState.selected => scheme.primary,
      OptionState.correct => semantic.success,
      OptionState.wrong => scheme.error,
    };

    return Container(
      width: 26.r,
      height: 26.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? color : null,
        border: Border.all(color: color, width: AppMetrics.stroke.r),
        borderRadius: BorderRadius.circular(multiple ? 6.r : 999),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: filled ? scheme.onPrimary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
