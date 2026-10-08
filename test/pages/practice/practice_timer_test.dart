// 练习计时器的 widget 测试：显示已花费时间、每秒真的在跳、时间倒流不倒扣、**能暂停**。
//
// 为什么值得测：计时器"看起来在动"很容易骗过人——定时器没接上、或者只算了一次
// 就再也不更新，界面第一眼都长得一样。这里用注入的假时钟（不是真实时间）走一遍，
// 才能确定它每秒读的是"runner 记的已过时长"，而不是一个冻住的初值。
//
// 暂停那几条是重点：暂停期间**显示的数字与交卷送上去的用时必须是同一个数**，
// 两者一旦各算各的，就会出现"顶栏 12 分钟、成绩单 25 分钟"（都"没错"，只是口径不同）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_timer.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_top_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  _sequentialTopBarTests();
  final start = DateTime(2026, 9, 16, 10, 0, 0);

  testWidgets('初始显示起算点到现在的时长', (tester) async {
    await _pump(tester, start: start, now: start.add(const Duration(seconds: 42)));

    expect(find.text('00:42'), findsOneWidget);
    expect(find.byType(PracticeTimer), findsOneWidget);
  });

  testWidgets('每秒刷新一次（假时钟前进，界面跟着变）', (tester) async {
    var now = start;
    await _pump(tester, start: start, nowOf: () => now, pump: false);

    expect(find.text('00:00'), findsOneWidget);

    now = start.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);

    now = start.add(const Duration(minutes: 2, seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('02:03'), findsOneWidget);
  });

  testWidgets('超过一小时显示 时:分:秒', (tester) async {
    await _pump(tester, start: start, now: start.add(const Duration(hours: 1, minutes: 2, seconds: 3)));

    expect(find.text('1:02:03'), findsOneWidget);
  });

  testWidgets('起算点在将来（时钟偏差）时显示 00:00，不出现负数', (tester) async {
    await _pump(tester, start: start, now: start.subtract(const Duration(seconds: 5)));

    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('点一下暂停：显示冻住，时间照样流逝也不涨', (tester) async {
    var now = start;
    final runner = await _pump(tester, start: start, nowOf: () => now, pump: false);

    now = start.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:30'), findsOneWidget);

    await tester.tap(find.byType(PracticeTimer));
    await tester.pump();
    expect(runner.isPaused, isTrue);

    // 暂停期间过了 5 分钟：显示必须一动不动（恢复后也不会一次跳过去）
    now = start.add(const Duration(minutes: 5, seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:30'), findsOneWidget);
    expect(find.text('已暂停'), findsOneWidget);
  });

  testWidgets('再点一下继续：暂停的那段既不算进显示，也不算进交卷用时', (tester) async {
    var now = start;
    final runner = await _pump(tester, start: start, nowOf: () => now, pump: false);

    // 走 30 秒 → 暂停 5 分钟 → 继续走 10 秒
    now = start.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byType(PracticeTimer));
    await tester.pump();
    now = start.add(const Duration(minutes: 5, seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byType(PracticeTimer));
    await tester.pump();
    expect(runner.isPaused, isFalse);
    now = start.add(const Duration(minutes: 5, seconds: 40));
    await tester.pump(const Duration(seconds: 1));

    // 40 秒 = 30 + 10，中间那 5 分钟一分钟都不算
    expect(find.text('00:40'), findsOneWidget);
    expect(runner.elapsed, const Duration(seconds: 40));
    expect(find.text('已暂停'), findsNothing);
  });

  testWidgets('暂停态在界面上是看得出来的：图标变播放键、有 tooltip 与语义标签', (tester) async {
    // 读语义标签要先打开语义树（读屏用户看到的就是这句话）。
    // 句柄必须在用例**体内**释放：验收发生在 addTearDown 之前。
    final semantics = tester.ensureSemantics();

    var now = start;
    final runner = await _pump(tester, start: start, nowOf: () => now, pump: false);

    // 计时中：暂停键
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    expect(find.byTooltip('暂停计时'), findsOneWidget);

    now = start.add(const Duration(seconds: 5));
    await tester.tap(find.byType(PracticeTimer));
    await tester.pump();

    expect(find.byIcon(Icons.pause_rounded), findsNothing);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byTooltip('继续计时'), findsOneWidget);
    // 读屏用户听到的也要是"已暂停"（语义标签在计时器自己身上）
    expect(find.bySemanticsLabel(RegExp('已暂停')), findsOneWidget);
    expect(runner.isPaused, isTrue);
    semantics.dispose();
  });

  testWidgets('暂停期间不空转：不再每秒重建（定时器已停）', (tester) async {
    var now = start;
    final runner = await _pump(tester, start: start, nowOf: () => now, pump: false);

    now = start.add(const Duration(seconds: 10));
    await tester.tap(find.byType(PracticeTimer));
    await tester.pump();
    expect(runner.isPaused, isTrue);

    // 假时间前进 3 分钟：若定时器没停，这里会因为有周期性任务而抛
    // 「A Timer is still pending even after the widget tree was disposed」。
    now = start.add(const Duration(minutes: 3, seconds: 10));
    await tester.pump(const Duration(minutes: 3));
    expect(find.text('00:10'), findsOneWidget);
  });

  testWidgets('顶栏里计时排在题号右侧', (tester) async {
    await _pumpTopBar(tester, start: start);

    final count = tester.getRect(find.text('7/20'));
    final timer = tester.getRect(find.byType(PracticeTimer));
    expect(timer.left, greaterThan(count.right), reason: '计时要在题号右边');
  });

  testWidgets('窄屏（有答题卡按钮）时计时仍在题号与按钮之间', (tester) async {
    await _pumpTopBar(tester, start: start, withAnswerSheet: true);

    final count = tester.getRect(find.text('7/20'));
    final timer = tester.getRect(find.byType(PracticeTimer));
    final sheet = tester.getRect(find.byIcon(Icons.grid_view_rounded));
    expect(timer.left, greaterThan(count.right));
    expect(timer.right, lessThan(sheet.left));
  });
}

/// 测试用的 runner：仓储只是为了让构造器满意，本文件一条网络都不发。
PracticeRunner _runner(DateTime Function() clock, {PracticeMode mode = PracticeMode.instant}) => PracticeRunner(
  repository: PracticeRepository(
    SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    ),
  ),
  snapshot: _snapshot,
  mode: mode,
  clock: clock,
);

final _snapshot = PracticeSessionSnapshot(
  sessionId: 's1',
  source: 'all',
  status: 'active',
  items: [
    for (var i = 0; i < 3; i++)
      PracticeItem(
        seq: i + 1,
        questionId: 'q$i',
        versionId: 'v$i',
        qtype: 'single_choice',
        content: QuestionContent(stem: [Block.text(text: '第 ${i + 1} 题')]),
      ),
  ],
);

Future<PracticeRunner> _pumpTopBar(
  WidgetTester tester, {
  required DateTime start,
  bool withAnswerSheet = false,
  PracticeMode mode = PracticeMode.instant,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final runner = _runner(() => start, mode: mode);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PracticeTopBar(
            index: 7,
            total: 20,
            progress: 0.35,
            runner: runner,
            onExit: () {},
            onOpenAnswerSheet: withAnswerSheet ? () {} : null,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return runner;
}

/// 建一个计时器并把它挂出来。
///
/// **起算点是 runner 的构造时刻**（不是传进去的参数），所以这里先用 [start] 造 runner，
/// 再把假时钟拨到 [now]——直接拿 now 去构造的话，已过时长恒为 0，测的就不是计时器了。
Future<PracticeRunner> _pump(
  WidgetTester tester, {
  required DateTime start,
  DateTime? now,
  DateTime Function()? nowOf,
  bool pump = true,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  var current = start;
  final runner = _runner(nowOf ?? () => current);
  if (nowOf == null && now != null) current = now;
  addTearDown(runner.dispose);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: PracticeTimer(runner: runner))),
      ),
    ),
  );
  if (pump) await tester.pump();
  return runner;
}

// 顺序练习（课堂讲练）在顶栏多挂一枚「不计分」标。顶栏是 390 宽下一行摆完的
// （× + 进度条 + 题号 + 计时 + 答题卡），多一枚标就有挤爆的风险，
// 而 RenderFlex 溢出在真机上只是黄黑条纹，测试里才是一条硬失败。
void _sequentialTopBarTests() {
  testWidgets('顺序练习的顶栏显示「不计分」，且不溢出', (tester) async {
    await _pumpTopBar(
      tester,
      start: DateTime(2026, 10, 8, 15, 0, 0),
      withAnswerSheet: true,
      mode: PracticeMode.sequential,
    );

    expect(find.text('不计分'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: '390 宽下顶栏不许溢出');
  });

  testWidgets('即时练习顶栏不显示「不计分」', (tester) async {
    await _pumpTopBar(tester, start: DateTime(2026, 10, 8, 15, 0, 0));

    expect(find.text('不计分'), findsNothing);
  });
}
