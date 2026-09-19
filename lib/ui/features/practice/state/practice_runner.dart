// 一次练习的会话状态机。
//
// **它不是 ViewModel**：由 PracticePage 自己 new 出来、随页面销毁、不进 provider、
// 不被任何其他 feature import。它只是"恰好要通知界面所以是 ChangeNotifier"的页面状态。
// 因此它不持有 BuildContext、不 import material_ui、不认识任何 Widget。
//
// 职责：
//   · 维护每一题的运行时状态（作答、判定、用时）
//   · 即时模式：本地判分抢先显示 → 异步提交 → 用服务端结果对账
//   · 批量模式：只记草稿，交卷时才逐题提交
//   · 计时与进度
//   · **认得出会话已经结束**（见 [ended]/[syncEndedState]）：服务端只接受 status = active
//     的会话，认不出来的话用户会在一个死会话里白答一整场
//
// 不负责：界面、导航、提示文案。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/domain/answer_grader.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/features/practice/state/question_runtime.dart';

class PracticeRunner extends ChangeNotifier {
  // 私有命名参数（`required this._repository`）是 Dart 3.13 起支持的写法
  PracticeRunner({
    required this._repository,
    required PracticeSessionSnapshot snapshot,
    required this.mode,
    bool shuffleOptions = true,
  }) : _sessionId = snapshot.sessionId,
       _ended = snapshot.isActive ? null : snapshot,
       _runtimes = buildQuestionRuntimes(snapshot, shuffleOptions: shuffleOptions) {
    // 续练时定位到第一道未作答的题；全答完则停在最后一题
    final pending = _runtimes.indexWhere((r) => !r.isSubmitted);
    _index = pending < 0 ? 0 : pending;
  }

  final PracticeRepository _repository;
  final PracticeMode mode;
  final String _sessionId;

  /// 元素会被替换（每次变更都换新的不可变实例），但列表本身不重新赋值。
  final List<QuestionRuntime> _runtimes;
  int _index = 0;
  final DateTime _startedAt = DateTime.now();

  /// 会话结束时的快照；为 null 表示还能作答。
  ///
  /// 两种来源：进页面时取回的会话本来就不是 active（首页「继续练习」卡片用的是
  /// 看板缓存，可以指到一场早就结束的练习），以及作答途中会话在别处被结束
  /// （同一账号在另一台设备上开始了新练习——服务端每人只允许一套进行中，
  /// 开新的会**静默作废**旧的）。
  ///
  /// 非空之后**一个字都不能再提交**：服务端 submit/finish 两处守卫都要求
  /// status = 'active'，再提交只会换来一句「本次练习已结束」。
  PracticeSessionSnapshot? _ended;

  /// 页面是否已经关掉。提交是异步的：用户完全可能在"检查"发出后、结果回来前
  /// 退出练习页，此时 Runner 已 dispose，再调 notifyListeners() 会在 debug 下抛
  /// 「A ChangeNotifier was used after being disposed」。判定结果仍照常写回
  /// `_runtimes`（历史要留在库里），只是不再通知界面。
  bool _disposed = false;

  void _notify() {
    if (!_disposed) super.notifyListeners();
  }

  String get sessionId => _sessionId;

  /// 会话已结束时的快照；非空即"不能再答"（界面据此换成结束态）。见 [_ended]。
  PracticeSessionSnapshot? get ended => _ended;

  int get index => _index;

  int get total => _runtimes.length;

  int get answeredCount => _runtimes.where((r) => r.isAnswered).length;

  QuestionRuntime get current => _runtimes[_index];

  /// 第 [index] 题的运行时（答题卡要读全卷状态）。越界退化为当前题，调用方不必判空。
  QuestionRuntime runtimeAt(int index) =>
      index >= 0 && index < _runtimes.length ? _runtimes[index] : current;

  /// 第 [index] 题的题目（答题卡按题型分组用）。
  PracticeItem itemAt(int index) => runtimeAt(index).item;

  /// 本次作答的开始时刻（页面打开时）。
  ///
  /// 计时器以它为起点，**不用库里会话的 started_at**：隔天点「继续练习」时，
  /// 那个时间戳会让顶部直接显示"练了 20 小时"。
  DateTime get startedAt => _startedAt;

  bool get isFirst => _index == 0;

  bool get isLast => _index == _runtimes.length - 1;

  double get progress => total == 0 ? 0 : answeredCount / total;

  /// 切题时结算本题用时（毫秒）。页面在 setDraft 前调用。
  void markQuestionSpent(int questionIndex, int elapsedMs) {
    _runtimes[questionIndex] =
        _runtimes[questionIndex].copyWith(durationMs: elapsedMs);
  }

  void setDraft(SubmittedAnswer? answer) {
    _runtimes[_index] = current.copyWith(draft: answer, clearDraft: answer == null);
    _notify();
  }

  /// 主观题自评。root 题的掌握与否通过 p_self_mastered 传给服务端。
  void setSelfMastered(bool mastered) {
    _runtimes[_index] = current.copyWith(selfMastered: mastered, verdict: mastered);
    _notify();
  }

  /// 即时模式：判定当前题。
  ///
  /// 先用本地镜像**立即**出结果（保证"选完就知道"的手感），再提交给服务端，
  /// 收到返回后用它的 is_correct **覆盖**本地结果——服务端是权威。
  /// 两者不一致说明本地镜像有 bug，会打日志（差分测试就是为了让它不发生）。
  Future<SubmitResult> check() async {
    // **下标必须在 await 之前锁定**：等待期间用户可能切走（答题卡跳转、退出练习），
    // 回来时 _index 已不是发起判定的那题 —— 那时写 _runtimes[_index] 会把判定结果
    // 落到**别的题**上，而真正作答的那题永远停在 submitting=true（按钮一直转圈）。
    final index = _index;
    final runtime = _runtimes[index];
    final answer = runtime.draft;
    if (answer == null) {
      throw StateError('未作答就调用 check');
    }

    // 主观题不由本地判分（gradeAnswer 返回 null），其结论来自自评
    final local = runtime.item.type.isSelfAssessed
        ? runtime.selfMastered
        : gradeAnswer(runtime.item.qtype, runtime.item.content.toJson(), answer.toJson());

    if (local != null) {
      _runtimes[index] = runtime.copyWith(verdict: local, submitting: true);
      _notify();
    }

    final SubmitResult result;
    try {
      result = await _submit(runtime);
    } catch (error) {
      // 失败要把 submitting 收回来。留着它，「检查」按钮会一直转圈，
      // 用户看不出这一题还能再点一次，于是它再也交不上去。
      _runtimes[index] = _runtimes[index].copyWith(submitting: false);
      _notify();
      rethrow;
    }

    if (local != null && local != result.isCorrect) {
      debugPrint(
        '判分不一致：本地=$local 服务端=${result.isCorrect} '
        '题=${runtime.item.questionId} 题型=${runtime.item.qtype} '
        '—— 这是 domain/answer_grader.dart 的 bug，请对照数据库函数修正',
      );
    }
    // 写回发起时的那一道题，而不是"现在这"一道
    _runtimes[index] = _runtimes[index].copyWith(
      verdict: result.isCorrect,
      submitting: false,
    );
    _notify();
    return result;
  }

  /// 把一道题的作答送给服务端。单题判定与整卷提交共用这一处：
  /// 两边参数完全一致，分开写迟早会漂移（比如新增 RPC 参数只改了一边）。
  /// selfMastered 只对主观题传。
  Future<SubmitResult> _submit(QuestionRuntime runtime) => _repository.submitAnswer(
    sessionId: _sessionId,
    questionId: runtime.item.questionId,
    answer: runtime.draft!,
    durationMs: runtime.durationMs,
    selfMastered: runtime.item.type.isSelfAssessed ? runtime.selfMastered : null,
  );

  /// 提交失败后回查会话状态，确认"是不是这场练习已经结束了"。
  ///
  /// 为什么要在**失败之后**多问一次服务端，而不是直接拿错误文案去认：
  /// 文案是给人看的（服务端 raise 的中文），拿它做分支迟早会因为改一句话而失效。
  /// 状态本身才是事实，而事实只能查。调用点都在已经失败的路径上，不欠正常作答的时间。
  ///
  /// 回查自己也失败（断网）就什么都不做：拿不到结论就不要乱改界面，
  /// 上层照常把那句错误提示显示出来。
  Future<void> syncEndedState() async {
    if (_ended != null) return;
    try {
      final snapshot = await _repository.fetchSession(_sessionId);
      if (snapshot.isActive) return;
      _ended = snapshot;
      _notify();
    } catch (error) {
      debugPrint('回查会话状态失败：${mapError(error).message}');
    }
  }

  /// 批量模式：交卷前把整卷未提交的作答逐题送上去。
  ///
  /// 逐题串行而不是并发：服务端每题都会刷新会话进度，并发写同一行容易相互覆盖；
  /// 而且卷子通常十几二十题，串行的额外耗时可以接受。
  Future<void> submitAll() async {
    for (var i = 0; i < _runtimes.length; i++) {
      // 会话已经结束：后面的每一题都注定被拒，别再打——界面正在换成结束态
      if (_ended != null) return;
      final runtime = _runtimes[i];
      if (runtime.isSubmitted || runtime.draft == null) continue;
      try {
        final result = await _submit(runtime);
        _runtimes[i] = runtime.copyWith(verdict: result.isCorrect);
      } catch (error) {
        // 单题失败不中断整卷：已提交的仍然算数，把失败的留给用户重试。
        // **但会话结束是例外**——那不是"这一题"的问题，整卷都送不进去了，
        // 必须当场认出来并停下：批量模式下这一场答的题只存在本机，
        // 让循环蒙头跑完，用户会在交卷时才发现全丢了。
        final mapped = mapError(error);
        debugPrint('提交失败（题 ${runtime.item.questionId}）：${mapped.message}');
        // 断网就不必回查了：查也查不通，只会让"整卷失败"变成"两倍的失败请求"
        if (mapped is! NetworkException) await syncEndedState();
      }
      _notify();
    }
  }

  void advance() {
    if (isLast) return;
    _index++;
    _notify();
  }

  void retreat() {
    if (isFirst) return;
    _index--;
    _notify();
  }

  void jumpTo(int target) {
    if (target < 0 || target >= total || target == _index) return;
    _index = target;
    _notify();
  }

  /// 交卷。批量模式会先把未提交的作答送上去。
  ///
  /// 返回 null 表示**这次交卷没有结果可给**：会话在 [submitAll] 那一步就被发现已经结束
  /// （见 [ended]）。此时再去打一次交卷必然被服务端拒（它要求 status = 'active'），
  /// 换回来的只是一句错误提示，而界面正在换成结束态——调用方看到 null 就别再导航了。
  Future<FinishSummary?> finish() async {
    if (mode == PracticeMode.batch) await submitAll();
    if (_ended != null) return null;
    final elapsed = DateTime.now().difference(_startedAt).inMilliseconds;
    return _repository.finishSession(sessionId: _sessionId, durationMs: elapsed);
  }

  /// 放弃本次练习。**已作答的记录仍留在库里并计入统计**——这是服务端行为。
  Future<void> abandon() => _repository.abandonSession(_sessionId);

  @override
  void dispose() {
    // 只置标志，不撤销在途请求：提交已经发出去了，结果仍要写回 _runtimes。
    _disposed = true;
    super.dispose();
  }
}
