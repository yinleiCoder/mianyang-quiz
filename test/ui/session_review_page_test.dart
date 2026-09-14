// 复盘页的 widget 测试：有数据时逐题渲染，「你的作答」与标准答案都在。
//
// 为什么值得测：复盘页把「只读题面 + 你的作答 + 正确答案/解析」三段摞在一张卡里，
// 错法都是静默的——作答解码猜错（已答显示成未作答）、复合题只读顶层答案（一片空白）、
// 卡片高度约束写错（真机才炸）。前两条由 records_answer_text_test 钉住，
// 这里钉住整页装配：有数据时能渲染、桌面尺寸下不报布局异常。
//
// 仓储用一个只实现 fetchSession 的假对象：复盘页只调这一个方法。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/ui/features/records/session_review_page.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('复盘页：答对/未作答都如实展示，标准答案与解析齐全', (tester) async {
    await _pump(tester, const Size(390, 844));

    expect(find.text('成绩概览'), findsOneWidget);
    expect(find.text('逐题回顾'), findsOneWidget);
    // 正确率的分母是总题数（含未作答），这里 0/2。
    expect(find.text('0%'), findsOneWidget);
    // 第一题：选项标记与作答行各有一个 B；标准答案与解析都在。
    expect(find.text('你的作答：'), findsOneWidget);
    expect(find.text('B'), findsNWidgets(2));
    expect(find.text('正确答案：'), findsOneWidget);
    expect(find.text('解析'), findsOneWidget);

    // 第二题在首屏之下（ListView 懒构建），滚过去再断言它：题面在，且判定为未作答
    // （判定徽标、作答行、主观题的空白提示都会说「未作答」，所以这里只要求出现）。
    await tester.scrollUntilVisible(find.text('简述光合作用。'), 200);
    expect(find.text('未作答'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('复盘页：桌面 1280×800 下不出现布局异常', (tester) async {
    ScreenUtil.enableScale(enableWH: () => false, enableText: () => false);
    addTearDown(
      () =>
          ScreenUtil.enableScale(enableWH: () => true, enableText: () => true),
    );

    await _pump(tester, const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => Provider<PracticeRepository>.value(
        value: _FakePracticeRepository(_snapshot),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SessionReviewPage(sessionId: 's1'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// 一次已交卷的练习：第一题选了 B（答案是 A），第二题没作答。
final _snapshot = PracticeSessionSnapshot(
  sessionId: 's1',
  status: 'submitted',
  startedAt: DateTime(2026, 9, 12, 10),
  submittedAt: DateTime(2026, 9, 12, 10, 5),
  durationMs: 125000,
  totalCount: 2,
  answeredCount: 1,
  correctCount: 0,
  items: const [
    PracticeItem(
      seq: 1,
      questionId: 'q1',
      versionId: 'v1',
      qtype: 'single_choice',
      difficulty: 2,
      content: QuestionContent(
        stem: [Block.text(text: '中国的首都是哪里？')],
        analysis: [Block.text(text: '北京是首都。')],
        options: [
          QuestionOption(
            key: 'A',
            label: [Block.text(text: '北京')],
          ),
          QuestionOption(
            key: 'B',
            label: [Block.text(text: '上海')],
          ),
        ],
        answer: ServerAnswer.choice(keys: ['A']),
      ),
    ),
    PracticeItem(
      seq: 2,
      questionId: 'q2',
      versionId: 'v2',
      qtype: 'short_answer',
      content: QuestionContent(
        stem: [Block.text(text: '简述光合作用。')],
        answer: ServerAnswer.text(samples: ['略']),
      ),
    ),
  ],
  answers: const [
    PracticeAnswerRecord(
      questionId: 'q1',
      answer: {
        'type': 'choice',
        'keys': ['B'],
      },
      isCorrect: false,
    ),
  ],
);

/// 只实现 fetchSession 的假仓储；其余方法不会被复盘页调用。
class _FakePracticeRepository implements PracticeRepository {
  _FakePracticeRepository(this.snapshot);

  final PracticeSessionSnapshot snapshot;

  @override
  Future<PracticeSessionSnapshot> fetchSession(String sessionId) async =>
      snapshot;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
