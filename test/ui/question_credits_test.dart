// 题目署名的 widget 测试：作者/组长/专家三枚署名与头像、已注销占位、空列表不占位。
//
// 为什么值得测：署名是详情页唯一的"人"信息，三种状态（有档案、账号已注销、整行没人）
// 走的是三条不同的渲染分支；而头像的降级（没上传 → 首字）是实测踩过的坑，
// 一旦画成空洞或破图，看着就像页面坏了。
//
// 纯渲染测试：入参是数据，不发任何请求。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/query/question_credits.dart';
import 'package:mianyang_quiz/ui/core/people/user_avatar.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_credits_row.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_meta_header.dart';

void main() {
  testWidgets('元信息条：标签在左、署名在右，两端对齐（宽屏）', (tester) async {
    await _pumpMeta(tester, width: 900);

    final row = tester.getRect(find.byType(QuestionMetaHeader));
    final tags = tester.getRect(find.textContaining('标签：'));
    // 取最后一枚署名的**文字**：头像后面还有姓名，用头像.right 量不到这一行的右端
    final lastCredit = tester.getRect(find.text('专家 李四'));
    // 标签贴左边界、最后一枚署名贴右边界 —— 这就是 spaceBetween 的效果
    expect(tags.left - row.left, lessThan(1));
    expect(row.right - lastCredit.right, lessThan(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('元信息条：窄屏 390 下不溢出（各自换行）', (tester) async {
    await _pumpMeta(tester, width: 390);

    // 溢出会以 RenderFlex overflow 的形式抛异常；两端对齐在窄屏退化成上下换行是可以的
    expect(tester.takeException(), isNull);
    expect(find.textContaining('标签：'), findsOneWidget);
  });

  testWidgets('署名行：作者 + 组长 + 专家各带一枚头像', (tester) async {
    await _pump(
      tester,
      const [
        (caption: '作者', person: Profile(userId: 'u1', name: '尹唐涛')),
        (caption: '组长', person: Profile(userId: 'u2', name: '张三')),
        (caption: '专家', person: Profile(userId: 'u3', name: '李四')),
      ],
    );

    expect(find.text('作者 尹唐涛'), findsOneWidget);
    expect(find.text('组长 张三'), findsOneWidget);
    expect(find.text('专家 李四'), findsOneWidget);
    expect(find.byType(UserAvatar), findsNWidgets(3));
    // 没上传头像 → 首字占位（不是空洞）
    expect(find.text('尹'), findsOneWidget);
  });

  testWidgets('署名行：账号已注销时给出文字占位，且不留头像位', (tester) async {
    await _pump(tester, const [(caption: '作者', person: null)]);

    expect(find.text('作者 已注销'), findsOneWidget);
    expect(find.byType(UserAvatar), findsNothing);
  });

  testWidgets('署名行：空列表不占高度', (tester) async {
    await _pump(tester, const <QuestionCredit>[]);

    expect(find.byType(UserAvatar), findsNothing);
    expect(tester.getSize(find.byType(QuestionCreditsRow)).height, 0);
  });
}

/// 元信息条的两个用例共用：标签 + 三枚署名的完整一行，宽度可调。
Future<void> _pumpMeta(WidgetTester tester, {required double width}) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  const brief = QuestionBrief(
    questionId: 'q1',
    versionId: 'v1',
    qtype: 'single_choice',
    stemText: '',
    tags: ['word', '办公应用'],
    nodePath: '计算机 / 办公应用',
    schoolName: '盐亭县职业技术学校',
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: Size(width, 900),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: QuestionMetaHeader(
              brief: brief,
              credits: [
                (caption: '作者', person: Profile(userId: 'u1', name: '尹唐涛')),
                (caption: '组长', person: Profile(userId: 'u2', name: '张三')),
                (caption: '专家', person: Profile(userId: 'u3', name: '李四')),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pump(WidgetTester tester, List<QuestionCredit> credits) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: QuestionCreditsRow(credits: credits),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
