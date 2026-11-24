// 密码框的显示 / 隐藏明文。
//
// 为什么值得测：这是四个密码入口共用的一份交互，眼睛图标一旦失灵，
// 用户会以为"密码只能盲打"，而且没有任何报错可看。

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
  testWidgets('默认隐藏，点眼睛显示明文，再点恢复隐藏', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await _pump(tester, PasswordField(controller: controller));

    TextField field() => tester.widget<TextField>(find.byType(TextField));
    expect(field().obscureText, isTrue);
    expect(find.byTooltip('显示密码'), findsOneWidget);

    await tester.tap(find.byTooltip('显示密码'));
    await tester.pump();
    expect(field().obscureText, isFalse);
    expect(find.byTooltip('隐藏密码'), findsOneWidget);

    await tester.tap(find.byTooltip('隐藏密码'));
    await tester.pump();
    expect(field().obscureText, isTrue);
  });

  testWidgets('提交中禁用：眼睛按钮也点不动，密码保持隐藏', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await _pump(tester, PasswordField(controller: controller, enabled: false));

    final button = tester.widget<IconButton>(find.byType(IconButton));
    expect(button.onPressed, isNull);
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
  });
}
