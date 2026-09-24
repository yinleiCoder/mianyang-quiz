// 试题分析：这份卷子每道题全班（或全校/全市）答得怎么样。
//
// 与网页端的 `/papers/[id]/board?tab=questions` 是同一份数据（paper_question_stats，0078），
// 但手机上的呈现不同：一题一张可折叠卡片（摘要给正确率，点开看选项分布与错答名单），
// 而不是投影用的宽表。
//
// **学生只在自己出分后才拿得到这份数据**（服务端 42501）——选项分布 + 标准答案合起来
// 就是答案本身。页面据此把"出分后可见"讲清楚，而不是显示一个空白页。
//
// 题干不在这里（服务端不下发题干，返回体只有计数与姓名）：对着题号回成绩单看原题。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_question_stats.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/filter_chip_group.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/question_stat_card.dart';
import 'package:provider/provider.dart';

class PaperAnalysisPage extends StatefulWidget {
  const PaperAnalysisPage({super.key, required this.paperId, this.paperTitle});

  final String paperId;

  /// 卷名（从上一页带过来，省一次往返）：加载期间标题不空着。
  final String? paperTitle;

  @override
  State<PaperAnalysisPage> createState() => _PaperAnalysisPageState();
}

class _PaperAnalysisPageState extends State<PaperAnalysisPage> {
  AsyncValue<PaperQuestionStats> _state = const AsyncLoading();
  LeaderboardScopeKey _scope = LeaderboardScopeKey.classScope;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final data = await context.read<AnalyticsRepository>().fetchQuestionStats(
        paperId: widget.paperId,
        scope: _scope,
      );
      if (!mounted) return;
      setState(() => _state = AsyncData(data));
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  void _switchScope(LeaderboardScopeKey key) {
    if (key == _scope) return;
    setState(() => _scope = key);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.paperTitle ?? '试题分析')),
      body: AsyncView<PaperQuestionStats>(
        state: _state,
        loadingMessage: '正在取分析…',
        onRetry: _load,
        errorTitle: '看不了这份分析',
        builder: (stats) => ListView(
          padding: EdgeInsets.all(AppMetrics.pagePadding.r),
          children: [
            FilterChipGroup<LeaderboardScopeKey>(
              items: LeaderboardScopeKey.values,
              labelOf: (k) => k.label,
              selectedOf: (k) => k == _scope,
              onToggle: _switchScope,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            Text(
              [
                '本次考试 ${stats.totals.attempts} 人参与',
                if (stats.totals.ungraded > 0) '其中 ${stats.totals.ungraded} 人待阅卷',
                if (stats.totals.otherVersionSkipped > 0)
                  '另有 ${stats.totals.otherVersionSkipped} 场考的是旧版卷面',
              ].join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            if (stats.items.isEmpty)
              DuoCard(
                child: Text(
                  '这份卷子还没有可统计的作答。',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final item in stats.items) ...[
                QuestionStatCard(
                  stat: item,
                  // 题型中文名的唯一出处是 core/constants/qtype_meta.dart；
                  // 认不出的取值落到「未知题型」而不是崩（题库加新题型时旧客户端照常显示）
                  qtypeLabel: questionTypeFrom(item.qtype).label,
                ),
                SizedBox(height: AppMetrics.gapSm.r),
              ],
          ],
        ),
      ),
    );
  }
}
