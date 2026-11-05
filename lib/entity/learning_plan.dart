// AI 推荐练习（只读）。字段与服务端 my_recommended_practice 对齐。
//
// item_ids 是给 PracticeDraftStore.setPickedQuestions 用的扁平列表；
// stages 只用于展示分组与"为什么推荐"。响应里没有题干/答案，页面不需要。

class LearningPlan {
  const LearningPlan({
    required this.status,
    required this.coldStart,
    this.nextDueAt,
    this.overallMastery,
    required this.itemsConsidered,
    required this.limit,
    required this.stages,
    required this.itemIds,
  });

  final String status;
  final bool coldStart;
  final DateTime? nextDueAt;
  final double? overallMastery;
  final int itemsConsidered;
  final int limit;
  final List<LearningStage> stages;
  final List<String> itemIds;

  bool get nothingDue => status != 'ok' || itemIds.isEmpty;

  factory LearningPlan.fromJson(Map<String, dynamic> json) {
    final summary = (json['summary'] as Map?)?.cast<String, dynamic>() ?? const {};
    return LearningPlan(
      status: '${json['status'] ?? 'ok'}',
      coldStart: json['cold_start'] == true,
      nextDueAt: DateTime.tryParse('${json['next_due_at']}'),
      overallMastery: _toDouble(summary['overall_mastery']),
      itemsConsidered: _toInt(summary['items_considered']),
      limit: _toInt(summary['limit']),
      stages: (json['stages'] as List? ?? const [])
          .map((item) => LearningStage.fromJson((item as Map).cast<String, dynamic>()))
          .toList(),
      itemIds: (json['item_ids'] as List? ?? const []).map((id) => '$id').toList(),
    );
  }
}

class LearningStage {
  const LearningStage({
    required this.key,
    required this.title,
    required this.description,
    required this.items,
  });

  final String key;
  final String title;
  final String description;
  final List<RecommendedItem> items;

  factory LearningStage.fromJson(Map<String, dynamic> json) => LearningStage(
    key: '${json['key'] ?? ''}',
    title: '${json['title'] ?? ''}',
    description: '${json['description'] ?? ''}',
    items: (json['items'] as List? ?? const [])
        .map((item) => RecommendedItem.fromJson((item as Map).cast<String, dynamic>()))
        .toList(),
  );
}

class RecommendedItem {
  const RecommendedItem({
    required this.questionId,
    required this.versionId,
    required this.qtype,
    required this.difficulty,
    required this.nodeName,
    this.pMastery,
    this.pCorrect,
    this.infoGain,
    this.score,
    required this.reasonCode,
  });

  final String questionId;
  final String versionId;
  final String qtype;
  final int difficulty;
  final String nodeName;
  final double? pMastery;
  final double? pCorrect;
  final double? infoGain;
  final double? score;
  final String reasonCode;

  factory RecommendedItem.fromJson(Map<String, dynamic> json) => RecommendedItem(
    questionId: '${json['question_id'] ?? ''}',
    versionId: '${json['version_id'] ?? ''}',
    qtype: '${json['qtype'] ?? ''}',
    difficulty: _toInt(json['difficulty']),
    nodeName: '${json['node_name'] ?? ''}',
    pMastery: _toDouble(json['p_mastery']),
    pCorrect: _toDouble(json['p_correct']),
    infoGain: _toDouble(json['info_gain']),
    score: _toDouble(json['score']),
    reasonCode: '${json['reason_code'] ?? ''}',
  );
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}
