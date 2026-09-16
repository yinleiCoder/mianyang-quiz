// 题目署名行：作者 + 两级审核通过人，各带小头像（对齐网页端题库详情的那一行）。
//
// 职责：把 `QuestionCredit` 列表渲染成一排「头像 + 角色 + 姓名」。
// 不负责：取数（QuestionCreditLoader）、点击弹资料（网页端有浮层，客户端只做展示）。
//
// 账号已注销（person == null）时只写「作者 已注销」——头像位留空会更像加载失败。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/query/question_credits.dart';
import 'package:mianyang_quiz/ui/core/people/user_avatar.dart';

class QuestionCreditsRow extends StatelessWidget {
  const QuestionCreditsRow({super.key, required this.credits});

  final List<QuestionCredit> credits;

  @override
  Widget build(BuildContext context) {
    if (credits.isEmpty) return const SizedBox.shrink();
    final muted = AppTextStyles.caption(
      context,
    ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Wrap(
      spacing: AppMetrics.gapMd.r,
      runSpacing: AppMetrics.gapXs.r,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final credit in credits) _Credit(credit: credit, style: muted),
      ],
    );
  }
}

class _Credit extends StatelessWidget {
  const _Credit({required this.credit, required this.style});

  final QuestionCredit credit;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final person = credit.person;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (person != null) ...[
          // 与文字同高的小头像：署名是附属信息，不该抢题干的视觉重量
          UserAvatar(
            initial: person.initial,
            avatarUrl: person.avatarUrl,
            size: 18,
          ),
          SizedBox(width: AppMetrics.gapXs.r),
        ],
        Text(
          person == null
              ? '${credit.caption} 已注销'
              : '${credit.caption} ${person.name}',
          style: style,
        ),
      ],
    );
  }
}
