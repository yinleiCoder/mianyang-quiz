// 外观半屏的接线：点一下要真的写进 ThemeStore（主题与持久化都在那边）。
//
// 为什么值得测：这个半屏本身不持有状态，它"对不对"完全取决于有没有把点击接到 store 上；
// 漏接的表现是**点了没反应**，而这类错误在真机上看起来像卡住了，很容易被当成"动画慢"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/profile/widgets/appearance_sheet.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('选「深色」→ store 变成 dark；点色点 → 换主题色', (tester) async {
    final store = ThemeStore();
    await _pumpHost(tester, store);

    await tester.tap(find.text('打开外观'));
    await tester.pumpAndSettle();

    expect(find.text('外观'), findsOneWidget);
    expect(find.text('跟随系统'), findsNothing, reason: '三个段位只用短词，避免窄屏挤成两行');

    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(store.mode, AppThemeMode.dark);

    // 主题色的圆点用 Tooltip 标名字（语义标签同源）
    await tester.tap(find.byTooltip('青'));
    await tester.pumpAndSettle();
    expect(store.seed, ThemeSeed.teal);
  });

  testWidgets('半屏跟着 store 变：外面改了，里面也是选中的那个', (tester) async {
    final store = ThemeStore();
    await _pumpHost(tester, store);

    await tester.tap(find.text('打开外观'));
    await tester.pumpAndSettle();

    // 打开后再从别处改（模拟"设置被同步过来"）——半屏要自己跟上
    await store.setMode(AppThemeMode.light);
    await tester.pumpAndSettle();
    final segmented = tester.widget<SegmentedButton<AppThemeMode>>(
      find.byType(SegmentedButton<AppThemeMode>),
    );
    expect(segmented.selected, {AppThemeMode.light});
  });
}

/// 把半屏挂在最小宿主上：一个能点开的按钮 + ThemeStore。
/// 不搭整套 App（那要网络与路由），这里只验接线。
Future<void> _pumpHost(WidgetTester tester, ThemeStore store) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => ChangeNotifierProvider.value(
        value: store,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showAppearanceSheet(context),
                  child: const Text('打开外观'),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
