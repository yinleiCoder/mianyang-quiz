// 考试状态机的纯逻辑测试（不起界面）。
//
// 钉住三件容易做错、且在界面上看不出来的事：
//   · 作答草稿的恢复次序（服务端 vs 本机暂存，后者优先）；
//   · "写了又删空"的主观题要回到**未作答**——否则答题卡记一格已答、交卷时什么都没交；
//   · 截止时刻缺失时不能退化成"立刻到点"（那会自动交掉一份空的卷子）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/exam/exam_answer.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final now = DateTime(2026, 9, 17, 10, 0, 0);

  group('作答草稿', () {
    test('续考时还原服务端已有的作答，并落在第一道没答的题上', () {
      final runner = _runner(
        snapshot: _snapshot(
          answers: const [
            ExamAnswerRecord(
              paperItemId: 'i1',
              seq: 1,
              answer: {'type': 'choice', 'keys': ['B']},
            ),
          ],
        ),
      );

      expect(runner.draftAt(0), isA<ChoiceAnswer>());
      expect(runner.draftAt(0)!.toJson()['keys'], ['B']);
      expect(runner.answeredCount, 1);
      // 第 2 题（下标 1）还没答
      expect(runner.index, 1);
    });

    test('本机暂存覆盖服务端的那份（它是学生刚在这台设备上写的）', () {
      final runner = _runner(
        snapshot: _snapshot(
          answers: const [
            ExamAnswerRecord(
              paperItemId: 'i1',
              seq: 1,
              answer: {'type': 'choice', 'keys': ['A']},
            ),
          ],
        ),
        localDrafts: const {
          'i1': {'type': 'choice', 'keys': ['C']},
        },
      );

      expect(runner.draftAt(0)!.toJson()['keys'], ['C']);
    });

    test('主观题写了又删空 = 未作答（不能占着答题卡的一格"已答"）', () {
      final runner = _runner(snapshot: _snapshot());

      runner.jumpTo(2);
      runner.setDraft(const EssayAnswer('先写点什么'));
      expect(runner.answeredCount, 1);
      expect(runner.draftAt(2), isA<EssayAnswer>());

      runner.setDraft(const EssayAnswer('   '));
      expect(runner.answeredCount, 0);
      expect(runner.draftAt(2), isNull);
    });

    test('作答按**题项 id** 索引，不是按题号顺序', () {
      final runner = _runner(snapshot: _snapshot());
      runner.jumpTo(1);
      runner.setDraft(const TrueFalseAnswer(true));

      expect(runner.draftAt(1)!.toJson(), {'type': 'tf', 'value': true});
      expect(runner.draftAt(0), isNull);
      expect(runner.progress, closeTo(1 / 3, 0.001));
    });
  });

  group('交卷', () {
    test('提交的是题项 id → 作答，且**不带**没作答的题', () async {
      final repository = _FakePaperRepository();
      final runner = _runner(snapshot: _snapshot(), repository: repository);

      runner.jumpTo(0);
      runner.setDraft(const ChoiceAnswer(['B']));
      runner.jumpTo(2);
      runner.setDraft(const EssayAnswer('我写的答案'));
      await runner.submit();

      expect(repository.answers.keys.toSet(), {'i1', 'i3'});
      expect(repository.answers['i1']!.toJson(), {
        'type': 'choice',
        'keys': ['B'],
      });
      expect(repository.answers['i3']!.toJson(), {
        'type': 'text',
        'text': '我写的答案',
      });
    });

    test('用时按服务端记的起考时刻算（不传就是恒为 0，成绩单上的用时永远不显示）', () async {
      final repository = _FakePaperRepository();
      final runner = _runner(snapshot: _snapshot(), repository: repository);

      // 假时钟是 10:00，快照的 started_at 是 09:00 → 整卷用时应为 1 小时
      await runner.submit();

      expect(repository.durationMs, const Duration(hours: 1).inMilliseconds);
    });

    test('时钟倒拨（起考时刻在将来）时不提交负用时', () async {
      final repository = _FakePaperRepository();
      final runner = _runner(
        snapshot: _snapshot(
          attempt: ExamAttempt(
            id: 'a1',
            paperId: 'p1',
            paperVersionId: 'v1',
            startedAt: DateTime(2026, 9, 17, 12),
          ),
        ),
        repository: repository,
      );

      await runner.submit();

      expect(repository.durationMs, isNull);
    });
  });

  group('大题归属', () {
    test('每题知道自己属于哪个大题，且认得出大题的第一题', () {
      final runner = _runner(snapshot: _snapshot());

      expect(runner.sectionAt(0).id, 's1');
      expect(runner.sectionAt(1).id, 's1');
      expect(runner.sectionAt(2).id, 's2');

      // 大题抬头只在该大题的第一题前面显示一次
      expect(runner.startsSection(0), isTrue);
      expect(runner.startsSection(1), isFalse);
      expect(runner.startsSection(2), isTrue);
    });
  });

  group('倒计时', () {
    test('截止时刻缺失时不会退化成"立刻到点"（那会交掉一份空卷）', () {
      final runner = _runner(snapshot: _snapshot(), deadline: false);

      expect(runner.deadline.isAfter(now.add(const Duration(days: 365))), isTrue);
      expect(runner.remaining, isNull);
    });

    test('过点了就是 0，不会是负数', () {
      final runner = _runner(
        snapshot: _snapshot(
          attempt: ExamAttempt(
            id: 'a1',
            paperId: 'p1',
            paperVersionId: 'v1',
            startedAt: now.subtract(const Duration(hours: 3)),
            deadlineAt: now.subtract(const Duration(hours: 2)),
          ),
        ),
      );

      expect(runner.remaining, Duration.zero);
    });
  });
}

ExamRunner _runner({
  required ExamSnapshot snapshot,
  Map<String, Map<String, dynamic>> localDrafts = const {},
  bool deadline = true,
  PaperRepository? repository,
}) {
  // freezed 的 copyWith 对可空字段用的是 sentinel，所以显式传 null 是"清空"而不是"不改"
  final prepared = deadline
      ? snapshot
      : snapshot.copyWith(
          attempt: snapshot.attempt.copyWith(deadlineAt: null),
        );
  return ExamRunner(
    repository:
        repository ??
        PaperRepository(
          SupabaseClient(
            'https://example.supabase.co',
            'sb_publishable_x',
            authOptions: const AuthClientOptions(autoRefreshToken: false),
          ),
        ),
    snapshot: prepared,
    localDrafts: localDrafts,
    clock: () => DateTime(2026, 9, 17, 10, 0, 0),
  );
}

/// 记下交卷时真正送出去的东西；其余方法不会被这些测试调用。
class _FakePaperRepository implements PaperRepository {
  Map<String, SubmittedAnswer> answers = const {};
  int? durationMs;

  @override
  Future<ExamSubmitSummary> submitAttempt({
    required String attemptId,
    required Map<String, SubmittedAnswer> answers,
    int? durationMs,
  }) async {
    this.answers = answers;
    this.durationMs = durationMs;
    return const ExamSubmitSummary();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ExamSnapshot _snapshot({
  List<ExamAnswerRecord> answers = const [],
  ExamAttempt? attempt,
}) =>
    ExamSnapshot(
      attempt:
          attempt ??
          ExamAttempt(
            id: 'a1',
            paperId: 'p1',
            paperVersionId: 'v1',
            startedAt: DateTime(2026, 9, 17, 9),
            deadlineAt: DateTime(2026, 9, 17, 10, 30),
            fullScore: 30,
          ),
      paper: const ExamPaper(
        versionId: 'v1',
        paperId: 'p1',
        title: '期中卷',
        sections: [
          ExamSection(
            id: 's1',
            seqLabel: '一',
            title: '单项选择题',
            sectionScore: 20,
            items: [
              ExamItem(
                id: 'i1',
                seq: 1,
                qtype: 'single_choice',
                score: 10,
                content: QuestionContent(stem: [Block.text(text: '第一题')]),
              ),
              ExamItem(
                id: 'i2',
                seq: 2,
                qtype: 'true_false',
                score: 10,
                content: QuestionContent(stem: [Block.text(text: '第二题')]),
              ),
            ],
          ),
          ExamSection(
            id: 's2',
            seqLabel: '二',
            title: '简答题',
            sectionScore: 10,
            items: [
              ExamItem(
                id: 'i3',
                seq: 3,
                qtype: 'short_answer',
                score: 10,
                content: QuestionContent(stem: [Block.text(text: '第三题')]),
              ),
            ],
          ),
        ],
      ),
      answers: answers,
    );
