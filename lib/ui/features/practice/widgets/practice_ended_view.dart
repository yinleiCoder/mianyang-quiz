// 会话已结束时的整屏占位（已交卷 / 已作废）。
//
// 为什么需要它：练习页原来不看会话状态，而服务端只接受 status = 'active' 的会话
// （0029 的 submit / finish 两处守卫）。于是一场早就结束的练习照样能打开、能作答、
// **本地判分还会照常显示对错**——用户白答一整场，直到交卷才被告知「本次练习已交卷或已作废」。
// 线上实测：24 小时内 307 次交卷里 106 次栽在这个守卫上，5924 次单题提交里 140 次栽在
// 它的姊妹守卫上，两个用户可见的报错就是这两句。
//
// 两种结束方式给的话不一样：
//   · 已交卷 —— 成绩已经结算，下一步是看成绩；
//   · 已作废 —— 这次不算完成，但**已作答的记录仍然计入统计**（服务端行为，见 0029）。
//     把这一点写明白，用户才不会以为刚才答的全丢了。
//
// 不自动跳走：会话在作答途中结束时（同一账号在另一台设备开了新练习，服务端只允许
// 一套进行中，开新的会静默作废旧的那个）被自动带走会莫名其妙——此时用户最想知道的
// 恰恰是"刚才发生了什么"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/state/practice_entry.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';

class PracticeEndedView extends StatelessWidget {
  const PracticeEndedView({super.key, required this.snapshot});

  /// 结束时的会话快照：状态决定文案，已答计数决定"还剩什么"。
  final PracticeSessionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final submitted = snapshot.status == SessionStatus.submitted.wire;

    return EmptyState(
      icon: submitted ? Icons.assignment_turned_in_outlined : Icons.block_outlined,
      title: submitted ? '本次练习已交卷' : '本次练习已作废',
      message: _message(submitted),
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DuoButton(
            label: submitted ? '查看成绩' : '重新开始一次练习',
            icon: submitted ? Icons.insights_outlined : Icons.replay_rounded,
            onPressed: () => submitted ? _openResult(context) : _restart(context),
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          DuoButton(
            label: '返回',
            variant: DuoButtonVariant.ghost,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  String _message(bool submitted) {
    final answered = snapshot.answeredCount;
    if (submitted) {
      return '这次练习的成绩已经结算，可以看成绩或逐题复盘。';
    }
    return answered > 0
        ? '已作废的练习不能再作答（作废发生在你开始新练习，或本次练习被放弃时）。'
              '你已经答过的 $answered 题仍会计入统计，不会丢。'
        : '已作废的练习不能再作答——它发生在你开始了另一场练习，或主动放弃了这一场时。';
  }

  /// 已交卷：结果页只带 sessionId 进来时会自己取回结算（见 PracticeResultPage）。
  void _openResult(BuildContext context) =>
      context.pushReplacement(AppRoutes.practiceResultOf(snapshot.sessionId));

  /// 已作废：按**这次练习的来源**重开一次，条件在组卷页还能再调。
  void _restart(BuildContext context) =>
      startPracticeFrom(context, snapshot.sourceValue, replace: true);
}
