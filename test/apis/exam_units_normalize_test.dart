// 答卷 units 形状的回归。
//
// 2026-11-05 的真实事故：交卷全部 200，学生却只看到「操作失败，请稍后重试」。
// 原因是人工判分题（简答）的 units 存成了裸布尔 [false,false]，而 ExamAnswerRecord
// 的生成代码里是 `e as Map<String, dynamic>` —— TypeError 让**整份答卷**解析失败。
// 服务端已统一成 [{ok, score}]（0139），这里守住客户端这一侧：
// 旧形状进来也要能解析出成绩单，而不是整页报错。

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';

Map<String, dynamic> snapshotJson(Object units) => {
  'attempt': {
    'id': 'attempt-1',
    'paper_id': 'paper-1',
    'paper_version_id': 'version-1',
    'status': 'submitted',
  },
  'paper': {'version_id': 'version-1', 'paper_id': 'paper-1'},
  'answers': [
    {
      'paper_item_id': 'item-1',
      'seq': 1,
      'answer': {'type': 'text', 'text': '学生的作答'},
      'units': units,
      'grading': 'pending',
    },
  ],
};

void main() {
  test('布尔形状的 units 解析不出来（事故现场）', () {
    // 抛的是 json_annotation 的 CheckedFromJsonException（TypeError 被它包了一层）。
    // mapError 不认这个类型 → UnknownException → 学生看到「操作失败，请稍后重试」。
    expect(
      () => ExamSnapshot.fromJson(snapshotJson([false, false])),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });

  test('归一化之后旧数据也能解析，且不改变"没给分"的含义', () {
    final snapshot = ExamSnapshot.fromJson(
      normalizeExamAnswerUnits(snapshotJson([false, false])),
    );

    final record = snapshot.answers.single;
    expect(record.grading, 'pending');
    expect(record.units, hasLength(2));
    expect(record.units.every((unit) => !unit.ok), isTrue);
    expect(record.units.every((unit) => unit.score == 0), isTrue);
    expect(record.isAnswered, isTrue);
  });

  test('已经是对象形状的 units 原样保留（不能把已阅卷的分抹成 0）', () {
    final json = snapshotJson([
      {'ok': true, 'score': 3},
      {'ok': false, 'score': 0},
    ]);

    final snapshot = ExamSnapshot.fromJson(normalizeExamAnswerUnits(json));

    expect(snapshot.answers.single.units.map((unit) => unit.score), [3, 0]);
  });

  test('没有 answers 也照常放行', () {
    final json = {
      'attempt': {
        'id': 'attempt-1',
        'paper_id': 'paper-1',
        'paper_version_id': 'version-1',
      },
      'paper': {'version_id': 'version-1', 'paper_id': 'paper-1'},
    };

    expect(ExamSnapshot.fromJson(normalizeExamAnswerUnits(json)).answers, isEmpty);
  });
}
