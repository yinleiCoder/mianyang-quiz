// 考试倒计时：剩余时间 + 最后五分钟的警示 + **到点自动交卷**。
//
// 截止时刻来自服务端（起考时 now + 时长），本机只做减法：改本机时间既续不了命
// （服务端记的是绝对时刻），也不会让这里显示出负数。本机时钟若偏得离谱，
// 显示会不准——这是纯客户端的固有上限，服务端不校验截止时刻（本轮决定），
// 所以两边都只是"提示"，真正的记录以交卷那一刻为准。
//
// 每秒只重建这一个 Text（同 PracticeTimer）：把它挂在页面状态里会让整道题
// 每秒重建一次，学生正在输入填空时会被打断。
//
// onExpired **只触发一次**：交卷是异步的，如果每秒都喊一次，交卷失败时会把
// 同一次提交连发几十遍。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';

class ExamTimer extends StatefulWidget {
  const ExamTimer({
    super.key,
    required this.deadline,
    this.onExpired,
    this.clock,
  });

  final DateTime deadline;

  /// 到点时的回调（页面据此自动交卷）。已在截止之后进入页面时**立即**触发。
  final VoidCallback? onExpired;

  /// 取"现在"的方式。默认 DateTime.now；测试注入假时钟才能验证它真的在走。
  final DateTime Function()? clock;

  @override
  State<ExamTimer> createState() => _ExamTimerState();
}

class _ExamTimerState extends State<ExamTimer> {
  Timer? _ticker;
  late Duration _remaining = _compute();
  bool _fired = false;

  /// 最后五分钟转为警示色。选 5 分钟是因为它正好是"还能通读一遍答题卡"的尺度。
  static const _warnWithin = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    // 每次重算 deadline - now，而不是 remaining--：页面被挂起（切后台、
    // 窗口最小化）时定时器会被节流，倒扣式计时回来就多了几分钟。
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    // 进页面时就已经过点了（续考一场早就该交的卷）：**等这一帧画完再喊**，
    // 在 initState 里同步回调会让页面在 build 期间发起交卷并跳转。
    if (_remaining == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fire();
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration _compute() {
    final left = widget.deadline.difference(widget.clock?.call() ?? DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  void _tick() {
    if (!mounted) return;
    final next = _compute();
    if (next != _remaining) setState(() => _remaining = next);
    if (next == Duration.zero) _fire();
  }

  void _fire() {
    if (_fired) return;
    _fired = true;
    widget.onExpired?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final urgent = _remaining <= _warnWithin;
    final color = urgent ? scheme.error : scheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(urgent ? Icons.timer_outlined : Icons.timer, size: 16.r, color: color),
        SizedBox(width: AppMetrics.gapXs.r),
        Text(
          Formatters.clock(_remaining),
          style: AppTextStyles.label(context).copyWith(
            color: color,
            // 等宽数字：否则秒数跳动时整块倒计时会左右抖
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
