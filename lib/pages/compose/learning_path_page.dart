// AI 学习路径：掌握度画像 + BKT 推荐练习 + 专项练题/到期复习入口。
//
// 页面放在 compose 模块内，是为了复用同模块的 startPracticeFlow；放到
// pages/practice 会触发架构守卫的跨模块 import（practice → compose）。
//
// 三个入口都走现有链路：
//   · 专项练题：QuestionFilter(nodeId/tagId) → start_practice_session（原逻辑）；
//   · 到期复习：推荐 RPC 的 review 模式 → setPickedQuestions → startPracticeFlow；
//   · 推荐练习：推荐 RPC 的 balanced 模式 → setPickedQuestions → startPracticeFlow。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/compose/start_practice_flow.dart';
import 'package:mianyang_quiz/pages/compose/widgets/learning_stage_card.dart';
import 'package:mianyang_quiz/pages/compose/widgets/mastery_overview_card.dart';
import 'package:mianyang_quiz/pages/compose/widgets/nothing_due_card.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class _LearningData {
  const _LearningData({required this.profile, required this.plan});

  final BktProfile profile;
  final LearningPlan plan;
}

class LearningPathPage extends StatefulWidget {
  const LearningPathPage({super.key});

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> with RouteAware {
  AsyncValue<_LearningData> _state = const AsyncLoading();
  double? _previousOverall;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// 从练习页返回时重拉：BKT 的掌握度已经因为刚才的作答变了。
  @override
  void didPopNext() => _load();

  Future<void> _load() async {
    final previous = _state is AsyncData<_LearningData>
        ? (_state as AsyncData<_LearningData>).value.profile.overallMastery
        : _previousOverall;
    setState(() => _state = const AsyncLoading());
    try {
      final repository = context.read<LearningRepository>();
      final (profile, plan) = await (
        repository.fetchProfile(),
        repository.fetchRecommendedPractice(limit: 20),
      ).wait;
      if (!mounted) return;
      setState(() {
        _previousOverall = previous;
        _state = AsyncData(_LearningData(profile: profile, plan: plan));
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  Future<void> _startPicked(List<String> ids) async {
    if (ids.isEmpty) return;
    final draft = context.read<PracticeDraftStore>();
    draft.setPickedQuestions(ids);
    // push 而不是 replace：练习完回到本页，RouteAware 会重拉掌握度。
    await startPracticeFlow(context, draft: draft, replace: false);
  }

  Future<void> _startNode(String? nodeId, String? tagId) async {
    final draft = context.read<PracticeDraftStore>();
    draft.startFrom(
      source: PracticeSource.all,
      filter: QuestionFilter(nodeId: nodeId, tagId: tagId),
    );
    await startPracticeFlow(context, draft: draft, replace: false);
  }

  Future<void> _startReview() async {
    try {
      final repository = context.read<LearningRepository>();
      final plan = await repository.fetchRecommendedPractice(limit: 20, mode: 'review');
      if (!mounted) return;
      if (plan.itemIds.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('今天没有到期该复习的题')));
        return;
      }
      await _startPicked(plan.itemIds);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapError(error).message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 学习路径')),
      body: AsyncView<_LearningData>(
        state: _state,
        loadingMessage: '正在算你的掌握度…',
        onRetry: _load,
        builder: (data) {
          // 少于 10 题时 BKT 基本只有先验，不该假装已经懂这个学生。
          final cold = data.profile.coldStart || data.profile.itemsCount < 10;
          return ListView(
            padding: EdgeInsets.all(AppMetrics.pagePadding.r),
            children: [
              MasteryOverviewCard(
                profile: data.profile,
                previousOverall: _previousOverall,
                onPracticeNode: (nodeId) => _startNode(nodeId, null),
                onPracticeTag: (tagId) => _startNode(null, tagId),
              ),
            SizedBox(height: AppMetrics.gapMd.r),
            DuoButton(
              label: '到期复习（今天）',
              icon: Icons.event_repeat_outlined,
              variant: DuoButtonVariant.outline,
              onPressed: _startReview,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            if (data.plan.nothingDue)
              NothingDueCard(plan: data.plan)
            else ...[
              Text(
                cold ? '起步诊断（AI 推荐）' : 'AI 推荐练习',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              ...data.plan.stages.map(
                (stage) => Padding(
                  padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
                  child: LearningStageCard(
                    stage: stage,
                    onStart: () => _startPicked(
                      stage.items.map((item) => item.questionId).toList(),
                    ),
                  ),
                ),
              ),
            ],
            ],
          );
        },
      ),
    );
  }
}

