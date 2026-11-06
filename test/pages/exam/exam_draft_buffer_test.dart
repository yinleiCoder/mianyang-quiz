// 考试作答的两份草稿怎么合并、怎么上传（0144）。
//
// 钉住三件事：
//   · 服务端草稿是**主通道**（换台设备靠它），本机暂存只在更新时覆盖；
//   · 上传只带改过的那几道题——整卷覆盖会让两台设备互相盖掉对方的答案；
//   · 清空作答发的是空 Map（服务端据此删掉该题），不是整卷重写。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/exam/state/exam_draft_buffer.dart';

void main() {
  test('本机比服务端旧：以服务端为准，本机只补服务端没有的题', () {
    final buffer = ExamDraftBuffer(attemptId: 'a1');

    buffer.restore(
      fromServer: const [],
      serverDrafts: const {
        'i1': {'type': 'choice', 'keys': ['B']},
      },
      fromDisk: const {
        'i1': {'type': 'choice', 'keys': ['A']}, // 旧缓存，应被覆盖
        'i2': {'type': 'choice', 'keys': ['C']}, // 服务端没有，保留
      },
      localWins: false,
    );

    expect(buffer.of('i1')!.toJson()['keys'], ['B']);
    expect(buffer.of('i2')!.toJson()['keys'], ['C']);
  });

  test('本机比服务端新：本机覆盖服务端', () {
    final buffer = ExamDraftBuffer(attemptId: 'a1');

    buffer.restore(
      fromServer: const [],
      serverDrafts: const {
        'i1': {'type': 'choice', 'keys': ['A']},
      },
      fromDisk: const {
        'i1': {'type': 'choice', 'keys': ['C']},
      },
      localWins: true,
    );

    expect(buffer.of('i1')!.toJson()['keys'], ['C']);
  });

  test('flush 只推改过的题；清空的题推空 Map', () async {
    final pushed = <Map<String, Map<String, dynamic>>>[];
    final buffer = ExamDraftBuffer(
      attemptId: 'a1',
      remote: (answers) async => pushed.add(answers),
    );

    buffer.put('i1', const ChoiceAnswer(['A']));
    buffer.put('i2', const ChoiceAnswer(['B']));
    buffer.put('i2', null); // 学生把答案清空了

    buffer.flush();
    await Future<void>.delayed(Duration.zero);

    expect(pushed, hasLength(1));
    expect(pushed.single.keys, containsAll(['i1', 'i2']));
    expect(pushed.single['i1'], {'type': 'choice', 'keys': ['A']});
    expect(pushed.single['i2'], isEmpty, reason: '空 Map = 服务端删掉这道题');

    buffer.cancelPendingSave();
  });

  test('交卷后取消待发：不把已经提交的作答再写回草稿', () async {
    final pushed = <Map<String, Map<String, dynamic>>>[];
    final buffer = ExamDraftBuffer(
      attemptId: 'a1',
      remote: (answers) async => pushed.add(answers),
    );

    buffer.put('i1', const ChoiceAnswer(['A']));
    buffer.cancelPendingSave();
    buffer.flush();
    await Future<void>.delayed(Duration.zero);

    expect(pushed, isEmpty);
  });
}
