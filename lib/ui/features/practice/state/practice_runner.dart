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
//
// 不负责：界面、导航、提示文案。

import 'package:flutter/foundation.dart';
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
    this.shuffleOptions = true,
  }) : _sessionId = snapshot.sessionId,
       _runtimes = buildQuestionRuntimes(snapshot, shuffleOptions: shuffleOptions) {
    // 续练时定位到第一道未作答的题；全答完则停在最后一题
    final pending = _runtimes.indexWhere((r) => !r.isSubmitted);
    _index = pending < 0 ? 0 : pending;
  }

  final PracticeRepository _repository;
  final PracticeMode mode;
  final bool shuffleOptions;
  final String _sessionId;

  /// 元素会被替换（每次变更都换新的不可变实例），但列表本身不重新赋值。
  final List<QuestionRuntime> _runtimes;
  int _index = 0;
  final DateTime _startedAt = DateTime.now();
  bool _finishing = false;

  String get sessionId => _sessionId;

  int get index => _index;

  int get total => _runtimes.length;

  int get answeredCount => _runtimes.where((r) => r.isAnswered).length;

  QuestionRuntime get current => _runtimes[_index];

  bool get isFirst => _index == 0;

  bool get isLast => _index == _runtimes.length - 1;

  bool get isFinishing => _finishing;

  double get progress => total == 0 ? 0 : answeredCount / total;

  List<QuestionRuntime> get runtimes => List.unmodifiable(_runtimes);

  /// 切题时结算本题用时（毫秒）。页面在 setDraft 前调用。
  void markQuestionSpent(int questionIndex, int elapsedMs) {
    _runtimes[questionIndex] =
        _runtimes[questionIndex].copyWith(durationMs: elapsedMs);
  }

  void setDraft(SubmittedAnswer? answer) {
    _runtimes[_index] = current.copyWith(draft: answer, clearDraft: answer == null);
    notifyListeners();
  }

  /// 主观题自评。root 题的掌握与否通过 p_self_mastered 传给服务端。
  void setSelfMastered(bool mastered) {
    _runtimes[_index] = current.copyWith(selfMastered: mastered, verdict: mastered);
    notifyListeners();
  }

  /// 即时模式：判定当前题。
  ///
  /// 先用本地镜像**立即**出结果（保证"选完就知道"的手感），再提交给服务端，
  /// 收到返回后用它的 is_correct **覆盖**本地结果——服务端是权威。
  /// 两者不一致说明本地镜像有 bug，会打日志（差分测试就是为了让它不发生）。
  Future<SubmitResult> check() async {
    final runtime = current;
    final answer = runtime.draft;
    if (answer == null) {
      throw StateError('未作答就调用 check');
    }

    // 主观题不由本地判分（gradeAnswer 返回 null），其结论来自自评
    final local = runtime.item.type.isSelfAssessed
        ? runtime.selfMastered
        : gradeAnswer(runtime.item.qtype, runtime.item.content.toJson(), answer.toJson());

    if (local != null) {
      _runtimes[_index] = runtime.copyWith(verdict: local, submitting: true);
      notifyListeners();
    }

    final result = await _repository.submitAnswer(
      sessionId: _sessionId,
      questionId: runtime.item.questionId,
      answer: answer,
      durationMs: runtime.durationMs,
      selfMastered: runtime.item.type.isSelfAssessed ? runtime.selfMastered : null,
    );

    if (local != null && local != result.isCorrect) {
      debugPrint(
        '判分不一致：本地=$local 服务端=${result.isCorrect} '
        '题=${runtime.item.questionId} 题型=${runtime.item.qtype} '
        '—— 这是 domain/answer_grader.dart 的 bug，请对照数据库函数修正',
      );
    }
    _runtimes[_index] = current.copyWith(
      verdict: result.isCorrect,
      submitting: false,
    );
    notifyListeners();
    return result;
  }

  /// 批量模式：交卷前把整卷未提交的作答逐题送上去。
  ///
  /// 逐题串行而不是并发：服务端每题都会刷新会话进度，并发写同一行容易相互覆盖；
  /// 而且卷子通常十几二十题，串行的额外耗时可以接受。
  Future<void> submitAll() async {
    for (var i = 0; i < _runtimes.length; i++) {
      final runtime = _runtimes[i];
      if (runtime.isSubmitted || runtime.draft == null) continue;
      try {
        final result = await _repository.submitAnswer(
          sessionId: _sessionId,
          questionId: runtime.item.questionId,
          answer: runtime.draft!,
          durationMs: runtime.durationMs,
          selfMastered: runtime.item.type.isSelfAssessed ? runtime.selfMastered : null,
        );
        _runtimes[i] = runtime.copyWith(verdict: result.isCorrect);
      } catch (error) {
        // 单题失败不中断整卷：已提交的仍然算数，把失败的留给用户重试
        debugPrint('提交失败（题 ${runtime.item.questionId}）：${mapError(error).message}');
      }
      notifyListeners();
    }
  }

  void advance() {
    if (isLast) return;
    _index++;
    notifyListeners();
  }

  void retreat() {
    if (isFirst) return;
    _index--;
    notifyListeners();
  }

  void jumpTo(int target) {
    if (target < 0 || target >= total || target == _index) return;
    _index = target;
    notifyListeners();
  }

  /// 交卷。批量模式会先把未提交的作答送上去。
  Future<FinishSummary> finish() async {
    _finishing = true;
    notifyListeners();
    try {
      if (mode == PracticeMode.batch) await submitAll();
      final elapsed = DateTime.now().difference(_startedAt).inMilliseconds;
      return await _repository.finishSession(
        sessionId: _sessionId,
        durationMs: elapsed,
      );
    } finally {
      _finishing = false;
      notifyListeners();
    }
  }

  /// 放弃本次练习。**已作答的记录仍留在库里并计入统计**——这是服务端行为。
  Future<void> abandon() => _repository.abandonSession(_sessionId);

  /// 续练：会话已交卷/作废时不该进入作答界面，由页面据此判断。
  bool get hasUnanswered => _runtimes.any((r) => !r.isAnswered);
}
