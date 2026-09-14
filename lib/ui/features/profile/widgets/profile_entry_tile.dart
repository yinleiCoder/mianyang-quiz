// 个人资料页的一行入口：图标 + 标题（+ 副标题）+ 右箭头。
//
// 职责：把「可点的一行」的版式统一，四处入口（编辑资料/就读信息/申请教师/退出登录）
// 长得一样，用户才会觉得它们是同一类动作。
// 不负责：动作本身（onTap 由页面给）。onTap 为 null 时整行不可点——
// 正在提交的「申请教师身份」就靠它防连点，而不是自己画一个禁用态。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';

class ProfileEntryTile extends StatelessWidget {
  const ProfileEntryTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  final IconData icon;

  final String label;

  /// 副标题：说清这一项里能改什么，比只说「编辑资料」有用。
  final String? subtitle;

  final VoidCallback? onTap;

  /// 右侧自定义内容（如转圈）；不传时是右箭头。
  final Widget? trailing;

  /// 危险动作（退出登录）：图标与文字都用 error 色。
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = AppTextStyles.caption(context)
        .copyWith(color: scheme.onSurfaceVariant);

    return DuoCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapLg.r,
        vertical: AppMetrics.gapMd.r,
      ),
      child: Row(
        children: [
          DuoIconBadge(
            icon: icon,
            tone: danger ? DuoIconBadgeTone.danger : DuoIconBadgeTone.brand,
            size: 40,
            filled: false,
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label(
                    context,
                  ).copyWith(color: danger ? scheme.error : scheme.onSurface),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: AppMetrics.gapXs.r),
                  Text(subtitle!, maxLines: 2, style: muted),
                ],
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          trailing ??
              Icon(
                Icons.chevron_right_rounded,
                size: 22.r,
                color: scheme.onSurfaceVariant,
              ),
        ],
      ),
    );
  }
}
