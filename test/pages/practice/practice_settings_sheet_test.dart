// 练习页「练习设置」里的练题音效开关。
//
// 为什么值得测：它和开始练习页的开关是同一份本地偏好，任何一边写坏，
// 表现都是"开关看起来动了、声音没变"或反过来，运行时没有任何报错。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_settings_sheet.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('练题音效开关与 SfxService 同步', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sfx = SfxService();
    addTearDown(sfx.dispose);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => ChangeNotifierProvider<SfxService>.value(
          value: sfx,
          // Provider 必须在 MaterialApp 之上：bottom sheet 是路由级的，
          // 挂在 home 下面它看不见（生产代码也是这个层级）。
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => openPracticeSettings(context),
                  child: const Text('打开设置'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开设置'));
    await tester.pumpAndSettle();

    expect(find.text('练题音效'), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isTrue,
    );

    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();

    expect(sfx.enabled, isFalse);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );

    // 等 setEnabled 里的本地写入走完，避免测试结束时留下未完成的异步
    await tester.pumpAndSettle();
  });
}
