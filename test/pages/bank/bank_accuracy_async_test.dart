// 题库列表不被「全站作答统计」挡住。
//
// 统计只是卡片上的一个标签（AccuracyChip），却要用题目 id 才能查——天然排在列表
// 之后。如果让它串在关键路径上，每次翻页都要多等一个网络往返（跨境网络 0.5~1.5s）。
// 这里用一个**一直不完成的统计请求**把边界钉死：题目必须已经出来。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/pages.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeQuestionRepository extends QuestionRepository {
  _FakeQuestionRepository(super.client);

  @override
  Future<QuestionPage> listQuestions({
    QuestionFilter filter = const QuestionFilter(),
    int page = 1,
    int pageSize = 10,
    List<SubjectNode>? nodes,
  }) async => (
    rows: const [
      QuestionBrief(
        questionId: 'q1',
        versionId: 'v1',
        qtype: 'true_false',
        stemText: '打印的快捷方式是按____组合键。',
        nodePath: '计算机 / 办公应用',
        schoolName: '盐亭县职业技术学校',
      ),
    ],
    total: 1,
  );
}

/// 统计请求由测试决定什么时候完成；在完成之前，列表必须已经可读。
class _FakeListRepository extends ListRepository {
  _FakeListRepository(super.client);

  final accuracy = Completer<Map<String, QuestionAccuracy>>();
  int calls = 0;

  @override
  Future<Map<String, QuestionAccuracy>> fetchAccuracy(
    List<String> questionIds,
  ) {
    calls++;
    return accuracy.future;
  }
}

class _FakeSubjectRepository extends SubjectRepository {
  _FakeSubjectRepository(super.client);

  @override
  Future<List<SubjectNode>> fetchNodes({bool force = false}) async => const [];

  @override
  Future<List<QuestionTag>> fetchTags({bool force = false}) async => const [];
}

void main() {
  testWidgets('题目先出；统计在后台补上（迟到的统计也不会挡列表）', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final lists = _FakeListRepository(client);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MultiProvider(
          providers: [
            Provider<QuestionRepository>(
              create: (_) => _FakeQuestionRepository(client),
            ),
            Provider<ListRepository>.value(value: lists),
            Provider<SubjectRepository>(
              create: (_) => _FakeSubjectRepository(client),
            ),
            ChangeNotifierProvider(
              create: (_) => FavoriteStore(FavoriteRepository(client)),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: GoRouter(
              initialLocation: '/bank',
              routes: [
                GoRoute(
                  path: '/bank',
                  builder: (_, _) => const Scaffold(body: BankPage()),
                ),
                GoRoute(
                  path: '/bank/:questionId',
                  builder: (_, _) => const Text('详情占位'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 统计请求还没回来，题目已经在了
    expect(lists.calls, 1, reason: '统计请求应该已经发出，只是不挡列表');
    expect(find.textContaining('打印的快捷方式'), findsOneWidget);
    expect(find.byType(AccuracyChip), findsNothing);

    // 统计回来后补上标签
    lists.accuracy.complete({
      'q1': (attempts: 10, correct: 2),
    });
    await tester.pumpAndSettle();

    expect(find.byType(AccuracyChip), findsOneWidget);
    expect(find.textContaining('易错'), findsOneWidget);
  });
}
