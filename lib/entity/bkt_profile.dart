// BKT 掌握度画像（只读）。字段与服务端 my_bkt_profile 对齐。
//
// 说明：标签掌握度只有在样本足够（attempts >= 5）时才有结论，服务端用
// insufficient 标出；页面据此显示"样本不足"，不硬给一个数。

class BktProfile {
  const BktProfile({
    required this.coldStart,
    required this.model,
    this.overallMastery,
    required this.nodes,
    required this.tags,
    required this.itemsCount,
  });

  final bool coldStart;
  final Map<String, dynamic> model;
  final double? overallMastery;
  final List<BktNode> nodes;
  final List<BktTag> tags;
  final int itemsCount;

  factory BktProfile.fromJson(Map<String, dynamic> json) => BktProfile(
    coldStart: json['cold_start'] == true,
    model: (json['model'] as Map?)?.cast<String, dynamic>() ?? const {},
    overallMastery: _toDouble(json['overall_mastery']),
    nodes: (json['nodes'] as List? ?? const [])
        .map((item) => BktNode.fromJson((item as Map).cast<String, dynamic>()))
        .toList(),
    tags: (json['tags'] as List? ?? const [])
        .map((item) => BktTag.fromJson((item as Map).cast<String, dynamic>()))
        .toList(),
    itemsCount: _toInt(json['items_count']),
  );
}

class BktNode {
  const BktNode({
    required this.nodeId,
    required this.nodeName,
    this.mastery,
    required this.attemptedItems,
    required this.totalItems,
    this.coverage,
  });

  final String nodeId;
  final String nodeName;
  final double? mastery;
  final int attemptedItems;
  final int totalItems;
  final double? coverage;

  factory BktNode.fromJson(Map<String, dynamic> json) => BktNode(
    nodeId: '${json['node_id'] ?? ''}',
    nodeName: '${json['node_name'] ?? ''}',
    mastery: _toDouble(json['mastery']),
    attemptedItems: _toInt(json['attempted_items']),
    totalItems: _toInt(json['total_items']),
    coverage: _toDouble(json['coverage']),
  );
}

class BktTag {
  const BktTag({
    required this.tagId,
    required this.tagName,
    this.mastery,
    required this.attempts,
    required this.items,
    required this.insufficient,
  });

  final String tagId;
  final String tagName;
  final double? mastery;
  final int attempts;
  final int items;
  final bool insufficient;

  factory BktTag.fromJson(Map<String, dynamic> json) => BktTag(
    tagId: '${json['tag_id'] ?? ''}',
    tagName: '${json['tag_name'] ?? ''}',
    mastery: _toDouble(json['mastery']),
    attempts: _toInt(json['attempts']),
    items: _toInt(json['items']),
    insufficient: json['insufficient'] == true,
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
