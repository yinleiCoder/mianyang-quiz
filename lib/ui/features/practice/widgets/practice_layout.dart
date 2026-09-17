// 练习页的版式：顶栏 + 答题区 + 底部操作区 + 答题卡。
//
// 从 PracticeStage 里抽出来，两者分工是：
//   · 本文件只管"东西摆在哪"——宽屏把答题卡常驻在右侧，窄屏收进顶栏按钮；
//   · PracticeStage 管"什么时候发生什么"（自动判题、交卷、退出）。
// 抽出来的直接原因是单文件行数（AGENTS.md 第三条），顺带让版式能单独读懂。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/layout/breakpoints.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/answer_sheet.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_bottom_bar.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_question_area.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_top_bar.dart';

/// 窄屏的答题卡：底部弹层。点格子即关，回到题目继续答。
Future<void> _openAnswerSheet(BuildContext context, PracticeRunner runner) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => ConstrainedBox(
      // 最多占 70% 高：题量 100 时答题卡会很长，留出上方题目区让人知道
      // "这是从哪儿弹出来的"，也避免整屏被表格占满
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
      ),
      child: AnswerSheet(
        runner: runner,
        onJump: (index) {
          Navigator.of(sheetContext).pop();
          runner.jumpTo(index);
        },
      ),
    ),
  );
}

class PracticeLayout extends StatelessWidget {
  const PracticeLayout({
    super.key,
    required this.runner,
    required this.graded,
    required this.instant,
    required this.checking,
    required this.onAnswerChanged,
    required this.onExit,
    required this.onCheck,
    required this.onContinue,
    required this.onFinish,
  });

  final PracticeRunner runner;
  final bool graded;
  final bool instant;
  final bool checking;
  final ValueChanged<SubmittedAnswer> onAnswerChanged;
  final VoidCallback onExit;
  final VoidCallback onCheck;
  final VoidCallback onContinue;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 宽屏：答题卡常驻右侧；窄屏：顶栏一个按钮开弹层
        final wide = constraints.maxWidth >= kWideBreakpoint;

        final column = Column(
          children: [
            PracticeTopBar(
              index: runner.index + 1,
              total: runner.total,
              progress: runner.progress,
              startedAt: runner.startedAt,
              onExit: onExit,
              onOpenAnswerSheet: wide
                  ? null
                  : () => _openAnswerSheet(context, runner),
            ),
            Expanded(
              child: PracticeQuestionArea(
                runner: runner,
                graded: graded,
                instant: instant,
                onAnswerChanged: onAnswerChanged,
              ),
            ),
            // 底部操作区的四种形态由 PracticeBottomBar 内部选择
            PracticeBottomBar(
              runner: runner,
              checking: checking,
              onCheck: onCheck,
              onContinue: onContinue,
              onFinish: onFinish,
            ),
          ],
        );

        if (!wide) return column;
        return Row(
          children: [
            Expanded(child: column),
            const VerticalDivider(width: 1),
            SizedBox(
              width: 260.r,
              child: AnswerSheet(runner: runner, onJump: runner.jumpTo),
            ),
          ],
        );
      },
    );
  }
}
