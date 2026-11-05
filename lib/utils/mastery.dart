// 掌握度与推荐理由的文案（纯 Dart，可单测）。
//
// 阈值与网页端 BKT 面板保持同一套语义：
//   < 0.40 薄弱 / < 0.60 待巩固 / < 0.80 较好 / >= 0.80 扎实。
// 这只影响措辞，不参与推荐计算——推荐完全由服务端 BKT 分数决定。

String masteryLabel(double? value) {
  if (value == null) return '暂无';
  if (value < 0.40) return '薄弱';
  if (value < 0.60) return '待巩固';
  if (value < 0.80) return '较好';
  return '扎实';
}

String masteryPercent(double? value) {
  if (value == null) return '—';
  return '${(value * 100).round()}%';
}

String reasonLabel(String code) => switch (code) {
  'new_item' => '新题',
  'due_review' => '到期复习',
  'weak_node' => '薄弱知识点',
  'high_info' => '信息量大',
  'consolidate' => '巩固',
  _ => code.isEmpty ? '推荐' : code,
};

String difficultyShort(int? value) => switch (value) {
  1 => '易',
  3 => '难',
  _ => '中',
};
