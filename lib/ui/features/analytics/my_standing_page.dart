// 「我的处境」：我在这场考试里排第几、比班均高还是低、离上一名还差几分、哪儿最弱。
//
// **数据全是既有的，没有新端点**（除了 0080 那个 20 行的 my_node_accuracy）：
//   · 名次/差距 ← paper_leaderboard 的 viewer（0077 一次算完三档名次 + chase）；
//   · 哪场考试 ← list_my_exam_attempts（只取**官方且已出分**的那一场：
//     同一份卷重做算自主练习，拿它当"我的处境"会误导人）；
//   · 薄弱点 ← my_node_accuracy + 上卷（与网页端同口径）。
//
// 空态是一等公民：没考过 / 没出分 / 没分班 / 没练过，各有各的说法（见下）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/node_accuracy.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/my_rank_card.dart';
import 'package:provider/provider.dart';

/// 这一页要的三样东西。
class _Standing {
  const _Standing({this.board, this.nodes = const [], this.note});

  final PaperLeaderboard? board;
  final List<NodeAccuracy> nodes;

  /// 没有名次可显示时的原因（页面据此说话，而不是显示一堆 0）。
  final String? note;
}

class MyStandingPage extends StatefulWidget {
  const MyStandingPage({super.key});

  @override
  State<MyStandingPage> createState() => _MyStandingPageState();
}

class _MyStandingPageState extends State<MyStandingPage> {
  AsyncValue<_Standing> _state = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final analytics = context.read<AnalyticsRepository>();
      final paperRepo = context.read<PaperRepository>();
      final subjectRepo = context.read<SubjectRepository>();

      final nodes = await analytics.fetchMyNodeAccuracy();
      final subjectNodes = await subjectRepo.fetchNodes();
      final rolled = rollUpByTopNode(nodes, subjectNodes);

      // 最近一场**官方且已出分**的考试：重做的场次不计入排行，拿它算排名会误导
      final attempts = await paperRepo.fetchMyAttempts(limit: 20);
      final official = attempts.where((a) => a.isOfficial && a.statusValue.isFinal).toList();
      final target = official.isNotEmpty ? official.first : null;
      if (target == null) {
        final anyGraded = attempts.any((a) => a.statusValue.isFinal);
        if (!mounted) return;
        setState(() => _state = AsyncData(_Standing(
          nodes: rolled,
          note: anyGraded ? 'not_official' : 'not_submitted',
        )));
        return;
      }

      final board = await analytics.fetchLeaderboard(paperId: target.paperId);
      if (!mounted) return;
      setState(() => _state = AsyncData(_Standing(board: board, nodes: rolled)));
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的处境')),
      body: AsyncView<_Standing>(
        state: _state,
        loadingMessage: '正在算你的位置…',
        onRetry: _load,
        builder: (data) => ListView(
          padding: EdgeInsets.all(AppMetrics.pagePadding.r),
          children: [
            if (data.board != null)
              MyRankCard(
                viewer: data.board!.viewer,
                stats: data.board!.stats,
                scopeLabel: data.board!.scope.label,
                viewerNote: data.board!.viewerNote,
              )
            else
              DuoCard(child: Text(_emptyText(data.note), style: Theme.of(context).textTheme.bodyMedium)),
            SizedBox(height: AppMetrics.gapMd.r),
            _WeakNodes(nodes: data.nodes),
          ],
        ),
      ),
    );
  }

  static String _emptyText(String? note) => switch (note) {
    'not_official' => '你的考试记录都是自主练习（或还没出分）。同一份卷只有第一次交卷计入排行，'
        '出分后就能看到自己的名次。',
    'not_submitted' => '还没有参加过考试。去试卷库挑一份试试——考完就知道自己在班里什么水平了。',
    _ => '暂时没有可显示的名次。',
  };
}

/// 我的薄弱知识点（按顶层科目汇总，最弱的排最前）。
class _WeakNodes extends StatelessWidget {
  const _WeakNodes({required this.nodes});

  final List<NodeAccuracy> nodes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weakest = nodes.take(5).toList();

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('我的薄弱点', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: AppMetrics.gapXs.r),
          if (weakest.isEmpty)
            Text(
              '最近 30 天还没有足够的练习记录。多练几组，这里就能看出你哪块最弱。',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final n in weakest) ...[
              SizedBox(height: AppMetrics.gapSm.r),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      n.name.isEmpty ? '未选科目' : n.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    // 0 次作答不等于 0%：上卷后 attempts>0 才留下，这里的 0 不会出现
                    Formatters.percent(n.accuracy),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: n.accuracy < 0.6
                          ? theme.colorScheme.error
                          : context.semantic.success,
                    ),
                  ),
                  SizedBox(width: AppMetrics.gapSm.r),
                  SizedBox(
                    width: 96.r,
                    child: Text(
                      '${n.correct}/${n.attempts} 题',
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: n.accuracy,
                  minHeight: 6.r,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
        ],
      ),
    );
  }
}
