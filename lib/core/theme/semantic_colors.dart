// 语义色：M3 的 ColorScheme 里没有「成功」「警告」这两个角色，而刷题类应用必须有。
//
// **为什么不能拿 tertiary 顶替**：`ColorScheme.fromSeed` 的 tertiary 是从种子色
// 色相旋转 + 补色派生出来的。deepPurple 种子派生出的 tertiary 是**粉红色**，
// 与表示错误的 error（红）几乎同色——用户根本分不出答对和答错。
// 这个错误很隐蔽：代码读起来通顺（"没有成功色就用第三色"），只有真看界面才会发现。
//
// 所以这里**显式**定义一组语义色。它们是"手写色值"，但主题正是唯一该写死颜色的地方：
// 组件一律从主题取色，主题负责给出这套色板。暗色模式另给一套，不要在组件里判亮暗。

import 'package:material_ui/material_ui.dart';

@immutable
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  /// 正向强调：答对、已掌握、达标。用于图标、文字与边框。
  final Color success;

  /// 正向底色：反馈条、结果卡这类需要整块浅色底的场合。
  final Color successContainer;
  final Color onSuccessContainer;

  /// 需要注意但不是错误：节点冻结、审批中、接近上限。
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;

  /// 亮色。绿色取 Material Green 800/100/900 —— 在白底上对比度足够，
  /// 且与 error 的红色在色相上相隔足够远，色觉障碍用户也能区分。
  static const SemanticColors light = SemanticColors(
    success: Color(0xFF2E7D32),
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF1B5E20),
    warning: Color(0xFFB26A00),
    warningContainer: Color(0xFFFFE0B2),
    onWarningContainer: Color(0xFF7A4F00),
  );

  /// 暗色。底色换成深绿、前景换成浅绿——直接把亮色那套放暗色上会看不清。
  static const SemanticColors dark = SemanticColors(
    success: Color(0xFF81C784),
    successContainer: Color(0xFF1B5E20),
    onSuccessContainer: Color(0xFFC8E6C9),
    warning: Color(0xFFFFCC80),
    warningContainer: Color(0xFF7A4F00),
    onWarningContainer: Color(0xFFFFE0B2),
  );

  @override
  SemanticColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) => SemanticColors(
    success: success ?? this.success,
    successContainer: successContainer ?? this.successContainer,
    onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    warning: warning ?? this.warning,
    warningContainer: warningContainer ?? this.warningContainer,
    onWarningContainer: onWarningContainer ?? this.onWarningContainer,
  );

  @override
  SemanticColors lerp(ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
    );
  }
}

/// 取语义色的便捷入口：`context.semantic.success`。
///
/// 之所以做成扩展而不是到处 `Theme.of(context).extension<SemanticColors>()!`：
/// 后者一旦主题忘了注册就会在运行时炸，而扩展只需写一次。
extension SemanticColorsX on BuildContext {
  SemanticColors get semantic =>
      Theme.of(this).extension<SemanticColors>() ??
      // 兜底而不是抛异常：主题一定注册了它，但万一没注册，
      // 界面退化成"颜色不对"远好过整页崩掉
      (Theme.of(this).brightness == Brightness.dark
          ? SemanticColors.dark
          : SemanticColors.light);
}
