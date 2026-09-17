// 考试作答的内存副本 + 落盘节流。
//
// 从 ExamRunner 里拆出来的：那个类管"考试怎么推进"（翻题、倒计时、交卷），
// 这个只管"作答怎么存住"。两者唯一的耦合是"改完要通知界面"，所以这里**不通知任何人**——
// 调用方改完自己 notifyListeners。
//
// 为什么要落盘：服务端要等交卷才写 exam_answers（见 exam_draft_service.dart），
// 中途退出（误触返回、闪退、没电）全指望这份本机暂存。
// 为什么要节流：填空题与主观题是**逐键**上抛的，每敲一个字都写一次盘会明显卡顿。

import 'dart:async';

import 'package:mianyang_quiz/data/models/exam/exam_answer.dart';
import 'package:mianyang_quiz/data/services/exam_draft_service.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';

class ExamDraftBuffer {
  // 私有命名参数（`this._attemptId`）是 Dart 3.13 起支持的写法：调用方写 `attemptId:`，
  // 字段本身是私有的。与 PracticeRunner / ExamRunner 一致。
  ExamDraftBuffer({
    required this._attemptId,
    this._service,
    this._delay = const Duration(milliseconds: 800),
  });

  final String _attemptId;
  final ExamDraftService? _service;
  final Duration _delay;

  final Map<String, SubmittedAnswer> _answers = {};
  Timer? _timer;

  /// 已作答的题项数（答题卡与进度条都读它）。
  int get length => _answers.length;

  bool has(String paperItemId) => _answers.containsKey(paperItemId);

  SubmittedAnswer? of(String paperItemId) => _answers[paperItemId];

  /// 交卷时整卷带走的那份。
  Map<String, SubmittedAnswer> snapshot() => {..._answers};

  /// 记下某题的作答。**空答案等于没作答**（主观题写了又删空），要移除而不是留一条空记录——
  /// 否则答题卡会给它记一格"已答"，交卷时那题其实什么都没交。
  void put(String paperItemId, SubmittedAnswer? answer) {
    if (answer == null || (answer is EssayAnswer && answer.text.trim().isEmpty)) {
      _answers.remove(paperItemId);
    } else {
      _answers[paperItemId] = answer;
    }
    _schedule();
  }

  /// 服务端存下来的作答打底，本机暂存放在上面覆盖。
  /// 本地优先：它是学生刚在这台设备上写的，比上一次同步更近。
  void restore({
    required List<ExamAnswerRecord> fromServer,
    required Map<String, Map<String, dynamic>> fromDisk,
  }) {
    for (final record in fromServer) {
      if (!record.isAnswered) continue;
      final answer = submittedAnswerFrom(record.answer);
      if (answer != null) _answers[record.paperItemId] = answer;
    }
    for (final entry in fromDisk.entries) {
      final answer = submittedAnswerFrom(entry.value);
      if (answer != null) _answers[entry.key] = answer;
    }
  }

  void _schedule() {
    if (_service == null) return;
    _timer?.cancel();
    _timer = Timer(_delay, flush);
  }

  /// 立刻落盘（不等节流窗口）。离开页面与交卷成功时各叫一次。
  void flush() {
    final service = _service;
    if (service == null) return;
    unawaited(service.save(_attemptId, {
      for (final entry in _answers.entries) entry.key: entry.value.toJson(),
    }));
  }

  /// 交卷成功后取消还没到点的那次落盘：留着的话，交完卷 800ms 后又会把
  /// 已经提交上去的作答写回本机，下次进来被当成"上次的答案"回填。
  void cancelPendingSave() => _timer?.cancel();

  void dispose() {
    _timer?.cancel();
    // 离开页面时把还没落盘的那一次补上——退出前的最后几笔作答最容易被丢掉
    flush();
  }
}
