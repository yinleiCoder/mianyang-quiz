// 一场考试的状态机：作答、翻题、倒计时、交卷。
// **它不是 ViewModel**：由 ExamPage 自己 new 出来、随页面销毁、不进 provider、
// 不被任何其他 feature import。只是"恰好要通知界面所以是 ChangeNotifier"的页面状态。
//
// 与 PracticeRunner 最大的不同：**这里一次也不判分**（判分权威在 0051 的
// grade_exam_units）。作答只存在内存 + 草稿里：草稿的存取与节流拆在 ExamDraftBuffer，
// 倒计时拆在 ExamClock，本类只负责"考试怎么推进"。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/exam/state/exam_clock.dart';
import 'package:mianyang_quiz/pages/exam/state/exam_draft_buffer.dart';

class ExamRunner extends ChangeNotifier {
  // 私有命名参数（`this._repository`）是 Dart 3.13 起支持的写法，与 PracticeRunner 一致
  ExamRunner({
    required this._repository,
    required ExamSnapshot snapshot,
    this._draftService,
    Map<String, Map<String, dynamic>> localDrafts = const {},
    Map<String, Map<String, dynamic>> serverDrafts = const {},
    // 默认本机优先（ExamDraftBuffer 的旧行为）；ExamPage 会按两份写入时刻显式传值。
    bool localDraftsWin = true,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _drafts = ExamDraftBuffer(
         attemptId: snapshot.attempt.id,
         service: _draftService,
         // 0144：交卷前的作答同步到服务端，换台设备也能接着答
         remote: (answers) => _repository.saveExamDrafts(
             attemptId: snapshot.attempt.id, answers: answers),
       ),
       _timer = ExamClock(deadlineAt: snapshot.attempt.deadlineAt, clock: clock),
       attempt = snapshot.attempt,
       paper = snapshot.paper,
       _items = snapshot.paper.items,
       // 与 _items 等长：每题属于哪个大题（题目区要在大题的第一题前印一遍大题名与给分口径）。
       _sections = [
         for (final section in snapshot.paper.sections)
           ...List<ExamSection>.filled(section.items.length, section),
       ] {
    _drafts.restore(
      fromServer: snapshot.answers,
      serverDrafts: serverDrafts,
      fromDisk: localDrafts,
      localWins: localDraftsWin,
    );
    // 续考落在第一道还没答的题上；全答完了就停在最后一题（让学生自己检查）
    final pending = _items.indexWhere((item) => !_drafts.has(item.id));
    _index = pending < 0 ? _items.length - 1 : pending;
    if (_index < 0) _index = 0;
  }

  /// 空卷（服务端不允许开考，纯粹是给越界访问一个不会崩的返回值）。
  static const _emptySection = ExamSection(id: '');

  final PaperRepository _repository;
  final ExamDraftService? _draftService;
  final DateTime Function() _clock;

  final ExamAttempt attempt;
  final ExamPaper paper;
  final List<ExamItem> _items;
  final List<ExamSection> _sections;
  final ExamDraftBuffer _drafts;

  int _index = 0;
  bool _submitting = false;
  bool _disposed = false;

  /// 倒计时状态（截止时刻可被服务端改写，0144）。见 exam_clock.dart。
  final ExamClock _timer;

  /// 交卷是否已经成功。页面据此决定离开时要不要暂停计时。
  bool _submitted = false;

  bool get submitted => _submitted;

  int get index => _index;

  int get total => _items.length;

  ExamItem get current => _items[_index];

  ExamItem itemAt(int index) =>
      index >= 0 && index < _items.length ? _items[index] : current;

  /// 第 [index] 题所属的大题。越界退化为当前题所属的那个，调用方不必判空。
  ExamSection sectionAt(int index) => index >= 0 && index < _sections.length
      ? _sections[index]
      : (_sections.isEmpty ? _emptySection : _sections[_index]);

  /// 这一题是不是它所在大题的第一题——是的话题目区要先印一遍大题名与给分口径。
  bool startsSection(int index) =>
      index <= 0 || sectionAt(index - 1).id != sectionAt(index).id;

  /// 第 [index] 题的作答，未作答为 null（答题卡与复盘都读它）。
  SubmittedAnswer? draftAt(int index) => _drafts.of(itemAt(index).id);

  int get answeredCount => _items.where((i) => _drafts.has(i.id)).length;

  double get progress => total == 0 ? 0 : answeredCount / total;

  bool get isFirst => _index == 0;

  bool get isLast => _index == _items.length - 1;

  bool get submitting => _submitting;

  /// 剩余时间；截止时刻缺失（脏数据）时返回 null，界面按"不限时"处理。
  Duration? get remaining => _timer.remaining;

  /// 倒计时用的截止时刻（可能已被服务端改写，见 [ExamClock]）。
  DateTime get deadline => _timer.deadline;

  /// 记下当前题的作答（空答案按未作答处理，见 ExamDraftBuffer.put）。
  void setDraft(SubmittedAnswer? answer) {
    _drafts.put(current.id, answer);
    _notify();
  }

  void jumpTo(int target) {
    if (target < 0 || target >= _items.length || target == _index) return;
    _index = target;
    _notify();
  }

  void advance() => jumpTo(_index + 1);

  void retreat() => jumpTo(_index - 1);

  /// 交卷。整卷一次提交，服务端逐题判分。
  ///
  /// 用时必须由客户端算：submit_exam_attempt 存的是 `coalesce(p_duration_ms, 0)`，
  /// 不传就恒为 0，成绩单的「用时」会永远不显示（真机联调时踩到过）。
  Future<ExamSubmitSummary> submit() async {
    if (_submitting) throw StateError('交卷进行中');
    _submitting = true;
    _notify();
    try {
      final startedAt = attempt.startedAt;
      // 用时 = 总时长 - 剩余（离开期间已暂停，不能把墙钟差算成答题时间）。
      // 截止时刻缺失时退回墙钟口径；本机时钟早于起考时刻（校时回拨）时宁可记 0。
      final elapsed =
          _timer.elapsedOf(Duration(minutes: paper.durationMinutes)) ??
          (startedAt == null ? null : _clock().difference(startedAt));
      final summary = await _repository.submitAttempt(
        attemptId: attempt.id,
        answers: _drafts.snapshot(),
        durationMs: elapsed == null || elapsed.isNegative
            ? null
            : elapsed.inMilliseconds,
      );
      // 交卷成功才清暂存：失败时那份草稿是学生唯一的凭据
      await _draftService?.clear(attempt.id);
      _drafts.cancelPendingSave();
      // 页面离开时据此跳过"暂停计时"——这场已经结束了
      _submitted = true;
      return summary;
    } finally {
      _submitting = false;
      _notify();
    }
  }

  /// 切后台 / 离开页面时立刻落盘并推给服务端（硬杀进程走不到 dispose）。
  void flushDrafts() => _drafts.flush();

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    // 离开页面时把还没落盘的那一次补上（见 ExamDraftBuffer.dispose）
    _drafts.dispose();
    super.dispose();
  }
}
