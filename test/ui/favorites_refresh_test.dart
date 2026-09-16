// 收藏 Tab 的「别处收藏后能看见」测试。
//
// 为什么值得测：这一页是 keepAlive 的，而底部导航是 StatefulShellRoute.indexedStack
// （分支不销毁）。用户在题库/详情页收藏完再切回记录页，如果列表不跟着全局收藏状态走，
// 就会停在打开时的空列表——用户看到的是「我明明收藏了，记录里却没有」。
// 这条只靠手点是很容易漏掉的回归（要点「先打开记录页 → 再去收藏 → 再切回来」的顺序）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:mianyang_quiz/ui/features/records/records_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 只实现收藏列表的读取；其余方法用不到（页面只用这一个）。
class _FakeListRepository extends ListRepository {
  _FakeListRepository(super.client);

  List<FavoriteQuestion> favorites = const [];
  int calls = 0;

  @override
  Future<List<FavoriteQuestion>> fetchFavorites({
    int limit = 20,
    int offset = 0,
  }) async {
    calls++;
    return favorites.skip(offset).take(limit).toList();
  }
}

/// toggle 只改本地状态，不发请求：这条测试关心的是「状态变了列表跟不跟」。
class _FakeFavoriteRepository extends FavoriteRepository {
  _FakeFavoriteRepository(super.client);

  @override
  Future<bool> toggleFavorite(String questionId) async => true;
}

void main() {
  testWidgets('收藏 Tab：别处收藏后切回来，列表能看到这道题', (tester) async {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final listRepo = _FakeListRepository(client);
    final store = FavoriteStore(_FakeFavoriteRepository(client));

    await _pump(tester, listRepo: listRepo, store: store);

    // 先打开收藏 Tab：此时确实没有收藏
    await tester.tap(find.text('收藏'));
    await tester.pumpAndSettle();
    expect(find.text('还没有收藏的题'), findsOneWidget);
    expect(listRepo.calls, 1);

    // 模拟「在题库里收藏了一道题」：列表能查到它，全局状态也知道它被收藏了
    listRepo.favorites = [
      const FavoriteQuestion(
        questionId: 'q1',
        versionId: 'v1',
        qtype: 'true_false',
        difficulty: 1,
        stemText: '打印的快捷方式是按____组合键。',
      ),
    ];
    await store.toggle('q1');
    await tester.pumpAndSettle();

    expect(find.text('还没有收藏的题'), findsNothing);
    expect(find.textContaining('打印的快捷方式'), findsOneWidget);
    expect(listRepo.calls, 2, reason: '应重查一次第一页拿行数据');
  });

  testWidgets('收藏 Tab：下拉可以刷新（重新拉第一页）', (tester) async {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final listRepo = _FakeListRepository(client)
      ..favorites = [
        const FavoriteQuestion(
          questionId: 'q1',
          versionId: 'v1',
          qtype: 'true_false',
          difficulty: 1,
          stemText: '打印的快捷方式是按____组合键。',
        ),
      ];
    final store = FavoriteStore(_FakeFavoriteRepository(client))..seed(['q1']);

    await _pump(tester, listRepo: listRepo, store: store);
    await tester.tap(find.text('收藏'));
    await tester.pumpAndSettle();
    expect(listRepo.calls, 1);

    // 下拉：RefreshIndicator 触顶后回弹，刷新走的是「重查第一页、不清空内容」
    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pumpAndSettle();

    expect(listRepo.calls, 2, reason: '下拉应重查一次');
    expect(find.textContaining('打印的快捷方式'), findsOneWidget, reason: '刷新期间内容不该被清空');
  });

  testWidgets('收藏 Tab：别处取消收藏后切回来，那一行消失', (tester) async {
    final client = SupabaseClient(
      'https://example.supabase.co',
      'sb_publishable_x',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    final listRepo = _FakeListRepository(client)
      ..favorites = [
        const FavoriteQuestion(
          questionId: 'q1',
          versionId: 'v1',
          qtype: 'true_false',
          difficulty: 1,
          stemText: '打印的快捷方式是按____组合键。',
        ),
      ];
    final store = FavoriteStore(_FakeFavoriteRepository(client))..seed(['q1']);

    await _pump(tester, listRepo: listRepo, store: store);
    await tester.tap(find.text('收藏'));
    await tester.pumpAndSettle();
    expect(find.textContaining('打印的快捷方式'), findsOneWidget);

    // 模拟在详情页取消收藏：只动全局状态，不再重查列表
    store.markNotFavorite('q1');
    await tester.pumpAndSettle();

    expect(find.textContaining('打印的快捷方式'), findsNothing);
    expect(listRepo.calls, 1, reason: '取消只需就地删行，不该重查');
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required ListRepository listRepo,
  required FavoriteStore store,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // autoRefreshToken 必须关掉：它起的是周期定时器，flutter_test 会因为
  // 「widget 树销毁后仍有 pending timer」判失败（与 records_page_test 同一个坑）。
  final client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MultiProvider(
        providers: [
          Provider<ListRepository>.value(value: listRepo),
          // 记录页另外两个 Tab 也要各自的仓储（第一个 Tab 一建就 fetch）
          Provider<PracticeRepository>(create: (_) => PracticeRepository(client)),
          ChangeNotifierProvider<FavoriteStore>.value(value: store),
          ChangeNotifierProvider(create: (_) => PracticeDraftStore()),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            initialLocation: '/records',
            routes: [
              GoRoute(path: '/', builder: (_, _) => const Text('首页占位')),
              GoRoute(
                path: '/records',
                builder: (_, _) => const RecordsPage(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
