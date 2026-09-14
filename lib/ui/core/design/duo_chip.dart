// 胶囊标签：审核状态、学段、难度之类的小信息。
//
// 职责：提供五种语气的**只读**标签（单行，过长省略）。
// 不负责：筛选交互——可点的标签请用 FilterChip / ChoiceChip，它们有选中态与语义。
//
// 颜色来自主题：成功/警告取 SemanticColors（M3 的 ColorScheme 没有这两个角色），
// 危险用 error、警告用 secondary 表达，暗色模式自动跟着变。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

/// 标签语气。
enum DuoChipTone {
  /// 中性信息（学段、题型）。
  neutral,

  /// 品牌强调（当前分类）。
  brand,

  /// 成功 / 正确（审核通过）。
  success,

  /// 警告 / 待办（待审核、有改动）。
  warning,

  /// 危险 / 错误（已驳回）。
  danger,
}

class DuoChip extends StatelessWidget {
  const DuoChip({
    super.key,
    required this.label,
    this.tone = DuoChipTone.neutral,
    this.icon,
    this.dense = false,
  });

  /// 标签文案，建议不超过 6 个字。
  final String label;

  final DuoChipTone tone;

  /// 文案左侧的小图标。
  final IconData? icon;

  /// 紧凑档：列表行内用，字号与内边距都小一号。
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (tone) {
      DuoChipTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      DuoChipTone.brand => (scheme.primaryContainer, scheme.onPrimaryContainer),
      DuoChipTone.success => (
        context.semantic.successContainer,
        scheme.onTertiaryContainer,
      ),
      DuoChipTone.warning => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      DuoChipTone.danger => (scheme.errorContainer, scheme.onErrorContainer),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (dense ? AppMetrics.gapSm : AppMetrics.gapMd).r,
        vertical: (dense ? 2 : AppMetrics.gapXs).r,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppMetrics.radiusChip.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: (dense ? 12 : 14).r, color: foreground),
            SizedBox(width: AppMetrics.gapXs.r),
          ],
          // Flexible：Row 里非 flex 的孩子拿不到宽度上限，不加它长文案会溢出。
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (dense ? 11 : 12).sp,
                fontWeight: FontWeight.w700,
                color: foreground,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
