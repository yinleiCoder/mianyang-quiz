// 即时练习反馈条的跳题规则（用户 2026-10-12）：
//   · 答对 → **不自动跳**，等学生自己点「继续」（有人要核对解析，2 秒会把页面抢走）
//   · 答错 → 同样不跳（一直如此）
//   · 末题 → 按钮文案变「完成」（就是交卷），更不会替学生按
//
// 为什么值得测：这条规则反复过三回（连答错也跳 → 只答对跳 → 一律不跳），
// 每次都有"看起来更顺"的理由推着它往回走。所以这里把**时间推进很久也不动**钉死，
// 谁想加回自动跳，先得删掉这几条断言，没法顺手改回来。
//
// 这个组件不再持有任何 Timer，所以也不需要"dispose 要取消计时器"那条测试。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_feedback_bar.dart';

void main() {
  testWidgets('答对也不自动跳：放多久都要学生自己点「继续」', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: true, onContinue: () => continued++);

    expect(find.text('答对了'), findsOneWidget);
    expect(find.text('2 秒后自动进入下一题'), findsNothing, reason: '不自动跳，就没有这句预告');

    // 时间一路推过去：2 秒、10 秒、1 分钟，都不该自己动
    for (final wait in const [
      Duration(seconds: 2),
      Duration(seconds: 10),
      Duration(seconds: 60),
    ]) {
      await tester.pump(wait);
      expect(continued, 0, reason: '答对的人也要核对解析，自动跳会把它抢走');
    }

    await tester.tap(find.text('继续'));
    expect(continued, 1, reason: '手动点是唯一的出口');
  });

  testWidgets('答错：同样不自动跳，等学生自己点「继续」', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: false, onContinue: () => continued++);

    expect(find.text('答错了'), findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    expect(continued, 0, reason: '答错的人要看解析，自动跳会把它抢走');

    await tester.tap(find.text('继续'));
    expect(continued, 1);
  });

  testWidgets('末题：按钮是「完成」（交卷），放多久都不会替学生按下去', (tester) async {
    var continued = 0;
    await _pumpBar(tester, correct: true, isLast: true, onContinue: () => continued++);

    await tester.pump(const Duration(seconds: 10));
    expect(continued, 0);
    expect(find.text('完成'), findsOneWidget);
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
