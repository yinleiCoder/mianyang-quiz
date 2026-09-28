// 答题卡的**数据形状**与分组：格子是什么、怎么按题型分组。
// 怎么画在 answer_sheet_grid.dart 里（那边只管像素，这边只管"有哪些格、什么状态"）。
//
// 分开的另一个好处：分组口径是纯函数，将来要按页码或大题分组时改这里，
// 不必碰任何一行布局代码。

/// 一格的状态。练习用到全部五种，考试只用得上三种（当前 / 已答 / 未答）。
enum AnswerSheetCellState {
  /// 正在作答的那一题——整张卡上最需要一眼看到的东西。
  current,

  /// 判过且答对。
  correct,

  /// 判过且答错。
  wrong,

  /// 答了，但还没有判定（批量练习、考试交卷前）。
  answered,

  /// 还没答。
  untouched,
}

/// 一格：题目下标（**0 起**，点击回调用的也是它）+ 状态。
typedef AnswerSheetCell = ({int index, AnswerSheetCellState state});

/// 一个分组：组名（题型名）+ 组内各格。
typedef AnswerSheetGroup = ({String label, List<AnswerSheetCell> cells});

/// 按题型分组。[qtypeWires] 是卷面上逐题的题型线格式（顺序即卷面顺序）。
///
/// [stateOf] 由调用方按题目下标给出状态——这里不猜"答没答对"，那是各 feature 的事。
/// 题型按**首次出现**的顺序排列，卷面顺序不被重排（它就是学生的心理顺序）。
List<AnswerSheetGroup> groupCellsByType(
  List<String> qtypeWires,
  AnswerSheetCellState Function(int index) stateOf,
) {
  final byType = <String, List<AnswerSheetCell>>{};
  for (var i = 0; i < qtypeWires.length; i++) {
    byType
        .putIfAbsent(qtypeWires[i], () => [])
        .add((index: i, state: stateOf(i)));
  }
  return [
    for (final entry in byType.entries) (label: entry.key, cells: entry.value),
  ];
}
