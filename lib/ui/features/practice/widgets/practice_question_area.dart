// 答题区：题干、选项、输入框那一块（可滚动）。
//
// 从 PracticeStage 里抽出来，一是为了让舞台只管布局与交互规则（单文件行数别顶到上限），
// 二是这块的重建语义需要单独交代：AnimatedSwitcher 的 key 必须落在 child 上。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';

class PracticeQuestionArea extends StatelessWidget {
  const PracticeQuestionArea({
    super.key,
    required this.runner,
    required this.graded,
    required this.instant,
    required this.onAnswerChanged,
  });

  final PracticeRunner runner;
  final bool graded;
  final bool instant;
  final ValueChanged<SubmittedAnswer> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    final runtime = runner.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.pagePadding,
        vertical: AppMetrics.gapLg,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        // key 必须给 child，不能给 AnimatedSwitcher 本身：
        // 它靠 `Widget.canUpdate(新 child, 旧 child)` 判断"是不是换人了"，
        // 而 canUpdate 比的是 runtimeType + key。child 不带 key 时恒为 true，
        // 于是新题被当成同一个 child 原地更新 —— 动画永远不播。
        // 加在 AnimatedSwitcher 上则是另一种错：每次切题整个 AnimatedSwitcher
        // 元素被替换，旧题立刻消失，同样没有过渡。
        //
        // key 用题号：切题时整块重建，避免上一题的输入焦点残留。
        child: QuestionView(
          key: ValueKey('${runner.index}-${runtime.item.questionId}'),
          qtype: runtime.item.qtype,
          content: runtime.item.content,
          answer: runtime.draft,
          onAnswerChanged: onAnswerChanged,
          shuffledKeys: runtime.displayOrder,
          reveal: graded ? AnswerReveal.graded : AnswerReveal.none,
          readOnly: instant && graded,
          selfMastered: runtime.selfMastered,
          onSelfAssessed: runner.setSelfMastered,
        ),
      ),
    );
  }
}
