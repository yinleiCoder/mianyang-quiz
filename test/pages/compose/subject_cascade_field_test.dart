// 组卷页科目三级级联下拉的 widget 测试。
//
// 为什么值得测：这里此前只列「公共学科 + 课程」，挂在「汽修」专业节点下的题
// 在组卷页**选不到**（学生于是刷不到那批题）。修法是把筛选值从"叶子"放宽到
// "最深的那个已选节点"，而这条语义全靠三个下拉的联动体现，
// analyze 看不出对错：
//   · 选了大类不选专业 → 必须交回**大类**的 id（= 整个大类），不是 null；
//   · 只有选了上一级，下一级才出现，且标题跟着数据类型走（专业 / 课程）；
//   · 传入的 nodeId 要能还原成各级的选中态（祖先链反推）。
//
// 纯渲染 + 回调：不连任何服务。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/compose/widgets/subject_cascade_field.dart';

void main() {
  testWidgets('没选科目时只有一级下拉（下面两级不出现）', (tester) async {
    await _pump(tester, initial: null);

    expect(_dropdowns, findsOneWidget);
    expect(find.text('科目'), findsOneWidget);
    expect(find.text('不限'), findsOneWidget);
  });

  testWidgets('选「汽修」大类：出现二级，标题是「专业」', (tester) async {
    final changes = <String?>[];
    await _pump(tester, initial: null, changes: changes);

    await _pick(tester, '汽修');

    expect(changes, [_catAuto], reason: '交回的是大类自己 = 整个大类');
    expect(_dropdowns, findsNWidgets(2));
    expect(find.text('专业'), findsOneWidget);
    expect(find.text('课程'), findsNothing, reason: '还没选专业，课程这一级不该出现');
    // 二级停在「不限」（= 整个大类）。未选中的下拉显示的是 hint，所以「不限」只有一处
    expect(find.text('不限'), findsOneWidget);
  });

  testWidgets('一路选到课程：三级标题是「课程」，交回课程 id', (tester) async {
    final changes = <String?>[];
    await _pump(tester, initial: null, changes: changes);

    await _pick(tester, '计算机'); // 一级：计算机大类
    await _pick(tester, '计算机', level: 1); // 二级：计算机专业（与大类同名，线上就是这样）
    await _pick(tester, '办公应用', level: 2);

    expect(changes, [_catComputer, _majorComputer, _courseOffice]);
    expect(_dropdowns, findsNWidgets(3));
    expect(find.text('课程'), findsOneWidget);
    // 三级都展开是这套控件最宽的状态：390 宽下不许把卡片撑破
    expect(tester.takeException(), isNull, reason: '390 宽下不许 RenderFlex 溢出');
  });

  testWidgets('二级选回「不限」：交回大类 id（不是 null）', (tester) async {
    final changes = <String?>[];
    await _pump(tester, initial: _majorComputer, changes: changes);

    expect(_dropdowns, findsNWidgets(3), reason: '大类 / 专业 / 课程三级都在');
    await _pick(tester, '不限', level: 1);

    expect(changes, [_catComputer], reason: '不选专业 = 整个大类，而不是"全部科目"');
  });

  testWidgets('一级选回「不限」：交回 null（全部科目）', (tester) async {
    final changes = <String?>[];
    await _pump(tester, initial: _catComputer, changes: changes);

    await _pick(tester, '不限');

    expect(changes, [null]);
  });

  testWidgets('公共学科只走两级：选「语文」后标题是「课程」', (tester) async {
    final changes = <String?>[];
    await _pump(tester, initial: null, changes: changes);

    await _pick(tester, '语文');

    expect(changes, [_discChinese]);
    expect(_dropdowns, findsNWidgets(2));
    expect(find.text('课程'), findsOneWidget, reason: '学科下面是课程，不是专业');
    expect(find.text('专业'), findsNothing);
  });

  testWidgets('传入课程 id：三级都按祖先链还原选中态', (tester) async {
    await _pump(tester, initial: _courseOffice);

    expect(_dropdowns, findsNWidgets(3));
    expect(tester.takeException(), isNull, reason: '长名字不许把行撑溢出（超长省略）');
    // 三级各自显示自己选中的那个名字；「计算机」在大类与专业两级各出现一次
    expect(find.text('计算机'), findsNWidgets(2));
    expect(find.text('办公应用'), findsOneWidget);
  });

  testWidgets('传入已不存在的节点 id：不抛断言，显示成「不限」', (tester) async {
    await _pump(tester, initial: '已经删掉的节点');

    expect(tester.takeException(), isNull);
    expect(_dropdowns, findsOneWidget);
  });
}

Finder get _dropdowns => find.byType(DropdownButtonFormField<String?>);

/// 点开第 [level] 级下拉并选中一项。下拉展开后菜单项在 overlay 里，
/// 取 last 是因为**按钮上那份可能与菜单项同名**（大类与专业都叫「计算机」时就是这样）。
Future<void> _pick(WidgetTester tester, String label, {int level = 0}) async {
  await tester.tap(_dropdowns.hitTestable().at(level));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

/// 用带状态的壳包一层：真实调用方（FilterFields）也是把 nodeId 存在 State 里，
/// 选中后重建 —— 下拉是否跟着 initialValue 走，只有这样才能验到。
Future<void> _pump(
  WidgetTester tester, {
  required String? initial,
  List<String?>? changes,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, _) => MaterialApp(
        // 主题在 builder 里建：AppTheme 用了 `.r`，要等 ScreenUtilInit 初始化完
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: _Harness(initial: initial, changes: changes ?? []),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

class _Harness extends StatefulWidget {
  const _Harness({required this.initial, required this.changes});

  final String? initial;
  final List<String?> changes;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late String? _nodeId = widget.initial;

  @override
  Widget build(BuildContext context) => SubjectCascadeField(
    nodes: _tree(),
    selectedNodeId: _nodeId,
    onChanged: (id) {
      widget.changes.add(id);
      setState(() => _nodeId = id);
    },
  );
}

// ---------- 与库里同形的测试数据（与 test/utils/subject_tree_test.dart 同源） ----------

const _discChinese = 'disc-chinese';
const _catComputer = 'cat-computer';
const _majorComputer = 'major-computer';
const _courseOffice = 'course-office';
const _catAuto = 'cat-auto';
const _majorAuto = 'major-auto';

List<SubjectNode> _tree() => [
  _node(_discChinese, null, '语文', kind: 'discipline', scope: 'common'),
  _node('course-chinese', _discChinese, '应用文写作'),
  _node(_catComputer, null, '计算机', kind: 'category'),
  _node(_majorComputer, _catComputer, '计算机', kind: 'major'),
  _node(_courseOffice, _majorComputer, '办公应用'),
  _node(_catAuto, null, '汽修', kind: 'category'),
  _node(_majorAuto, _catAuto, '汽修', kind: 'major'),
];

SubjectNode _node(
  String id,
  String? parentId,
  String name, {
  String kind = 'course',
  String scope = 'vocational',
}) => SubjectNode(
  id: id,
  parentId: parentId,
  scope: scope,
  kind: kind,
  name: name,
);
