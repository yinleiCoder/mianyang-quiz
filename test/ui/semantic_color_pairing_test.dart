// 语义色的「底色 / 前景」配对测试。
//
// 为什么值得测：M3 没有「成功」这个角色，本仓自己定义了 SemanticColors。
// 一旦有人拿 onTertiaryContainer 去配 successContainer（AGENTS.md 二·五记的那个坑），
// 代码读起来通顺、analyze 也不报错，只有真看界面才发现字和底糊在一起——
// deepPurple 种子派生出的 tertiary 是**粉红色**，粉字压浅绿底就是这样来的。
//
// 断言的是"取的是同族 on 色"，而不是某个具体色值：换色板不该让测试红。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';

void main() {
  // 主题必须在用例体内构建：AppTheme 里用了 `.r`，ScreenUtil 还没初始化时会抛
  // 「Field '_data' has not been initialized」（与其它 widget 测试同一个坑）。
  for (final (name, dark, expected) in [
    ('亮色', false, SemanticColors.light),
    ('暗色', true, SemanticColors.dark),
  ]) {
    testWidgets('$name：成功色 chip 的前景是 onSuccessContainer，不是 onTertiaryContainer', (
      tester,
    ) async {
      await _pump(
        tester,
        dark: dark,
        child: const DuoChip(label: '难度 易', tone: DuoChipTone.success),
      );

      final text = tester.widget<Text>(find.text('难度 易'));
      expect(text.style?.color, expected.onSuccessContainer);
      expect(
        text.style?.color,
        isNot(Theme.of(tester.element(find.byType(DuoChip))).colorScheme.onTertiaryContainer),
        reason: 'onTertiaryContainer 是粉红色，压在浅绿底上就是"字和底糊在一起"',
      );

      final box = tester.widget<Container>(find.byType(Container).first);
      expect((box.decoration as BoxDecoration?)?.color, expected.successContainer);
    });

    testWidgets('$name：成功色图标徽标同样用 onSuccessContainer', (tester) async {
      await _pump(
        tester,
        dark: dark,
        child: const DuoIconBadge(
          icon: Icons.check,
          tone: DuoIconBadgeTone.success,
          filled: true,
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, expected.onSuccessContainer);
    });
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required bool dark,
  required Widget child,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      // 主题在 builder 里建：AppTheme 用了 `.r`，要等 ScreenUtilInit 初始化完才行
      builder: (context, _) => MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        home: Scaffold(body: Center(child: child)),
      ),
    ),
  );
  await tester.pump();
}
