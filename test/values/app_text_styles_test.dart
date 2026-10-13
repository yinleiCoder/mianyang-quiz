// 字阶的两条硬约束（2026-10-12 M3 改版时立）：
//
// ① **主题里不许有 w500**。中文字体只有 400/700，w500 会走引擎合成的伪粗体，
//    而合成结果在不同字号上并不一致（AGENTS.md 二·五）。`tool/check_architecture.dart`
//    只盯得到代码里写死的字面量，**盯不到从主题继承来的字重**——而 M3 默认的
//    titleMedium / titleSmall / label* 五档恰好全是 w500，全仓一百多处内联用法都吃它。
//    所以在这条测试里钉死：谁把 _cjkWeights 删了，这里立刻红。
//
// ② **六个角色对着 M3 的字阶取值**（24/16/16/12/28/14）。它们是全站唯一出处，
//    漂了就是整站字号漂了。字重一律 w700（M3 的 500 档在中文里落强的那一侧）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  testWidgets('亮暗两套主题的每一档字重都只有 w400 / w700', (tester) async {
    for (final brightness in Brightness.values) {
      final text = (await _themeOf(tester, brightness)).textTheme;
      for (final entry in _roles(text).entries) {
        final weight = entry.value.fontWeight;
        // null = 继承默认（400），也算合规
        expect(
          weight == null || weight == FontWeight.w400 || weight == FontWeight.w700,
          isTrue,
          reason: '${brightness.name} 的 ${entry.key} 是 $weight —— '
              'M3 的 w500 档必须在主题里收敛成 w700（中文合成伪粗体见 AGENTS.md 二·五）',
        );
      }
    }
  });

  testWidgets('六个角色对着 M3 字阶：24 / 16 / 16 / 12 / 28 / 14', (tester) async {
    final styles = await _appStyles(tester);
    expect(styles['pageTitle']!.fontSize, 24, reason: 'M3 headlineSmall');
    expect(styles['sectionTitle']!.fontSize, 16, reason: 'M3 titleMedium');
    expect(styles['body']!.fontSize, 16, reason: 'M3 bodyLarge');
    expect(styles['caption']!.fontSize, 12, reason: 'M3 bodySmall');
    expect(styles['number']!.fontSize, 28, reason: 'M3 headlineMedium');
    expect(styles['label']!.fontSize, 14, reason: 'M3 labelLarge');
  });

  testWidgets('字体回退栈带着中文字体（丢了就是整屏方块）', (tester) async {
    final theme = await _themeOf(tester, Brightness.light);
    // 回退栈挂在字阶的每一档上（ThemeData 本身没有这个字段）
    final stack = theme.textTheme.bodyLarge?.fontFamilyFallback;
    // 拉丁字形交给平台默认，中文全靠这条栈——Android 上尤其不能只留 Windows 的字体
    expect(stack, contains('Microsoft YaHei UI'));
    expect(stack, contains('Noto Sans CJK SC'));
  });
}

Map<String, TextStyle> _roles(TextTheme t) => {
  'displayLarge': t.displayLarge!,
  'displayMedium': t.displayMedium!,
  'displaySmall': t.displaySmall!,
  'headlineLarge': t.headlineLarge!,
  'headlineMedium': t.headlineMedium!,
  'headlineSmall': t.headlineSmall!,
  'titleLarge': t.titleLarge!,
  'titleMedium': t.titleMedium!,
  'titleSmall': t.titleSmall!,
  'bodyLarge': t.bodyLarge!,
  'bodyMedium': t.bodyMedium!,
  'bodySmall': t.bodySmall!,
  'labelLarge': t.labelLarge!,
  'labelMedium': t.labelMedium!,
  'labelSmall': t.labelSmall!,
};

/// 六个角色都要一个 context（它们从 Theme 派生），所以得挂一棵最小树。
Future<Map<String, TextStyle>> _appStyles(WidgetTester tester) async {
  late Map<String, TextStyle> captured;
  await _pump(tester, () {}, (context) {
    captured = {
      'pageTitle': AppTextStyles.pageTitle(context),
      'sectionTitle': AppTextStyles.sectionTitle(context),
      'body': AppTextStyles.body(context),
      'caption': AppTextStyles.caption(context),
      'number': AppTextStyles.number(context),
      'label': AppTextStyles.label(context),
    };
  });
  return captured;
}

Future<ThemeData> _themeOf(WidgetTester tester, Brightness brightness) async {
  late ThemeData captured;
  await _pump(tester, () {}, (context) {
    captured = Theme.of(context);
  }, brightness: brightness);
  return captured;
}

/// 主题里用了 .r/.sp，**必须在 ScreenUtilInit 之下求值**（否则抛 LateInitializationError）。
Future<void> _pump(
  WidgetTester tester,
  void Function() _,
  void Function(BuildContext) capture, {
  Brightness brightness = Brightness.light,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: brightness == Brightness.light ? AppTheme.light() : AppTheme.dark(),
        home: Builder(
          builder: (inner) {
            capture(inner);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  await tester.pump();
}
