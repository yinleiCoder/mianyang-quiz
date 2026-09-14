// 图标徽章：圆角方底 + 一个图标。
//
// 职责：给图标一个带语气的底，用在统计卡、空状态、列表左侧，让"图标"这件事全站一致。
// 不负责：点击（它不可点，要可点请在外面包 InkWell 或改用 DuoButton）、
// 也不负责动效——要强调请在外层自己包动画。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

/// 徽章语气。与 DuoChip 的语义一一对应，页面不要自己拼颜色。
enum DuoIconBadgeTone {
  /// 品牌色（默认）。
  brand,

  /// 成功 / 正确。
  success,

  /// 警告 / 待办。
  warning,

  /// 危险 / 错误。
  danger,

  /// 中性（无语气）。
  neutral,
}

class DuoIconBadge extends StatelessWidget {
  const DuoIconBadge({
    super.key,
    required this.icon,
    this.tone = DuoIconBadgeTone.brand,
    this.size = 48,
    this.filled = true,
  });

  final IconData icon;

  final DuoIconBadgeTone tone;

  /// 边长：圆角与图标大小都由它派生，所以只需要改这一个数。
  final double size;

  /// 实心（容器色底 + 深色图标）还是空心（中性浅底 + 语气色图标）。
  /// 卡片本身已有底色时用空心，避免两种底色打架。
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (container, onContainer, accent) = switch (tone) {
      DuoIconBadgeTone.brand => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        scheme.primary,
      ),
      DuoIconBadgeTone.success => (
        context.semantic.successContainer,
        scheme.onTertiaryContainer,
        context.semantic.success,
      ),
      DuoIconBadgeTone.warning => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        scheme.secondary,
      ),
      DuoIconBadgeTone.danger => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        scheme.error,
      ),
      DuoIconBadgeTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        scheme.onSurfaceVariant,
      ),
    };

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: filled ? container : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(size.r * 0.3),
      ),
      child: Icon(
        icon,
        size: size.r * 0.5,
        color: filled ? onContainer : accent,
      ),
    );
  }
}
