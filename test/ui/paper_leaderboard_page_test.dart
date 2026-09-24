// 成绩榜页的三态与切档行为。
//
// 为什么值得测：
//   · 「榜上没有我」有三种原因（没交过 / 这场是自主练习 / 还在等判主观题），
//     文案必须原样来自服务端 viewer_note —— 讲错了学生会以为成绩丢了；
//   · 切档（全班/全校/全市）必须**真的重新取数**并带上新 scope，
//     悄悄留在旧数据上会让人以为"全市和全班一样"；
//   · 桌面 1280×800 下不出现布局异常（repo 约定：每页都在这个窗口里过一遍）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_entry.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_stats.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/ui/features/analytics/paper_leaderboard_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('有成绩：显示名次、姓名与得分，我那一行在榜上', (tester) async {
    final fake = _FakeAnalytics(
      _board(
        viewer: const LeaderboardViewer(userId: 'u1', name: '唐涛', rank: 2, scopeTotal: 3, score: 80, fullScore: 100, percent: 0.8),
      ),
    );
    await _pump(tester, fake);

    expect(find.text('第 2 名'), findsOneWidget);
    expect(find.text('1班 · 共 3 人'), findsOneWidget);
    expect(find.text('唐涛（我）'), findsOneWidget);
    expect(find.text('张明'), findsOneWidget);
  });

  testWidgets('待阅卷：说出原因而不是显示空榜', (tester) async {
    final fake = _FakeAnalytics(_board(viewerNote: 'not_graded'));
    await _pump(tester, fake);

    expect(find.text('你已交卷，等主观题判完出分后才会进榜。'), findsOneWidget);
  });

  testWidgets('自主练习：说明为什么重做没上榜', (tester) async {
    final fake = _FakeAnalytics(_board(viewerNote: 'not_official'));
    await _pump(tester, fake);

    expect(find.textContaining('只有第一次交卷计入排行'), findsOneWidget);
  });

  testWidgets('切到全校：带着新 scope 重新取数', (tester) async {
    final fake = _FakeAnalytics(_board());
    await _pump(tester, fake);
    expect(fake.scopes, [LeaderboardScopeKey.classScope]);

    await tester.tap(find.text('全校'));
    await tester.pumpAndSettle();

    expect(fake.scopes, [LeaderboardScopeKey.classScope, LeaderboardScopeKey.school]);
  });

  testWidgets('桌面 1280×800 下不出现布局异常', (tester) async {
    final fake = _FakeAnalytics(
      _board(
        viewer: const LeaderboardViewer(userId: 'u1', name: '唐涛', rank: 1, scopeTotal: 2, score: 98, fullScore: 100, percent: 0.98),
      ),
    );
    await _pump(tester, fake, size: const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });
}

LeaderboardRow _row(String id, String name, int rank, double score, {bool isMe = false}) => LeaderboardRow(
  order: rank,
  rank: rank,
  userId: id,
  name: name,
  score: score,
  fullScore: 100,
  percent: score / 100,
  className: '1班',
  schoolName: '盐亭县职业技术学校',
  isMe: isMe,
);

PaperLeaderboard _board({LeaderboardViewer? viewer, String? viewerNote}) => PaperLeaderboard(
  paper: const LeaderboardPaper(id: 'p1', title: '期中卷', fullScore: 100, examName: '月考'),
  scope: const LeaderboardScope(key: 'class', label: '1班'),
  rows: [_row('u2', '张明', 1, 98), _row('u1', '唐涛', 2, 80, isMe: true)],
  viewer: viewer,
  viewerNote: viewerNote,
  stats: const LeaderboardStats(total: 2, avgScore: 89, avgPercent: 0.89, maxScore: 98, minScore: 80),
);

class _FakeAnalytics extends AnalyticsRepository {
  _FakeAnalytics(this.board) : super(_client);

  // autoRefreshToken 必须关掉：周期定时器会让 flutter_test 判「树销毁后仍有 pending timer」
  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  final PaperLeaderboard board;
  final List<LeaderboardScopeKey> scopes = [];

  @override
  Future<PaperLeaderboard> fetchLeaderboard({
    required String paperId,
    LeaderboardScopeKey scope = LeaderboardScopeKey.classScope,
    String? classId,
  }) async {
    scopes.add(scope);
    return board;
  }
}

Future<void> _pump(WidgetTester tester, _FakeAnalytics fake, {Size size = const Size(390, 844)}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => Provider<AnalyticsRepository>.value(
        value: fake,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const PaperLeaderboardPage(paperId: 'p1', paperTitle: '期中卷'),
        ),
      ),
    ),
  );
  await tester.pump();
}
