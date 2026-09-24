// 即时练习反馈条的自动跳题规则（用户 2026-09-24）：
//   · 答对 → 2 秒后自动进入下一题（答对的人基本不用看解析）
//   · 答错 → 停在原地，等学生自己点「继续」（要看解析）
//   · 末题 → 永不自动跳（「完成」就是交卷，不能替学生按下去）
//
// 为什么值得测：这里曾经一刀切地取消过自动跳——因为当年连答错也跳，解析被抢走，
// 学生反映"看不到解析"。现在只保留答对这条，边界必须钉死，
// 免得以后有人顺手把它改回"一律自动跳"。
//
// 另一个好处：这个组件自己持有 Timer，测在这里能保证它 dispose 时取消了——
// 漏掉取消会让**所有**渲染过反馈条的测试报"pending timer"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_feedback_bar.dart';

void main() {
  testWidgets('答对：2 秒后自动进入下一题', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: true, onContinue: () => continued++);

    expect(find.text('答对了'), findsOneWidget);
    expect(find.text('2 秒后自动进入下一题'), findsOneWidget, reason: '不预告就切页，学生会以为点错了');

    // 差一点点还不跳
    await tester.pump(const Duration(milliseconds: 1900));
    expect(continued, 0, reason: '刚判完就跳会看不清对错');

    await tester.pump(const Duration(milliseconds: 200));
    expect(continued, 1, reason: '2 秒后应当自己跳到下一题');
  });

  testWidgets('答错：不自动跳，等学生自己点「继续」', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: false, onContinue: () => continued++);

    expect(find.text('答错了'), findsOneWidget);
    expect(find.text('2 秒后自动进入下一题'), findsNothing, reason: '答错不跳，也就没有这句预告');

    await tester.pump(const Duration(seconds: 10));
    expect(continued, 0, reason: '答错的人要看解析，自动跳会把它抢走');

    await tester.tap(find.text('继续'));
    expect(continued, 1, reason: '手动点是唯一的出口');
  });

  testWidgets('末题答对也不自动跳：「完成」是交卷，不能替学生按', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: true, isLast: true, onContinue: () => continued++);

    await tester.pump(const Duration(seconds: 10));
    expect(continued, 0);
    expect(find.text('完成'), findsOneWidget);
  });

  testWidgets('卸载后计时器不再触发（否则所有渲染过反馈条的测试都会吊着 pending timer）', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: true, onContinue: () => continued++);

    // 切题：反馈条被换掉 → dispose
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
    expect(continued, 0, reason: 'dispose 里没取消的话，这里会对着已销毁的页面回调');
  });
}

Future<void> _pumpBar(
  WidgetTester tester, {
  required bool correct,
  required VoidCallback onContinue,
  bool isLast = false,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      // 桌面端与测试环境都关掉线性缩放；不传的话会把 390 按屏幕放大
      enableScaleWH: () => false,
      enableScaleText: () => false,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: PracticeFeedbackBar(
              correct: correct,
              isLast: isLast,
              summary: '正确答案：B',
              onContinue: onContinue,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
