// 单题的运行时状态：这一题**现在**是什么样。
//
// 不可变 + copyWith：状态变更由 PracticeRunner 统一发号施令，
// 子组件只读快照。这样"谁改了什么"永远只有一处，不会出现两个地方各改一半。
//
// 刻意不含任何 Widget/Context/Controller —— 它是纯数据，可以在纯 Dart 测试里构造与断言。

import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/domain/option_order.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';

class QuestionRuntime {
  const QuestionRuntime({
    required this.item,
    required this.displayOrder,
    this.draft,
    this.verdict,
    this.selfMastered,
    this.durationMs = 0,
    this.submitting = false,
  });

  final PracticeItem item;

  /// 选项的**显示顺序**（存的是原始 key）。
  /// 在创建时算一次并物化——绝不能放进 build()，否则每次重建都会重排，
  /// 用户点完选项位置会跳。
  final List<String> displayOrder;

  /// 当前作答（未作答为 null）。
  final SubmittedAnswer? draft;

  /// 判定结果。null 表示尚未判定（或主观题等自评）。
  final bool? verdict;

  /// 主观题自评：是否掌握。也是 short_answer 的判定依据。
  final bool? selfMastered;

  /// 本题用时（毫秒），由页面在切题时累加。
  final int durationMs;

  /// 正在提交中（即时模式）。
  final bool submitting;

  /// 这道题**有答案了**：本次刚选的（draft）或续练时从服务端还原的（已判过）。
  ///
  /// 只认 draft 会让续练的进度条从 0 开始、答题卡把已答的题画成"未作答"、
  /// 批量模式还会提示"还有 N 道题没作答"——那几道明明答过了。
  bool get isAnswered => draft != null || isGraded;

  bool get isGraded => verdict != null || selfMastered != null;

  /// 该题在服务端是否已有记录（续练时从 answers 还原）。
  bool get isSubmitted => verdict != null;

  QuestionRuntime copyWith({
    List<String>? displayOrder,
    SubmittedAnswer? draft,
    bool? verdict,
    bool? selfMastered,
    int? durationMs,
    bool? submitting,
    bool clearDraft = false,
    bool clearVerdict = false,
  }) {
    return QuestionRuntime(
      item: item,
      displayOrder: displayOrder ?? this.displayOrder,
      draft: clearDraft ? null : (draft ?? this.draft),
      verdict: clearVerdict ? null : (verdict ?? this.verdict),
      selfMastered: selfMastered ?? this.selfMastered,
      durationMs: durationMs ?? this.durationMs,
      submitting: submitting ?? this.submitting,
    );
  }
}

/// 从会话快照构造全部单题运行时。
///
/// 放在本文件而不是 Runner 里：「怎么把一道题变成运行时」是围绕 QuestionRuntime 的知识，
/// 与"会话怎么推进"是两件事。Runner 因此能专注于状态机本身。
List<QuestionRuntime> buildQuestionRuntimes(
  PracticeSessionSnapshot snapshot, {
  required bool shuffleOptions,
}) {
  final records = snapshot.answersByQuestion;
  return [
    for (final item in snapshot.items)
      _buildOne(item, records[item.questionId], shuffleOptions),
  ];
}

QuestionRuntime _buildOne(
  PracticeItem item,
  PracticeAnswerRecord? record,
  bool shuffle,
) {
  final keys = item.content.options.map((o) => o.key).toList();
  return QuestionRuntime(
    item: item,
    // 种子取 questionId：同一题每次进入顺序一致，复盘时才对得上
    displayOrder: displayOrder(keys, seed: item.questionId, shuffle: shuffle),
    verdict: record?.isCorrect,
    selfMastered: record?.selfMastered,
    durationMs: record?.durationMs ?? 0,
  );
}
