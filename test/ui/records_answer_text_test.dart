// 复盘页「你的作答」的解码测试。
//
// 为什么这几条必须有测试：practice_answers.answer 是**写侧契约的原样回读**
// （形状由 0029 的 grade_answer 定义），解错的错法全是静默的——
// 把「已答」显示成「未作答」、把复合题显示成空白，页面照常渲染，没人会收到报错。
//
// 期望值取自真实库里的形状：choice / tf / blank / text / unknown / composite，
// 以及复合题主观子题那种 {"mastered": bool} 没有 type 键的写法。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/submitted_answer_text.dart';

void main() {
  group('submittedAnswerText', () {
    test('没有作答记录时是「未作答」', () {
      expect(submittedAnswerText(null), '未作答');
    });

    test('选择题按原始 key 列出，空 key 数组算未作答', () {
      expect(
        _auto({
          'type': 'choice',
          'keys': ['A', 'C'],
        }),
        'A、C',
      );
      expect(_auto({'type': 'choice', 'keys': <String>[]}), '未作答');
    });

    test('判断题、不会、主观题各有一句话', () {
      expect(_auto({'type': 'tf', 'value': true}), '正确');
      expect(_auto({'type': 'tf', 'value': false}), '错误');
      expect(_auto({'type': 'unknown'}), '标记为「不会」');
      expect(_auto({'type': 'text'}), '已作答（主观题）');
    });

    test('填空题多个空时标上空位序号', () {
      expect(
        _auto({
          'type': 'blank',
          'values': ['光合作用'],
        }),
        '光合作用',
      );
      expect(
        _auto({
          'type': 'blank',
          'values': ['甲', '乙'],
        }),
        '第 1 空 甲；第 2 空 乙',
      );
      expect(_auto({'type': 'blank', 'values': <String>[]}), '未作答');
    });

    test('主观题看自评，不看 answer（它只有一个 type）', () {
      expect(_self(true), '自评：已掌握');
      expect(_self(false), '自评：未掌握');
    });

    test('复合题逐子题列出，主观子题没有 type 键', () {
      expect(
        _auto({
          'type': 'composite',
          'subs': [
            {
              'type': 'choice',
              'keys': ['B'],
            },
            {'mastered': true},
          ],
        }),
        '第 1 题 B\n第 2 题 自评：已掌握',
      );
      expect(_auto({'type': 'composite', 'subs': <dynamic>[]}), '未作答');
    });

    test('认不出的形状退回「已作答」，而不是谎报未作答', () {
      expect(_auto(<String, dynamic>{}), '已作答');
    });
  });
}

String _auto(Map<String, dynamic> answer) =>
    submittedAnswerText(PracticeAnswerRecord(questionId: 'q1', answer: answer));

String _self(bool mastered) => submittedAnswerText(
  PracticeAnswerRecord(
    questionId: 'q1',
    answer: const {'type': 'text'},
    grading: 'self',
    selfMastered: mastered,
  ),
);
