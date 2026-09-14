// 立体按钮：多邻国那种「有厚度、按下会下沉」的按钮。
//
// 职责：五种语气共用一个物理隐喻——外层是一条更深的「厚度」，按下时整个面在
// 厚度里从上滑到底，于是有了按下去的手感。
// 不负责：导航与业务（onPressed 由页面给）；纯图标按钮请用 IconButton。
//
// 几何：外层高 = 面高 + 厚度，两者都参与布局，所以按下时不会挤动兄弟节点。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';

/// 按钮语气：主操作 / 次操作 / 描边 / 纯文字 / 危险。语义固定，页面不要自己拼颜色。
enum DuoButtonVariant { primary, secondary, outline, ghost, danger }

class DuoButton extends StatefulWidget {
  const DuoButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DuoButtonVariant.primary,
    this.icon,
    this.expand = true,
    this.loading = false,
    this.compact = false,
  });

  /// 按钮文案，单行，过长省略（不换行，按钮高度才不会抖）。
  final String label;

  /// 为 null 即禁用：灰底灰字、无厚度、不响应点击。
  final VoidCallback? onPressed;

  /// 语气。见 DuoButtonVariant。icon 是文案左侧图标；expand=false 按内容收缩；
  /// loading 显示转圈且尺寸不变；compact 用 48 的紧凑高度（仍不小于触控目标）。
  final DuoButtonVariant variant;

  final IconData? icon;
  final bool expand;
  final bool loading;
  final bool compact;

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  static const _duration = Duration(milliseconds: 90);

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final variant = widget.variant;
    // 禁用只看 onPressed；loading 只是暂时不响应点击，配色仍按语气走。
    final disabled = widget.onPressed == null;
    final enabled = !disabled && !widget.loading;
    final radius = BorderRadius.circular(AppMetrics.radiusButton.r);
    final height = widget.compact
        ? AppMetrics.buttonHeightCompact.r
        : AppMetrics.buttonHeight.r;
    final faceHeight = height - AppMetrics.buttonDepth.r;
    final sink = _pressed && enabled && variant != DuoButtonVariant.ghost;
    final faceColor = _faceColor(scheme, disabled);

    final face = AnimatedContainer(
      duration: _duration,
      // 不写 alignment：Container 的 Align 在有界宽度下会撑满，expand=false 就收缩不了。
      width: widget.expand ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: AppMetrics.gapLg.r),
      decoration: BoxDecoration(
        color: faceColor,
        borderRadius: radius,
        border: variant == DuoButtonVariant.outline
            ? Border.all(
                color: scheme.outlineVariant,
                width: AppMetrics.stroke.r,
              )
            : null,
      ),
      child: _content(context, _textColor(scheme, disabled)),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTap: enabled ? widget.onPressed : null,
          child: Container(
            height: height,
            width: widget.expand ? double.infinity : null,
            decoration: BoxDecoration(
              color: _depthColor(scheme, disabled, faceColor),
              borderRadius: radius,
            ),
            // 面在厚度里上下滑动：滑到底 = 厚度被完全盖住 = 按到底了。
            child: AnimatedAlign(
              alignment: sink ? Alignment.bottomCenter : Alignment.topCenter,
              widthFactor: 1,
              heightFactor: 1,
              duration: _duration,
              curve: Curves.easeOut,
              child: SizedBox(
                height: faceHeight,
                width: widget.expand ? double.infinity : null,
                child: face,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Color fg) {
    // loading 时转圈优先，图标让位，避免两个图形挤在一起。
    final Widget? leading = widget.loading
        ? SizedBox(
            width: 18.r,
            height: 18.r,
            child: CircularProgressIndicator(strokeWidth: 2.4.r, color: fg),
          )
        : widget.icon == null
        ? null
        : Icon(widget.icon, size: 20.r, color: fg);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading, SizedBox(width: AppMetrics.gapSm.r)],
        // Flexible：Row 里非 flex 的孩子拿不到宽度上限，不加它长文案会撑破按钮。
        Flexible(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.label(context)
                .copyWith(color: fg, fontSize: (widget.compact ? 14 : 15).sp),
          ),
        ),
      ],
    );
  }

  Color _faceColor(ColorScheme s, bool disabled) {
    if (disabled) return s.surfaceContainerHighest;
    return switch (widget.variant) {
      DuoButtonVariant.primary => s.primary,
      DuoButtonVariant.secondary => s.secondaryContainer,
      DuoButtonVariant.outline => s.surface,
      // ghost 平时全透明（透明也从主题色派生，不写死），按下时给一层浅底。
      DuoButtonVariant.ghost =>
        _pressed ? s.surfaceContainerHighest : s.surface.withValues(alpha: 0),
      DuoButtonVariant.danger => s.error,
    };
  }

  Color _textColor(ColorScheme s, bool disabled) {
    if (disabled) return s.onSurfaceVariant;
    return switch (widget.variant) {
      DuoButtonVariant.primary => s.onPrimary,
      DuoButtonVariant.secondary => s.onSecondaryContainer,
      DuoButtonVariant.outline || DuoButtonVariant.ghost => s.primary,
      DuoButtonVariant.danger => s.onError,
    };
  }

  /// 厚度色。禁用态与 ghost 直接用面色（等于没有厚度），其余按语气加深。
  Color _depthColor(ColorScheme s, bool disabled, Color face) {
    if (disabled || widget.variant == DuoButtonVariant.ghost) return face;
    final secondary = s.secondaryContainer;
    return switch (widget.variant) {
      DuoButtonVariant.primary => _darken(s.primary),
      DuoButtonVariant.secondary => _darken(secondary),
      // 面是 surface（暗色下几乎等于背景），只有描边色当厚度才看得见。
      DuoButtonVariant.outline => s.outlineVariant,
      DuoButtonVariant.ghost => face, // 已被上面拦下，这里只为穷尽性。
      DuoButtonVariant.danger => _darken(s.error),
    };
  }
}

/// 同色系加深：厚度色必须「同色但更深」。用 HSL 降明度而不是混黑——混黑会让浅色发灰，
/// 而且颜色仍从 colorScheme 派生，没有写死值。
Color _darken(Color color, [double amount = 0.16]) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}
