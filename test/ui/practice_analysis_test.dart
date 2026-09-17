// 即时练习的「答完就能看解析」。
//
// 学生反馈："即时练习模式应该做一道题就能看到当题的解析"——原来判完只标了对错
// （选项变绿变红），说不出为什么。钉住两点：
//   · 判完（graded）时解析与标准答案都在；
//   · 没判（批量模式、或即时模式还没提交）时**一个字都不露**——
//     提前显示答案等于把练习变成抄答案。

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
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_question_area.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('判完之后：标准答案与解析都在题目下方', (tester) async {
    await _pump(tester, graded: true);

    expect(find.text('中国的首都是哪里？'), findsOneWidget);
    expect(find.text('正确答案：'), findsOneWidget);
    expect(find.text('解析'), findsOneWidget);
    expect(find.text('北京是首都。'), findsOneWidget);
  });

  testWidgets('还没判：标准答案与解析都不露', (tester) async {
    await _pump(tester, graded: false);

    expect(find.text('中国的首都是哪里？'), findsOneWidget);
    expect(find.text('正确答案：'), findsNothing);
    expect(find.text('解析'), findsNothing);
    expect(find.text('北京是首都。'), findsNothing);
  });
}

Future<void> _pump(WidgetTester tester, {required bool graded}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final runner = PracticeRunner(
    repository: PracticeRepository(
      SupabaseClient(
        'https://example.supabase.co',
        'sb_publishable_x',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      ),
    ),
    snapshot: _snapshot,
    mode: PracticeMode.instant,
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PracticeQuestionArea(
            runner: runner,
            graded: graded,
            instant: true,
            onAnswerChanged: runner.setDraft,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

final _snapshot = const PracticeSessionSnapshot(
  sessionId: 's1',
  source: 'all',
  status: 'active',
  items: [
    PracticeItem(
      seq: 1,
      questionId: 'q1',
      versionId: 'v1',
      qtype: 'single_choice',
      content: QuestionContent(
        stem: [Block.text(text: '中国的首都是哪里？')],
        analysis: [Block.text(text: '北京是首都。')],
        options: [
          QuestionOption(key: 'A', label: [Block.text(text: '北京')]),
          QuestionOption(key: 'B', label: [Block.text(text: '上海')]),
        ],
        answer: ServerAnswer.choice(keys: ['A']),
      ),
    ),
  ],
);
