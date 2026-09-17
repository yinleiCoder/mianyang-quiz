// 考试倒计时的 widget 测试：显示剩余、每秒在走、到点只喊一次。
//
// 为什么值得测：倒计时"看起来在动"很容易骗过人，而它挂着**自动交卷**这个副作用——
// 触发两次就会把同一份卷子交两遍（服务端第二次会报"已经交卷了"，学生看到的是红色报错）；
// 一次都不触发则超时也不交卷。这三种状态在界面上长得一模一样。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_timer.dart';

void main() {
  final start = DateTime(2026, 9, 17, 10, 0, 0);

  testWidgets('显示剩余时间，并随假时钟每秒减少', (tester) async {
    var now = start;
    await _pump(tester, deadline: start.add(const Duration(minutes: 90)), nowOf: () => now);

    expect(find.text('1:30:00'), findsOneWidget);

    now = start.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('1:29:59'), findsOneWidget);

    now = start.add(const Duration(minutes: 30, seconds: 5));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('59:55'), findsOneWidget);
  });

  testWidgets('到点触发一次自动交卷，且不再重复触发', (tester) async {
    var now = start;
    var fired = 0;
    await _pump(
      tester,
      deadline: start.add(const Duration(seconds: 3)),
      nowOf: () => now,
      onExpired: () => fired++,
    );

    // 还剩 3 秒：不该触发
    await tester.pump(const Duration(seconds: 1));
    expect(fired, 0);

    now = start.add(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));
    expect(fired, 1);
    expect(find.text('00:00'), findsOneWidget);

    // 交卷是异步的：过点了每秒都再喊一遍的话，一次提交会变成几十次
    now = start.add(const Duration(seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(fired, 1);
  });

  testWidgets('进页面时就已经过点（续考一场早该交的卷）：回调发生在 build 之后', (tester) async {
    // 回调里 setState 是真实页面的做法（交卷要切状态/跳转）。如果倒计时在
    // initState 里同步喊这一声，就会撞上 "setState() called during build"——
    // 那正是它必须等一帧的原因。
    var fired = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, _) => MaterialApp(
          theme: AppTheme.light(),
          home: _Host(
            deadline: start.subtract(const Duration(hours: 2)),
            clock: () => start,
            onExpired: () => fired++,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(fired, 1);
    expect(find.text('00:00'), findsOneWidget);
  });

  testWidgets('最后五分钟转警示色', (tester) async {
    await _pump(
      tester,
      deadline: start.add(const Duration(minutes: 4)),
      nowOf: () => start,
    );

    final text = tester.widget<Text>(find.text('04:00'));
    final scheme = AppTheme.light().colorScheme;
    expect(text.style?.color, scheme.error);
  });
}

/// 把倒计时放进一个真实页面形状的宿主里：收到"到点"就 setState（真实页面会这么干）。
class _Host extends StatefulWidget {
  const _Host({
    required this.deadline,
    required this.clock,
    required this.onExpired,
  });

  final DateTime deadline;
  final DateTime Function() clock;
  final VoidCallback onExpired;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExamTimer(
          deadline: widget.deadline,
          clock: widget.clock,
          onExpired: () {
            widget.onExpired();
            setState(() {});
          },
        ),
      ),
    );
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required DateTime deadline,
  required DateTime Function() nowOf,
  VoidCallback? onExpired,
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: ExamTimer(
              deadline: deadline,
              clock: nowOf,
              onExpired: onExpired,
            ),
          ),
        ),
      ),
    ),
  );
  if (settle) await tester.pump();
}
