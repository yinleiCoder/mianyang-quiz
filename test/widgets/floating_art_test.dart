// 会动的插画（FloatingArt）的测试：资源在包里、能解析、真的在动、并且**会停下来**。
//
// 为什么要测这三件：
//   · flutter_svg 对 SVG 语法很严格，写坏了是"那块地方什么都没有"（静默）；
//   · "看起来在动"的组件太容易骗过人（控制器的值没人读、动画绑错对象，界面第一眼一样）；
//   · 漂浮是**有限次数**的——这条得钉住，无限循环会让 pumpAndSettle 永远等不到静止，
//     那是全仓测试的公共负担（本仓的加载转圈就是那个毛病）。

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('吉祥物 SVG 真的打进了包（路径写错是静默的，只能靠这里兜住）', () async {
    final data = await rootBundle.load(kMascotStudy);

    expect(data.lengthInBytes, greaterThan(400));
    final text = String.fromCharCodes(data.buffer.asUint8List());
    expect(text, contains('<svg'), reason: '加载出来的不是 SVG');
  });

  testWidgets('能被 flutter_svg 解析并画出来', (tester) async {
    await _pump(tester);

    // 矢量图形的解码走的是真实异步，假时钟推不动它——让真实时间流一点过去再断言
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await tester.pump();

    expect(tester.takeException(), isNull, reason: 'SVG 语法有问题时会在这里冒出来');
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('漂浮期间位置真的在变，最后停在静止位置（不是无限循环）', (tester) async {
    await _pump(tester);
    final rest = tester.getCenter(find.byType(SvgPicture));

    // 入场播完，再空推一帧让漂浮从这一帧起算（入场结束时才启动漂浮，见实现）
    await tester.pump(AppMotion.slow);
    await tester.pump();

    // 采样点要挑在正弦的波峰与波谷上：正好踩在过零点上会得到"没动"的假象
    await tester.pump(AppMotion.loop ~/ 4);
    final a = tester.getCenter(find.byType(SvgPicture));
    await tester.pump(AppMotion.loop ~/ 2);
    final b = tester.getCenter(find.byType(SvgPicture));

    expect(
      (a.dy - b.dy).abs(),
      greaterThan(3),
      reason: '插画应当真的在浮动（幅度约 ±3.5）',
    );
    expect(a.dx, closeTo(b.dx, 0.5), reason: '只上下漂，不该左右跑');

    // 关键：pumpAndSettle 能收尾 —— 有限次数，不会把测试挂死
    await tester.pumpAndSettle();

    expect(
      tester.getCenter(find.byType(SvgPicture)).dy,
      closeTo(rest.dy, 0.5),
      reason: '漂完要回到静止位置（起点与终点都在零点）',
    );
    await tester.pump(AppMotion.loop);
    expect(
      tester.getCenter(find.byType(SvgPicture)).dy,
      closeTo(rest.dy, 0.5),
      reason: '停下来之后就不该再动了',
    );
  });
}

Future<void> _pump(WidgetTester tester, {double size = 96}) async {
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
            child: FloatingArt(asset: kMascotStudy, size: size, semanticLabel: '小书'),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
