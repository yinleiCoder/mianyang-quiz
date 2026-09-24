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
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_result_summary.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_review_card.dart';
import 'package:provider/provider.dart';

class ExamResultPage extends StatefulWidget {
  const ExamResultPage({super.key, required this.attemptId});

  final String attemptId;

  @override
  State<ExamResultPage> createState() => _ExamResultPageState();
}

class _ExamResultPageState extends State<ExamResultPage> {
  AsyncValue<ExamSnapshot> _state = const AsyncLoading();

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
      setState(() => _state = AsyncData(snapshot));
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
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
          builder: (snapshot) => _Body(snapshot: snapshot),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.snapshot});

  final ExamSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final attempt = snapshot.attempt;
    final paper = snapshot.paper;
    final revealed = attempt.statusValue.isFinal;
    final answers = snapshot.answersByItem;
    final items = paper.items;

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        MaxWidthBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExamResultSummary(attempt: attempt, title: paper.title),
              SizedBox(height: AppMetrics.gapMd.r),
              // 成绩榜入口就放在成绩旁边：看完分数最想知道的就是"我这分在班里算什么水平"。
              // 卷名随 extra 带过去，榜页标题不用等一次加载。
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
              // 试题分析：每题全班答得怎么样（选项分布 + 谁选了什么）。
              // **只在已出分时给入口**——没出分时服务端会拒（选项分布 + 标准答案 = 答案本身）。
              if (revealed)
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
                revealed ? '逐题得分' : '逐题作答',
                style: AppTextStyles.sectionTitle(context),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(
                revealed
                    ? '已经出分，题目下方给出标准答案'
                    : '老师判完卷后，这里会显示每一题的得分与标准答案',
                style: AppTextStyles.caption(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppMetrics.gapMd.r),
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(height: AppMetrics.gapMd.r),
                ExamReviewCard(
                  number: i + 1,
                  item: items[i],
                  record: answers[items[i].id],
                  revealed: revealed,
                ),
              ],
              SizedBox(height: AppMetrics.gapXl.r),
              _Footer(attempt: attempt, paper: paper),
            ],
          ),
        ),
      ],
    );
  }
}

/// 交卷时间与卷面信息。放最后：看完成绩与逐题之后，才是"这场是什么时候考的"。
class _Footer extends StatelessWidget {
  const _Footer({required this.attempt, required this.paper});

  final ExamAttempt attempt;
  final ExamPaper paper;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lines = <String>[
      if (attempt.submittedAt != null)
        '交卷时间：${Formatters.dateTime(attempt.submittedAt)}',
      if (attempt.gradedAt != null)
        '出分时间：${Formatters.dateTime(attempt.gradedAt)}',
      '科目：${paper.subjectLabel?.trim().isNotEmpty ?? false ? paper.subjectLabel! : '—'}',
      '满分：${Formatters.score(paper.totalScore)} 分 · 限时 ${paper.durationMinutes} 分钟',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Padding(
            padding: EdgeInsets.only(bottom: AppMetrics.gapXs.r),
            child: Text(
              line,
              style: AppTextStyles.caption(context)
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}
