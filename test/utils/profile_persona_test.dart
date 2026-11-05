// 学习画像 persona/summary 的 Dart 镜像测试。
// 与网页端 scripts/test-profile-persona.mjs 互为清单：改规则时两边一起改。
import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/profile_persona.dart';

const _labels = <String, String>{
  'mastery': '掌握力',
  'accuracy': '准确率',
  'effort': '勤奋度',
  'growth': '进步力',
  'breadth': '知识面',
  'stability': '稳定性',
};

LearningProfileAxis _axis(String key, double? score) {
  return LearningProfileAxis(
    key: key,
    label: _labels[key] ?? key,
    score: score,
    raw: const {},
    sample: score == null ? 0 : 20,
    sufficient: score != null,
    hint: 'hint',
  );
}

List<LearningProfileAxis> _axes(Map<String, double?> scores) {
  return _labels.keys.map((key) => _axis(key, scores[key])).toList();
}

void main() {
  test('稳健型：掌握/准确/稳定都在高位', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 78,
      'accuracy': 81,
      'effort': 60,
      'growth': 50,
      'breadth': 50,
      'stability': 74,
    }));
    expect(persona.key, 'steady');
    expect(persona.reason, contains('78'));
  });

  test('冲刺型：进步与勤奋同时高', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 50,
      'accuracy': 60,
      'effort': 80,
      'growth': 65,
      'breadth': 50,
      'stability': 50,
    }));
    expect(persona.key, 'sprinter');
  });

  test('探索型：知识面宽但准确率低', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 50,
      'accuracy': 60,
      'effort': 50,
      'growth': 50,
      'breadth': 80,
      'stability': 50,
    }));
    expect(persona.key, 'explorer');
  });

  test('勤奋型：勤奋高但准确率低', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 50,
      'accuracy': 60,
      'effort': 80,
      'growth': 50,
      'breadth': 50,
      'stability': 50,
    }));
    expect(persona.key, 'diligent');
  });

  test('均衡型：最高与最低差 ≤15', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 60,
      'accuracy': 62,
      'effort': 58,
      'growth': 61,
      'breadth': 59,
      'stability': 60,
    }));
    expect(persona.key, 'balanced');
  });

  test('成长型：六轴齐全但没有强标签', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 90,
      'accuracy': 50,
      'effort': 50,
      'growth': 40,
      'breadth': 40,
      'stability': 40,
    }));
    expect(persona.key, 'growing');
  });

  test('新同学：不足 5 轴有数据', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 80,
      'accuracy': 80,
      'effort': 80,
      'growth': 80,
      'breadth': null,
      'stability': null,
    }));
    expect(persona.key, 'newcomer');
    expect(persona.reason, contains('还差 1 个维度'));
  });

  test('准确率缺失时不会误判成探索型/勤奋型', () {
    final persona = buildProfilePersona(_axes({
      'mastery': 50,
      'accuracy': null,
      'effort': 60,
      'growth': 50,
      'breadth': 80,
      'stability': 50,
    }));
    expect(persona.key, isNot('explorer'));
    expect(persona.key, isNot('diligent'));
  });

  test('summary 带强项与最该补的轴', () {
    final summary = buildProfileSummary(_axes({
      'mastery': 90,
      'accuracy': 60,
      'effort': 30,
      'growth': 50,
      'breadth': 50,
      'stability': 50,
    }));
    expect(summary, contains('掌握力 90'));
    expect(summary, contains('勤奋度 30'));
  });

  test('summary 空数据给引导而不是空话', () {
    expect(buildProfileSummary(const []), contains('再练几题'));
  });
}
