// 即时练习的自动跳题规则（用户 2026-10-24）。
//
// 钉住四条：
//   · 答对后停 1 秒自动进下一题；
//   · 答错不自动跳（由用户自己点「继续」）；
//   · 用户手动切题后，计时器不再抢页面（回到刚答对的题看解析时尤其重要）；
//   · 最后一题不自动跳（那里要交卷，不是翻页）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/practice/state/auto_advance.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('答对后 1 秒自动进下一题', (tester) async {
    final repo = _FakePracticeRepository(correct: true);
    final runner = _runner(repo, itemCount: 2);
    final auto = AutoAdvanceController(runner);
    addTearDown(auto.dispose);

    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.check();
    auto.schedule(0);

    await tester.pump(const Duration(milliseconds: 999));
    expect(runner.index, 0, reason: '还没到 1 秒');

    await tester.pump(const Duration(milliseconds: 1));
    expect(runner.index, 1, reason: '1 秒后自动进入下一题');
  });

  testWidgets('答错不自动跳', (tester) async {
    final repo = _FakePracticeRepository(correct: false);
    final runner = _runner(repo, itemCount: 2);
    final auto = AutoAdvanceController(runner);
    addTearDown(auto.dispose);

    runner.setDraft(const ChoiceAnswer(['B']));
    await runner.check();
    // 阶段代码只会在 verdict == true 时调 schedule；这里模拟"误调"也不该跳，
    // 因为 controller 触发前会再核对一次 verdict。
    auto.schedule(0);

    await tester.pump(const Duration(seconds: 2));
    expect(runner.index, 0);
  });

  testWidgets('手动切题后计时器被取消（回到答对的题看解析不受影响）', (tester) async {
    final repo = _FakePracticeRepository(correct: true);
    final runner = _runner(repo, itemCount: 3);
    final auto = AutoAdvanceController(runner);
    addTearDown(auto.dispose);

    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.check();
    auto.schedule(0);

    // 用户点答题卡跳到第 3 题：计时器应取消
    runner.jumpTo(2);
    await tester.pump(const Duration(seconds: 2));
    expect(runner.index, 2, reason: '用户已经自己切走了，不能再被自动跳走');

    // 再跳回刚答对的第 1 题：不该再有任何计时器
    runner.jumpTo(0);
    await tester.pump(const Duration(seconds: 2));
    expect(runner.index, 0, reason: '回来看解析时不应被抢走');
  });

  testWidgets('最后一题不自动跳', (tester) async {
    final repo = _FakePracticeRepository(correct: true);
    final runner = _runner(repo, itemCount: 1);
    final auto = AutoAdvanceController(runner);
    addTearDown(auto.dispose);

    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.check();
    auto.schedule(0);

    await tester.pump(const Duration(seconds: 2));
    expect(runner.index, 0, reason: '末题要交卷，不翻页');
  });
}

PracticeRunner _runner(_FakePracticeRepository repo, {required int itemCount}) =>
    PracticeRunner(
      repository: repo,
      snapshot: _snapshot(itemCount: itemCount),
      mode: PracticeMode.instant,
    );

PracticeSessionSnapshot _snapshot({required int itemCount}) =>
    PracticeSessionSnapshot(
      sessionId: 's1',
      source: 'all',
      status: 'active',
      totalCount: itemCount,
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
                QuestionOption(key: 'B', label: [Block.text(text: '乙')]),
              ],
              answer: const ServerAnswer.choice(keys: ['A']),
            ),
          ),
      ],
    );

class _FakePracticeRepository extends PracticeRepository {
  _FakePracticeRepository({required this.correct}) : super(_client);

  // 关掉自动刷新：它起的是周期定时器，测试结束时会报"仍有 pending timer"。
  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  final bool correct;

  @override
  Future<SubmitResult> submitAnswer({
    required String sessionId,
    required String questionId,
    required SubmittedAnswer answer,
    int durationMs = 0,
    bool? selfMastered,
  }) async => SubmitResult(isCorrect: correct);
}
