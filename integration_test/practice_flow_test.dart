// 真实账号的练习写路径：开始练习 → 答一题 → 拿到**服务端**判定 → 收尾作废。
//
// ⚠ **这条会写生产库**，所以默认不跑：
//   · `start_practice_session` 建一行 practice_sessions，
//     并且会**静默作废该账号进行中的会话**（服务端每人只允许一套进行中）
//   · `submit_practice_answer` 写一行作答
//   · 用例**结束时不管成功失败**都会把会话作废掉（tearDown 里），不留"进行中"的壳
//   按 0069「当天练过的题当天不再发」，跑一次会消耗掉这个账号当天的题池。
//
// 要跑就在 config/test.local.json 里加 `"TEST_WRITE": true`：
//   flutter test integration_test/practice_flow_test.dart -d windows \
//     --dart-define-from-file=config/dev.json \
//     --dart-define-from-file=config/test.local.json
//
// **为什么只答一题就收**：这条要证明的是两个写 RPC 真的通
//（建会话、提交作答并拿回判定），不是把整卷点完。点完会多出
//「交卷」「成绩单」「逐题复盘」一堆分支，收益不抵脆弱度——
// 那些界面本身已有组件测试盯着。
//
// 只读的那条在 live_backend_test.dart，不需要 TEST_WRITE。

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/dependencies.dart';
import 'package:mianyang_quiz/pages/pages.dart';
import 'package:mianyang_quiz/pages/practice/widgets/batch_nav_bar.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_feedback_bar.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

import 'support/live_account.dart';

/// 组卷页底部那颗「开始练习」按钮。
///
/// **必须带上左括号**：这一页的 AppBar 标题也叫「开始练习」（compose_page.dart:65），
/// 用 `textContaining('开始练习')` 会先匹配到标题——点上去毫无反应，
/// 然后你会盯着"点了按钮却什么都没发生"发呆。按钮文案是
/// 「开始练习（最多 N 题）」或「开始练习（题库）」，都带括号。
///
/// 同时**限定在 ComposePage 子树内**：首页那颗「开始一次练习」还挂在树里
/// （IndexedStack 不销毁已访问的分支）。
final _startButton = find.descendant(
  of: find.byType(ComposePage),
  matching: find.textContaining('开始练习（'),
);

/// 把「开始练习」按钮滚进视野。
///
/// 组卷页的 body 是 `ListView`（**懒构建**），按钮是最后一个子项，
/// 首屏之外时它**根本没被创建**，`find` 找不到、`ensureVisible` 也没用
///（那个要求先有 element）。只能真的往下拖到它出现。
Future<void> _scrollToStartButton(WidgetTester tester) async {
  final scrollable = find
      .descendant(of: find.byType(ComposePage), matching: find.byType(Scrollable))
      .first;
  for (var i = 0; i < 15 && _startButton.evaluate().isEmpty; i++) {
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pump();
    await Future<void>.delayed(const Duration(milliseconds: 60));
  }
  await waitFor(tester, _startButton, what: '组卷页底部的「开始练习」按钮');
}

/// 点一个**弹出面板**上的按钮。
///
/// 面板有入场动画；`waitForAny` 一看到文字就返回，那时按钮还没落到最终位置，
/// 直接 `tap` 会点空（甚至点到遮罩把面板关掉）。先让动画走完再点，
/// 而且点的是 `DuoButton` 本身而不是里面那个 `Text`。
Future<void> _tapSheetButton(WidgetTester tester, String label) async {
  await tester.pump(const Duration(milliseconds: 600));
  await tester.tap(find.widgetWithText(DuoButton, label));
  await tester.pump();
}

/// 收尾：把该账号进行中的会话作废掉。
///
/// **注册成 tearDown**，这样用例中途失败也会跑——否则每失败一次就往库里
/// 留一个"进行中的会话"，下次进组卷页就弹「上次的练习还没做完」，
/// 让下一次运行走不同的分支，越跑越乱。
void _abandonOnExit(AppDependencies deps) {
  addTearDown(() async {
    try {
      final dashboard = await deps.statsRepository.fetchDashboard();
      final sessionId = dashboard.activeSession?.sessionId;
      if (sessionId != null) await deps.practiceRepository.abandonSession(sessionId);
    } catch (_) {
      // 收尾失败不该把已经验过的结论判成红
    }
  });
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('真实账号：开始练习 → 答一题 → 服务端判定', (tester) async {
    if (skipUnlessAccountConfigured()) return;
    if (!testWriteEnabled) {
      markTestSkipped(
        '未设置 TEST_WRITE —— 这条会往生产库写练习记录，并作废该账号进行中的会话。'
        '确认要跑就在 config/test.local.json 里加 "TEST_WRITE": true',
      );
      return;
    }

    final deps = await launchAndLogin(tester);
    _abandonOnExit(deps);

    // ---- 等首页学情真的回来 ----
    // `launchAndLogin` 只等到主壳出现，而**首页数据还在路上**：
    // 那时 AsyncView 显示的是转圈，ListView 里一个子项都没建，
    // 直接去点「开始一次练习」会报 "could not find any matching widgets"。
    await waitFor(tester, find.textContaining('你好，'), what: '首页学情加载完成');

    // ---- 进组卷页 ----
    await tester.tap(find.widgetWithText(DuoButton, '开始一次练习'));
    await tester.pump();
    await waitFor(tester, find.byType(ComposePage), what: '组卷页');

    // ---- 开一场 ----
    await _scrollToStartButton(tester);
    await tester.tap(_startButton);
    await tester.pump();

    // ---- 点下去有三种结局，一个都不能假设 ----
    final outcome = await waitForAny(tester, {
      'practice': find.byType(PracticePage),
      'active_session': find.text('上次的练习还没做完'),
      'nothing_due': find.textContaining('仍然加练'),
    }, what: '点了「开始练习」之后');

    switch (outcome) {
      case 'active_session':
        // 账号上还有没做完的会话。**选「继续」而不是「重新开始」**：
        // 目的只是进到练习页答题，没必要把已有进度毁掉。
        await _tapSheetButton(tester, '继续上次的练习');
        await waitFor(tester, find.byType(PracticePage), what: '继续上次练习后进入练习页');
      case 'nothing_due':
        // 今天的题都练完了。点「仍然加练」才会带 same_day 再发一批
        await _tapSheetButton(tester, '仍然加练（会重复今天练过的题）');
        await waitFor(tester, find.byType(PracticePage), what: '加练后进入练习页');
      case 'practice':
        break;
    }

    // ---- 答一题，拿到服务端判定 ----
    //
    // **不能假设进来时是个"没答过的题"**：走「继续上次的练习」时，
    // 服务端会把已答的题的判定一并恢复回来，那这题一进来就带着反馈条、
    // 根本没有「检查」可点。所以这里是个有界循环：已判过就翻到下一题，没判过就答它。
    var proved = false;
    for (var attempt = 1; attempt <= 5 && !proved; attempt++) {
      final state = await waitForAny(tester, {
        'check': find.widgetWithText(DuoButton, '检查'),
        'feedback': find.byType(PracticeFeedbackBar),
        'batch': find.byType(BatchNavBar),
      }, what: '练习页底部操作条（第 $attempt 次尝试）');

      expect(
        state,
        isNot('batch'),
        reason: '草稿默认是即时练习；出现批量模式说明默认值或界面分支变了',
      );

      if (state == 'feedback') {
        // 这题进来时就已判过 —— 翻到下一题
        await _tapSheetButton(tester, _hasContinue() ? '继续' : '完成');
        await tester.pump();
        continue;
      }

      await waitFor(tester, find.byType(OptionTile), what: '题目选项渲染出来');
      await tester.tap(find.byType(OptionTile).first);
      await tester.pump();

      // **即时练习是「选完立刻出对错」**（组卷页自己的原话）——
      // 选择题一点选项就提交了，这时「检查」已经消失（它变成了反馈条）。
      // 「检查」只留给填空/主观这类需要显式提交的题型。
      // 所以选完之后两种都可能：已判 → 直接等反馈条；未判 → 再点一下「检查」。
      final afterPick = await waitForAny(tester, {
        'feedback': find.byType(PracticeFeedbackBar),
        'check': find.widgetWithText(DuoButton, '检查'),
      }, what: '选完之后（第 $attempt 次尝试）');

      if (afterPick == 'check') {
        await tester.tap(find.widgetWithText(DuoButton, '检查'));
        await tester.pump();
      }

      // 反馈条**只在服务端返回判定之后**才出现（本地判分只是抢先显示，
      // 见 utils/answer_grader.dart 的文件头）。它出现 =
      // submit_practice_answer 这条路真的通了。
      await waitFor(tester, find.byType(PracticeFeedbackBar), what: '服务端判定返回');
      proved = true;
    }

    expect(proved, isTrue, reason: '试了 5 次都没能走到「提交作答并拿到服务端判定」');
    expect(tester.takeException(), isNull);
  });
}

/// 反馈条在最后一题给的是「完成」（= 交卷），其余给「继续」。
bool _hasContinue() =>
    find.widgetWithText(DuoButton, '继续').evaluate().isNotEmpty;
