// 一场考试的状态机：作答、翻题、倒计时、交卷。
//
// **它不是 ViewModel**：由 ExamPage 自己 new 出来、随页面销毁、不进 provider、
// 不被任何其他 feature import。只是"恰好要通知界面所以是 ChangeNotifier"的页面状态。
//
// 与 PracticeRunner 最大的不同：**这里一次也不判分**。判分权威完全在服务端
// （0051 的 grade_exam_units 按计分点给分），本地既没有镜像也不需要抢先显示——
// 交卷前学生本就不该知道自己答得对不对。作答只存在内存 + 本机暂存里
// （服务端要等交卷才写 exam_answers，见 exam_draft_service）；那份草稿的存取与节流
// 拆在 ExamDraftBuffer 里，本类只负责"考试怎么推进"。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/services/exam_draft_service.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_draft_buffer.dart';

class ExamRunner extends ChangeNotifier {
  // 私有命名参数（`this._repository`）是 Dart 3.13 起支持的写法，与 PracticeRunner 一致
  ExamRunner({
    required this._repository,
    required ExamSnapshot snapshot,
    this._draftService,
    Map<String, Map<String, dynamic>> localDrafts = const {},
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       _drafts = ExamDraftBuffer(attemptId: snapshot.attempt.id, service: _draftService),
       attempt = snapshot.attempt,
       paper = snapshot.paper,
       _items = snapshot.paper.items,
       // 与 _items 等长：每题属于哪个大题（题目区要在大题的第一题前印一遍大题名与给分口径）。
       _sections = [
         for (final section in snapshot.paper.sections)
           ...List<ExamSection>.filled(section.items.length, section),
       ] {
    _drafts.restore(fromServer: snapshot.answers, fromDisk: localDrafts);
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
  Duration? get remaining => attempt.remainingFrom(_clock());

  /// 倒计时用的截止时刻。
  ///
  /// 缺失时退化成"十年后"而不是"现在"：_clock() 当截止会让倒计时一进页面就归零、
  /// 立刻自动交卷——一个空字段不该把学生的卷子交掉。**宁可永不到点，也不要误交。**
  DateTime get deadline =>
      attempt.deadlineAt ?? _clock().add(const Duration(days: 3650));

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
  /// 整卷用时按**服务端记的起考时刻**算：续考时本页才打开十几分钟，用页内计时会把
  /// 90 分钟的考试记成 15 分钟。
  ///
  /// 也**不能指望服务端自己算**：submit_exam_attempt 存的是 `coalesce(p_duration_ms, 0)`，
  /// 不传就是恒为 0——成绩单上的"用时"会永远不显示（真机联调时踩到过）。
  Future<ExamSubmitSummary> submit() async {
    if (_submitting) throw StateError('交卷进行中');
    _submitting = true;
    _notify();
    try {
      final startedAt = attempt.startedAt;
      // 本机时钟若早于起考时刻（校时回拨），宁可记 0 也不要负用时
      final elapsed = startedAt == null
          ? null
          : _clock().difference(startedAt);
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
      return summary;
    } finally {
      _submitting = false;
      _notify();
    }
  }

  /// 服务端存下来的作答（续考）打底，本机暂存放在上面覆盖。
  /// 本地优先：它是学生刚在这台设备上写的，比上一次同步更近。
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
