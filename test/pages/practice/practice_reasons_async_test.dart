// 练习页不被「为什么推这道题」挡住。
//
// 推荐依据是解释性数据（BKT/FSRS 的说明卡片），却要走一次 RPC。等它一起回来，
// 学生就要在"正在准备练习…"上多等一个网络往返；这里用一个**一直不完成**的
// 依据请求把边界钉死：题面必须已经可答。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/practice/practice_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('会话一到就开练；推荐依据晚到也不影响作答', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final repo = _FakePracticeRepository(client);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        enableScaleWH: () => false,
        enableScaleText: () => false,
        builder: (context, _) => MultiProvider(
          providers: [
            Provider<PracticeRepository>.value(value: repo),
            ChangeNotifierProvider<SfxService>.value(
              // 舞台取它来放音效；本用例不答题，测试环境也没有音频通道
              value: SfxService(),
            ),
            ChangeNotifierProvider<FavoriteStore>.value(
              value: FavoriteStore(FavoriteRepository(client)),
            ),
            ChangeNotifierProvider<PracticePrefsStore>.value(
              value: PracticePrefsStore(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const PracticePage(sessionId: 's1', shuffleOptions: false),
          ),
        ),
      ),
    );

    // fetchSession 是异步的：两次 pump 让它与首帧落地（不能 pumpAndSettle，
    // 顶栏计时器是 Timer.periodic，永远 settle 不下来）。
    await tester.pump();
    await tester.pump();

    expect(repo.reasonCalls, 1, reason: '依据请求应该已经发出，只是不挡题面');
    expect(find.text('中国的首都是哪里？'), findsOneWidget);
    expect(find.text('为什么推这道题'), findsNothing);

    repo.reasons.complete({
      'q1': const PracticeReason(questionId: 'q1', reasonCode: 'due_review'),
    });
    await tester.pump();
    await tester.pump();

    expect(find.text('为什么推这道题'), findsOneWidget);
  });
}

class _FakePracticeRepository extends PracticeRepository {
  _FakePracticeRepository(super.client);

  final reasons = Completer<Map<String, PracticeReason>>();
  int reasonCalls = 0;

  @override
  Future<PracticeSessionSnapshot> fetchSession(String sessionId) async =>
      PracticeSessionSnapshot(
        sessionId: sessionId,
        source: 'all',
        status: 'active',
        items: const [
          PracticeItem(
            seq: 1,
            questionId: 'q1',
            versionId: 'v1',
            qtype: 'single_choice',
            content: QuestionContent(
              stem: [Block.text(text: '中国的首都是哪里？')],
              options: [
                QuestionOption(key: 'A', label: [Block.text(text: '北京')]),
                QuestionOption(key: 'B', label: [Block.text(text: '上海')]),
              ],
              answer: ServerAnswer.choice(keys: ['A']),
            ),
          ),
        ],
      );

  @override
  Future<Map<String, PracticeReason>> fetchSessionReasons(String sessionId) {
    reasonCalls++;
    return reasons.future;
  }
}
