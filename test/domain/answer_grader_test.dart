// 判分镜像的差分测试。
//
// 本文件的**每一个期望值都来自真实的数据库函数**，不是从文档推的。
// 取法（2026-09，本库）：把下面同一批 content/answer 喂给 public.grade_answer
//   select id, public.grade_answer(qtype, content, answer) from (values …) as cases(…);
// 把输出原样抄成 expected。这能抓到两类读文档绝对发现不了的偏差：
//   · 多选比的是**排序后的数组而非集合** → ['A','A'] 与 ['A'] 不等（用 Set 实现会宽松）
//   · 填空题某一空被归一成空串要判错（不是"空着不算错"）
//
// 若将来数据库的 collation 或判分逻辑变了，本测试会先失败 —— 这正是它存在的意义。
// 改动本文件前请先重跑上面的 SQL，不要凭直觉改期望值。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/domain/answer_grader.dart';

void main() {
  group('normAnswerText', () {
    test('全角数字与字母转半角', () {
      expect(normAnswerText('ＡＢＣ１２３'), 'abc123');
    });

    test('中文标点转半角（14 对逐字符映射）', () {
      expect(normAnswerText('。，！？；：（）《》【】、—'), '.,!?;:()<>[],-');
    });

    test('删除全部空白并小写', () {
      expect(normAnswerText(' A b\tC\n'), 'abc');
    });

    test('删除数据库实测命中的非常见空白码位', () {
      // U+001C–U+001F 与 U+0085 是 PostgreSQL [[:space:]] 匹配、而 Dart \\s 不匹配的
      expect(normAnswerText('abcde'), 'abcde');
      expect(normAnswerText('ab'), 'ab');
      // 全角空格
      expect(normAnswerText('光　合'), '光合');
    });

    test('保留数据库不视为空白的码位', () {
      // U+FEFF：Dart 的 RegExp(r'\s') 会删除它，而本库不会 —— 这正是不能用 \\s 的原因
      expect(normAnswerText('a﻿b'), 'a﻿b');
      // U+200B 零宽空格同样不在集合内
      expect(normAnswerText('a​b'), 'a​b');
    });

    test('null 与空串都归一成空串', () {
      expect(normAnswerText(null), '');
      expect(normAnswerText(''), '');
      expect(normAnswerText('   '), '');
    });
  });

  group('gradeAnswer（期望值取自真实数据库）', () {
    for (final c in _cases) {
      test(c.id, () {
        expect(gradeAnswer(c.qtype, c.content, c.answer), c.expected);
      });
    }
  });
}

typedef _Case = ({
  String id,
  String qtype,
  Map<String, dynamic> content,
  Map<String, dynamic> answer,
  bool? expected,
});

const _cases = <_Case>[
  // ---------- 单选 ----------
  (id: 'sc_ok', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice', 'keys': ['B']}, expected: true),
  (id: 'sc_lower', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice', 'keys': ['b']}, expected: true),
  (id: 'sc_space', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice', 'keys': [' b ']}, expected: true),
  (id: 'sc_wrong', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice', 'keys': ['C']}, expected: false),
  (id: 'sc_empty', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice', 'keys': <String>[]}, expected: false),
  (id: 'sc_nokeys', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'choice'}, expected: false),
  (id: 'sc_wrongtype', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'tf', 'value': true}, expected: false),
  (id: 'sc_unknown', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: {'type': 'unknown'}, expected: false),
  (id: 'sc_noanswer', qtype: 'single_choice',
    content: {'answer': {'type': 'choice', 'keys': ['B']}},
    answer: <String, dynamic>{}, expected: false),
  (id: 'sc_nocontent', qtype: 'single_choice',
    content: {'answer': <String, dynamic>{}},
    answer: {'type': 'choice', 'keys': ['B']}, expected: false),

  // ---------- 多选：顺序无关，但按数组比（重复项不等价）----------
  (id: 'mc_reorder', qtype: 'multiple_choice',
    content: {'answer': {'type': 'choice', 'keys': ['A', 'C']}},
    answer: {'type': 'choice', 'keys': ['C', 'A']}, expected: true),
  (id: 'mc_dup_ok', qtype: 'multiple_choice',
    content: {'answer': {'type': 'choice', 'keys': ['A', 'A']}},
    answer: {'type': 'choice', 'keys': ['A', 'A']}, expected: true),
  // 关键：['A','A'] ≠ ['A']。用 Set 实现会误判为 true
  (id: 'mc_dup_mismatch', qtype: 'multiple_choice',
    content: {'answer': {'type': 'choice', 'keys': ['A']}},
    answer: {'type': 'choice', 'keys': ['A', 'A']}, expected: false),
  (id: 'mc_missing', qtype: 'multiple_choice',
    content: {'answer': {'type': 'choice', 'keys': ['A', 'C']}},
    answer: {'type': 'choice', 'keys': ['A']}, expected: false),
  (id: 'mc_extra', qtype: 'multiple_choice',
    content: {'answer': {'type': 'choice', 'keys': ['A', 'C']}},
    answer: {'type': 'choice', 'keys': ['A', 'C', 'D']}, expected: false),

  // ---------- 判断 ----------
  (id: 'tf_true', qtype: 'true_false',
    content: {'answer': {'type': 'tf', 'value': true}},
    answer: {'type': 'tf', 'value': true}, expected: true),
  (id: 'tf_false', qtype: 'true_false',
    content: {'answer': {'type': 'tf', 'value': false}},
    answer: {'type': 'tf', 'value': false}, expected: true),
  (id: 'tf_mismatch', qtype: 'true_false',
    content: {'answer': {'type': 'tf', 'value': true}},
    answer: {'type': 'tf', 'value': false}, expected: false),
  (id: 'tf_missing', qtype: 'true_false',
    content: {'answer': {'type': 'tf', 'value': true}},
    answer: {'type': 'tf'}, expected: false),
  (id: 'tf_null', qtype: 'true_false',
    content: {'answer': {'type': 'tf', 'value': true}},
    answer: {'type': 'tf', 'value': null}, expected: false),

  // ---------- 填空 ----------
  (id: 'fb_ok', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['光合作用', '叶绿体']}},
    answer: {'type': 'blank', 'values': ['光合作用', '叶绿体']}, expected: true),
  (id: 'fb_fullwidth', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['ABC123']}},
    answer: {'type': 'blank', 'values': ['ＡＢＣ１２３']}, expected: true),
  (id: 'fb_space', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['a b']}},
    answer: {'type': 'blank', 'values': [' a   b ']}, expected: true),
  (id: 'fb_punct', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['x,y.']}},
    answer: {'type': 'blank', 'values': ['x，y。']}, expected: true),
  (id: 'fb_order', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['甲', '乙']}},
    answer: {'type': 'blank', 'values': ['乙', '甲']}, expected: false),
  (id: 'fb_shortlen', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['甲', '乙']}},
    answer: {'type': 'blank', 'values': ['甲']}, expected: false),
  // 归一化后为空串 → 判错（不是"空着不算错"）
  (id: 'fb_blankitem', qtype: 'fill_blank',
    content: {'answer': {'type': 'blank', 'values': ['甲']}},
    answer: {'type': 'blank', 'values': ['   ']}, expected: false),

  // ---------- 主观题：不由本函数判定 ----------
  (id: 'sa_any', qtype: 'short_answer',
    content: {'answer': {'type': 'text', 'samples': ['参考答案']}},
    answer: {'type': 'text'}, expected: null),

  // ---------- 复合题 ----------
  (id: 'co_all_ok', qtype: 'composite',
    content: {'sub': [
      {'type': 'single_choice', 'answer': {'type': 'choice', 'keys': ['A']}},
      {'type': 'true_false', 'answer': {'type': 'tf', 'value': true}},
    ]},
    answer: {'type': 'composite', 'subs': [
      {'type': 'choice', 'keys': ['A']},
      {'type': 'tf', 'value': true},
    ]}, expected: true),
  (id: 'co_one_wrong', qtype: 'composite',
    content: {'sub': [
      {'type': 'single_choice', 'answer': {'type': 'choice', 'keys': ['A']}},
      {'type': 'true_false', 'answer': {'type': 'tf', 'value': true}},
    ]},
    answer: {'type': 'composite', 'subs': [
      {'type': 'choice', 'keys': ['B']},
      {'type': 'tf', 'value': true},
    ]}, expected: false),
  (id: 'co_sub_short_ok', qtype: 'composite',
    content: {'sub': [
      {'type': 'short_answer', 'answer': {'type': 'text', 'samples': ['x']}},
    ]},
    answer: {'type': 'composite', 'subs': [
      {'mastered': true},
    ]}, expected: true),
  (id: 'co_sub_short_no', qtype: 'composite',
    content: {'sub': [
      {'type': 'short_answer', 'answer': {'type': 'text', 'samples': ['x']}},
    ]},
    answer: {'type': 'composite', 'subs': [
      {'mastered': false},
    ]}, expected: false),
  (id: 'co_missing_sub', qtype: 'composite',
    content: {'sub': [
      {'type': 'single_choice', 'answer': {'type': 'choice', 'keys': ['A']}},
    ]},
    answer: {'type': 'composite', 'subs': <Map<String, dynamic>>[]}, expected: false),
  (id: 'co_empty_subs', qtype: 'composite',
    content: {'sub': <Map<String, dynamic>>[]},
    answer: {'type': 'composite', 'subs': <Map<String, dynamic>>[]}, expected: false),
  (id: 'co_notcomposite', qtype: 'composite',
    content: {'sub': [
      {'type': 'single_choice', 'answer': {'type': 'choice', 'keys': ['A']}},
    ]},
    answer: {'type': 'choice', 'keys': ['A']}, expected: false),
];
