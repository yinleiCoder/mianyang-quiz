// 答题区：题干、选项、输入框那一块（可滚动）。
//
// 从 PracticeStage 里抽出来，一是为了让舞台只管布局与交互规则（单文件行数别顶到上限），
// 二是这块的重建语义需要单独交代：AnimatedSwitcher 的 key 必须落在 child 上。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/question/analysis_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_report_sheet.dart';
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
        child: Column(
          key: ValueKey('${runner.index}-${runtime.item.questionId}'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuestionView(
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
            // 判完就把标准答案与解析摆出来——**即时模式的意义就在这里**：
            // 学生做完一道立刻知道错在哪，而不是交卷后翻复盘。
            // 客观题的选项本来就会标色，但那只说明"哪一项对"，说不出为什么；
            // 与复盘页同一套组件（AnalysisView 默认会带上「正确答案」那一行）。
            if (graded) ...[
              SizedBox(height: AppMetrics.gapXl.r),
              AnalysisView(
                content: runtime.item.content,
                optionOrder: runtime.displayOrder,
              ),
            ],
            // 纠错入口放在题目**下方**，两个理由：
            //   · 学生得看完整道题（含答案/解析）才可能发现"答案给错了"；
            //   · 顶栏是刻意做空的（学多邻国，只有退出/进度/计时），
            //     往里塞一个旗标会破坏那条视觉主线。
            // 提交结果只弹 SnackBar：练习页没有"我的反馈"展示位，
            // 回音在题库详情页看（那页专门有一块）。
            SizedBox(height: AppMetrics.gapXl.r),
            Center(
              child: TextButton.icon(
                onPressed: () => showQuestionReportSheet(
                  context,
                  questionId: runtime.item.questionId,
                  versionId: runtime.item.versionId,
                  // 练习条目不带 version_no（快照里只有 version_id），弹层对 null 有兜底文案
                  versionNo: null,
                ),
                icon: Icon(Icons.flag_outlined, size: 16.r),
                label: const Text('这题有问题'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
