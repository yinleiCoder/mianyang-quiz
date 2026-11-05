// 「为什么推这道题」的实体与文案测试。
import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';

void main() {
  test('fromJson 解析 reason/mastery/due/node', () {
    final reason = PracticeReason.fromJson({
      'question_id': 'q1',
      'reason_code': 'due_review',
      'p_mastery': 0.42,
      'due_at': '2026-11-04T08:00:00+08:00',
      'node_name': 'Excel',
    });
    expect(reason.questionId, 'q1');
    expect(reason.reasonCode, 'due_review');
    expect(reason.mastery, closeTo(0.42, 1e-9));
    expect(reason.dueAt, isNotNull);
    expect(reason.nodeName, 'Excel');
  });

  test('缺失字段不崩，详情给兜底', () {
    final reason = PracticeReason.fromJson({
      'question_id': 'q2',
      'reason_code': 'new_item',
    });
    expect(reason.mastery, isNull);
    expect(reason.dueAt, isNull);
    expect(practiceReasonDetail(reason), contains('BKT'));
  });

  test('四个人群标签与兜底', () {
    expect(practiceReasonLabel('new_item'), contains('新题'));
    expect(practiceReasonLabel('due_review'), contains('复习'));
    expect(practiceReasonLabel('weak_node'), contains('薄弱'));
    expect(practiceReasonLabel('mastered'), contains('巩固'));
    expect(practiceReasonLabel('unknown'), contains('练习计划'));
  });

  test('详情带知识点/掌握度/日期', () {
    final reason = PracticeReason(
      questionId: 'q3',
      reasonCode: 'weak_node',
      mastery: 0.5,
      dueAt: DateTime(2026, 11, 4),
      nodeName: 'Excel',
    );
    final detail = practiceReasonDetail(reason);
    expect(detail, contains('Excel'));
    expect(detail, contains('50%'));
    expect(detail, contains('11-4'));
  });
}
