// 遗忘曲线卡片：什么时候画图、什么时候说"还画不出来"。
//
// 为什么值得测：这张图最容易出的不是崩溃，是**误导**——拿两三个样本连一条线，
// 学生会以为自己"14 天后就忘光了"。所以"样本不够时不画"是一条真正的产品规则，
// 值得钉住。

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/forgetting_curve_card.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  Future<void> pump(WidgetTester tester, List<ForgettingBucket> buckets) async {
    // 桌面端关掉线性缩放（与 bootstrap 同源）——否则 1280 宽会被放大 3.28 倍，
    // 报出一个真机上不存在的溢出。
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        enableScaleWH: () => false,
        enableScaleText: () => false,
        builder: (context, _) => MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: ForgettingCurveCard(buckets: buckets)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('完全没有复习记录时给出解释，而不是一张空图', (tester) async {
    await pump(tester, const []);

    expect(find.byType(LineChart), findsNothing);
    expect(find.text('还没法画出你的遗忘曲线'), findsOneWidget);
    expect(find.textContaining('隔几天再练一次'), findsOneWidget);
  });

  testWidgets('可信桶不足 2 个时不画——一个点连不成线', (tester) async {
    await pump(tester, const [
      ForgettingBucket(days: 0, attempts: 20, correct: 19),
      // 只有 2 次作答：不可信
      ForgettingBucket(days: 1, attempts: 2, correct: 1),
      // 只有 1 次作答：更不可信
      ForgettingBucket(days: 7, attempts: 1, correct: 0),
    ]);

    expect(find.byType(LineChart), findsNothing);
    expect(find.text('还没法画出你的遗忘曲线'), findsOneWidget);
    // 提示里要带上已有的样本量，让用户知道离能画还差多远
    expect(find.textContaining('3 次'), findsOneWidget);
  });

  testWidgets('刚好 2 个可信桶会画，但要明说形状还看不出来', (tester) async {
    await pump(tester, const [
      ForgettingBucket(days: 0, attempts: 20, correct: 19),
      ForgettingBucket(days: 1, attempts: 9, correct: 6),
      ForgettingBucket(days: 7, attempts: 1, correct: 0), // 样本太少，不算
    ]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.textContaining('看不出形状'), findsOneWidget);
  });

  testWidgets('两个可信桶以上才画图，且实测线与理论线都在', (tester) async {
    await pump(tester, const [
      ForgettingBucket(days: 0, attempts: 30, correct: 29),
      ForgettingBucket(days: 1, attempts: 25, correct: 22),
      ForgettingBucket(days: 7, attempts: 12, correct: 8),
      ForgettingBucket(days: 14, attempts: 5, correct: 3),
    ]);

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('还没法画出你的遗忘曲线'), findsNothing);

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    expect(chart.data.lineBarsData.length, 2, reason: '一条实测线 + 一条理论线');
    expect(tester.takeException(), isNull);
  });

  testWidgets('图注要说明理论线是无意义音节的基线，否则结论会被读歪', (tester) async {
    await pump(tester, const [
      ForgettingBucket(days: 0, attempts: 30, correct: 29),
      ForgettingBucket(days: 1, attempts: 25, correct: 22),
      ForgettingBucket(days: 7, attempts: 12, correct: 8),
    ]);

    expect(find.textContaining('无意义音节'), findsOneWidget);
    expect(find.textContaining('掉得快不快'), findsOneWidget);
  });
}
