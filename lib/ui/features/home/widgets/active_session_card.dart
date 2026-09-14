// 「继续练习」卡片：有没做完的练习时出现在工作台最上方。
//
// 放在最显眼的位置是有理由的：服务端每人同时只允许一套进行中的会话，
// 用户若无视它去开始新练习，这次的进度会被静默作废。
// 所以这张卡不是"便利入口"，而是"别丢进度"的护栏。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/stats/recent_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_progress_bar.dart';

class ActiveSessionCard extends StatelessWidget {
  const ActiveSessionCard({super.key, required this.session});

  final ActiveSessionBrief session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DuoCard(
      emphasized: true,
      padding: const EdgeInsets.all(AppMetrics.gapLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pending_actions, size: 22.r, color: scheme.primary),
              const SizedBox(width: AppMetrics.gapSm),
              Text(
                '继续上次的练习',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppMetrics.gapSm),
          Text(
            '${session.sourceValue.label} · 已完成 ${session.answeredCount}/'
            '${session.totalCount} 题'
            '${session.startedAt == null ? '' : ' · ${Formatters.relative(session.startedAt)}开始'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppMetrics.gapMd),
          DuoProgressBar(value: session.progress),
          const SizedBox(height: AppMetrics.gapLg),
          DuoButton(
            label: '继续练习',
            icon: Icons.play_arrow,
            onPressed: () =>
                context.push(AppRoutes.practiceOf(session.sessionId)),
          ),
        ],
      ),
    );
  }
}
