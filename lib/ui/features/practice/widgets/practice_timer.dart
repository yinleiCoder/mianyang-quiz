// 练习计时：闹钟图标 + 已花费时间，每秒刷新。
//
// 职责：从 [startedAt] 起算，把"已经花了多久"实时显示出来。
// 不负责：结算（服务端按每题用时累计，见 markQuestionSpent）、暂停/继续（本页不提供）。
//
// 每秒重绘一次的代价很小（只是一个 Text），但**必须只重建这一个组件**：
// 直接把计时状态放在 PracticeStage 里，会让整道题（选项、输入框）每秒重建一次，
// 用户正在输入时会被打断。所以计时器自己是 StatefulWidget，只 setState 自己。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';

class PracticeTimer extends StatefulWidget {
  const PracticeTimer({super.key, required this.startedAt, this.clock});

  /// 起算时刻（练习页打开的时间，见 PracticeRunner.startedAt）。
  final DateTime startedAt;

  /// 取"现在"的方式。默认 DateTime.now；测试注入假时钟才能验证每秒真的在跳
  /// （widget 测试里 pump 走的是调度器的假时间，DateTime.now 仍是真实时间）。
  final DateTime Function()? clock;

  @override
  State<PracticeTimer> createState() => _PracticeTimerState();
}

class _PracticeTimerState extends State<PracticeTimer> {
  Timer? _ticker;
  late Duration _elapsed = _compute();

  @override
  void initState() {
    super.initState();
    // 用"每次重算 now - startedAt"而不是 elapsed++：后者在页面被挂起
    // （切后台、窗口最小化）时定时器会被节流甚至暂停，回来就少算了。
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = _compute());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration _compute() {
    final value = (widget.clock?.call() ?? DateTime.now()).difference(widget.startedAt);
    return value.isNegative ? Duration.zero : value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.alarm, size: 16.r, color: muted),
        Text(
          // 计时钟格式（12:34）：结算页用中文文案，这里每秒都在跳，用纯数字不晃眼
          Formatters.clock(_elapsed),
          style: theme.textTheme.labelSmall?.copyWith(
            color: muted,
            // 等宽数字：否则秒数跳动时整块计时的宽度会左右抖
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
