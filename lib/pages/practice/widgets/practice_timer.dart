// 练习计时：闹钟/暂停图标 + 已花费时间，每秒刷新，**点一下可以暂停**。
//
// 职责：把 [PracticeRunner.elapsed] 实时显示出来，并在暂停时冻住它。
// 不负责：计时本身——暂停状态、累计暂停时长都在 PracticeRunner 里（单一事实来源），
// 因为交卷结算送上去的用时是同一个数（见 runner 的 finish）。这里只负责"画"。
//
// 暂停的语义只有一条：**暂停期间不走进任何一处用时**。所以本组件在暂停时
// 不是把秒数冻住（那样恢复后会跳一大截），而是整个显示都读 runner 的已过时长——
// 恢复时 runner 已经把暂停段扣掉了，显示自然接着走。
//
// 每秒重绘一次的代价很小（只是一小行），但**必须只重建这一个组件**：
// 直接把计时状态放在 PracticeStage 里，会让整道题（选项、输入框）每秒重建一次，
// 用户正在输入时会被打断。所以计时器自己是 StatefulWidget，只 setState 自己。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';

class PracticeTimer extends StatefulWidget {
  const PracticeTimer({super.key, required this.runner});

  /// 计时的事实来源：只是"读"，真正的状态在它身上。
  final PracticeRunner runner;

  @override
  State<PracticeTimer> createState() => _PracticeTimerState();
}

class _PracticeTimerState extends State<PracticeTimer> {
  Timer? _ticker;
  late bool _paused = widget.runner.isPaused;

  @override
  void initState() {
    super.initState();
    widget.runner.addListener(_onRunnerChanged);
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant PracticeTimer old) {
    super.didUpdateWidget(old);
    if (old.runner == widget.runner) return;
    old.runner.removeListener(_onRunnerChanged);
    widget.runner.addListener(_onRunnerChanged);
    _paused = widget.runner.isPaused;
    _syncTicker();
  }

  @override
  void dispose() {
    widget.runner.removeListener(_onRunnerChanged);
    _ticker?.cancel();
    super.dispose();
  }

  /// runner 每秒都在通知（切题、判定）——只有**暂停态变了**跟本组件有关，
  /// 其余的（作答、判定结果）一律不理，省下一次无谓重建。
  void _onRunnerChanged() {
    if (widget.runner.isPaused == _paused) return;
    setState(() => _paused = widget.runner.isPaused);
    _syncTicker();
  }

  /// 暂停时把定时器停掉：反正显示是冻住的，让它每秒空转只是白耗电。
  void _syncTicker() {
    if (_paused) {
      _ticker?.cancel();
      _ticker = null;
      return;
    }
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = scheme.onSurfaceVariant;
    final paused = widget.runner.isPaused;

    // 暂停态靠三件事一起说清楚：图标变成播放键、多一个「已暂停」标签、整块浮起浅底。
    // 只把颜色调暗是不够的——原色本来就是次要色（onSurfaceVariant），再暗用户看不出来。
    return Tooltip(
      message: paused ? '继续计时' : '暂停计时',
      child: Semantics(
        button: true,
        toggled: paused,
        label: paused ? '已暂停，点击继续计时' : '计时中，点击暂停',
        child: InkWell(
          onTap: widget.runner.togglePause,
          borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.standard,
            // 撑到最小触控目标：顶栏本来就 48 高（旁边那颗退出按钮决定的），
            // 这里不跟着撑起来的话，可点区域只有二十几像素高，"点不中"比"看不清"更糟
            height: AppMetrics.touchTarget.r,
            padding: EdgeInsets.symmetric(
              horizontal: AppMetrics.gapSm.r,
              vertical: AppMetrics.gapXs.r,
            ),
            decoration: BoxDecoration(
              // 未暂停时是完全透明的一层（不是 null）：这样两个状态之间才有过渡，
              // 而且透明色同样取自主题，不写死。
              color: paused
                  ? scheme.surfaceContainerHighest
                  : scheme.surface.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 18.r,
                  color: muted,
                ),
                SizedBox(width: AppMetrics.gapXs.r),
                AnimatedSize(
                  duration: AppMotion.fast,
                  curve: AppMotion.standard,
                  child: paused
                      ? Padding(
                          padding: EdgeInsets.only(right: AppMetrics.gapSm.r),
                          child: Text(
                            '已暂停',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Text(
                  // 计时钟格式（12:34）：结算页用中文文案，这里每秒都在跳，用纯数字不晃眼
                  Formatters.clock(widget.runner.elapsed),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: muted,
                    // 等宽数字：否则秒数跳动时整块计时的宽度会左右抖
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
