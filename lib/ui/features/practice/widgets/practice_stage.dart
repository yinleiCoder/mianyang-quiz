// 练习舞台：顶栏 + 当前题 + 底部操作区。
//
// 这里是**交互规则**的落点（什么时候自动判题、什么时候可以交卷），
// 但所有状态变更都转发给 PracticeRunner，本组件自己不持有题目状态。
//
// 即时模式（学多邻国）：
//   · 单选/判断**选完立即判题**——这两类作答"选中即完整"，再让用户点一次检查是多余的
//   · 多选/填空/主观需要显式点「检查」（作答可能还没结束）
//   · 判完停在原地：标准答案与解析就显示在题目下方，看完自己点「继续」（不再自动跳题）
// 批量模式：只记草稿，上一题/下一题/答题卡自由切换，交卷时才提交。

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_layout.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/quit_confirm_sheet.dart';
import 'package:provider/provider.dart';

class PracticeStage extends StatefulWidget {
  const PracticeStage({super.key, required this.runner});

  final PracticeRunner runner;

  @override
  State<PracticeStage> createState() => _PracticeStageState();
}

class _PracticeStageState extends State<PracticeStage> {
  bool _checking = false;

  PracticeRunner get _runner => widget.runner;

  /// 单选与判断题选中即完整，可以立刻判。
  bool _isCompleteSubmission(SubmittedAnswer answer) => switch (answer) {
    ChoiceAnswer() => answer.keys.isNotEmpty,
    TrueFalseAnswer() => true,
    _ => false,
  };

  void _onAnswerChanged(SubmittedAnswer answer) {
    // 点选项给一记轻响。**只对"点一下"的题型**：填空/主观题是逐键上抛的，
    // 每敲一个字响一下就成了噪音。
    if (answer is ChoiceAnswer || answer is TrueFalseAnswer) {
      unawaited(context.read<SfxService>().selectOption());
    }

    if (_runner.mode == PracticeMode.batch) {
      _runner.setDraft(answer);
      return;
    }
    _runner.setDraft(answer);
    // 只有"选中即完整"的题型才自动判，否则用户在多选/填空题上会被反复打断
    final type = questionTypeFrom(_runner.current.item.qtype);
    final autoCheck = type == QuestionType.singleChoice || type == QuestionType.trueFalse;
    if (autoCheck && _isCompleteSubmission(answer) && !_runner.current.isGraded) {
      unawaited(_check());
    }
  }

  Future<void> _check() async {
    if (_checking) return;
    setState(() => _checking = true);
    try {
      await _runner.check();
      if (!mounted) return;
      // 音效跟着判定结果走（多邻国式即时反馈）。用 context.read 取一次、不监听：
      // 开关只影响后续播放，不需要它触发重建。
      final verdict = _runner.current.verdict;
      final sfx = context.read<SfxService>();
      if (verdict == true) {
        unawaited(sfx.correct());
      } else if (verdict == false) {
        unawaited(sfx.wrong());
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        // 用 mapError 取文案，不要插值原始异常：AppException.toString() 是
        // '$runtimeType: $message'，用户会看到「ServerException: …」。
        SnackBar(content: Text('提交失败：${mapError(error).message}')),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  void _continue() {
    if (_runner.isLast) {
      unawaited(_finish());
    } else {
      _runner.advance();
    }
  }

  Future<void> _finish() async {
    try {
      final summary = await _runner.finish();
      if (!mounted) return;
      unawaited(context.read<SfxService>().finish());
      // 用 pushReplacement：交卷后不该能"返回"到已结束的答题界面
      context.pushReplacement(
        AppRoutes.practiceResultOf(_runner.sessionId),
        extra: summary,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('交卷失败：${mapError(error).message}')),
      );
    }
  }

  Future<void> _confirmQuit() async {
    final action = await showQuitConfirmSheet(context);
    if (!mounted || action == null) return;
    // 两条分支都是"离开答题"，都放退出音（用户选完才响，取消不响）
    unawaited(context.read<SfxService>().quit());
    if (action == QuitAction.abandon) {
      await _runner.abandon();
      if (mounted) Navigator.of(context).pop();
    } else if (action == QuitAction.keepAndLeave) {
      // 保留会话：不放弃，下次可从"继续练习"回来
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _runner,
      builder: (context, _) => PracticeLayout(
        runner: _runner,
        graded: _runner.current.isGraded,
        instant: _runner.mode == PracticeMode.instant,
        checking: _checking,
        onAnswerChanged: _onAnswerChanged,
        onExit: _confirmQuit,
        onCheck: _check,
        onContinue: _continue,
        onFinish: _finish,
      ),
    );
  }
}
