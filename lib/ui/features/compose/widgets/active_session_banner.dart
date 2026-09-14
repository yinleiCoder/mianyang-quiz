// 「你还有一次练习没做完」的提醒面板。
//
// 存在的唯一理由：服务端每人同时只允许一套进行中的会话，
// start_practice_session 会**静默作废**旧的——不提醒的话用户会莫名其妙丢掉进度。
// 所以这里不是"贴心提示"，而是防止数据丢失的必要环节。
//
// 返回 null 表示用户取消（不开始新练习）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/stats/recent_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

enum ActiveSessionChoice {
  /// 回到那次没做完的练习。
  resume,

  /// 作废它，开始新的。
  restart,
}

Future<ActiveSessionChoice?> showActiveSessionBanner(
  BuildContext context,
  ActiveSessionBrief session,
) {
  return showModalBottomSheet<ActiveSessionChoice>(
    context: context,
    showDragHandle: true,
    isDismissible: true,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.pagePadding,
            0,
            AppMetrics.pagePadding,
            AppMetrics.pagePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '上次的练习还没做完',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              Text(
                '${session.sourceValue.label} · 已答 ${session.answeredCount}/'
                '${session.totalCount} 题'
                '${session.startedAt == null ? '' : ' · ${Formatters.relative(session.startedAt)}开始'}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapLg),
              DuoButton(
                label: '继续上次的练习',
                icon: Icons.play_arrow,
                onPressed: () => Navigator.of(context).pop(ActiveSessionChoice.resume),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              DuoButton(
                label: '重新开始（上次进度将作废）',
                variant: DuoButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(ActiveSessionChoice.restart),
              ),
              SizedBox(height: 4.r),
              DuoButton(
                label: '先不练了',
                variant: DuoButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
