// 作答的**写入侧**契约：提交给 submit_practice_answer 的 p_answer JSON 形状。
//
// 为什么不复用「读到的答案」模型：两者形状不同，硬凑一个类会两边都别扭。
//   · 读到的（ServerAnswer）：单选/多选都是 {"type":"choice","keys":[…]}
//   · 写回去的（这里）：主观题要 {"type":"text"}（不带内容，是否掌握另经 p_self_mastered），
//     而复合题里的主观**子题**是 {"mastered": true}——**没有 type 键**。
// 这份形状由 0029 的 grade_answer 定义，写错的表现是"提交成功但永远判错"。
//
// **考试复用同一套形状**（submit_exam_attempt 的 p_answers[].answer）：0051 的
// grade_exam_units 读的是 `-> 'keys'` / `->> 'value'` / `-> 'values'` / `-> 'subs'`，
// 不认 `type` 判别键，所以这里多带一个 type 它照样判得对——两边不必各造一套词汇表。
// 唯一的差别是主观题：练习只要一个标记，考试要学生写的原文（见 EssayAnswer）。
//
// 放 domain 而非 data/models：这是纯契约类型，不做反序列化、不依赖任何仓储，
// 与 answer_grader 是同一份契约的两半，放一起才好对照着改。

sealed class SubmittedAnswer {
  const SubmittedAnswer();

  /// 服务端契约形状。
  Map<String, dynamic> toJson();
}

final class ChoiceAnswer extends SubmittedAnswer {
  const ChoiceAnswer(this.keys);

  /// **原始选项 key**（A/B/C…），不是乱序后的显示字母。
  /// 乱序只影响展示，提交必须用原始 key，否则服务端按 key 匹配答案会全错。
  final List<String> keys;

  @override
  Map<String, dynamic> toJson() => {'type': 'choice', 'keys': keys};
}

final class TrueFalseAnswer extends SubmittedAnswer {
  const TrueFalseAnswer(this.value);
  final bool value;

  @override
  Map<String, dynamic> toJson() => {'type': 'tf', 'value': value};
}

final class BlankAnswer extends SubmittedAnswer {
  const BlankAnswer(this.values);
  final List<String> values;

  @override
  Map<String, dynamic> toJson() => {'type': 'blank', 'values': values};
}

/// 主观题作答：内容不参与判分（由用户自评决定），所以只带一个 type。
/// 是否掌握通过 submit_practice_answer 的 p_self_mastered 单独传。
final class TextAnswer extends SubmittedAnswer {
  const TextAnswer();

  @override
  Map<String, dynamic> toJson() => {'type': 'text'};
}

/// 考试的主观题作答：学生**写下来**的答案，原样交给阅卷人。
///
/// 与 [TextAnswer] 的区别不是形状的细节，而是「有没有内容」：练习的主观题没有输入框
/// （对错由自评决定，写了也没人看），考试则必须留下学生的原话。
///
/// 服务端判分不看它（grade_exam_units 对 short_answer 一律返回 manual），
/// 但**阅卷页要看**——网页端取的是 `answer.samples ?? answer.text`
/// （见 components/papers/exam-grading-board.jsx 的 AnswerText），
/// 所以这里的键只能是 `text`，换成 `content` 之类会让阅卷页显示「（未作答）」。
final class EssayAnswer extends SubmittedAnswer {
  const EssayAnswer(this.text);

  final String text;

  @override
  Map<String, dynamic> toJson() => {'type': 'text', 'text': text};
}

/// 复合题里**主观子题**的自评：注意没有 type 键，这是 SQL 里 `->> 'mastered'` 的约定。
final class SubMasteredAnswer extends SubmittedAnswer {
  const SubMasteredAnswer(this.mastered);
  final bool mastered;

  @override
  Map<String, dynamic> toJson() => {'mastered': mastered};
}

final class CompositeAnswer extends SubmittedAnswer {
  const CompositeAnswer(this.subs);

  /// 与 content.sub **同序**；缺项按空作答处理（服务端会判错）。
  final List<SubmittedAnswer> subs;

  @override
  Map<String, dynamic> toJson() =>
      {'type': 'composite', 'subs': subs.map((s) => s.toJson()).toList()};
}

/// 「不会」：计一次作答且判错，但比直接跳过更诚实——它会计入统计。
final class UnknownAnswer extends SubmittedAnswer {
  const UnknownAnswer();

  @override
  Map<String, dynamic> toJson() => {'type': 'unknown'};
}

/// 把服务端存下来的作答记录还原成 SubmittedAnswer。
///
/// 用途：复盘页要标出"用户当时选了什么"。练习记录里存的是提交上去的那份 JSON，
/// 形状与 [SubmittedAnswer.toJson] 一致，所以这里能原路还原。
///
/// 为什么不能拿读取侧的 ServerAnswer 顶替：两者判别键虽然都叫 type，
/// 但主观题完全不同（读到的带 samples、写回去的只带 type），
/// 复合题的**主观子题**更是 `{"mastered":true}` —— **连 type 键都没有**。
///
/// 无法识别的形状返回 null（调用方据此退化为"只显示正确答案"），
/// 而不是抛异常：历史数据里可能有旧版本写下的形状，不该让复盘页崩掉。
SubmittedAnswer? submittedAnswerFrom(Map<String, dynamic>? wire) {
  if (wire == null) return null;
  final type = wire['type'] as String? ?? '';

  return switch (type) {
    'choice' => ChoiceAnswer(_strings(wire['keys'])),
    'tf' => TrueFalseAnswer(wire['value'] == true),
    'blank' => BlankAnswer(_strings(wire['values'])),
    // 练习存下来的 {"type":"text"} 没有 text 键（它只是个「已作答」标记），
    // 考试的 EssayAnswer 才有。两者靠这一处分开，读到旧数据不会变成空的论述题。
    'text' => wire['text'] is String
        ? EssayAnswer(wire['text'] as String)
        : const TextAnswer(),
    'unknown' => const UnknownAnswer(),
    'composite' => CompositeAnswer([
      for (final raw in (wire['subs'] as List? ?? const []))
        if (raw is Map && raw['mastered'] != null)
          SubMasteredAnswer(raw['mastered'] == true)
        else
          submittedAnswerFrom(
                raw is Map ? Map<String, dynamic>.from(raw) : null,
              ) ??
              const UnknownAnswer(),
    ]),
    _ => null,
  };
}

List<String> _strings(Object? raw) {
  if (raw is! List) return const [];
  return raw.map((e) => '$e').toList();
}
