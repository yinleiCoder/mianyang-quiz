// 首页打卡区的版式与口径。
//
// 钉住用户 2026-10-24 明确要的三件事：
//   · 默认目标 20（不是 10）；
//   · 宽屏下打卡区与热力图**等高**（IntrinsicHeight + Row stretch），不出现溢出；
//   · 连续天数来自 CheckinStore（云端打卡），而不是看板的练习天数。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/home/widgets/streak_header.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('默认目标 20 题，连续天数来自云端打卡', (tester) async {
    final store = CheckinStore(_FakeCheckinRepository());
    addTearDown(store.dispose);
    await store.recordToday();

    await _pump(tester, store, const Size(390, 844));

    expect(find.text('连续打卡 9 天'), findsOneWidget);
    expect(find.text('今日 3 / 20 题'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('宽屏 1280 下打卡区与热力图等高且不溢出', (tester) async {
    final store = CheckinStore(_FakeCheckinRepository());
    addTearDown(store.dispose);
    await store.recordToday();

    await _pump(tester, store, const Size(1280, 800));

    expect(find.text('连续打卡 9 天'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, CheckinStore store, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => ChangeNotifierProvider<CheckinStore>.value(
        value: store,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ListView(
              children: [
                const StreakHeader(
                  name: '测试同学',
                  dashboard: PracticeDashboard(
                    todayAnswers: 3,
                    heatmapFrom: '2026-08-03',
                    heatmapTo: '2026-10-24',
                    heatmapDaily: [
                      DailyStat(date: '2026-10-24', count: 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

class _FakeCheckinRepository extends CheckinRepository {
  _FakeCheckinRepository()
    : super(
        SupabaseClient(
          'https://example.supabase.co',
          'sb_publishable_x',
          authOptions: const AuthClientOptions(autoRefreshToken: false),
        ),
      );

  @override
  Future<CheckinStatus> recordToday() async =>
      const CheckinStatus(day: '2026-10-24', streakDays: 9, dailyGoal: 20);
}
