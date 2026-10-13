// 主按钮：五种语气映射到 Material 3 的按钮变体，形态与交互全部交给 M3。
//
//   primary   → FilledButton        主操作（primary 底 / onPrimary 字）
//   secondary → FilledButton.tonal  次操作（secondaryContainer 底）
//   outline   → OutlinedButton      描边
//   ghost     → TextButton          纯文字
//   danger    → FilledButton + error 角色（M3 没有"危险"变体，用错误色拼出来）
//
// **为什么不再画"厚度"**：那是多邻国的物理隐喻（按下时整块面在深色底座里下沉），
// 不在 M3 的语汇里。M3 用**色阶 + 状态层**表达层级与反馈：按下是涟漪、悬停叠一层
// 8% 的 onSurface、禁用是同色 12%（底）/38%（字）。自绘底座会把这一整套挡掉
// ——M3 的按钮状态由 ButtonStyle 统一管，在外面包一层自绘就等于放弃它。
//
// 本组件只做 M3 按钮没给的三件事：**loading 转圈**、**expand 撑满宽度**、
// **loading 时挡重复点击**。其余（尺寸、圆角、字重、禁用态配色）都从主题来。
//
// ⚠ 类名仍叫 Duo*：全仓 86 处调用、51 个文件都写着它，而这一步要换的是**形态**。
// 形态稳定后另起一次纯机械的改名（那时是全局替换，安全得多）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 按钮语气：主操作 / 次操作 / 描边 / 纯文字 / 危险。语义固定，页面不要自己拼颜色。
enum DuoButtonVariant { primary, secondary, outline, ghost, danger }

class DuoButton extends StatelessWidget {
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

  /// 为 null 即禁用（M3 的禁用态配色）。
  final VoidCallback? onPressed;

  /// 语气。见 DuoButtonVariant。icon 是文案左侧图标；expand=false 按内容收缩；
  /// loading 显示转圈且尺寸不变；compact 用 48 的紧凑高度（仍不小于触控目标）。
  final DuoButtonVariant variant;

  final IconData? icon;
  final bool expand;
  final bool loading;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // loading 期间不接受点击：M3 没有加载态，只能借"禁用"这件事，
    // 但配色会由 _loadingStyle 按语气钉回去（禁用态的 38% 灰会让转圈糊掉）。
    final VoidCallback? handlePress = loading ? null : onPressed;
    final style = _loadingStyle(context) ?? const ButtonStyle();
    final sized = compact
        ? AppMetrics.buttonHeightCompact.r
        : AppMetrics.buttonHeight.r;
    final button = switch (variant) {
      DuoButtonVariant.primary => FilledButton(
        style: style,
        onPressed: handlePress,
        child: _content(context),
      ),
      DuoButtonVariant.secondary => FilledButton.tonal(
        style: style,
        onPressed: handlePress,
        child: _content(context),
      ),
      DuoButtonVariant.outline => OutlinedButton(
        style: style,
        onPressed: handlePress,
        child: _content(context),
      ),
      DuoButtonVariant.ghost => TextButton(
        style: style,
        onPressed: handlePress,
        child: _content(context),
      ),
      DuoButtonVariant.danger => FilledButton(
        style: style.merge(_dangerStyle(context)),
        onPressed: handlePress,
        child: _content(context),
      ),
    };

    // 高度：M3 的 minimumSize 只管"至少"，这里显式给一个，两种高度才是确定的。
    // expand 时撑满可用宽度（SizedBox 用 double.infinity 而不是依赖父级对齐）。
    return SizedBox(
      width: expand ? double.infinity : null,
      height: sized,
      child: button,
    );
  }

  Widget _content(BuildContext context) {
    final fg = _foreground(context);
    // loading 时转圈优先，图标让位，避免两个图形挤在一起。
    final Widget? leading = loading
        ? SizedBox(
            width: 18.r,
            height: 18.r,
            child: CircularProgressIndicator(strokeWidth: 2.4.r, color: fg),
          )
        : icon == null
        ? null
        : Icon(icon, size: 20.r, color: fg);

    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: (compact ? 14 : 15).sp),
    );
    if (leading == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading,
        SizedBox(width: AppMetrics.gapSm.r),
        // Flexible：Row 里非 flex 的孩子拿不到宽度上限，不加它长文案会撑破按钮。
        Flexible(child: text),
      ],
    );
  }

  /// 按钮前景色（转圈用它）。取的是 M3 各变体的 standard 配色。
  Color _foreground(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return switch (variant) {
      DuoButtonVariant.primary => s.onPrimary,
      DuoButtonVariant.secondary => s.onSecondaryContainer,
      DuoButtonVariant.outline || DuoButtonVariant.ghost => s.primary,
      DuoButtonVariant.danger => s.onError,
    };
  }

  /// 危险语气：M3 没有"危险按钮"变体，用 FilledButton 套错误色角色。
  ButtonStyle _dangerStyle(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(s.error),
      foregroundColor: WidgetStatePropertyAll(s.onError),
    );
  }

  /// loading 期间的配色覆盖。**只在"本来能点、只是正在提交"时生效**：
  /// 真禁用（onPressed 为 null）时返回 null，照 M3 的禁用态画。
  ButtonStyle? _loadingStyle(BuildContext context) {
    if (!loading || onPressed == null) return null;
    final s = Theme.of(context).colorScheme;
    final fg = _foreground(context);
    final bg = switch (variant) {
      DuoButtonVariant.primary => s.primary,
      DuoButtonVariant.secondary => s.secondaryContainer,
      DuoButtonVariant.danger => s.error,
      // 描边与纯文字本来就没有底色，只把字色钉回去
      DuoButtonVariant.outline || DuoButtonVariant.ghost => null,
    };
    return ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(fg),
      backgroundColor: bg == null ? null : WidgetStatePropertyAll(bg),
    );
  }
}
