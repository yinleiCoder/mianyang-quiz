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

  testWidgets('两行题干 + 题型/难度 chip 不撑破行高', (tester) async {
    await _pump(
      tester,
      const Size(390, 844),
      rows: const [
        WrongQuestion(
          questionId: 'q-long',
          qtype: 'single_choice',
          difficulty: 3,
          wrongCount: 12,
          stemText: '下列对计算机病毒特征的描述中，属于病毒自我复制与传播能力、'
              '潜伏性和破坏性综合考查的选项是',
        ),
      ],
      // 系统字体放大到 1.5 倍时，两行题干 + chip 会超过 72 的行高上限。
      textScale: 1.5,
    );

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pump(
  WidgetTester tester,
  Size size, {
  List<WrongQuestion>? rows,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final data = rows ?? const [
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
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppMetrics.pagePadding.r,
            ),
            child: SingleChildScrollView(
              child: WrongQuestionsTable(
                rows: data,
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
