// 考试页的舞台：版式 + 三个"会发生什么"（退出、交卷、到点自动交卷）。
//
// 与 PracticeStage 的分工相同：状态机在 ExamRunner 里，这里只管把状态摆出来、
// 把用户的动作翻译成对 Runner 的调用。**不含任何判分逻辑**——考试本来也不判分。
//
// 宽窄屏：宽屏把答题卡常驻在右侧，窄屏收进顶栏按钮（弹层）。同一个东西不给两个入口。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/layout/breakpoints.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_answer_sheet.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_bottom_bar.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_confirm_sheet.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_question_area.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_top_bar.dart';
import 'package:provider/provider.dart';

class ExamStage extends StatefulWidget {
  const ExamStage({super.key, required this.runner, this.clock});

  final ExamRunner runner;

  /// 测试注入的假时钟，透传给倒计时。
  final DateTime Function()? clock;

  @override
  State<ExamStage> createState() => _ExamStageState();
}

class _ExamStageState extends State<ExamStage> {
  ExamRunner get _runner => widget.runner;

  /// 窄屏的答题卡：底部弹层，点格子即关，回到题目继续答。
  Future<void> _openAnswerSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => ConstrainedBox(
        // 最多占 70% 高：题量上百时答题卡会很长，留出上方题目区让人知道
        // "这是从哪儿弹出来的"，也避免整屏被表格占满
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
        ),
        child: ExamAnswerSheet(
          runner: _runner,
          onJump: (index) {
            Navigator.of(sheetContext).pop();
            _runner.jumpTo(index);
          },
        ),
      ),
    );
  }

  /// 记下作答。点选项时给一记轻响，与练习页同一套规则（填空/主观题逐键上抛，不放）。
  void _onAnswerChanged(SubmittedAnswer answer) {
    if (answer is ChoiceAnswer || answer is TrueFalseAnswer) {
      unawaited(context.read<SfxService>().selectOption());
    }
    _runner.setDraft(answer);
  }

  Future<void> _confirmExit() async {
    final leave = await showExamConfirmSheet(
      context,
      title: '离开考试？',
      // 两条都要说：倒计时不暂停（会亏时间），作答已存本机（不会白答）。
      message: '倒计时不会暂停，离开期间它照常走。\n'
          '已作答的内容已保存在本机，回来可以从「我的考试」接着答。',
      confirmLabel: '离开',
      cancelLabel: '继续答题',
    );
    if (leave && mounted) {
      unawaited(context.read<SfxService>().quit());
      context.pop();
    }
  }

  Future<void> _confirmSubmit() async {
    final unanswered = _runner.total - _runner.answeredCount;
    final ok = await showExamConfirmSheet(
      context,
      title: '确认交卷？',
      message: unanswered > 0
          ? '还有 $unanswered 道题没作答，交卷后将计入未作答。\n交卷后不能再修改。'
          : '交卷后不能再修改。',
      confirmLabel: '确认交卷',
      cancelLabel: '再检查一下',
      danger: true,
    );
    if (ok && mounted) await _submit();
  }

  /// 交卷并跳到成绩单。
  ///
  /// [auto] 只影响失败时的措辞：到点自动交卷失败与手动交卷失败，学生看到的
  /// 应该是两句话——前者要让他知道"时间已经到了，是系统在替他交"。
  Future<void> _submit({bool auto = false}) async {
    if (_runner.submitting) return;
    try {
      await _runner.submit();
      if (!mounted) return;
      unawaited(context.read<SfxService>().finish());
      // pushReplacement：交完卷还留在答题页按返回就回到了已结束的考试。
      context.pushReplacement(AppRoutes.examResultOf(_runner.attempt.id));
    } catch (error) {
      if (!mounted) return;
      final retry = await showExamConfirmSheet(
        context,
        title: auto ? '时间到，自动交卷失败' : '交卷失败',
        message: '${mapError(error).message}\n\n作答仍保存在本机，可以重试。',
        confirmLabel: '重试交卷',
        cancelLabel: '稍后再说',
        danger: true,
      );
      if (retry && mounted) await _submit(auto: auto);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 系统返回（Android 手势/返回键）也要过确认：考试页被误触退出太亏了。
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: ListenableBuilder(
        listenable: _runner,
        builder: (context, _) => LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= kWideBreakpoint;
            final column = Column(
              children: [
                ExamTopBar(
                  index: _runner.index + 1,
                  total: _runner.total,
                  progress: _runner.progress,
                  deadline: _runner.deadline,
                  clock: widget.clock,
                  onExit: _confirmExit,
                  onExpired: () => _submit(auto: true),
                  onOpenAnswerSheet: wide ? null : _openAnswerSheet,
                ),
                Expanded(
                  child: ExamQuestionArea(
                    runner: _runner,
                    onAnswerChanged: _onAnswerChanged,
                  ),
                ),
                ExamBottomBar(runner: _runner, onFinish: _confirmSubmit),
              ],
            );

            if (!wide) return column;
            return Row(
              children: [
                Expanded(child: column),
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 260.r,
                  child: ExamAnswerSheet(runner: _runner, onJump: _runner.jumpTo),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
