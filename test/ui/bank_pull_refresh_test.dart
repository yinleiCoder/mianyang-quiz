// 题库列表的下拉刷新测试。
//
// 为什么值得测：下拉刷新有两个容易做错的地方——① 刷新时把列表切成加载态，
// 用户正看着的内容整块消失（比不刷新还糟）；② 列表只有一两条时不可滚动，
// 手势直接失效。这两条都不会被 analyze 抓到，只能靠把手势真做出来看。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/features/bank/bank_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeQuestionRepository extends QuestionRepository {
  _FakeQuestionRepository(super.client);

  int calls = 0;

  @override
  Future<QuestionPage> listQuestions({
    QuestionFilter filter = const QuestionFilter(),
    int page = 1,
    int pageSize = 10,
    List<SubjectNode>? nodes,
  }) async {
    calls++;
    return (
      rows: [
        const QuestionBrief(
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
}

/// 参考数据（科目树、标签）在测试里给空集即可：列表本身不依赖它们。
class _FakeSubjectRepository extends SubjectRepository {
  _FakeSubjectRepository(super.client);

  @override
  Future<List<SubjectNode>> fetchNodes() async => const [];

  @override
  Future<List<QuestionTag>> fetchTags() async => const [];
}

void main() {
  testWidgets('题库列表：下拉刷新会重查，且刷新期间列表内容不消失', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final questions = _FakeQuestionRepository(client);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MultiProvider(
          providers: [
            Provider<QuestionRepository>.value(value: questions),
            Provider<SubjectRepository>(create: (_) => _FakeSubjectRepository(client)),
            ChangeNotifierProvider(
              create: (_) => FavoriteStore(FavoriteRepository(client)),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: GoRouter(
              initialLocation: '/bank',
              routes: [
                GoRoute(path: '/bank', builder: (_, _) => const Scaffold(body: BankPage())),
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
    expect(questions.calls, 1, reason: '进页面加载一次');
    expect(find.textContaining('打印的快捷方式'), findsOneWidget);

    // 只有一条数据也要能下拉（AlwaysScrollableScrollPhysics 管的就是这件事）
    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    expect(questions.calls, 2, reason: '下拉应重查当前这一页');
    expect(find.textContaining('打印的快捷方式'), findsOneWidget, reason: '刷新期间内容不该被清空');
    expect(tester.takeException(), isNull);
  });
}
