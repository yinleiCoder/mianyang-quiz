// 主题底色的测试。
//
// 学生试用后的第一条反馈就是"软件背景应该是白的"：fromSeed 从 deepPurple 派生的
// surface 是带紫的近白色（#FEF7FF），单看一张卡不觉得，整屏铺开就是发灰发紫。
// 这条改动只在亮色生效——顺手钉住"暗色别被一起改成白的"。
//
// 用 testWidgets 而不是 test：AppTheme 里的圆角/间距都走 ScreenUtil 的 .r，
// 没经 ScreenUtilInit 初始化会抛 LateInitializationError。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';

void main() {
  testWidgets('亮色：页面底色与顶栏都是纯白', (tester) async {
    final theme = await _themeOf(tester, Brightness.light);

    expect(theme.scaffoldBackgroundColor, Colors.white);
    expect(theme.appBarTheme.backgroundColor, Colors.white);
  });

  testWidgets('暗色：底色仍是深色，没被一起改成白的', (tester) async {
    final theme = await _themeOf(tester, Brightness.dark);

    expect(theme.scaffoldBackgroundColor, isNot(Colors.white));
    expect(theme.scaffoldBackgroundColor.computeLuminance(), lessThan(0.2));
  });

  testWidgets('亮色下卡片与页面分得开（白底上仍看得出层次）', (tester) async {
    final theme = await _themeOf(tester, Brightness.light);

    expect(theme.cardTheme.color, isNot(Colors.white));
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
