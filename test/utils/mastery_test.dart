import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';

void main() {
  test('掌握度分档与缺失值', () {
    expect(masteryLabel(null), '暂无');
    expect(masteryLabel(0.2), '薄弱');
    expect(masteryLabel(0.5), '待巩固');
    expect(masteryLabel(0.7), '较好');
    expect(masteryLabel(0.9), '扎实');
  });

  test('百分比文案', () {
    expect(masteryPercent(null), '—');
    expect(masteryPercent(0.573), '57%');
    expect(masteryPercent(0.6), '60%');
  });

  test('推荐理由码', () {
    expect(reasonLabel('new_item'), '新题');
    expect(reasonLabel('due_review'), '到期复习');
    expect(reasonLabel('weak_node'), '薄弱知识点');
    expect(reasonLabel('high_info'), '信息量大');
    expect(reasonLabel('consolidate'), '巩固');
    expect(reasonLabel(''), '推荐');
  });

  test('难度简称', () {
    expect(difficultyShort(1), '易');
    expect(difficultyShort(2), '中');
    expect(difficultyShort(3), '难');
  });
}
