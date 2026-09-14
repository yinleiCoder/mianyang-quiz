// 题目渲染域的 widget 测试：reveal 的三种语义、乱序的「字母 / 原始 key 分离」、
// 填空空位数、复合题逐子题与主观子题的作答形状。
//
// 为什么这几条必须有测试：它们的错法全是**静默**的——
//   · reveal 标错色只是"看起来有点怪"，不报错；
//   · 复合题只读顶层 answer 会显示成空白；
//   · 填空按标准答案长度画框，在脏数据下会多出/少掉输入框；
//   · 主观子题写成 {"type":"text"} 会"提交成功但永远判错"。
//
// 注意：所有 .r / .sp 都要求 ScreenUtil 已初始化，所以每个用例都要用 ScreenUtilInit
// 包裹（否则抛 LateInitializationError）。测试窗口固定为设计稿尺寸，缩放系数为 1。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_theme.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/answer_summary_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/sub_question_card.dart';
import 'package:mianyang_quiz/ui/core/question/option_tile.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

void main() {
  group('reveal 的三种语义（单选题）', () {
    testWidgets('none：只显示选中，不泄露对错', (tester) async {
      await _pump(tester, _singleChoice(answer: const ChoiceAnswer(['B'])));

      expect(_states(tester), [
        OptionState.idle,
        OptionState.selected,
        OptionState.idle,
      ]);
    });

    testWidgets('graded：正确答案标 correct，选错的标 wrong', (tester) async {
      await _pump(
        tester,
        _singleChoice(
          answer: const ChoiceAnswer(['B']),
          reveal: AnswerReveal.graded,
        ),
      );

      expect(_states(tester), [
        OptionState.correct, // A 是标准答案
        OptionState.wrong, // B 不是答案，但用户选了
        OptionState.idle,
      ]);
    });

    testWidgets('graded：选对的也是 correct，未选的不标', (tester) async {
      await _pump(
        tester,
        _singleChoice(
          answer: const ChoiceAnswer(['A']),
          reveal: AnswerReveal.graded,
        ),
      );

      expect(_states(tester), [
        OptionState.correct,
        OptionState.idle,
        OptionState.idle,
      ]);
    });

    testWidgets('answerOnly：只标标准答案，用户选过的错误项不显示', (tester) async {
      await _pump(
        tester,
        _singleChoice(
          answer: const ChoiceAnswer(['B']),
          reveal: AnswerReveal.answerOnly,
        ),
      );

      expect(_states(tester), [
        OptionState.correct,
        OptionState.idle, // B 曾被选中，但背题模式不该显示
        OptionState.idle,
      ]);
    });

    testWidgets('readOnly：点击不产出任何作答', (tester) async {
      final emitted = <SubmittedAnswer>[];
      await _pump(
        tester,
        _singleChoice(answer: null, readOnly: true, onChanged: emitted.add),
      );

      await tester.tap(find.byType(OptionTile).first);
      await tester.pump();

      expect(emitted, isEmpty);
    });
  });

  group('乱序：显示字母与原始 key 分离', () {
    testWidgets('显示字母按位置，产出的 key 是原始 key', (tester) async {
      final emitted = <SubmittedAnswer>[];
      await _pump(
        tester,
        _singleChoice(
          answer: null,
          onChanged: emitted.add,
          // 显示顺序：原始 C 在最前（用户看到的那个「A」）
          shuffledKeys: const ['C', 'A', 'B'],
        ),
      );

      final tiles = tester.widgetList<OptionTile>(find.byType(OptionTile)).toList();
      expect(tiles.map((t) => t.letter), ['A', 'B', 'C']);
      expect(tiles.first.label.plainText, '鳄鱼'); // 位置 0 装的是原始 C

      await tester.tap(find.byType(OptionTile).first);
      await tester.pump();

      final answer = emitted.single as ChoiceAnswer;
      expect(answer.keys, ['C'], reason: '提交只能是原始 key，绝不能是显示字母 A');
    });
  });

  group('多选题', () {
    testWidgets('点选即增删，产出的仍是原始 key', (tester) async {
      final emitted = <SubmittedAnswer>[];
      // 组件是纯受控的：作答状态在页面手里。用会重建的宿主模拟页面，
      // 否则第二次点击读到的还是旧作答，测出来的行为不是真实行为。
      SubmittedAnswer answer = const ChoiceAnswer(['A']);
      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => _singleChoice(
            answer: answer,
            multiple: true,
            onChanged: (value) {
              emitted.add(value);
              setState(() => answer = value);
            },
          ),
        ),
      );

      await tester.tap(find.byType(OptionTile).at(2));
      await tester.pump();
      expect((emitted.last as ChoiceAnswer).keys, containsAll(['A', 'C']));

      await tester.tap(find.byType(OptionTile).first);
      await tester.pump();
      expect((emitted.last as ChoiceAnswer).keys, ['C']);
    });
  });

  group('填空题', () {
    testWidgets('输入框数量按题干空位数，不按标准答案长度', (tester) async {
      await _pump(tester, _fillBlank(blankCount: 2, answerValues: ['H2O', '100', '多余']));

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('第 1 空'), findsOneWidget);
      expect(find.text('第 2 空'), findsOneWidget);
    });

    testWidgets('答案不足处留空；作答由输入框本身决定', (tester) async {
      final emitted = <SubmittedAnswer>[];
      SubmittedAnswer answer = const BlankAnswer(['H2O']); // 标准答案有 3 个，这里只有 1 个
      await _pump(
        tester,
        StatefulBuilder(
          builder: (context, setState) => _fillBlank(
            blankCount: 3,
            answerValues: ['H2O', '100', '多余'],
            answer: answer,
            onChanged: (value) {
              emitted.add(value);
              setState(() => answer = value);
            },
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(3));
      expect(_fieldText(tester, 0), 'H2O');
      expect(_fieldText(tester, 1), '', reason: '答案不足的空位必须留空');

      await tester.enterText(find.byType(TextField).at(1), '100');
      await tester.pump();
      expect((emitted.last as BlankAnswer).values, ['H2O', '100', '']);
    });
  });

  group('复合题', () {
    testWidgets('逐子题渲染；主观子题的作答是 {"mastered": bool}，没有 type 键', (tester) async {
      final emitted = <SubmittedAnswer>[];
      await _pump(tester, _composite(onChanged: emitted.add));

      expect(find.byType(SubQuestionCard), findsNWidgets(2));
      expect(find.text('第 1 题'), findsOneWidget);
      expect(find.text('第 2 题'), findsOneWidget);

      final button = find.text('我会了');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      final answer = emitted.last as CompositeAnswer;
      expect(answer.subs, hasLength(2), reason: 'subs 必须与 content.sub 同序同长');
      expect(answer.subs[1].toJson(), {'mastered': true});
      expect(answer.subs[1].toJson().containsKey('type'), isFalse,
          reason: '主观子题带 type 键会让服务端读到 null，表现为永远判错');
    });

    testWidgets('AnswerSummaryView 逐子题渲染标准答案（根节点没有 answer）', (tester) async {
      const content = _compositeJson;
      final parsed = QuestionContent.fromJson(content);
      expect(parsed.answer, isNull, reason: '复合题根节点本来就没有 answer');

      await _pump(tester, AnswerSummaryView(content: parsed));

      // 标题与答案是两个 Text（样式不同），分开断言
      expect(find.text('第 1 题'), findsOneWidget);
      expect(find.text('正确答案：'), findsOneWidget); // 子题 0 是选择题
      expect(find.text('B'), findsOneWidget);
      expect(find.text('第 2 题'), findsOneWidget);
      expect(find.text('参考答案：'), findsOneWidget); // 子题 1 是主观题
      expect(find.textContaining('标准大气压'), findsOneWidget);
    });
  });

  testWidgets('未知题型降级为提示而不是崩溃', (tester) async {
    await _pump(
      tester,
      QuestionView(
        qtype: 'essay_v2',
        content: QuestionContent.fromJson(_singleChoiceJson),
        answer: null,
        onAnswerChanged: (_) {},
      ),
    );

    expect(find.textContaining('暂不支持'), findsOneWidget);
  });
}

// ---------- 辅助 ----------

List<OptionState> _states(WidgetTester tester) => tester
    .widgetList<OptionTile>(find.byType(OptionTile))
    .map((tile) => tile.state)
    .toList();

Future<void> _pump(WidgetTester tester, Widget child) async {
  // 固定成设计稿尺寸：缩放系数为 1，避免 .sp 在小窗口下把布局撑爆
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
      child: child,
    ),
  );
}

Widget _singleChoice({
  required SubmittedAnswer? answer,
  AnswerReveal reveal = AnswerReveal.none,
  bool readOnly = false,
  bool multiple = false,
  List<String>? shuffledKeys,
  ValueChanged<SubmittedAnswer>? onChanged,
}) => QuestionView(
  qtype: multiple ? 'multiple_choice' : 'single_choice',
  content: QuestionContent.fromJson(_singleChoiceJson),
  answer: answer,
  onAnswerChanged: onChanged ?? (_) {},
  reveal: reveal,
  readOnly: readOnly,
  shuffledKeys: shuffledKeys,
);

Widget _fillBlank({
  required int blankCount,
  required List<String> answerValues,
  SubmittedAnswer? answer,
  ValueChanged<SubmittedAnswer>? onChanged,
}) => QuestionView(
  qtype: 'fill_blank',
  content: QuestionContent.fromJson({
    'format_version': 1,
    'stem': [
      {'t': 'text', 'text': List.filled(blankCount, '___').join('与')},
    ],
    'answer': {'type': 'blank', 'values': answerValues},
  }),
  answer: answer,
  onAnswerChanged: onChanged ?? (_) {},
);

/// 第 index 个填空输入框里的文本。
String _fieldText(WidgetTester tester, int index) =>
    tester.widget<TextField>(find.byType(TextField).at(index)).controller!.text;

Widget _composite({ValueChanged<SubmittedAnswer>? onChanged}) => QuestionView(
  qtype: 'composite',
  content: QuestionContent.fromJson(_compositeJson),
  answer: null,
  onAnswerChanged: onChanged ?? (_) {},
);

/// 三个选项：A=鲸鱼（标准答案），B=鲨鱼，C=鳄鱼。
const _singleChoiceJson = <String, dynamic>{
  'format_version': 1,
  'stem': [
    {'t': 'text', 'text': '下列哪个是哺乳动物？'},
  ],
  'options': [
    {
      'key': 'A',
      'label': [
        {'t': 'text', 'text': '鲸鱼'},
      ],
    },
    {
      'key': 'B',
      'label': [
        {'t': 'text', 'text': '鲨鱼'},
      ],
    },
    {
      'key': 'C',
      'label': [
        {'t': 'text', 'text': '鳄鱼'},
      ],
    },
  ],
  'answer': {'type': 'choice', 'keys': ['A']},
  'analysis': [
    {'t': 'text', 'text': '鲸鱼是哺乳动物。'},
  ],
};

/// 子题 0：单选（答案 B）；子题 1：主观题（参考答案一条）。
const _compositeJson = <String, dynamic>{
  'format_version': 1,
  'stem': [
    {'t': 'text', 'text': '阅读下列材料后作答。'},
  ],
  'sub': [
    {
      'type': 'single_choice',
      'format_version': 1,
      'stem': [
        {'t': 'text', 'text': '水的沸点是多少？'},
      ],
      'options': [
        {
          'key': 'A',
          'label': [
            {'t': 'text', 'text': '50℃'},
          ],
        },
        {
          'key': 'B',
          'label': [
            {'t': 'text', 'text': '100℃'},
          ],
        },
      ],
      'answer': {'type': 'choice', 'keys': ['B']},
    },
    {
      'type': 'short_answer',
      'format_version': 1,
      'stem': [
        {'t': 'text', 'text': '简述你的理由。'},
      ],
      'answer': {
        'type': 'text',
        'samples': ['因为标准大气压下水的沸点是 100℃。'],
      },
    },
  ],
};
