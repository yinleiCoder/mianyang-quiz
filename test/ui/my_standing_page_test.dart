// 「我的处境」页：名次卡 + 薄弱点，以及三种"没有名次"的说法。
//
// 为什么值得测：
//   · 这一页要**挑对哪一场考试**——只认"官方且已出分"的那一场，重做（自主练习）与
//     待阅卷都不该拿来算名次，否则学生看到的排名是假的；
//   · 空态要说话：没考过 / 全是自主练习，各有各的下一步动作，不能显示一堆 0。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_entry.dart';
import 'package:mianyang_quiz/data/models/analytics/leaderboard_stats.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/node_accuracy.dart';
import 'package:mianyang_quiz/ui/features/analytics/my_standing_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('官方且已出分的那一场：显示名次与差距', (tester) async {
    await _pump(
      tester,
      analytics: _FakeAnalytics(
        board: _board(),
        nodes: const [NodeAccuracy(nodeId: 'c1', attempts: 10, correct: 3)],
      ),
      attempts: [_attempt(isOfficial: true, status: 'graded')],
    );

    expect(find.text('第 3 名'), findsOneWidget);
    expect(find.text('1班 · 共 6 人'), findsOneWidget);
    expect(find.textContaining('距上一名（任周）'), findsOneWidget);
  });

  testWidgets('只有自主练习：说明为什么没有名次，而不是显示 0', (tester) async {
    final fake = _FakeAnalytics(board: _board(), nodes: const []);
    await _pump(
      tester,
      analytics: fake,
      attempts: [_attempt(isOfficial: false, status: 'graded')],
    );

    expect(find.textContaining('只有第一次交卷计入排行'), findsOneWidget);
    expect(find.text('第 3 名'), findsNothing);
    // 没挑到合格的那一场，就不该再去拉榜
    expect(fake.boardCalls, 0);
  });

  testWidgets('一场考试都没有：引导去考试', (tester) async {
    await _pump(tester, analytics: _FakeAnalytics(board: _board(), nodes: const []), attempts: []);

    expect(find.textContaining('还没有参加过考试'), findsOneWidget);
  });

  testWidgets('薄弱点：按顶层科目汇总并显示比例', (tester) async {
    await _pump(
      tester,
      analytics: _FakeAnalytics(
        board: _board(),
        // 课程层两条，挂在同一个大类下 → 上卷成一条
        nodes: const [
          NodeAccuracy(nodeId: 'c1', attempts: 10, correct: 2),
          NodeAccuracy(nodeId: 'c2', attempts: 10, correct: 8),
        ],
      ),
      attempts: [_attempt(isOfficial: true, status: 'graded')],
    );

    expect(find.text('计算机类'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget, reason: '10/20');
  });

  testWidgets('桌面 1280×800 下不出现布局异常', (tester) async {
    await _pump(
      tester,
      analytics: _FakeAnalytics(board: _board(), nodes: const []),
      attempts: [_attempt(isOfficial: true, status: 'graded')],
      size: const Size(1280, 800),
    );

    expect(tester.takeException(), isNull);
  });
}

PaperLeaderboard _board() => const PaperLeaderboard(
  paper: LeaderboardPaper(id: 'p1', title: '期中卷', fullScore: 100),
  scope: LeaderboardScope(key: 'class', label: '1班'),
  rows: [],
  stats: LeaderboardStats(total: 6, avgScore: 60, avgPercent: 0.6),
  viewer: LeaderboardViewer(
    userId: 'me',
    name: '我',
    rank: 3,
    scopeTotal: 6,
    score: 70,
    fullScore: 100,
    percent: 0.7,
    chase: LeaderboardChase(userId: 'u2', name: '任周', score: 73, gap: 3),
  ),
);

ExamAttemptRecord _attempt({required bool isOfficial, required String status}) => ExamAttemptRecord(
  attemptId: 'a1',
  paperId: 'p1',
  paperVersionId: 'v1',
  title: '期中卷',
  status: status,
  totalScore: 70,
  fullScore: 100,
  isOfficial: isOfficial,
);

class _FakeAnalytics extends AnalyticsRepository {
  _FakeAnalytics({required this.board, required this.nodes}) : super(_client);

  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  final PaperLeaderboard board;
  final List<NodeAccuracy> nodes;
  int boardCalls = 0;

  @override
  Future<List<NodeAccuracy>> fetchMyNodeAccuracy({int days = 30}) async => nodes;

  @override
  Future<PaperLeaderboard> fetchLeaderboard({
    required String paperId,
    LeaderboardScopeKey scope = LeaderboardScopeKey.classScope,
    String? classId,
  }) async {
    boardCalls += 1;
    return board;
  }
}

class _FakePapers extends PaperRepository {
  _FakePapers(this.attempts) : super(_client);

  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  final List<ExamAttemptRecord> attempts;

  @override
  Future<List<ExamAttemptRecord>> fetchMyAttempts({int limit = 20, int offset = 0}) async => attempts;
}

class _FakeSubjects extends SubjectRepository {
  _FakeSubjects() : super(_client);

  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  @override
  Future<List<SubjectNode>> fetchNodes() async => const [
    SubjectNode(id: 'cat', scope: 'vocational', kind: 'category', name: '计算机类'),
    SubjectNode(id: 'c1', scope: 'vocational', kind: 'course', name: '办公应用', parentId: 'cat'),
    SubjectNode(id: 'c2', scope: 'vocational', kind: 'course', name: '网络基础', parentId: 'cat'),
  ];
}

Future<void> _pump(
  WidgetTester tester, {
  required _FakeAnalytics analytics,
  required List<ExamAttemptRecord> attempts,
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MultiProvider(
        providers: [
          Provider<AnalyticsRepository>.value(value: analytics),
          Provider<PaperRepository>.value(value: _FakePapers(attempts)),
          Provider<SubjectRepository>.value(value: _FakeSubjects()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const MyStandingPage()),
      ),
    ),
  );
  await tester.pump(); // 三 awaiting 的链：多 pump 几次让它们跑完
  await tester.pump();
  await tester.pump();
}
