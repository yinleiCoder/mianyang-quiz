// 个人资料页的头部卡片：头像 + 姓名 + 邮箱 + 身份/学校标签 + 就读信息。
//
// 职责：把档案里"一眼要看全"的东西摆在一起；身份用 Identity.label（三态之首）。
// 不负责：学校名的查询（页面查好传进来）、头像上传（编辑页的事）、任何写操作。
//
// 就读信息只对**非教师**身份展示：教师没有班级与专业，摆一行空的「还没有填写」
// 只会让人以为资料缺了东西。教师待审核仍在学生阶段，照常显示。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/core/people/user_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile, this.schoolName});

  final Profile profile;

  /// 学校名（页面查好）；null = 未绑定或学校列表还没回来。
  final String? schoolName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final identity = profile.identityValue;
    final showEnrollment = identity != Identity.teacher;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                initial: profile.initial,
                avatarUrl: profile.avatarUrl,
              ),
              SizedBox(width: AppMetrics.gapLg.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.name.isEmpty ? '未填写姓名' : profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                    SizedBox(height: AppMetrics.gapXs.r),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(context)
                          .copyWith(color: scheme.onSurfaceVariant),
                    ),
                    SizedBox(height: AppMetrics.gapMd.r),
                    Wrap(
                      spacing: AppMetrics.gapXs.r,
                      runSpacing: AppMetrics.gapXs.r,
                      children: [
                        DuoChip(
                          label: identity.label,
                          tone: _identityTone(identity),
                          dense: true,
                        ),
                        if (profile.isAdmin)
                          const DuoChip(
                            label: '管理员',
                            tone: DuoChipTone.brand,
                            dense: true,
                          ),
                        DuoChip(
                          label: schoolName ?? '未绑定学校',
                          tone: DuoChipTone.neutral,
                          icon: Icons.account_balance_outlined,
                          dense: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (identity == Identity.teacherPending) ...[
            SizedBox(height: AppMetrics.gapLg.r),
            const _InfoRow(
              icon: Icons.hourglass_top_rounded,
              tone: DuoIconBadgeTone.warning,
              text: '教师身份审核中：学校管理员通过后即可出题',
            ),
          ],
          if (showEnrollment) ...[
            SizedBox(height: AppMetrics.gapLg.r),
            _InfoRow(
              icon: Icons.badge_outlined,
              tone: DuoIconBadgeTone.neutral,
              text: _enrollmentText(profile),
            ),
          ],
        ],
      ),
    );
  }
}

/// 身份标签的语气：教师=品牌色、待审核=警告、学生=中性。
DuoChipTone _identityTone(Identity identity) => switch (identity) {
  Identity.teacher => DuoChipTone.brand,
  Identity.teacherPending => DuoChipTone.warning,
  Identity.student => DuoChipTone.neutral,
};

/// 就读信息拼成一行；四项都没填时给一句可行动的提示，而不是留白。
String _enrollmentText(Profile profile) {
  final parts = <String>[
    if (profile.enrollYear != null)
      Formatters.enrollmentYear(profile.enrollYear),
    if (profile.majorCategory?.isNotEmpty ?? false) profile.majorCategory!,
    if (profile.major?.isNotEmpty ?? false) profile.major!,
    if (profile.className?.isNotEmpty ?? false) profile.className!,
  ];
  return parts.isEmpty ? '就读信息还没填，点「修改就读信息」补上' : parts.join(' · ');
}

/// 头部里的一行小提示：图标 + 一句话。
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.tone, required this.text});

  final IconData icon;
  final DuoIconBadgeTone tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DuoIconBadge(icon: icon, tone: tone, size: 32, filled: false),
        SizedBox(width: AppMetrics.gapMd.r),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }
}
