// 练习的答题卡：把 PracticeRunner 的状态翻译成格子，版式与交互都在 ui/core 的
// AnswerSheetGrid 里（考试的答题卡是同一个组件，只是状态少几种）。
//
// 本文件只剩一件事：**每题该显示成什么状态**。判定优先级：当前题 > 判过 > 答过 > 没答。
// 主观题没有"对错"，它的结论在 selfMastered 上，与 verdict 同等对待。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/ui/core/question/answer_sheet_data.dart';
import 'package:mianyang_quiz/ui/core/question/answer_sheet_grid.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';

class AnswerSheet extends StatelessWidget {
  const AnswerSheet({super.key, required this.runner, required this.onJump});

  final PracticeRunner runner;

  /// 参数是**题目索引**（从 0 开始，与 runner.jumpTo 同口径）。
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    return AnswerSheetGrid(
      groups: groupCellsByType(
        [for (var i = 0; i < runner.total; i++) runner.itemAt(i).qtype],
        _stateOf,
      ),
      onJump: onJump,
      typeLabel: (wire) => questionTypeFrom(wire).label,
      summary: '已作答 ${runner.answeredCount}/${runner.total}',
    );
  }

  AnswerSheetCellState _stateOf(int index) {
    final runtime = runner.runtimeAt(index);
    if (index == runner.index) return AnswerSheetCellState.current;
    if (runtime.verdict == true || runtime.selfMastered == true) {
      return AnswerSheetCellState.correct;
    }
    if (runtime.verdict == false || runtime.selfMastered == false) {
      return AnswerSheetCellState.wrong;
    }
    return runtime.isAnswered
        ? AnswerSheetCellState.answered
        : AnswerSheetCellState.untouched;
  }
}
