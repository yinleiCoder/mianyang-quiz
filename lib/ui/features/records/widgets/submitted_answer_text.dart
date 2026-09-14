// 作答记录 → 一句可读的中文（复盘页「你的作答」用）。
//
// 职责：按 SubmittedAnswer.toJson() 的 `type` 键把记录里的 Map 拼成文字。
// 不负责：判定对错（记录里有 is_correct）、也不做反序列化**重建**成 SubmittedAnswer——
// 主观题存的是 {'type':'text'} 不带内容、复合题的主观子题是 {'mastered':bool} 没有 type 键，
// 重建要么丢信息、要么把「已答」显示成「未作答」。
//
// 放在 feature 内而不是 domain：它只服务复盘的展示，且直接依赖 data 层的记录模型；
// 真要给第二个页面用时再上提（到时按 ui/core 的规矩做，别直接 import 本文件）。

import 'package:mianyang_quiz/data/models/practice/practice_session.dart';

/// [record] 为 null 表示当时没作答。复合题逐子题列出，顺序与题面一致。
String submittedAnswerText(PracticeAnswerRecord? record) {
  if (record == null) return '未作答';
  // 主观题的对错由自评决定，记录里的 answer 只有一个 type，说不出内容。
  if (record.grading == 'self') {
    return record.selfMastered == true ? '自评：已掌握' : '自评：未掌握';
  }
  return _answerText(record.answer);
}

String _answerText(Map<String, dynamic> answer) {
  switch (answer['type']) {
    case 'choice':
      final keys = _asStrings(answer['keys']);
      return keys.isEmpty ? '未作答' : keys.join('、');
    case 'tf':
      final value = answer['value'];
      if (value is! bool) return '未作答';
      return value ? '正确' : '错误';
    case 'blank':
      final values = _asStrings(answer['values']);
      if (values.isEmpty) return '未作答';
      if (values.length == 1) return values.first;
      // 多个空时标上空位序号，否则一串答案看不出谁对应哪个空。
      return [
        for (var i = 0; i < values.length; i++) '第 ${i + 1} 空 ${values[i]}',
      ].join('；');
    case 'unknown':
      return '标记为「不会」';
    case 'composite':
      final subs = answer['subs'];
      if (subs is! List || subs.isEmpty) return '未作答';
      final parts = <String>[];
      for (var i = 0; i < subs.length; i++) {
        final sub = subs[i];
        final text = sub is Map
            ? _answerText(Map<String, dynamic>.from(sub))
            : '未作答';
        parts.add('第 ${i + 1} 题 $text');
      }
      return parts.join('\n');
    case 'text':
      return '已作答（主观题）';
    default:
      // 复合题的主观子题没有 type 键，只有 {'mastered': bool}。
      final mastered = answer['mastered'];
      if (mastered is bool) return mastered ? '自评：已掌握' : '自评：未掌握';
      return '已作答';
  }
}

List<String> _asStrings(dynamic value) =>
    value is List ? [for (final item in value) '$item'] : const [];
