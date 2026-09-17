// 考试的答题卡：把 ExamRunner 的状态翻译成格子，版式在 ui/core 的 AnswerSheetGrid 里。
//
// 比练习少两种状态——考试**交卷前谁都不知道对错**，所以只有"当前 / 已答 / 未答"。
// 这也是考试答题卡唯一的用处：让学生确认"我是不是每道都答了"。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/ui/core/question/answer_sheet_data.dart';
import 'package:mianyang_quiz/ui/core/question/answer_sheet_grid.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';

class ExamAnswerSheet extends StatelessWidget {
  const ExamAnswerSheet({super.key, required this.runner, required this.onJump});

  final ExamRunner runner;

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
    if (index == runner.index) return AnswerSheetCellState.current;
    return runner.draftAt(index) == null
        ? AnswerSheetCellState.untouched
        : AnswerSheetCellState.answered;
  }
}
