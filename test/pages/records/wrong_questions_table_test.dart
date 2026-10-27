// 错题本 DataTable 的宽度：宽屏上必须占满，不能右边空一大条。
//
// 这一条单独测是因为它只在"屏幕比三列内容宽"时才看得见——手机上表格本来就
// 横向滚动，察觉不到。用户在 Windows 桌面端报的正是这个（2026-10-27）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/records/widgets/wrong_questions_table.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  testWidgets('宽屏上表格占满可用宽度', (tester) async {
    await _pump(tester, const Size(1280, 800));

    final table = tester.getSize(find.byType(DataTable));
    // 修之前三列的固有宽度约 480，修之后应铺满 1280 宽（减去左右页边距）
    expect(table.width, greaterThan(1200));
    expect(table.width, lessThanOrEqualTo(1280));
  });

  testWidgets('窄屏上仍然可以横向滚动（不因铺满而裁掉列）', (tester) async {
    await _pump(tester, const Size(390, 844));

    // 表格比视口宽时允许溢出滚动；这里只断言没有抛布局异常、题干仍可见
    expect(find.textContaining('下列词语'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  const rows = [
    WrongQuestion(
      questionId: 'q1',
      qtype: 'single_choice',
      difficulty: 2,
      wrongCount: 3,
      stemText: '下列词语中加点字的读音完全正确的一项是',
    ),
  ];

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppMetrics.pagePadding.r,
            ),
            child: SingleChildScrollView(
              child: WrongQuestionsTable(
                rows: rows,
                sortKey: 'wrong',
                ascending: false,
                onSort: (_, _) {},
                onOpen: (_) {},
                onLoadMore: () {},
                hasMore: false,
                loadingMore: false,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
