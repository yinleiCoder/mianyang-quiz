// 考试作答的线格式契约。
//
// 为什么值得测：这份形状同时被**两个仓库**读——服务端的 grade_exam_units（判分）
// 与网页端的阅卷台（读 `answer.samples ?? answer.text` 显示学生写了什么）。
// 改错了不会有任何编译错误，表现是"提交成功、判分也对，但老师看不见学生写的答案"。
//
// 另外钉住一整圈往返：toJson → submittedAnswerFrom 必须还原成同一个作答。
// 成绩单的逐题复盘正是这么回放学生答案的（0056 把它存成 jsonb 再读回来）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';

void main() {
  group('线格式', () {
    test('考试的主观题带 text 键，且与练习的标记区分得开', () {
      expect(const EssayAnswer('光合作用把光能变成化学能').toJson(), {
        'type': 'text',
        'text': '光合作用把光能变成化学能',
      });
      // 练习的标记不带内容——它是"已作答"，不是答案
      expect(const TextAnswer().toJson(), {'type': 'text'});
    });

    test('客观题的形状与练习一致（服务端只认 keys/value/values，不认 type）', () {
      expect(const ChoiceAnswer(['A', 'C']).toJson(), {
        'type': 'choice',
        'keys': ['A', 'C'],
      });
      expect(const TrueFalseAnswer(true).toJson(), {'type': 'tf', 'value': true});
      expect(const BlankAnswer(['水', '氧气']).toJson(), {
        'type': 'blank',
        'values': ['水', '氧气'],
      });
    });

    test('多选题比的是排序后的数组：重复的 key 原样留着，不在这里去重', () {
      // 去重会让客户端比服务端宽松，表现是"本地看着对、服务端判错"（见 answer_grader）
      expect(const ChoiceAnswer(['A', 'A']).toJson()['keys'], ['A', 'A']);
    });
  });

  group('往返还原（成绩单回放学生答案用）', () {
    test('每种作答都能原样回来', () {
      const answers = <SubmittedAnswer>[
        ChoiceAnswer(['B']),
        TrueFalseAnswer(false),
        BlankAnswer(['甲', '乙']),
        EssayAnswer('我写了这些'),
        UnknownAnswer(),
      ];
      for (final answer in answers) {
        final restored = submittedAnswerFrom(answer.toJson());
        expect(restored, isNotNull, reason: '${answer.runtimeType} 还原失败');
        expect(restored!.toJson(), answer.toJson());
      }
    });

    test('复合题逐子题还原，主观子题保留原文', () {
      const composite = CompositeAnswer([
        ChoiceAnswer(['A']),
        EssayAnswer('子题二我写的答案'),
      ]);
      final restored = submittedAnswerFrom(composite.toJson());
      expect(restored, isA<CompositeAnswer>());
      expect(restored!.toJson(), composite.toJson());

      final subs = (restored as CompositeAnswer).subs;
      expect(subs[1], isA<EssayAnswer>());
      expect((subs[1] as EssayAnswer).text, '子题二我写的答案');
    });

    test('练习存下来的 {"type":"text"}（没有 text 键）还原成标记，不是空的论述题', () {
      final restored = submittedAnswerFrom(const {'type': 'text'});
      expect(restored, isA<TextAnswer>());
    });

    test('认不出的形状返回 null，不抛异常（历史数据不该让复盘页崩掉）', () {
      expect(submittedAnswerFrom(const {'type': '未来题型'}), isNull);
      expect(submittedAnswerFrom(null), isNull);
    });
  });
}
