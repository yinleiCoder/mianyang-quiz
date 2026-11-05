// AI 学习路径页：画像、阶段卡、冷启动与"今天练完了"。
//
// 只测渲染与加载（不点"开始"）：点击会进入 startPracticeFlow，那条链路
// 需要 DashboardStore/PracticeRepository 的完整假实现，属于练习流程测试的职责。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/pages.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeLearning extends LearningRepository {
  _FakeLearning(this.profile, this.plan)
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'test-anon-key',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  final BktProfile profile;
  final LearningPlan plan;

  @override
  Future<BktProfile> fetchProfile({int days = 365, int maxItems = 600}) async => profile;

  @override
  Future<LearningPlan> fetchRecommendedPractice({
    int limit = 20,
    String? nodeId,
    String mode = 'balanced',
  }) async => plan;
}

BktProfile _profile({bool cold = false}) => BktProfile(
  coldStart: cold,
  model: const {'name': 'BKT', 'p_t': 0.15, 'p_s': 0.10},
  overallMastery: 0.42,
  nodes: const [
    BktNode(
      nodeId: 'n1',
      nodeName: '办公应用',
      mastery: 0.35,
      attemptedItems: 20,
      totalItems: 100,
      coverage: 0.2,
    ),
  ],
  tags: const [
    BktTag(
      tagId: 't1',
      tagName: 'excel',
      mastery: 0.3,
      attempts: 8,
      items: 5,
      insufficient: false,
    ),
  ],
  itemsCount: 20,
);

LearningPlan _plan({bool cold = false, bool nothingDue = false}) => LearningPlan(
  status: nothingDue ? 'nothing_due' : 'ok',
  coldStart: cold,
  nextDueAt: nothingDue ? DateTime(2026, 11, 3) : null,
  overallMastery: 0.42,
  itemsConsidered: 100,
  limit: 20,
  stages: nothingDue
      ? const []
      : const [
          LearningStage(
            key: 'foundation',
            title: '补齐薄弱基础',
            description: '掌握度 < 0.60，先补最薄的一块',
            items: [
              RecommendedItem(
                questionId: 'q1',
                versionId: 'v1',
                qtype: 'single_choice',
                difficulty: 2,
                nodeName: '办公应用',
                pMastery: 0.3,
                pCorrect: 0.6,
                infoGain: 0.1,
                score: 0.8,
                reasonCode: 'weak_node',
              ),
              RecommendedItem(
                questionId: 'q2',
                versionId: 'v2',
                qtype: 'true_false',
                difficulty: 1,
                nodeName: '办公应用',
                pMastery: 0.35,
                pCorrect: 0.65,
                infoGain: 0.08,
                score: 0.7,
                reasonCode: 'new_item',
              ),
            ],
          ),
        ],
  itemIds: nothingDue ? const [] : const ['q1', 'q2'],
);

Future<void> _pump(
  WidgetTester tester, {
  required LearningPlan plan,
  bool cold = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MultiProvider(
        providers: [
          Provider<LearningRepository>.value(
            value: _FakeLearning(_profile(cold: cold), plan),
          ),
          ChangeNotifierProvider<PracticeDraftStore>(create: (_) => PracticeDraftStore()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const LearningPathPage()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('画像 + 推荐阶段 + 三个入口', (tester) async {
    await _pump(tester, plan: _plan());

    expect(find.text('掌握度画像'), findsOneWidget);
    // 标题与进度条标签各一次
    expect(find.text('42%'), findsNWidgets(2));
    expect(find.text('办公应用'), findsWidgets);
    expect(find.text('补齐薄弱基础'), findsOneWidget);
    expect(find.text('开始这 2 道'), findsOneWidget);
    expect(find.text('到期复习（今天）'), findsOneWidget);
    expect(find.text('专项练题'), findsNWidgets(2));
  });

  testWidgets('冷启动显示起步诊断', (tester) async {
    await _pump(tester, plan: _plan(cold: true), cold: true);

    expect(find.text('起步诊断（AI 推荐）'), findsOneWidget);
    expect(find.textContaining('起步诊断'), findsWidgets);
  });

  testWidgets('今天练完了显示下一道到期时间', (tester) async {
    await _pump(tester, plan: _plan(nothingDue: true));

    expect(find.text('今天该练的都练完了'), findsOneWidget);
    expect(find.textContaining('11 月 3 日'), findsOneWidget);
    expect(find.text('补齐薄弱基础'), findsNothing);
  });
}
