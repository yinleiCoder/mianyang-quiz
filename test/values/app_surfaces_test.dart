// 侧栏底色的测试。
//
// 锁三件事：Windows 亮色下侧栏是纯白（学生反馈桌面端侧栏"发灰发紫"）、
// 暗色**没有**被一起改成白的（白侧栏在暗色下等于把界面掀翻）、
// 其它平台一切照旧（别为了一个平台把手机端也改了）。
//
// 用 testWidgets 而不是 test：AppTheme 里的圆角/间距都走 ScreenUtil 的 .r，
// 没经 ScreenUtilInit 初始化会抛 LateInitializationError（同 app_theme_test）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  testWidgets('Windows 亮色：侧栏纯白', (tester) async {
    final theme = await _themeOf(tester, Brightness.light);

    final sideNav = AppSurfaces.sideNav(
      theme.copyWith(platform: TargetPlatform.windows),
    );

    expect(sideNav, Colors.white);
  });

  testWidgets('Windows 暗色：侧栏仍是深色，没被改成白的', (tester) async {
    final theme = await _themeOf(tester, Brightness.dark);

    final sideNav = AppSurfaces.sideNav(
      theme.copyWith(platform: TargetPlatform.windows),
    );

    expect(sideNav, isNot(Colors.white));
    expect(sideNav.computeLuminance(), lessThan(0.2));
  });

  testWidgets('手机端（非 Windows）亮色：保持 surfaceContainer，不跟着变白', (tester) async {
    final theme = await _themeOf(tester, Brightness.light);

    final sideNav = AppSurfaces.sideNav(
      theme.copyWith(platform: TargetPlatform.android),
    );

    expect(sideNav, theme.colorScheme.surfaceContainer);
  });

  testWidgets('卡片是白色（暗色下是深色 surface），不再叠主题色轻染', (tester) async {
    final light = await _themeOf(tester, Brightness.light);
    final dark = await _themeOf(tester, Brightness.dark);

    expect(AppSurfaces.card(light.colorScheme), Colors.white);
    expect(AppSurfaces.contentCard(light.colorScheme), Colors.white);
    // 暗色下卡片跟着主题的 surface；亮色固定白（不再叠主题色轻染）。
    expect(AppSurfaces.card(dark.colorScheme), dark.colorScheme.surface);
  });
}

Future<ThemeData> _themeOf(WidgetTester tester, Brightness brightness) async {
  late ThemeData captured;
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: brightness == Brightness.light
            ? AppTheme.light()
            : AppTheme.dark(),
        home: Builder(
          builder: (inner) {
            captured = Theme.of(inner);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  await tester.pump();
  return captured;
}
