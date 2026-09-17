// 成绩单页的 widget 测试。
//
// 这里有本项目最容易骗过人的一条产品规则：**待阅卷时不能拿总分当分子**。
// 那时的 total_score 只有客观分（主观题还是 0），显示成「34 / 60」会被读成
// "我才考了 34 分"，而这卷子根本还没判完。所以未出分时分母换成客观题满分，
// 并且明说"还有 N 道题等老师阅卷"。这两种状态在数据上都"有分数"，不测就分不出来。
//
// 另一半是答案的可见性：标准答案**只有出分后才由服务端下发**（0056），
// 客户端只是"有就显示"。待阅卷那一场里不该出现「正确答案」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/data/models/exam/exam_answer.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/ui/features/exam/exam_result_page.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('待阅卷：显示客观题得分与待阅卷题数，且不下发标准答案', (tester) async {
    await _pump(tester, _pending);

    expect(find.text('待阅卷'), findsWidgets);
    expect(find.text('客观题得分'), findsOneWidget);
    expect(find.text('34'), findsOneWidget);
    expect(find.text(' / 40'), findsOneWidget);
    expect(find.textContaining('还有 1 道题等老师阅卷'), findsOneWidget);
    // 逐题：主观题那一格是「待阅卷」，客观题那一格给出得分
    expect(find.textContaining('得 4 / 4 分'), findsOneWidget);
    // 服务端这时不给答案，页面上就不该有「正确答案」
    expect(find.text('正确答案：'), findsNothing);
  });

  testWidgets('出分后：显示总分与标准答案，待阅卷字样消失', (tester) async {
    await _pump(tester, _graded);

    expect(find.text('总成绩'), findsOneWidget);
    expect(find.text('38'), findsOneWidget);
    expect(find.text(' / 60'), findsOneWidget);
    expect(find.textContaining('客观题 34 分'), findsOneWidget);
    expect(find.text('正确答案：'), findsOneWidget);
    expect(find.textContaining('待阅卷'), findsNothing);
  });

  testWidgets('桌面 1280×800 下不出现布局异常', (tester) async {
    await _pump(tester, _graded, size: const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester,
  ExamSnapshot snapshot, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // **enableScaleWH / enableScaleText 必须传**：ScreenUtilInit 初始化时会用它们覆盖
  // 之前设过的值，而参数为 null 时按 `?? () => true` 重置为"开"——于是 1280 宽的窗口
  // 会按 390 的设计宽度放大 3.3 倍，.sp(17) 变成 56px，界面直接炸掉。
  // 这正是 bootstrap.dart 里必须把 screenScaleEnabled 传下去的那个坑，
  // 测试里同样要传，否则测的是一个真机上不存在的布局。
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => Provider<PaperRepository>.value(
        value: _FakePaperRepository(snapshot),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ExamResultPage(attemptId: 'a1'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

ExamItem _choiceItem() => const ExamItem(
  id: 'i1',
  seq: 1,
  qtype: 'single_choice',
  score: 4,
  scoreUnits: [4],
  content: QuestionContent(
    stem: [Block.text(text: '中国的首都是哪里？')],
    options: [
      QuestionOption(key: 'A', label: [Block.text(text: '北京')]),
      QuestionOption(key: 'B', label: [Block.text(text: '上海')]),
    ],
    answer: ServerAnswer.choice(keys: ['A']),
  ),
);

ExamItem _essayItem({required bool withAnswer}) => ExamItem(
  id: 'i2',
  seq: 2,
  qtype: 'short_answer',
  score: 56,
  scoreUnits: const [56],
  content: QuestionContent(
    stem: const [Block.text(text: '简述光合作用。')],
    answer: withAnswer ? const ServerAnswer.text(samples: ['略']) : null,
  ),
);

ExamPaper _paper({required bool withAnswers}) => ExamPaper(
  versionId: 'v1',
  paperId: 'p1',
  title: '2026 春季期中卷',
  subjectLabel: '计算机应用',
  durationMinutes: 90,
  totalScore: 60,
  sections: [
    ExamSection(
      id: 's1',
      seqLabel: '一',
      title: '单项选择题',
      sectionScore: 4,
      items: [_choiceItem()],
    ),
    ExamSection(
      id: 's2',
      seqLabel: '二',
      title: '简答题',
      sectionScore: 56,
      items: [_essayItem(withAnswer: withAnswers)],
    ),
  ],
);

/// 已交卷、等老师判主观题。
final _pending = ExamSnapshot(
  attempt: ExamAttempt(
    id: 'a1',
    paperId: 'p1',
    paperVersionId: 'v1',
    status: 'submitted',
    submittedAt: DateTime(2026, 9, 17, 10, 30),
    fullScore: 60,
    objectiveFullScore: 40,
    objectiveScore: 34,
    pendingReviewCount: 1,
    durationMs: 1830000,
  ),
  paper: _paper(withAnswers: false),
  answers: const [
    ExamAnswerRecord(
      paperItemId: 'i1',
      seq: 1,
      answer: {'type': 'choice', 'keys': ['B']},
      units: [ScoreUnit(ok: true, score: 4)],
      score: 4,
      isCorrect: true,
    ),
    ExamAnswerRecord(
      paperItemId: 'i2',
      seq: 2,
      answer: {'type': 'text', 'text': '把光能变成化学能'},
      grading: 'pending',
    ),
  ],
);

/// 已出分：卷面里带上了标准答案（服务端只在 graded 时下发）。
final _graded = ExamSnapshot(
  attempt: ExamAttempt(
    id: 'a1',
    paperId: 'p1',
    paperVersionId: 'v1',
    status: 'graded',
    submittedAt: DateTime(2026, 9, 17, 10, 30),
    gradedAt: DateTime(2026, 9, 18, 9),
    fullScore: 60,
    objectiveFullScore: 40,
    objectiveScore: 34,
    subjectiveScore: 4,
    totalScore: 38,
    durationMs: 1830000,
  ),
  paper: _paper(withAnswers: true),
  answers: const [
    ExamAnswerRecord(
      paperItemId: 'i1',
      seq: 1,
      answer: {'type': 'choice', 'keys': ['A']},
      units: [ScoreUnit(ok: true, score: 4)],
      score: 4,
      isCorrect: true,
    ),
    ExamAnswerRecord(
      paperItemId: 'i2',
      seq: 2,
      answer: {'type': 'text', 'text': '把光能变成化学能'},
      units: [ScoreUnit(ok: false, score: 4)],
      score: 4,
      grading: 'manual',
      isCorrect: false,
      comment: '要点不全',
    ),
  ],
);

/// 只实现 fetchAttempt 的假仓储；其余方法不会被成绩单页调用。
class _FakePaperRepository implements PaperRepository {
  _FakePaperRepository(this.snapshot);

  final ExamSnapshot snapshot;

  @override
  Future<ExamSnapshot> fetchAttempt(String attemptId) async => snapshot;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
