// 练习会话结束之后的行为：不许再答、交卷不许重发。
//
// 为什么值得测：线上 24 小时窗口里，307 次交卷有 106 次、5924 次单题提交有 140 次
// 报的都是服务端同一个守卫（只有 status = 'active' 的会话才接受提交）。
// 成因在客户端：已作废/已交卷的会话照样能打开并作答，**本地判分还照常显示对错**，
// 用户于是白答一整场，直到交卷才被告知「本次练习已交卷或已作废」。
// 这里钉住三个不许退回去的点：
//   · 打开一场已结束的练习 → 直接进结束态，一道题不渲染、一次提交都不发；
//   · 作答途中会话在别处结束 → 回查认得出来，之后的交卷不再打出去；
//   · 连点交卷 → 只发一次（重发的那次必被拒，用户会看到"交卷失败"）。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
// go_router 也导出一个 Block（on_enter 的），与题面模型的 Block 撞名
import 'package:go_router/go_router.dart' hide Block;
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_stage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('打开一场已作废的练习：认得出结束，且一道题都不提交', () async {
    final repo = _FakePracticeRepository();
    final runner = _runner(repo, status: 'abandoned');

    expect(runner.ended, isNotNull, reason: '已作废的会话必须被认出来');

    // 给当前题一个草稿：没有它，submitAll 本来就会跳过，测不出"拒绝提交"
    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.submitAll();
    expect(repo.submitCalls, 0, reason: '会话结束后一次提交都不该发');

    expect(await runner.finish(), isNull, reason: '结束的会话没有成绩可给');
    expect(repo.finishCalls, 0, reason: '交卷请求不该发出去——服务端必然拒');
  });

  test('作答途中会话在别处结束：回查认得出来并通知界面', () async {
    final repo = _FakePracticeRepository();
    final runner = _runner(repo, status: 'active');
    expect(runner.ended, isNull, reason: '打开时还是进行中');

    var notified = 0;
    runner.addListener(() => notified++);

    // 另一台设备开始了新练习 → 服务端把这一场静默作废
    repo.session = _snapshot(status: 'abandoned');
    await runner.syncEndedState();

    expect(runner.ended?.status, 'abandoned');
    expect(notified, greaterThan(0), reason: '界面要能据此换成结束态');
    expect(await runner.finish(), isNull);
    expect(repo.finishCalls, 0);
  });

  test('回查本身失败（断网）：保持原样，不误判成已结束', () async {
    final repo = _FakePracticeRepository(fetchFails: true);
    final runner = _runner(repo, status: 'active');

    await runner.syncEndedState();

    expect(runner.ended, isNull, reason: '拿不到结论就不要乱改界面');
    await runner.finish();
    expect(repo.finishCalls, 1, reason: '照常交卷，由上层显示错误');
  });

  test('断网时批量提交不逐题回查——不然整卷失败会变成两倍的失败请求', () async {
    final repo = _FakePracticeRepository(submitFails: true);
    final runner = _runner(
      repo,
      status: 'active',
      mode: PracticeMode.batch,
      itemCount: 2,
    );
    runner.setDraft(const ChoiceAnswer(['A']));
    runner.jumpTo(1);
    runner.setDraft(const ChoiceAnswer(['A']));

    await runner.submitAll();

    expect(repo.submitCalls, 2, reason: '两道题都要试着交（单题失败不中断整卷）');
    expect(repo.fetchCalls, 0, reason: '断网时回查也查不通，只会把失败请求翻倍');
  });

  testWidgets('练习页打开一场已交卷的练习：显示结束态，题目一个字都不露', (tester) async {
    final repo = _FakePracticeRepository();
    await _pumpStage(tester, _runner(repo, status: 'submitted'));

    expect(find.text('本次练习已交卷'), findsOneWidget);
    expect(find.text('查看成绩'), findsOneWidget);
    // 题面与作答控件都不该在：能答就等于白答
    expect(find.text('第 1 题'), findsNothing);
    expect(find.text('检查'), findsNothing);
    expect(find.text('交卷'), findsNothing);
  });

  testWidgets('桌面 1280×800 下结束态不出现布局异常', (tester) async {
    final repo = _FakePracticeRepository();
    // 宽屏那条：面板里的按钮是 expand 的，套在空态的 Column 里一旦拿不到宽度上限就会炸
    await _pumpStage(
      tester,
      _runner(repo, status: 'abandoned'),
      size: const Size(1280, 800),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('本次练习已作废'), findsOneWidget);
    expect(find.text('重新开始一次练习'), findsOneWidget);
  });

  testWidgets('连点交卷只发一次请求，且在途时按钮转圈', (tester) async {
    final repo = _FakePracticeRepository();
    final runner = _runner(repo, status: 'active', mode: PracticeMode.batch);
    repo.finishGate = Completer<void>();

    await _pumpStage(tester, runner, router: true);

    await tester.tap(find.text('交卷'));
    await tester.pump();
    // 第一次交卷还在途时再点一次：防重入要挡住它
    await tester.tap(find.text('交卷'));
    await tester.pump();

    expect(repo.finishCalls, 1, reason: '重发的那次必然被服务端拒，不能让用户看到"交卷失败"');
    expect(find.byType(CircularProgressIndicator), findsOneWidget, reason: '要知道点到了');

    repo.finishGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('结果页'), findsOneWidget, reason: '交卷成功后换到结果页');
  });
}

PracticeRunner _runner(
  _FakePracticeRepository repo, {
  required String status,
  PracticeMode mode = PracticeMode.instant,
  int itemCount = 1,
}) => PracticeRunner(
  repository: repo,
  snapshot: _snapshot(status: status, itemCount: itemCount),
  mode: mode,
);

Future<void> _pumpStage(
  WidgetTester tester,
  PracticeRunner runner, {
  bool router = false,
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final stage = Scaffold(body: SafeArea(child: PracticeStage(runner: runner)));

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      // 整个 App 必须在 builder 里搭：AppTheme 用了 .r（ScreenUtil），
      // 在 ScreenUtilInit 跑起来之前取主题会抛 LateInitializationError
      builder: (context, _) => ChangeNotifierProvider<SfxService>.value(
        // 舞台放音效要有 SfxService（测试环境没有音频通道，播放失败在服务里是静默的）
        value: SfxService(),
        // 交卷成功会 pushReplacement 去结果页，没有路由树会直接抛
        child: router
            ? MaterialApp.router(
                theme: AppTheme.light(),
                routerConfig: GoRouter(
                  initialLocation: '/practice/s1',
                  routes: [
                    GoRoute(
                      path: '/practice/:sessionId',
                      builder: (context, state) => stage,
                    ),
                    GoRoute(
                      path: '/practice/:sessionId/result',
                      builder: (context, state) =>
                          const Scaffold(body: Center(child: Text('结果页'))),
                    ),
                  ],
                ),
              )
            : MaterialApp(theme: AppTheme.light(), home: stage),
      ),
    ),
  );
  await tester.pump();
}

PracticeSessionSnapshot _snapshot({
  required String status,
  int itemCount = 1,
}) => PracticeSessionSnapshot(
  sessionId: 's1',
  source: 'all',
  status: status,
  totalCount: itemCount,
  answeredCount: status == 'active' ? 0 : itemCount,
  correctCount: status == 'active' ? 0 : itemCount,
  items: [
    for (var i = 1; i <= itemCount; i++)
      PracticeItem(
        seq: i,
        questionId: 'q$i',
        versionId: 'v$i',
        qtype: 'single_choice',
        content: QuestionContent(
          stem: [Block.text(text: '第 $i 题')],
          options: const [
            QuestionOption(key: 'A', label: [Block.text(text: '甲')]),
          ],
          answer: const ServerAnswer.choice(keys: ['A']),
        ),
      ),
  ],
);

/// 可控的练习仓储：本测试只用到会话读取、单题提交与交卷三处。
class _FakePracticeRepository extends PracticeRepository {
  _FakePracticeRepository({this.fetchFails = false, this.submitFails = false})
    : super(_client);

  // autoRefreshToken 必须关掉：它起的是周期定时器，flutter_test 会因为
  // 「widget 树销毁后仍有 pending timer」判失败（与 auth_pages_test 同一个坑）。
  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  /// 回查会话状态时返回的会话。
  PracticeSessionSnapshot session = _snapshot(status: 'active');

  /// 回查直接失败（模拟断网）。
  final bool fetchFails;

  /// 单题提交直接失败（模拟断网）。
  final bool submitFails;

  /// 非空时交卷请求会卡在这里，直到测试放行——用来观察"在途"那一刻的界面。
  Completer<void>? finishGate;

  int fetchCalls = 0;
  int submitCalls = 0;
  int finishCalls = 0;

  @override
  Future<PracticeSessionSnapshot> fetchSession(String sessionId) async {
    fetchCalls++;
    if (fetchFails) throw const NetworkException();
    return session;
  }

  @override
  Future<SubmitResult> submitAnswer({
    required String sessionId,
    required String questionId,
    required SubmittedAnswer answer,
    int durationMs = 0,
    bool? selfMastered,
  }) async {
    submitCalls++;
    if (submitFails) throw const NetworkException();
    return const SubmitResult(isCorrect: true);
  }

  @override
  Future<FinishSummary> finishSession({
    required String sessionId,
    int? durationMs,
  }) async {
    finishCalls++;
    await finishGate?.future;
    return const FinishSummary(
      total: 1,
      answered: 1,
      correct: 1,
      wrong: 0,
      omitted: 0,
      accuracy: 1,
    );
  }
}
