// 单个选项。刷题、背题、题目详情、复盘四处共用。
//
// 四种视觉态（按 M3 的**色调容器**表达，不是换描边粗细）：
//   idle     surface + 1dp outlineVariant
//   selected secondaryContainer（M3 里"被选中"用的就是这一对角色）
//   correct  successContainer（语义色，见 semantic_colors.dart）
//   wrong    errorContainer
//
// 按下反馈交给 InkWell 的状态层（涟漪），不再画"厚度 + 下沉"——那是多邻国的物理隐喻，
// M3 用状态层表达按压。整个组件因此也不需要 State 了。
//
// **显示字母由调用方给出**——乱序之后用户看到的 A 可能对应原始 C。
// 本组件只负责画，不认识原始 key，也不参与作答构造。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/block_list_view.dart';

enum OptionState { idle, selected, correct, wrong }

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.label,
    required this.state,
    this.onTap,
    this.enabled = true,
  });

  /// 显示字母（A/B/C…）。由调用方按显示顺序给出，不是原始 key。
  final String letter;

  final List<Block> label;
  final OptionState state;

  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    // (底色, 描边, 正文色)：正文用**同族的 on 色**——M3 的容器色都规定了配套前景，
    // 拿 onSurface 压在 errorContainer 上在暗色下会糊成一片。
    final (background, border, foreground) = switch (state) {
      OptionState.idle => (scheme.surface, scheme.outlineVariant, scheme.onSurface),
      OptionState.selected => (
        scheme.secondaryContainer,
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      OptionState.correct => (
        semantic.successContainer,
        semantic.success,
        semantic.onSuccessContainer,
      ),
      OptionState.wrong => (
        scheme.errorContainer,
        scheme.error,
        scheme.onErrorContainer,
      ),
    };
    final interactive = enabled && onTap != null;
    final radius = BorderRadius.circular(AppMetrics.radiusCard.r);

    return Padding(
      padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
      child: Material(
        color: background,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          // M3 的容器描边一律 1dp；旧版那种 2dp 粗边是多邻国那套的表达
          side: BorderSide(color: border, width: AppMetrics.hairline.r),
        ),
        child: InkWell(
          onTap: interactive ? onTap : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppMetrics.gapLg.r,
              vertical: AppMetrics.gapMd.r,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Marker(letter: letter, state: state),
                SizedBox(width: AppMetrics.gapMd.r),
                Expanded(
                  child: BlockListView(
                    blocks: label,
                    compact: true,
                    textStyle: theme.textTheme.bodyLarge?.copyWith(color: foreground),
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

/// 选项左侧的标记，内含显示字母。
///
/// 形状**不区分单选多选**，一律是 M3 的 extra small 圆角方（4）——
/// 用户 2026-10-12 明确要求两者一致（原本单选画圆、多选画方）。
class _Marker extends StatelessWidget {
  const _Marker({required this.letter, required this.state});

  final String letter;
  final OptionState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semantic;
    final filled = state != OptionState.idle;
    // 未选中用 onSurfaceVariant（M3 的 Radio/Checkbox 未选中圈用的就是它，不是 outline）
    final color = switch (state) {
      OptionState.idle => scheme.onSurfaceVariant,
      OptionState.selected => scheme.primary,
      OptionState.correct => semantic.success,
      OptionState.wrong => scheme.error,
    };
    // 填充后的字母要压在**同族**的 on 色上：选中是 primary → onPrimary，
    // 对错则是各自的容器前景色。
    final letterColor = switch (state) {
      OptionState.idle => scheme.onSurfaceVariant,
      OptionState.selected => scheme.onPrimary,
      OptionState.correct => semantic.onSuccessContainer,
      OptionState.wrong => scheme.onErrorContainer,
    };

    return Container(
      width: 26.r,
      height: 26.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? color : null,
        border: Border.all(color: color, width: AppMetrics.stroke.r),
        borderRadius: BorderRadius.circular(AppMetrics.radiusExtraSmall.r),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: letterColor,
        ),
      ),
    );
  }
}
