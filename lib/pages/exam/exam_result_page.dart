// 成绩单：总分 + 逐题复盘。
//
// 三种状态在这一页合流（服务端给什么就显示什么，不做本地判断）：
//   · 待阅卷 / 阅卷中：客观分已出，主观题还是 pending，逐题列出「待阅卷」；
//   · 已出分：总分、逐题得分、标准答案（服务端这时才把答案下发）；
//   · 进行中：不该来这一页（可能是旧链接），转回答题页。
//
// 逐题复盘用的是成绩单**当时的卷面**（paper_version 快照），不是题库的当前版本：
// 题目事后改版不该让这份成绩单换个样子。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/exam/widgets/exam_result_footer.dart';
import 'package:mianyang_quiz/pages/exam/widgets/exam_result_summary.dart';
import 'package:mianyang_quiz/pages/exam/widgets/exam_review_card.dart';
import 'package:provider/provider.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({super.key, required this.attemptId});

  final String attemptId;

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  AsyncValue<ExamSnapshot> _state = const AsyncLoading();

  /// 逐题作答统计（paper_items.id → 统计），只在出分后取得到。
  Map<String, QuestionStat> _stats = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final snapshot = await context.read<PaperRepository>().fetchAttempt(
        widget.attemptId,
      );
      if (!mounted) return;
      // 还没交卷：这一页没有可看的东西，送回答题页
      if (snapshot.attempt.statusValue.isOpen) {
        context.pushReplacement(AppRoutes.examAttemptOf(widget.attemptId));
        return;
      }
      final stats = await _loadStats(snapshot);
      if (!mounted) return;
      setState(() {
        _state = AsyncData(snapshot);
        _stats = stats;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  /// 每题的作答统计（正确率 / 易错标识的来源）。
  ///
  /// **三项都要求出分**：没出分服务端会拒（选项分布 + 标准答案 = 答案本身，见 0078），
  /// 所以这里先看 `isFinal` 再请求。任何失败都**静默降级**为空 ——
  /// 成绩单主体（分数、逐题得分）不该因为一份附加统计而整页报错。
  Future<Map<String, QuestionStat>> _loadStats(ExamSnapshot snapshot) async {
    if (!snapshot.attempt.statusValue.isFinal) return const {};
    try {
      final stats = await context.read<AnalyticsRepository>().fetchQuestionStats(
        paperId: snapshot.attempt.paperId,
      );
      return {for (final item in stats.items) item.itemId: item};
    } catch (_) {
      return const {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('考试成绩')),
      body: SafeArea(
        child: AsyncView<ExamSnapshot>(
          state: _state,
          loadingMessage: '正在加载成绩…',
          onRetry: _load,
          builder: (snapshot) => _Body(snapshot: snapshot, stats: _stats),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.snapshot, this.stats = const {}});

  final ExamSnapshot snapshot;

  /// 逐题作答统计（paper_items.id → 统计）。没出分或取不到时是空表。
  final Map<String, QuestionStat> stats;

  @override
  Widget build(BuildContext context) {
    final attempt = snapshot.attempt;
    final paper = snapshot.paper;
    final finalScore = attempt.statusValue.isFinal;
    // 交卷后服务端就下发客观题答案（0106），顶层简答题仍等阅卷；
    // 所以"是否显示答案"不再等于"是否已出分"。
    final revealed =
        finalScore ||
        attempt.statusValue == ExamStatus.submitted ||
        attempt.statusValue == ExamStatus.grading;
    final answers = snapshot.answersByItem;
    final items = paper.items;

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        // 考试复盘限宽 1000：640 在桌面上太窄（用户 2026-10-24）。
        MaxWidthBox(
          maxWidth: 1000,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 只做入场（分数是拿来读的，不做数字滚动或撒花）
              FadeSlideIn(
                child: ExamResultSummary(attempt: attempt, title: paper.title),
              ),
              SizedBox(height: AppMetrics.gapMd.r),
              DuoButton(
                label: '查看成绩排行',
                variant: DuoButtonVariant.outline,
                icon: Icons.emoji_events_outlined,
                onPressed: () => context.push(
                  AppRoutes.paperLeaderboardOf(attempt.paperId),
                  extra: paper.title,
                ),
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              // 只在已出分时给入口（否则服务端拒：选项分布 + 答案 = 答案本身）
              if (finalScore)
                DuoButton(
                  label: '试题分析',
                  variant: DuoButtonVariant.outline,
                  icon: Icons.bar_chart_outlined,
                  onPressed: () => context.push(
                    AppRoutes.paperAnalysisOf(attempt.paperId),
                    extra: paper.title,
                  ),
                ),
              SizedBox(height: AppMetrics.gapXl.r),
              Text(
                finalScore ? '逐题得分' : (revealed ? '逐题复盘' : '逐题作答'),
                style: AppTextStyles.sectionTitle(context),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(
                finalScore
                    ? '已经出分，题目下方给出标准答案'
                    : revealed
                      ? '客观题标准答案已给出；简答题等老师阅卷后显示'
                      : '老师判完卷后，这里会显示每一题的得分与标准答案',
                style: AppTextStyles.caption(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppMetrics.gapMd.r),
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(height: AppMetrics.gapMd.r),
                FadeSlideIn(
                  order: i,
                  child: ExamReviewCard(
                    number: i + 1,
                    item: items[i],
                    record: answers[items[i].id],
                    revealed: revealed,
                    stat: stats[items[i].id],
                  ),
                ),
              ],
              SizedBox(height: AppMetrics.gapXl.r),
              ExamResultFooter(attempt: attempt, paper: paper),
            ],
          ),
        ),
      ],
    );
  }
}

