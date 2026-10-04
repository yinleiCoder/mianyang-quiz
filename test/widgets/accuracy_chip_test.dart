// 「易错」判据与标签的测试。
//
// 为什么值得测：这条线是**跨两端、跨四个面**的契约 —— 网页端 lib/accuracy.js 与这里
// values/accuracy_meta.dart 必须给出同一个答案（错误率 ≥60% **且** 样本 ≥5 才算易错），
// 而「样本不够就不标」正是 2026-09-30 定的口径（此前 1 人做错 = 100% 也会被标红，
// 那会把真正该讲的题挤下去）。四个面各写一份判据的话迟早各标各的。
//
// 线上目前没有一份卷子的题目同时满足两条件，所以这几条边界只能靠测试钉住。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) =>
          MaterialApp(theme: AppTheme.light(), home: Scaffold(body: child)),
    ),
  );
}

void main() {
  group('AccuracyChip', () {
    testWidgets('错误率 ≥60% 且样本 ≥5：标「易错」', (tester) async {
      await _pump(tester, const AccuracyChip(attempts: 20, correct: 5)); // 75%
      expect(find.text('易错 75%'), findsOneWidget);
    });

    testWidgets('边界：正好 5 次作答、正好 60% 错误率算易错', (tester) async {
      await _pump(tester, const AccuracyChip(attempts: 5, correct: 2)); // 60%
      expect(find.text('易错 60%'), findsOneWidget);
    });

    testWidgets('样本不够就不算易错：4 次作答全错（100%）只显示错误率', (tester) async {
      await _pump(tester, const AccuracyChip(attempts: 4, correct: 0));
      expect(find.text('错误率 100%'), findsOneWidget);
      expect(find.textContaining('易错'), findsNothing);
    });

    testWidgets('错误率不够也不算易错', (tester) async {
      await _pump(tester, const AccuracyChip(attempts: 20, correct: 12)); // 40%
      expect(find.text('错误率 40%'), findsOneWidget);
      expect(find.textContaining('易错'), findsNothing);
    });

    testWidgets('没有作答数据时什么都不渲染（0 次作答 ≠ 0% 错误率）', (tester) async {
      await _pump(tester, const AccuracyChip(attempts: 0, correct: 0));
      expect(find.byType(DuoChip), findsNothing);
    });
  });

  group('判据本身（跨两端那份契约）', () {
    test('错误率与样本量两条线必须同时满足', () {
      expect(isHighError(errorRate: 0.6, sample: 5), isTrue);
      expect(isHighError(errorRate: 0.6, sample: 4), isFalse);
      expect(isHighError(errorRate: 0.59, sample: 100), isFalse);
      expect(isHighError(errorRate: null, sample: 100), isFalse);
    });

    test('全站口径：由 attempts/correct 推出错误率', () {
      expect(isEasilyWrong(attempts: 10, correct: 3), isTrue); // 70%
      expect(isEasilyWrong(attempts: 3, correct: 0), isFalse); // 100% 但样本不够
      expect(isEasilyWrong(attempts: 0, correct: 0), isFalse); // 没数据
    });

    test('错答人次 = 作答 − 答对，且不会为负', () {
      expect(wrongAttempts(attempts: 10, correct: 3), 7);
      expect(wrongAttempts(attempts: 3, correct: 3), 0);
    });
  });
}
