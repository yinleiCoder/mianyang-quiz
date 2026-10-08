// 顺序练习（教师讲练）的两条口径：**一个字节都不往服务端送答案**，以及
// 成绩单是本机算的（服务端那一份只会是 0/N）。
//
// 为什么这两条值得单独钉住：它们是"不计入统计"的全部实现方式。哪天有人
// 为了"顺手把答案也存下来"改回 _submit，错题本、正确率、遗忘曲线、今日额度
// 会一起被课堂讲练污染——而且是静默污染，没有任何一处会报错。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('顺序练习：判题不发请求，答案留在本机', () async {
    final repo = _CountingRepository();
    final runner = _runner(PracticeMode.sequential, repo);

    runner.setDraft(const ChoiceAnswer(['A']));
    final result = await runner.check();

    expect(repo.submitCalls, 0, reason: '顺序练习不许写 practice_answers（0090）');
    expect(result.isCorrect, isTrue);
    expect(runner.current.verdict, isTrue, reason: '本机判定要立刻生效，界面才有反馈');
  });

  test('对照：即时练习照样逐题提交', () async {
    final repo = _CountingRepository();
    final runner = _runner(PracticeMode.instant, repo);

    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.check();

    expect(repo.submitCalls, 1);
  });

  test('顺序练习的成绩单按本机状态算，并且把会话关掉', () async {
    final repo = _CountingRepository();
    final runner = _runner(PracticeMode.sequential, repo, itemCount: 3);

    // 第一题答对
    runner.setDraft(const ChoiceAnswer(['A']));
    await runner.check();
    // 第二题答错
    runner.advance();
    runner.setDraft(const ChoiceAnswer(['B']));
    await runner.check();
    // 第三题不答

    final summary = await runner.finish();

    expect(repo.finishCalls, 1, reason: '会话必须关掉，否则记录页一直是"进行中"');
    expect(summary, isNotNull);
    expect(summary!.total, 3);
    expect(summary.correct, 1);
    expect(summary.wrong, 1);
    expect(summary.omitted, 1, reason: '没答的那题算未作答');
    expect(summary.scored, isFalse, reason: '结果页要据此说明"不计入统计"');
  });
}

PracticeRunner _runner(
  PracticeMode mode,
  _CountingRepository repository, {
  int itemCount = 1,
}) => PracticeRunner(
  repository: repository,
  snapshot: PracticeSessionSnapshot(
    sessionId: 's1',
    source: 'all',
    status: 'active',
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
  ),
  mode: mode,
);

/// 只数调用次数的仓储：一条网络都不发。
class _CountingRepository extends PracticeRepository {
  _CountingRepository()
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'sb_publishable_x',
          // autoRefreshToken 必须关：它起周期定时器，flutter_test 会判"仍有 pending timer"
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  int submitCalls = 0;
  int finishCalls = 0;

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

  @override
  Future<FinishSummary> finishSession({
    required String sessionId,
    int? durationMs,
  }) async {
    finishCalls++;
    // 服务端那份：顺序练习没写过答案，所以只能算出 0/N
    return const FinishSummary();
  }
}
