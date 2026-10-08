// 入场动效（FadeSlideIn）的测试：真的在淡入、错开顺序生效、并且**会结束**。
//
// 值得测的理由：它是全站列表/卡片的入场包装，一旦退化成"永远播不完"，
// 所有用 pumpAndSettle 的页面测试都会挂死——那种故障排查起来极贵。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

void main() {
  testWidgets('从透明淡入到不透明，并回到原位', (tester) async {
    await _pump(tester);

    // 首帧：还在起点（透明度 0、向下偏移）
    expect(_opacity(tester), lessThan(1));
    final start = tester.getTopLeft(find.text('内容'));

    await tester.pump(AppMotion.medium);
    expect(_opacity(tester), 1);
    expect(
      tester.getTopLeft(find.text('内容')).dy,
      lessThan(start.dy),
      reason: '应该从下往上升，而不是原地出现',
    );
  });

  testWidgets('order 越大越晚开始，但封顶（长列表不会等到天荒地老）', (tester) async {
    await _pump(tester, order: AppMotion.maxStagger + 10);

    // 延迟 240ms 封顶：推进略少于封顶时间时还没开始
    await tester.pump(AppMotion.staggerFor(AppMotion.maxStagger + 10) - const Duration(milliseconds: 20));
    final early = _opacity(tester);
    expect(early, lessThan(1), reason: '错开的那一段里应当还在起点');

    await tester.pump(AppMotion.medium + const Duration(milliseconds: 40));
    expect(_opacity(tester), 1);
  });

  testWidgets('动画会结束：pumpAndSettle 不超时', (tester) async {
    await _pump(tester);

    await tester.pumpAndSettle();

    expect(_opacity(tester), 1);
  });
}

/// 只读 FadeSlideIn 自己那一层——树上还有路由/主题带来的 FadeTransition。
double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find
          .descendant(
            of: find.byType(FadeSlideIn),
            matching: find.byType(FadeTransition),
          )
          .first,
    )
    .opacity
    .value;

Future<void> _pump(WidgetTester tester, {int order = 0}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(child: FadeSlideIn(order: order, child: const Text('内容'))),
        ),
      ),
    ),
  );
  await tester.pump();
}
