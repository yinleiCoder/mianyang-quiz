// 「我的位置」卡：多邻国式的钉住——不管我排第几，先让我看见自己。
//
// 榜上没有我 ≠ 系统没算我的分：三种"不在榜"各有原因（没交过 / 这场是自主练习 /
// 还在等老师判主观题 / 没分班），服务端用 viewerNote 说明，这里必须原样讲出来，
// 否则学生会以为成绩丢了（这也是 0077 里 viewer_note 存在的唯一理由）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_entry.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_stats.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';

class MyRankCard extends StatelessWidget {
  const MyRankCard({
    super.key,
    required this.viewer,
    required this.stats,
    required this.scopeLabel,
    this.viewerNote,
  });

  /// 为 null = 我不在榜上，原因看 viewerNote。
  final LeaderboardViewer? viewer;
  final LeaderboardStats stats;
  final String scopeLabel;
  final String? viewerNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final me = viewer;
    if (me == null) return _note(context);

    final duration = Formatters.duration(me.durationMs);
    final avg = stats.avgPercent;
    final gap = avg == null ? null : ((me.percent - avg) * 100).round() / 10;
    final chase = me.chase;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 中间那段要能缩：窄屏（390 - 左右内边距 - 卡片内边距 ≈ 318）上
          // 「第 2 名 · 1班 · 共 3 人 · 80 / 100」排不下，尖括号里必须有一个 Expanded，
          // 否则整行溢出（widget 测试在 390 宽下抓到的就是这个）
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '第 ${me.rank} 名',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: Text(
                  '$scopeLabel · 共 ${me.scopeTotal} 人',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Text(
                '${Formatters.score(me.score)} / ${Formatters.score(me.fullScore)}',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Wrap(
            spacing: AppMetrics.gapMd.r,
            runSpacing: AppMetrics.gapXs.r,
            children: [
              if (gap != null)
                _Line(
                  text: gap >= 0 ? '高于平均分 ${gap.abs()} 分' : '低于平均分 ${gap.abs()} 分',
                  good: gap >= 0,
                ),
              if (chase != null)
                _Line(text: '距上一名（${chase.name}）还差 ${Formatters.score(chase.gap)} 分')
              else if (me.rank == 1)
                const _Line(text: '暂列第一', good: true),
              if (duration.isNotEmpty) _Line(text: '用时 $duration'),
              if ((me.schoolRank ?? 0) > 0)
                _Line(text: '全校 ${me.schoolRank}/${me.schoolTotal}'),
              if ((me.cityRank ?? 0) > 0)
                _Line(text: '全市 ${me.cityRank}/${me.cityTotal}（超过 ${(me.percentile * 100).round()}%）'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _note(BuildContext context) {
    final text = _noteText(viewerNote);
    if (text == null) return const SizedBox.shrink();
    return DuoCard(
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18.r,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  /// 与服务端 viewer_note 一一对应（0077）。文案要给出下一步动作。
  static String? _noteText(String? note) => switch (note) {
    'not_submitted' => '你还没交过这份卷子：交卷后就会出现在榜上。',
    'not_official' => '你这一场是自主练习。同一份卷只有第一次交卷计入排行。',
    'not_graded' => '你已交卷，等主观题判完出分后才会进榜。',
    'not_in_class' => '你还没有分班，看不到全班榜——先看全校或全市。',
    'empty_scope' => '这个范围里还没有可比的成绩。',
    _ => null,
  };
}

/// 一行小字。good = true 用成功色（高于平均、暂列第一）——
/// M3 的 ColorScheme 没有"成功"角色，走本项目的 SemanticColors（AGENTS.md 二·五）。
class _Line extends StatelessWidget {
  const _Line({required this.text, this.good = false});

  final String text;
  final bool good;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = good ? context.semantic.success : theme.colorScheme.onSurfaceVariant;
    return Text(text, style: theme.textTheme.bodySmall?.copyWith(color: color));
  }
}
