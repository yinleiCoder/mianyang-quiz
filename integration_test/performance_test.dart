// 帧耗时基准：在真实设备上量「列表滚动」与「列表首屏」两件事的帧预算。
//
// **为什么要有它**：这个项目在此之前没有任何性能基线——渲染侧的改动（换主题、
// 给卡片加阴影/裁剪、改重建粒度）没有任何东西能告诉你"变慢了"。
// 官方文档的原话是 Flutter 默认就快，要防的是踩坑；而防坑的前提是**量得出来**。
//
// **量的是什么**（FrameTimingSummarizer 的输出，见 build/ 下产出的 json）：
//   average / 90th / 99th / worst frame build time    —— UI 线程（Dart 构建）
//   average / 90th / 99th / worst frame rasterizer    —— 光栅线程（GPU 提交）
//   missed_frame_build_budget_count / missed_frame_rasterizer_budget_count
// 60Hz 下每帧预算是 16ms，上面这四个数里**看 99th 与 worst**：
// 平均值好看而 worst 很差，说明有偶发的重布局，那才是用户感觉到的卡。
//
// **必须用 flutter drive 跑**，否则数字无处可去：
//   flutter drive \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/performance_test.dart \
//     --profile
// 产出：build/bank_scroll_summary.json、build/list_first_frame_summary.json
//
// **不要用 flutter test 跑这个文件取性能**：那是 debug 构建，
// 官方明确说 debug 下的数字不代表用户体感（assert 与 JIT 都会拖慢）。
// 用 flutter test 跑只验证"这两段流程本身不抛异常"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/bootstrap.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/bank/widgets/question_list_view.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 列表规模：题库页一页 10 条，但用户会一直往下翻，
/// 200 条足以让「懒加载有没有生效」暴露出来——真全部构建的话滚动会明显掉帧。
const _rowCount = 200;

/// 滚动次数。每轮 fling 之后等动画停，测量窗口覆盖整段滚动。
const _flings = 6;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('帧耗时：滚动 200 条题库列表', (tester) async {
    await tester.pumpWidget(_harness(_rows()));
    await tester.pumpAndSettle();

    // 列表真的铺出来了再开始量，否则量到的是空树
    expect(find.byType(QuestionListView), findsOneWidget);

    await binding.watchPerformance(() async {
      for (var i = 0; i < _flings; i++) {
        await tester.fling(find.byType(ListView), const Offset(0, -600), 1500);
        await tester.pumpAndSettle();
        // 换方向滚回去，避免一直往下滚到列表尽头后没有内容可画
        await tester.fling(find.byType(ListView), const Offset(0, 600), 1500);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'bank_scroll');
  });

  testWidgets('帧耗时：列表首屏从无到有', (tester) async {
    // 冷启动第一屏是最容易暴露"一次构建了整个列表"的地方：
    // 如果这一帧的 build time 远高于后续滚动帧，就说明懒加载没生效。
    await binding.watchPerformance(() async {
      await tester.pumpWidget(_harness(_rows()));
      await tester.pumpAndSettle();
    }, reportKey: 'list_first_frame');
  });
}

/// 外壳必须与真机一致：**ScreenUtilInit 的缩放开关要与 bootstrap 同源**。
/// 不传 enableScaleWH/Text 会把它重新打开，1280 宽按 390 放大 3.28 倍，
/// 报出一个真机上根本不存在的 RenderFlex 溢出（这个坑已经踩过一次）。
Widget _harness(List<QuestionBrief> rows) => ScreenUtilInit(
  designSize: designSize,
  minTextAdapt: true,
  splitScreenMode: true,
  enableScaleWH: screenScaleEnabled,
  enableScaleText: screenScaleEnabled,
  builder: (context, _) => MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: QuestionListView(
        rows: rows,
        isFavorite: (id) => false,
        onOpen: (_) {},
        onToggleFavorite: (_) {},
        onRefresh: () async {},
      ),
    ),
  ),
);

/// 造一批**形状真实**的行：题干长度、科目路径、学校名与标签都按真实数据给，
/// 因为行高与文字换行直接影响布局开销，用 "item 1" 这种短文量出来的数字没有意义。
List<QuestionBrief> _rows() => List.generate(
  _rowCount,
  (i) => QuestionBrief(
    questionId: 'q-$i',
    versionId: 'v-$i',
    qtype: 'single_choice',
    difficulty: (i % 3) + 1,
    stemText: '第 $i 题：下列关于汽车发动机冷却系统工作原理的说法中，正确的是哪一项？',
    nodePath: '专业目录 / 装备制造类 / 汽车运用与维修',
    schoolName: '绵阳市某中等职业学校',
    tags: const ['发动机', '冷却系统'],
  ),
);
