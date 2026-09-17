// 答题页的装配与版式测试。
//
// 钉住三件事：
//   · 答题卡在宽屏常驻右侧、窄屏收进顶栏——**同一个东西不给两个入口**；
//   · 选项点选后计入"已作答"，答题卡与底部条的提示跟着变；
//   · 桌面 1280×800 下不出现布局异常（屏幕适配的坑只在这个尺寸暴露）。
//
// 用 ExamRunner 直接驱动舞台，不经过路由：舞台的跳转只在交卷/退出时发生，
// 渲染路径与路由无关。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_stage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final now = DateTime(2026, 9, 17, 10, 0, 0);

  testWidgets('窄屏：答题卡收进顶栏按钮，题目与底部操作区都在', (tester) async {
    await _pump(tester, const Size(390, 844), now: now);

    // 顶栏：题号 + 倒计时（还剩 1 小时）+ 答题卡入口
    expect(find.text('1/3'), findsOneWidget);
    expect(find.text('1:00:00'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);

    // 第一题是大题的第一题，卷面上先印大题名与给分口径
    expect(find.text('一、单项选择题'), findsOneWidget);
    expect(find.textContaining('本大题共 2 小题'), findsOneWidget);
    expect(find.text('第 1 题'), findsOneWidget);
    expect(find.text('10 分'), findsOneWidget);
    expect(find.text('中国的首都是哪里？'), findsOneWidget);

    // 底部：上一题（禁用）/ 下一题 / 提前交卷
    expect(find.text('上一题'), findsOneWidget);
    expect(find.text('下一题'), findsOneWidget);
    expect(find.text('交卷'), findsOneWidget);
    expect(find.textContaining('还有 3 道题没作答'), findsOneWidget);

    // 窄屏没有常驻答题卡（只有顶栏那个入口）
    expect(find.text('答题卡'), findsNothing);
  });

  testWidgets('窄屏：底部三颗按钮的文案不被压窄（真机上会变成「上…」「下…」）', (tester) async {
    // 320 是最窄的一档安卓机。**这个宽度是量出来的**：真机联调时窗口是 368 逻辑像素，
    // 那里三颗带图标的按钮刚好被压成「上…」「下…」；而在 390/360 下测试字体比
    // 微软雅黑窄一点，同样的代码却能过——把宽度压到 320 才真的能复现挤窄。
    await _pump(tester, const Size(320, 700), now: now);

    // 「显示得下」不能靠 find.text —— 省略号是绘制期的事，Text 的数据仍是完整的三个字。
    // 只能量：文本实际拿到的宽度不能小于它自己排出来需要的宽度。
    for (final label in ['上一题', '下一题', '交卷']) {
      final widget = tester.widget<Text>(find.text(label));
      final painter = TextPainter(
        text: TextSpan(text: label, style: widget.style),
        textDirection: TextDirection.ltr,
      )..layout();
      expect(
        tester.getSize(find.text(label)).width,
        greaterThanOrEqualTo(painter.width - 0.5),
        reason: '「$label」被挤窄了，真机上会显示成省略号',
      );
    }
  });

  testWidgets('宽屏：答题卡常驻右侧，顶栏不再有入口', (tester) async {
    await _pump(tester, const Size(1280, 800), now: now);

    expect(find.text('答题卡'), findsOneWidget);
    expect(find.text('已作答 0/3'), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsNothing);
  });

  testWidgets('点选选项后计入已作答，答题卡与提示跟着变', (tester) async {
    final runner = await _pump(tester, const Size(1280, 800), now: now);

    await tester.tap(find.text('北京'));
    await tester.pump();

    expect(runner.answeredCount, 1);
    expect(find.text('已作答 1/3'), findsOneWidget);
    expect(find.textContaining('还有 2 道题没作答'), findsOneWidget);
  });

  testWidgets('桌面 1280×800 下不出现布局异常', (tester) async {
    await _pump(tester, const Size(1280, 800), now: now);

    expect(tester.takeException(), isNull);
  });
}

Future<ExamRunner> _pump(
  WidgetTester tester,
  Size size, {
  required DateTime now,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final runner = ExamRunner(
    repository: PaperRepository(
      SupabaseClient(
        'https://example.supabase.co',
        'sb_publishable_x',
        authOptions: const AuthClientOptions(autoRefreshToken: false),
      ),
    ),
    snapshot: _snapshot(now),
    clock: () => now,
  );

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      // 与 bootstrap.dart 同款：桌面端关掉线性缩放，否则 .sp(17) 会被放大 3.3 倍
      enableScaleWH: () => false,
      enableScaleText: () => false,
      // 舞台现在会在点选项时放音效，所以需要一个 SfxService
      // （测试环境没有音频通道，播放失败在服务里是静默的）
      builder: (context, _) => ChangeNotifierProvider<SfxService>.value(
        value: SfxService(),
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SafeArea(child: ExamStage(runner: runner, clock: () => now)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return runner;
}

ExamSnapshot _snapshot(DateTime now) => ExamSnapshot(
  attempt: ExamAttempt(
    id: 'a1',
    paperId: 'p1',
    paperVersionId: 'v1',
    startedAt: now,
    deadlineAt: now.add(const Duration(hours: 1)),
    fullScore: 30,
  ),
  paper: const ExamPaper(
    versionId: 'v1',
    paperId: 'p1',
    title: '期中卷',
    durationMinutes: 60,
    totalScore: 30,
    sections: [
      ExamSection(
        id: 's1',
        seqLabel: '一',
        title: '单项选择题',
        sectionScore: 20,
        items: [
          ExamItem(
            id: 'i1',
            seq: 1,
            qtype: 'single_choice',
            score: 10,
            scoreUnits: [10],
            content: QuestionContent(
              stem: [Block.text(text: '中国的首都是哪里？')],
              options: [
                QuestionOption(key: 'A', label: [Block.text(text: '北京')]),
                QuestionOption(key: 'B', label: [Block.text(text: '上海')]),
              ],
            ),
          ),
          ExamItem(
            id: 'i2',
            seq: 2,
            qtype: 'true_false',
            score: 10,
            scoreUnits: [10],
            content: QuestionContent(stem: [Block.text(text: '水的沸点是 100℃。')]),
          ),
        ],
      ),
      ExamSection(
        id: 's2',
        seqLabel: '二',
        title: '简答题',
        sectionScore: 10,
        items: [
          ExamItem(
            id: 'i3',
            seq: 3,
            qtype: 'short_answer',
            score: 10,
            scoreUnits: [10],
            content: QuestionContent(stem: [Block.text(text: '简述光合作用。')]),
          ),
        ],
      ),
    ],
  ),
);
