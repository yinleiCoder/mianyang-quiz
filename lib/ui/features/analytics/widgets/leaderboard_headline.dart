// 榜单的抬头：卷名信息 + 上榜人数 + 两个"为什么榜上是空的"提示。
//
// 单独成文件是因为页面本体触到 200 行上限（架构守卫会拦）——这里的职责本来也独立：
// 它只描述"这是哪张卷、有多少人"，不碰榜单本身。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';

class LeaderboardHeadline extends StatelessWidget {
  const LeaderboardHeadline({super.key, required this.board});

  final PaperLeaderboard board;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paper = board.paper;
    final stats = board.stats;
    final notes = [
      '满分 ${numText(paper.fullScore)}',
      if (paper.examName != null && paper.examName!.isNotEmpty) paper.examName!,
      '上榜 ${stats.total} 人',
    ];
    // 待阅卷 / 旧版场次都要说出来，否则"榜上怎么就这几个人"会被当成故障（0077 的口径）
    final hints = [
      if (stats.ungraded > 0) '还有 ${stats.ungraded} 人待阅卷，出分后才进榜',
      if (stats.otherVersionSkipped > 0)
        '另有 ${stats.otherVersionSkipped} 场考的是旧版卷面，未计入',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notes.join(' · '), style: theme.textTheme.titleMedium),
        if (stats.avgScore != null)
          Text(
            '平均 ${numText(stats.avgScore!)} 分'
            '${stats.maxScore != null ? ' · 最高 ${numText(stats.maxScore!)}' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        for (final hint in hints)
          Padding(
            padding: EdgeInsets.only(top: AppMetrics.gapXs.r),
            child: Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(color: context.semantic.warning),
            ),
          ),
      ],
    );
  }
}

/// 分数文案：整数不拖 ".0"（榜上一列数字，能省一个字符就省一个）。
String numText(double v) => v == v.roundToDouble() ? v.round().toString() : v.toString();
