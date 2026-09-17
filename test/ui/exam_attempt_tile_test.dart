// 「我的考试」一行的测试。
//
// 钉住一条产品规则：**待阅卷时不给数字**。那时的 total_score 只有客观分（主观题还是 0），
// 写成「42 / 100」会被读成"我才考了 42 分"，而这卷子根本还没判完。
// 分数与占位符在界面上都只是几个字符，不测就分不出对错。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_attempt_tile.dart';

void main() {
  testWidgets('已出分：给出得分/满分与用时', (tester) async {
    await _pump(
      tester,
      _record(status: 'graded', totalScore: 38, fullScore: 60, durationMs: 1830000),
    );

    expect(find.text('38 / 60'), findsOneWidget);
    expect(find.text('已出分'), findsOneWidget);
    expect(find.textContaining('用时 30 分 30 秒'), findsOneWidget);
  });

  testWidgets('待阅卷：分数位置是占位符，并说明还有几题没判', (tester) async {
    await _pump(
      tester,
      _record(
        status: 'submitted',
        totalScore: 34,
        fullScore: 60,
        pendingReviewCount: 2,
      ),
    );

    // 34 分是客观分，不是成绩——不能显示成「34 / 60」
    expect(find.text('34 / 60'), findsNothing);
    expect(find.text('—'), findsOneWidget);
    expect(find.text('待阅卷'), findsOneWidget);
    expect(find.textContaining('2 题待阅卷'), findsOneWidget);
  });

  testWidgets('进行中：显示开始时间而不是交卷时间（它决定倒计时还剩多少）', (tester) async {
    await _pump(tester, _record(status: 'in_progress'));

    expect(find.text('进行中'), findsOneWidget);
    expect(find.textContaining('开始于 09-17 09:00'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester, ExamAttemptRecord record) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: ExamAttemptTile(record: record, onTap: () {}),
        ),
      ),
    ),
  );
  await tester.pump();
}

ExamAttemptRecord _record({
  required String status,
  double totalScore = 0,
  double fullScore = 60,
  int pendingReviewCount = 0,
  int durationMs = 0,
}) => ExamAttemptRecord(
  attemptId: 'a1',
  paperId: 'p1',
  paperVersionId: 'v1',
  title: '2026 春季期中卷',
  examName: '期中考试',
  status: status,
  startedAt: DateTime(2026, 9, 17, 9),
  submittedAt: DateTime(2026, 9, 17, 10, 30),
  totalScore: totalScore,
  fullScore: fullScore,
  pendingReviewCount: pendingReviewCount,
  durationMs: durationMs,
  itemCount: 20,
);
