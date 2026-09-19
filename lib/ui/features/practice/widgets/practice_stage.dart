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
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_ended_view.dart';
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

  /// 交卷在途。交卷**必须防重入**：服务端一次只结算一次，重复的那次报
  /// 「本次练习已交卷或已作废」，于是屏幕上会同时出现"交卷成功"（导航去了结果页）
  /// 和"交卷失败"（重发的那次弹的提示）。实测有用户 350ms 内发出 22 次交卷请求。
  bool _finishing = false;

  PracticeRunner get _runner => widget.runner;

  /// 单选与判断题选中即完整，可以立刻判。
  bool _isCompleteSubmission(SubmittedAnswer answer) => switch (answer) {
    ChoiceAnswer() => answer.keys.isNotEmpty,
    TrueFalseAnswer() => true,
    _ => false,
  };

  void _onAnswerChanged(SubmittedAnswer answer) {
    // 只有"选中即完整"的题型才自动判，否则用户在多选/填空题上会被反复打断
    final type = questionTypeFrom(_runner.current.item.qtype);
    final autoCheck =
        type == QuestionType.singleChoice || type == QuestionType.trueFalse;
    // setDraft 只改 draft，不碰 verdict/selfMastered，所以这里先算与后算等价
    final willGradeNow =
        _runner.mode != PracticeMode.batch &&
        autoCheck &&
        _isCompleteSubmission(answer) &&
        !_runner.current.isGraded;

    // 点选项给一记轻响 —— **只在紧接着不会响判定音的时候放**。
    //
    // 单选/判断在即时模式下是选中即判的：「答对」「答错」紧接着就会响，
    // 再叠一记「选择一个选项」两段音频糊成一团，听感很乱（用户反馈过）。
    // 这两种题型本来就立刻有反馈音，不需要再补一记。
    //
    // 注意判据不是「题型是不是多选」：**批量模式与考试同样不判题**，
    // 那里的单选若也静音，点选项就成了哑巴 —— 那记轻响是唯一反馈。
    // 填空/主观题是逐键上抛的，每敲一个字响一下会变成噪音，一并排除。
    if (!willGradeNow && (answer is ChoiceAnswer || answer is TrueFalseAnswer)) {
      unawaited(context.read<SfxService>().selectOption());
    }

    if (_runner.mode == PracticeMode.batch) {
      _runner.setDraft(answer);
      return;
    }
    _runner.setDraft(answer);
    if (willGradeNow) {
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
      // 失败了先问一句"这场练习还活着吗"：已经结束的话界面会换成结束态并说明原因，
      // 再叠一句"提交失败：……"只会让人以为再点一次就能好（见 _runner.syncEndedState）
      await _runner.syncEndedState();
      if (!mounted || _runner.ended != null) return;
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
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      final summary = await _runner.finish();
      if (!mounted) return;
      // null = 会话在批量提交那一步就被发现已经结束，界面已换成结束态，没有成绩可给
      if (summary == null) return;
      unawaited(context.read<SfxService>().finish());
      // 用 pushReplacement：交卷后不该能"返回"到已结束的答题界面
      context.pushReplacement(
        AppRoutes.practiceResultOf(_runner.sessionId),
        extra: summary,
      );
    } catch (error) {
      if (!mounted) return;
      // 同 _check：会话已结束时界面自己会说明，不再叠一句"交卷失败"
      await _runner.syncEndedState();
      if (!mounted || _runner.ended != null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('交卷失败：${mapError(error).message}')),
      );
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _runner,
      builder: (context, _) {
        // 会话结束（打开时就已经结束，或作答途中在别处被结束）：换成结束态，
        // **一道题都不许再答** —— 服务端会拒绝之后每一次提交，而本地判分照样显示对错，
        // 让人答下去等于白答一整场（见 PracticeEndedView 的说明）
        final ended = _runner.ended;
        if (ended != null) return PracticeEndedView(snapshot: ended);

        return PracticeLayout(
          runner: _runner,
          graded: _runner.current.isGraded,
          instant: _runner.mode == PracticeMode.instant,
          checking: _checking,
          finishing: _finishing,
          onAnswerChanged: _onAnswerChanged,
          onExit: () => confirmQuitPractice(context, _runner),
          onCheck: _check,
          onContinue: _continue,
          onFinish: _finish,
        );
      },
    );
  }
}
