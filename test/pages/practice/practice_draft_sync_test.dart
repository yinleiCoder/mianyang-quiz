// 练习草稿的跨设备同步（0144）。
//
// 钉住三件事：
//   · 批量练习的作答会攒成草稿推给服务端——它交卷前不写 practice_answers，
//     没有这条通道，换台设备/关掉软件再开就全丢了；
//   · 即时练习**不走**草稿通道（作答本来就走 submit_practice_answer）；
//   · 续练时草稿里的作答与判定会被还原（否则进度条从 0 开始）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/pages/practice/state/question_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('批量练习：作答攒成草稿推给服务端', () async {
    final repository = _RecordingRepository();
    final runner = PracticeRunner(
      repository: repository,
      snapshot: _snapshot(),
      mode: PracticeMode.batch,
    );

    runner.setDraft(const ChoiceAnswer(['A']));
    runner.flushDrafts();
    await Future<void>.delayed(Duration.zero);

    expect(repository.saved['q1']?['answer'], {
      'type': 'choice',
      'keys': ['A'],
    });
  });

  test('即时练习不走草稿通道（作答由 submit_practice_answer 负责）', () async {
    final repository = _RecordingRepository();
    final runner = PracticeRunner(
      repository: repository,
      snapshot: _snapshot(),
      mode: PracticeMode.instant,
    );

    runner.setDraft(const ChoiceAnswer(['A']));
    runner.flushDrafts();
    await Future<void>.delayed(Duration.zero);

    expect(repository.saved, isEmpty);
  });

  test('续练：草稿里的作答与判定会被还原，并落在第一道没答的题上', () {
    final runtimes = buildQuestionRuntimes(
      _snapshot(
        drafts: const {
          'q1': {
            'answer': {'type': 'choice', 'keys': ['B']},
            'is_correct': true,
          },
        },
      ),
      shuffleOptions: false,
    );

    expect(runtimes.first.draft, isA<ChoiceAnswer>());
    expect(runtimes.first.verdict, isTrue);
    expect(runtimes.first.isAnswered, isTrue);
    expect(runtimes.last.isAnswered, isFalse);
  });

  test('续练定位：批量练习只看草稿也要停在下一道没答的题', () {
    final runner = PracticeRunner(
      repository: _RecordingRepository(),
      snapshot: _snapshot(
        drafts: const {
          'q1': {
            'answer': {'type': 'choice', 'keys': ['B']},
          },
        },
      ),
      mode: PracticeMode.batch,
    );

    expect(runner.index, 1, reason: '第 1 题已答，应该停在第 2 题');
  });
}

PracticeSessionSnapshot _snapshot({
  Map<String, dynamic> drafts = const {},
}) => PracticeSessionSnapshot(
  sessionId: 's1',
  status: 'active',
  drafts: drafts,
  items: const [
    PracticeItem(
      seq: 1,
      questionId: 'q1',
      versionId: 'v1',
      qtype: 'single_choice',
      content: QuestionContent(stem: [Block.text(text: '第 1 题')]),
    ),
    PracticeItem(
      seq: 2,
      questionId: 'q2',
      versionId: 'v2',
      qtype: 'single_choice',
      content: QuestionContent(stem: [Block.text(text: '第 2 题')]),
    ),
  ],
);

/// 只记"草稿送了什么"的仓储。本文件一条网络都不发。
class _RecordingRepository extends PracticeRepository {
  _RecordingRepository()
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'sb_publishable_x',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  Map<String, Map<String, dynamic>> saved = {};

  @override
  Future<void> saveProgress({
    required String sessionId,
    String? mode,
    Map<String, Map<String, dynamic>> answers = const {},
  }) async {
    saved = {...saved, ...answers};
  }
}
