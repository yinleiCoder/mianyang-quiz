// 组卷页「题量」滑杆的 widget 测试。
//
// 为什么值得测：题量从 ±5 的步进器换成了滑杆，上限也从 50 放到 100。
// 这类控件的错法（上限写死成别的数、拖动后回调没把 double 收成 int、
// 值超出 min/max 导致 Slider 断言失败）都不会在 analyze 里露头。
//
// 纯渲染 + 回调：不连任何服务。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/compose_options.dart';

void main() {
  testWidgets('题量用滑杆：上限 100、当前值显示在标题右侧', (tester) async {
    await _pump(tester, limit: 20);

    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('题量'), findsOneWidget);
    expect(find.text('20 题'), findsOneWidget);

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, PracticeDraftStore.minLimit.toDouble());
    expect(slider.max, 100);
    expect(slider.value, 20);
    expect(slider.divisions, 99, reason: '一题一档');
  });

  testWidgets('拖到最右给出 100（不是 50）', (tester) async {
    final changed = <int>[];
    await _pump(tester, limit: 20, onChanged: changed.add);

    await tester.drag(find.byType(Slider), const Offset(600, 0));
    await tester.pumpAndSettle();

    expect(changed, isNotEmpty);
    expect(changed.last, 100);
  });

  testWidgets('拖到最左给出 1', (tester) async {
    final changed = <int>[];
    await _pump(tester, limit: 60, onChanged: changed.add);

    await tester.drag(find.byType(Slider), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(changed.last, 1);
  });

  testWidgets('越界的 limit 不会让滑杆断言失败（取的是夹住后的值）', (tester) async {
    await _pump(tester, limit: 999);

    expect(tester.takeException(), isNull);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 100);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required int limit,
  ValueChanged<int>? onChanged,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        // 主题在 builder 里建：AppTheme 用了 `.r`，要等 ScreenUtilInit 初始化完
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ComposeOptions(
              mode: PracticeMode.instant,
              limit: limit,
              shuffle: true,
              sound: true,
              onModeChanged: (_) {},
              onLimitChanged: onChanged ?? (_) {},
              onShuffleChanged: (_) {},
              onSoundChanged: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
