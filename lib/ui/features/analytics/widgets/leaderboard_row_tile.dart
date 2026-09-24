// 榜单的一行：名次徽章 + 头像 + 姓名 +（学校或班级）+ 得分。
//
// 手机上只有一列的宽度，所以次要信息（学校/班级、用时）挤在姓名下面那行，
// 而不是像网页端表头那样并排成列。
//
// 前三名给金银铜：多邻国那套"领奖台"的最小实现——不画图，只换徽章底色。
// 学校只在校际榜上显示（同班比的时候每行都写"盐亭县职业技术学校"是纯噪声），
// 这是用户要的"排行应标注出学校信息"在窄屏上的落地方式。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_entry.dart';
import 'package:mianyang_quiz/ui/core/people/user_avatar.dart';

class LeaderboardRowTile extends StatelessWidget {
  const LeaderboardRowTile({super.key, required this.row, this.showSchool = false});

  final LeaderboardRow row;

  /// true = 显示学校（全校/全市榜），false = 显示班级（全班榜）。
  final bool showSchool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final secondary = showSchool ? (row.schoolName ?? '') : (row.className ?? '');
    final duration = Formatters.duration(row.durationMs);
    final subtitle = [secondary, if (duration.isNotEmpty) '用时 $duration'].join(' · ');

    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapMd.r,
        vertical: AppMetrics.gapSm.r,
      ),
      child: Row(
        children: [
          _RankBadge(rank: row.rank),
          SizedBox(width: AppMetrics.gapSm.r),
          UserAvatar(initial: _initial(row.name), avatarUrl: row.avatarUrl, size: 32),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.isMe ? '${row.name}（我）' : row.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: row.isMe ? FontWeight.w700 : FontWeight.w400,
                    color: row.isMe ? scheme.primary : scheme.onSurface,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Text(
            Formatters.score(row.score),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          Text(
            ' / ${Formatters.score(row.fullScore)}',
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );

    if (!row.isMe) return content;
    // 我那一行加底色：榜长的时候一眼能找到自己（与网页端同一条做法）
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
      ),
      child: content,
    );
  }

  /// 与 Profile.initial 同口径（姓名首字，空就给问号）
  static String _initial(String name) => name.isEmpty ? '?' : name.substring(0, 1);
}

/// 名次徽章：前三名金银铜，其余中性色。
class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // 只有前三名特殊：不引图标，换底色就够了（金/银/铜在语义色里不存在，
    // 用固定的三个色值——它们表达的是"名次"而不是主题语义）
    final (background, foreground) = switch (rank) {
      1 => (const Color(0xFFFFE7A3), const Color(0xFF6B4E00)),
      2 => (const Color(0xFFE6E8EC), const Color(0xFF3F4652)),
      3 => (const Color(0xFFF6D9BE), const Color(0xFF6B3F17)),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };

    return Container(
      width: 30.r,
      height: 30.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        '$rank',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}
