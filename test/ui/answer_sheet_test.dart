// 答题卡的 widget 测试：按题型分组、题号齐全、点格子跳到对应题。
//
// 为什么值得测：答题卡是"整卷地图"，错了会让人跳到错误的题（比没有更糟）。
// 分组口径（题型）、题号（从 1 开始）、以及当前题的高亮都是靠索引算出来的，
// 索引差一位这类错误肉眼扫一眼界面看不出来，测试里断言一下就见分晓。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/answer_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('按题型分组、题号从 1 开始、点格子回调对应索引', (tester) async {
    final jumps = <int>[];
    await _pump(tester, jumps.add);

    // 三道单选 + 两道判断：两个分组各带"n 题"
    expect(find.text('单选题'), findsOneWidget);
    expect(find.text('判断题'), findsOneWidget);
    expect(find.text('3 题'), findsOneWidget);
    expect(find.text('2 题'), findsOneWidget);
    for (final number in ['1', '2', '3', '4', '5']) {
      expect(find.text(number), findsOneWidget);
    }

    // 点第 5 格（判断题的第 2 道）→ 索引 4
    await tester.tap(find.text('5'));
    await tester.pump();
    expect(jumps, [4]);
  });

  testWidgets('已作答计数跟着 runner 走', (tester) async {
    await _pump(tester, (_) {});

    // 快照里第 1 题已有作答记录 → 0 题正确但已作答 1 道
    expect(find.text('已作答 1/5'), findsOneWidget);
  });

  testWidgets('窄屏宽度下不溢出', (tester) async {
    await _pump(tester, (_) {}, width: 300);

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester,
  ValueChanged<int> onJump, {
  double width = 390,
}) async {
  tester.view.physicalSize = Size(width, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );
  final runner = PracticeRunner(
    repository: PracticeRepository(client),
    snapshot: _snapshot,
    mode: PracticeMode.batch,
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: AnswerSheet(runner: runner, onJump: onJump)),
      ),
    ),
  );
  await tester.pump();
}

final _snapshot = PracticeSessionSnapshot(
  sessionId: 's1',
  source: 'all',
  status: 'active',
  items: [
    // 前三道单选、后两道判断：答题卡要按题型分成两组
    for (final (i, qtype) in [
      'single_choice',
      'single_choice',
      'single_choice',
      'true_false',
      'true_false',
    ].indexed)
      PracticeItem(
        seq: i + 1,
        questionId: 'q$i',
        versionId: 'v$i',
        qtype: qtype,
        content: QuestionContent(stem: [Block.text(text: '第 ${i + 1} 题')]),
      ),
  ],
  // 第 1 题已作答：答题卡要算进"已作答 1/5"
  answers: const [PracticeAnswerRecord(questionId: 'q0', isCorrect: true)],
);
