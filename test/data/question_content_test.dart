// 内容模型的解析与**往返**测试。
//
// 重点不是"能解析"，而是"toJson() 出来的形状能直接喂给判分函数"——
// 这是模型层与 domain 层之间的隐式契约，断了不会有编译错误，
// 只会表现为"提交后永远判错"。所以这里显式跑一次端到端判分。

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/domain/answer_grader.dart';

void main() {
  group('解析', () {
    test('单选题：题干/选项/答案/解析', () {
      final content = QuestionContent.fromJson(_singleChoiceJson);

      expect(content.formatVersion, 1);
      expect(content.stemText, '下列哪个是哺乳动物？');
      expect(content.options, hasLength(3));
      expect(content.options.first.key, 'A');
      expect(content.options.first.plainText, '鲸鱼');
      expect(content.answer, isA<ChoiceServerAnswer>());
      expect((content.answer! as ChoiceServerAnswer).keys, ['A']);
      expect(content.analysis.plainText, '鲸鱼是哺乳动物。');
    });

    test('媒体块与文本块混合时，纯文本只取文本块', () {
      final content = QuestionContent.fromJson({
        'format_version': 1,
        'stem': [
          {'t': 'text', 'text': '看图作答：'},
          {'t': 'media', 'kind': 'image', 'key': 'qbank/2026/09/abc.png', 'alt': '示意图'},
          {'t': 'text', 'text': '图中是什么？'},
        ],
      });

      expect(content.stem, hasLength(3));
      expect(content.stem.whereType<TextBlock>(), hasLength(2));
      expect(content.stemText, '看图作答：图中是什么？');
      expect(content.stem.whereType<MediaBlock>().single.key, 'qbank/2026/09/abc.png');
    });

    test('填空题空位数按题干数，不按标准答案数', () {
      final content = QuestionContent.fromJson({
        'format_version': 1,
        'stem': [
          {'t': 'text', 'text': '水的化学式是___，沸点是___摄氏度。__两个下划线不算空位。'},
        ],
        'answer': {'type': 'blank', 'values': ['H2O', '100']},
      });

      // ___ 与 ___ 是空位；__ 只有两个下划线，不是
      expect(content.blankCount, 2);
    });

    test('缺失的可选字段回落为空数组而不是崩溃', () {
      final content = QuestionContent.fromJson({
        'format_version': 1,
        'stem': [
          {'t': 'text', 'text': '题干'},
        ],
      });

      expect(content.options, isEmpty);
      expect(content.sub, isEmpty);
      expect(content.analysis, isEmpty);
      expect(content.answer, isNull);
    });

    test('复合题：子题带 type，根节点没有 answer', () {
      final content = QuestionContent.fromJson(_compositeJson);

      expect(content.answer, isNull);
      expect(content.sub, hasLength(2));
      expect(content.sub[0].type, 'single_choice');
      expect(content.sub[1].type, 'short_answer');
      expect(content.isComposite, isTrue);
    });
  });

  group('往返后仍可判分（模型层 ↔ 判分契约）', () {
    test('单选题：toJson() 直接喂给 gradeAnswer', () {
      final content = QuestionContent.fromJson(_singleChoiceJson);
      // 走一遍 toJson 再判分——模拟真实链路（模型 → JSON → 判分）
      final wire = jsonDecode(jsonEncode(content.toJson())) as Map<String, dynamic>;

      expect(gradeAnswer('single_choice', wire, {'type': 'choice', 'keys': ['A']}), isTrue);
      expect(gradeAnswer('single_choice', wire, {'type': 'choice', 'keys': ['B']}), isFalse);
    });

    test('复合题：子题自带 type 与 answer，逐子题判分', () {
      final content = QuestionContent.fromJson(_compositeJson);
      final wire = jsonDecode(jsonEncode(content.toJson())) as Map<String, dynamic>;

      final allCorrect = {
        'type': 'composite',
        'subs': [
          {'type': 'choice', 'keys': ['B']},
          {'mastered': true},
        ],
      };
      expect(gradeAnswer('composite', wire, allCorrect), isTrue);

      final secondSubFailed = {
        'type': 'composite',
        'subs': [
          {'type': 'choice', 'keys': ['B']},
          {'mastered': false},
        ],
      };
      expect(gradeAnswer('composite', wire, secondSubFailed), isFalse);
    });

    test('toJson() 的键名与数据库线格式一致（format_version 带下划线）', () {
      final content = QuestionContent.fromJson(_singleChoiceJson);
      final wire = content.toJson();

      expect(wire.containsKey('format_version'), isTrue,
          reason: '写成 formatVersion 的话，把 content 回传服务端时会被当成未知字段');
      expect(wire.containsKey('formatVersion'), isFalse);
      // 块与答案的判别键也必须是 t / type
      final stem = wire['stem']! as List;
      expect((stem.first as Map).containsKey('t'), isTrue);
      expect((wire['answer']! as Map)['type'], 'choice');
    });
  });
}

const _singleChoiceJson = <String, dynamic>{
  'format_version': 1,
  'stem': [
    {'t': 'text', 'text': '下列哪个是哺乳动物？'},
  ],
  'options': [
    {
      'key': 'A',
      'label': [
        {'t': 'text', 'text': '鲸鱼'},
      ],
    },
    {
      'key': 'B',
      'label': [
        {'t': 'text', 'text': '鲨鱼'},
      ],
    },
    {
      'key': 'C',
      'label': [
        {'t': 'text', 'text': '鳄鱼'},
      ],
    },
  ],
  'answer': {'type': 'choice', 'keys': ['A']},
  'analysis': [
    {'t': 'text', 'text': '鲸鱼是哺乳动物。'},
  ],
};

const _compositeJson = <String, dynamic>{
  'format_version': 1,
  'stem': [
    {'t': 'text', 'text': '阅读下列材料后作答。'},
  ],
  'sub': [
    {
      'type': 'single_choice',
      'format_version': 1,
      'stem': [
        {'t': 'text', 'text': '材料中提到的温度是多少？'},
      ],
      'options': [
        {
          'key': 'A',
          'label': [
            {'t': 'text', 'text': '50℃'},
          ],
        },
        {
          'key': 'B',
          'label': [
            {'t': 'text', 'text': '100℃'},
          ],
        },
      ],
      'answer': {'type': 'choice', 'keys': ['B']},
    },
    {
      'type': 'short_answer',
      'format_version': 1,
      'stem': [
        {'t': 'text', 'text': '简述你的理由。'},
      ],
      'answer': {
        'type': 'text',
        'samples': ['因为标准大气压下水的沸点是 100℃。'],
      },
    },
  ],
};
