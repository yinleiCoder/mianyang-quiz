// 试题分析页的行为。
//
// 为什么值得测：
//   · **0 次判分 ≠ 0% 正确率**（服务端给 null，页面必须显示「—」）——这是全站反复强调的
//     一条口径，最容易被后来的人"顺手补个 0"；
//   · 「谁选了什么」展开后才出现，且答案项要被标出来；
//   · 切档（全班/全校/全市）必须真的重新取数；
//   · 服务端 42501（没出分）要变成"看不了"的错误态，而不是白屏。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/analytics/option_stats.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_question_stats.dart';
import 'package:mianyang_quiz/data/models/analytics/question_stats.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/ui/features/analytics/paper_analysis_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('有作答：显示题号、题型、正确率与作答人数', (tester) async {
    await _pump(tester, _Fake(_stats()));

    expect(find.text('第 1 题'), findsOneWidget);
    expect(find.textContaining('单选题'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.textContaining('作答 2/2'), findsOneWidget);
    expect(find.textContaining('本次考试 2 人参与'), findsOneWidget);
  });

  testWidgets('还没判分：正确率显示「—」，不是 0%', (tester) async {
    await _pump(
      tester,
      _Fake(_stats(items: [_item(seq: 1, correctRate: null, graded: 0, correct: 0)])),
    );

    expect(find.text('—'), findsOneWidget);
    expect(find.text('0%'), findsNothing, reason: '0 次判分不等于全错');
  });

  testWidgets('展开后给出选项分布与错答名单', (tester) async {
    await _pump(tester, _Fake(_stats()));

    // 折叠时不该有选项文本
    expect(find.text('Ctrl键'), findsNothing);

    await tester.tap(find.text('第 1 题'));
    await tester.pumpAndSettle();

    expect(find.text('Ctrl键'), findsOneWidget);
    expect(find.text('Shift键'), findsOneWidget);
    expect(find.textContaining('张明'), findsWidgets, reason: '谁选了什么要看得见');
    expect(find.textContaining('答错的 1 人'), findsOneWidget);
  });

  testWidgets('切到全校：带着新 scope 重新取数', (tester) async {
    final fake = _Fake(_stats());
    await _pump(tester, fake);
    expect(fake.scopes, [LeaderboardScopeKey.classScope]);

    await tester.tap(find.text('全校'));
    await tester.pumpAndSettle();

    expect(fake.scopes, [LeaderboardScopeKey.classScope, LeaderboardScopeKey.school]);
  });

  testWidgets('没出分（服务端 42501）：显示错误态与重试，不是白屏', (tester) async {
    await _pump(tester, _Fake(_stats(), fail: true));

    expect(find.text('看不了这份分析'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('桌面 1280×800 下不出现布局异常', (tester) async {
    await _pump(tester, _Fake(_stats()), size: const Size(1280, 800));

    expect(tester.takeException(), isNull);
  });
}

PaperQuestionStats _stats({List<QuestionStat>? items}) => PaperQuestionStats(
  items: items ?? [_item()],
  studentLimit: 50,
  totals: const QuestionStatsTotals(attempts: 2),
);

QuestionStat _item({int seq = 1, double? correctRate = 0.5, int graded = 2, int correct = 1}) =>
    QuestionStat(
      itemId: 'i1',
      seq: seq,
      qtype: 'single_choice',
      score: 3,
      total: 2,
      blank: 0,
      graded: graded,
      correct: correct,
      correctRate: correctRate,
      options: [
        const QuestionOptionStat(
          key: 'A',
          text: 'Shift键',
          isAnswer: true,
          count: 1,
          students: [OptionStudent(userId: 'u1', name: '张明', className: '1班')],
        ),
        const QuestionOptionStat(
          key: 'C',
          text: 'Ctrl键',
          count: 1,
          students: [OptionStudent(userId: 'u2', name: '唐涛', className: '1班')],
        ),
      ],
      wrongStudents: const [WrongStudent(userId: 'u2', name: '唐涛', className: '1班', label: 'C')],
      wrongTotal: 1,
    );

class _Fake extends AnalyticsRepository {
  _Fake(this.stats, {this.fail = false}) : super(_client);

  // autoRefreshToken 关掉：周期定时器会让 flutter_test 判「树销毁后仍有 pending timer」
  static final SupabaseClient _client = SupabaseClient(
    'https://example.supabase.co',
    'sb_publishable_x',
    authOptions: const AuthClientOptions(autoRefreshToken: false),
  );

  final PaperQuestionStats stats;
  final bool fail;
  final List<LeaderboardScopeKey> scopes = [];

  @override
  Future<PaperQuestionStats> fetchQuestionStats({
    required String paperId,
    LeaderboardScopeKey scope = LeaderboardScopeKey.classScope,
    String? classId,
  }) async {
    scopes.add(scope);
    if (fail) throw const NetworkException();
    return stats;
  }
}

Future<void> _pump(
  WidgetTester tester,
  _Fake fake, {
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
      builder: (context, _) => Provider<AnalyticsRepository>.value(
        value: fake,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const PaperAnalysisPage(paperId: 'p1', paperTitle: '期中卷'),
        ),
      ),
    ),
  );
  await tester.pump();
}
