// 即时练习的"答对后 1 秒自动下一题"。
//
// 从 practice_stage.dart 拆出来：那边已经顶到 200 行上限，而这段规则有自己的
// 生命周期（监听题号、计时、取消），正好是一刀。
//
// 三条规则：
//   · 只有**即时练习**（PracticeMode.instant）且不是最后一题才自动跳；
//   · 题号一变就取消——用户点答题卡回到刚答对的题看解析时，不能再被抢走；
//   · 计时器触发时再核对一次"还停在刚答对那题、判定仍为对"，否则什么都不做。
//
// 顺序练习（教师讲练）不自动跳；答错一律等用户自己点「继续」。

import 'dart:async';

import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';

class AutoAdvanceController {
  AutoAdvanceController(this._runner) {
    _lastIndex = _runner.index;
    _runner.addListener(_onRunnerChanged);
  }

  final PracticeRunner _runner;
  Timer? _timer;
  late int _lastIndex;

  /// 答对后调用：安排 1 秒后的自动跳题。
  void schedule(int answeredIndex) {
    if (_runner.mode != PracticeMode.instant || _runner.isLast) return;
    cancel();
    _timer = Timer(const Duration(seconds: 1), () {
      _timer = null;
      if (_runner.ended != null) return;
      if (_runner.index != answeredIndex) return;
      if (!_runner.current.isGraded || _runner.current.verdict != true) return;
      _runner.advance();
    });
  }

  /// 用户手动切题/点继续/交卷/退出时调用。
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void _onRunnerChanged() {
    if (_runner.index == _lastIndex) return;
    _lastIndex = _runner.index;
    cancel();
  }

  void dispose() {
    cancel();
    _runner.removeListener(_onRunnerChanged);
  }
}
