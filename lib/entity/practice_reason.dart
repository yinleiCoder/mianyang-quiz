// 「为什么推这道题」的推荐依据（0137 practice_session_reasons）。
//
// 字段来自 0126 practice_plan：reason_code / p_mastery / due_at / node_name。
// 只用于解释推荐，不参与判分；旧会话或迁移未执行时为空表，界面整块不渲染。

class PracticeReason {
  const PracticeReason({
    required this.questionId,
    required this.reasonCode,
    this.mastery,
    this.dueAt,
    this.nodeName = '',
  });

  final String questionId;
  final String reasonCode;

  /// BKT 掌握度 0–1；null = 新题还没学到。
  final double? mastery;

  /// FSRS 下次到期时间；null = 没有复习计划。
  final DateTime? dueAt;

  final String nodeName;

  factory PracticeReason.fromJson(Map<String, dynamic> json) => PracticeReason(
    questionId: '${json['question_id'] ?? ''}',
    reasonCode: '${json['reason_code'] ?? ''}',
    mastery: (json['p_mastery'] as num?)?.toDouble(),
    dueAt: DateTime.tryParse('${json['due_at']}'),
    nodeName: '${json['node_name'] ?? ''}',
  );
}

/// 四个人群标签（reason_code）→ 学生能懂的一句话。
String practiceReasonLabel(String code) => switch (code) {
  'new_item' => '新题：还没练过，先建立印象',
  'due_review' => '到了复习时间：FSRS 预计今天会忘',
  'weak_node' => '薄弱知识点：掌握度偏低',
  'mastered' => '巩固题：已掌握，少量回顾',
  _ => '按当前练习计划推荐',
};

/// 卡片的第二行：知识点 / 掌握度 / 计划复习时间。
String practiceReasonDetail(PracticeReason reason) {
  final parts = <String>[];
  if (reason.nodeName.isNotEmpty) parts.add('知识点：${reason.nodeName}');
  if (reason.mastery != null) {
    final value = reason.mastery!.clamp(0.0, 1.0);
    parts.add('掌握度 ${(value * 100).round()}%');
  }
  if (reason.dueAt != null) {
    parts.add('计划复习：${_formatDate(reason.dueAt!)}');
  }
  return parts.isEmpty ? '由 BKT 掌握度与 FSRS 复习间隔共同决定。' : parts.join(' · ');
}

String _formatDate(DateTime date) => '${date.month}-${date.day}';
