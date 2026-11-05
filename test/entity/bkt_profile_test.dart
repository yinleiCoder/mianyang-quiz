import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';

void main() {
  test('BktProfile.fromJson 解析画像', () {
    final profile = BktProfile.fromJson({
      'cold_start': false,
      'model': {'name': 'BKT', 'p_t': 0.15, 'p_s': 0.10},
      'overall_mastery': 0.573,
      'nodes': [
        {
          'node_id': 'n1',
          'node_name': '办公应用',
          'mastery': 0.573,
          'attempted_items': 193,
          'total_items': 731,
          'coverage': 0.264,
        },
      ],
      'tags': [
        {
          'tag_id': 't1',
          'tag_name': 'word',
          'mastery': 0.493,
          'attempts': 68,
          'items': 51,
          'insufficient': false,
        },
        {
          'tag_id': 't2',
          'tag_name': 'ppt',
          'mastery': 0.3,
          'attempts': 2,
          'items': 2,
          'insufficient': true,
        },
      ],
      'items_count': 193,
    });

    expect(profile.coldStart, isFalse);
    expect(profile.overallMastery, closeTo(0.573, 0.0001));
    expect(profile.itemsCount, 193);
    expect(profile.model['name'], 'BKT');
    expect(profile.nodes.single.nodeName, '办公应用');
    expect(profile.nodes.single.attemptedItems, 193);
    expect(profile.tags.first.tagName, 'word');
    expect(profile.tags.first.attempts, 68);
    expect(profile.tags.last.insufficient, isTrue);
  });

  test('LearningPlan.fromJson 解析阶段与题目', () {
    final plan = LearningPlan.fromJson({
      'status': 'ok',
      'cold_start': false,
      'summary': {'overall_mastery': 0.573, 'items_considered': 850, 'limit': 10},
      'stages': [
        {
          'key': 'foundation',
          'title': '补齐薄弱基础',
          'description': '掌握度 < 0.60',
          'items': [
            {
              'question_id': 'q1',
              'version_id': 'v1',
              'qtype': 'true_false',
              'difficulty': 2,
              'node_name': '计算机',
              'p_mastery': 0.15,
              'p_correct': 0.56,
              'info_gain': 0.048,
              'score': 0.601,
              'reason_code': 'new_item',
            },
          ],
        },
      ],
      'item_ids': ['q1'],
    });

    expect(plan.status, 'ok');
    expect(plan.nothingDue, isFalse);
    expect(plan.overallMastery, closeTo(0.573, 0.0001));
    expect(plan.limit, 10);
    expect(plan.stages.single.title, '补齐薄弱基础');
    expect(plan.stages.single.items.single.reasonCode, 'new_item');
    expect(plan.stages.single.items.single.pMastery, closeTo(0.15, 0.0001));
    expect(plan.itemIds, ['q1']);
  });

  test('nothing_due 与缺失字段的兜底', () {
    final plan = LearningPlan.fromJson({
      'status': 'nothing_due',
      'next_due_at': '2026-11-03T01:00:00+00:00',
      'summary': {'items_considered': 850},
      'stages': [],
      'item_ids': [],
    });

    expect(plan.nothingDue, isTrue);
    expect(plan.nextDueAt, isNotNull);
    expect(plan.stages, isEmpty);
    expect(plan.itemIds, isEmpty);
    expect(plan.limit, 0);
  });
}
