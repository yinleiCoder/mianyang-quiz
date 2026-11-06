// 考试作答的内存副本 + 双通道落盘（本机 + 服务端草稿）。
//
// 从 ExamRunner 里拆出来的：那个类管"考试怎么推进"（翻题、倒计时、交卷），
// 这个只管"作答怎么存住"。两者唯一的耦合是"改完要通知界面"，所以这里**不通知任何人**——
// 调用方改完自己 notifyListeners。
//
// 为什么要落盘：服务端要等交卷才写 exam_answers（0052）。本机那份兜的是断网/闪退；
// 服务端那份（0144 的 save_exam_answers）兜的是"换台设备接着答"。
// 为什么要节流：填空题与主观题是**逐键**上抛的，每敲一个字都写一次盘会明显卡顿。
//
// 合并规则见 [restore]：本机比服务端新才让本机覆盖，否则以服务端为准。

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/utils/utils.dart';

class ExamDraftBuffer {
  // 私有命名参数（`this._attemptId`）是 Dart 3.13 起支持的写法：调用方写 `attemptId:`，
  // 字段本身是私有的。与 PracticeRunner / ExamRunner 一致。
  ExamDraftBuffer({
    required this._attemptId,
    this._service,
    this._remote,
    this._delay = const Duration(milliseconds: 800),
  });

  final String _attemptId;
  final ExamDraftService? _service;

  /// 服务端草稿通道（0144）。null = 不同步（测试或旧服务端）。
  /// 只收音效：失败不抛给界面，下次改动再试。
  final Future<void> Function(Map<String, Map<String, dynamic>> answers)? _remote;

  final Duration _delay;

  final Map<String, SubmittedAnswer> _answers = {};

  /// 还没送到服务端的题项 id。只发这些，服务端逐题合并。
  final Set<String> _dirty = {};

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
    _dirty.add(paperItemId);
    _schedule();
  }

  /// 服务端草稿与本机暂存合并，本机的改动优先。
  ///
  /// [localWins] 由调用方按两份写入时刻判定（本机更晚才为 true）。
  /// 为 false 时本机只补上服务端没有的题——那些是断网时写的、还没同步上去的。
  void restore({
    required List<ExamAnswerRecord> fromServer,
    Map<String, Map<String, dynamic>> serverDrafts = const {},
    required Map<String, Map<String, dynamic>> fromDisk,
    bool localWins = true,
  }) {
    // 旧路径：服务端已交卷的场次会给 answers（判分记录），照旧回填
    for (final record in fromServer) {
      if (!record.isAnswered) continue;
      final answer = submittedAnswerFrom(record.answer);
      if (answer != null) _answers[record.paperItemId] = answer;
    }

    for (final entry in serverDrafts.entries) {
      final answer = submittedAnswerFrom(entry.value);
      if (answer != null) _answers[entry.key] = answer;
    }

    for (final entry in fromDisk.entries) {
      if (!localWins && _answers.containsKey(entry.key)) continue;
      final answer = submittedAnswerFrom(entry.value);
      if (answer != null) _answers[entry.key] = answer;
    }
  }

  void _schedule() {
    if (_service == null && _remote == null) return;
    _timer?.cancel();
    _timer = Timer(_delay, flush);
  }

  /// 立刻落盘（不等节流窗口）。离开页面、切后台与交卷成功时各叫一次。
  void flush() {
    _timer?.cancel();
    _timer = null;
    final service = _service;
    if (service != null) {
      unawaited(service.save(_attemptId, {
        for (final entry in _answers.entries) entry.key: entry.value.toJson(),
      }));
    }
    _pushRemote();
  }

  /// 把改过的那几道题送到服务端。失败就把它们放回待发队列，下次改动时一起重试。
  void _pushRemote() {
    final remote = _remote;
    if (remote == null || _dirty.isEmpty) return;
    final changed = {
      for (final id in _dirty)
        // 已删除的题发空 Map：服务端据此把它从草稿里移除
        id: _answers[id]?.toJson() ?? const <String, dynamic>{},
    };
    _dirty.clear();
    unawaited(
      remote(changed).catchError((Object error) {
        // 失败不打扰答题：草稿是辅助信息，本机那份还在
        debugPrint('考试草稿同步失败：$error');
        _dirty.addAll(changed.keys);
      }),
    );
  }

  /// 交卷成功后取消还没到点的那次落盘：留着的话，交完卷 800ms 后又会把
  /// 已经提交上去的作答写回本机，下次进来被当成"上次的答案"回填。
  void cancelPendingSave() {
    _timer?.cancel();
    _timer = null;
    _dirty.clear();
  }

  void dispose() {
    // 离开页面时把还没落盘的那一次补上——退出前的最后几笔作答最容易被丢掉
    flush();
  }
}
