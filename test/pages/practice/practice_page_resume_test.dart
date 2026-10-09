// 续练必须沿用**会话自己的模式**，不能信路由给的默认值（0095）。
//
// 为什么值得单独钉住：课堂讲练（顺序练习）的会话 scored = false，0090 定死了
// 「一轮里一个答案都不提交」——错题本 / 正确率 / 遗忘曲线 / 今日额度全部派生自
// practice_answers，不写就是干净。
//
// 而「继续练习」的几个入口（首页进行中卡片、练习记录）都是直接 push 路由、
// **不带 extra 的**，路由于是按 PracticeMode.instant 兜底。于是在 0095 之前：
// 教师中途退出讲练 → 从首页点「继续练习」→ 页面当成即时练习重开 →
// **每答一题都真的提交到服务端**。表现完全是静默的：没有任何地方报错，
// 只是课堂讲练的作答悄悄灌进了学生的个人统计。
//
// 这里钉的就是这条：路由说 instant，但会话说 scored=false，页面必须按顺序练习跑。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/practice/practice_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 一个占位客户端：本用例不发真请求，它只为满足仓储的构造参数。
/// autoRefreshToken 必须关——它起周期定时器，flutter_test 会判"仍有 pending timer"。
SupabaseClient _client() => SupabaseClient(
  'https://example.supabase.co',
  'sb_publishable_x',
  authOptions: const AuthClientOptions(autoRefreshToken: false),
);

void main() {
  testWidgets('续练一场不计分的课堂讲练：按顺序练习重开，判题不发请求', (tester) async {
    final repo = _FakePracticeRepository(scored: false, client: _client());
    // 关键：路由给的是默认值 instant（模拟"继续练习"入口没带 extra）
    await _pumpPage(tester, repo, mode: PracticeMode.instant);

    expect(find.text('不计分'), findsOneWidget, reason: '顶栏要标出这是不计分的讲练');

    await _answerAndCheck(tester);

    expect(repo.submitCalls, 0, reason: '0090：讲练一轮里一个答案都不提交');
  });

  testWidgets('对照：续练一场计分的练习，仍按路由给的即时模式走', (tester) async {
    final repo = _FakePracticeRepository(scored: true, client: _client());
    await _pumpPage(tester, repo, mode: PracticeMode.instant);

    expect(find.text('不计分'), findsNothing);

    await _answerAndCheck(tester);

    expect(repo.submitCalls, 1, reason: '即时练习照旧逐题提交');
  });
}

/// 点一个选项。单选题在即时类模式下是**选中即判**（见 practice_stage._onAnswerChanged），
/// 所以这一步就会走完整的判定链路：即时练习在此提交，顺序练习只本地判。
Future<void> _answerAndCheck(WidgetTester tester) async {
  await tester.tap(find.text('甲'));
  await tester.pump();
  await tester.pump();
}

Future<void> _pumpPage(
  WidgetTester tester,
  _FakePracticeRepository repo, {
  required PracticeMode mode,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      // 桌面端要关缩放（见 AGENTS.md 四·屏幕适配）；测试里关掉缩放系数才稳定为 1
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MultiProvider(
        providers: [
          Provider<PracticeRepository>.value(value: repo),
          ChangeNotifierProvider<SfxService>.value(
            // 舞台放音效要有它（测试环境没有音频通道，播放失败在服务里是静默的）
            value: SfxService(),
          ),
          ChangeNotifierProvider<FavoriteStore>.value(
            value: FavoriteStore(FavoriteRepository(repo.client)),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: PracticePage(
            sessionId: 's1',
            mode: mode,
            shuffleOptions: false,
          ),
        ),
      ),
    ),
  );
  // fetchSession 是异步的：第一次 pump 建树，第二次让它落地（**不能 pumpAndSettle**，
  // 顶栏计时器是 Timer.periodic，永远settle不下来）
  await tester.pump();
  await tester.pump();
}

class _FakePracticeRepository extends PracticeRepository {
  _FakePracticeRepository({required this.scored, required this.client})
    : super(client);

  final bool scored;

  /// 同一个客户端也给 FavoriteRepository 用（本用例不点收藏，占位即可）。
  final SupabaseClient client;

  int submitCalls = 0;

  @override
  Future<PracticeSessionSnapshot> fetchSession(String sessionId) async =>
      PracticeSessionSnapshot(
        sessionId: sessionId,
        source: 'all',
        status: 'active',
        scored: scored,
        items: const [
          PracticeItem(
            seq: 1,
            questionId: 'q1',
            versionId: 'v1',
            qtype: 'single_choice',
            content: QuestionContent(
              stem: [Block.text(text: '中国的首都是哪里？')],
              options: [
                QuestionOption(key: 'A', label: [Block.text(text: '甲')]),
                QuestionOption(key: 'B', label: [Block.text(text: '乙')]),
              ],
              answer: ServerAnswer.choice(keys: ['A']),
            ),
          ),
        ],
      );

  @override
  Future<SubmitResult> submitAnswer({
    required String sessionId,
    required String questionId,
    required SubmittedAnswer answer,
    int durationMs = 0,
    bool? selfMastered,
  }) async {
    submitCalls++;
    return const SubmitResult(isCorrect: true);
  }
}
