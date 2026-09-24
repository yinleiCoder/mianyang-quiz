// 榜单主体：前 N 名 + （我不在前 N 时）我附近那几名。
//
// 为什么要有"附近那几名"一段：我的名次可能是"全市第 204 名"，而榜只取前 200 ——
// 少了这一段，翻到底也找不到自己，学生会以为没上榜。服务端专门把附近几名
// 从全量排名集里切出来（0077 的 nearby），这里只负责画。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/leaderboard_row_tile.dart';

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({super.key, required this.board});

  final PaperLeaderboard board;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 同班比的时候每行都写校名是噪声；跨校榜才显示学校（用户要求的"标注学校信息"）
    final showSchool = board.scope.key != LeaderboardScopeKey.classScope.wire;
    final mine = board.viewer?.userId;
    final inRows = board.rows.any((r) => r.userId == mine);

    if (board.rows.isEmpty) {
      return DuoCard(
        child: Text(
          '这个范围里还没有成绩——交卷并出分后就会出现在这里。',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Card(
          children: [
            for (final row in board.rows) LeaderboardRowTile(row: row, showSchool: showSchool),
          ],
        ),
        if (!inRows && board.nearby.isNotEmpty) ...[
          SizedBox(height: AppMetrics.gapMd.r),
          Text(
            '你在榜上的附近位置',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          _Card(
            children: [
              for (final row in board.nearby)
                LeaderboardRowTile(row: row, showSchool: showSchool),
            ],
          ),
        ],
        if (board.truncated) ...[
          SizedBox(height: AppMetrics.gapSm.r),
          Text(
            '只显示前 ${board.limit} 名（共 ${board.stats.total} 人）',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// 榜单外壳：行与行之间不画分隔线，靠行内的间距分开（张榜的观感，不是表格）。
class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DuoCard(
    padding: EdgeInsets.symmetric(vertical: AppMetrics.gapXs.r),
    child: Column(children: children),
  );
}
