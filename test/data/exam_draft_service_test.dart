// 考试作答本机暂存的测试。
//
// 为什么值得测：服务端的考试**只在交卷那一刻**写 exam_answers，中途退出（误触返回、
// 闪退、没电）全靠这份暂存兜底——它就是"90 分钟的作答会不会白写"这件事的全部。
// 三个动作都要对：存得下、读得回、交卷后清得掉（不清的话补考会回填上一场的答案）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/services/exam_draft_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ExamDraftService service;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    service = ExamDraftService();
  });

  test('存进去的作答能原样读回来', () async {
    await service.save('attempt-1', {
      'item-1': {'type': 'choice', 'keys': ['A']},
      'item-2': {'type': 'text', 'text': '学生写的答案'},
    });

    final loaded = await service.load('attempt-1');
    expect(loaded, {
      'item-1': {'type': 'choice', 'keys': ['A']},
      'item-2': {'type': 'text', 'text': '学生写的答案'},
    });
  });

  test('不同场次互不串（同一份卷补考时不会回填上一场的答案）', () async {
    await service.save('attempt-1', {
      'item-1': {'type': 'choice', 'keys': ['A']},
    });

    expect(await service.load('attempt-2'), isEmpty);

    await service.clear('attempt-1');
    expect(await service.load('attempt-1'), isEmpty);
  });

  test('没存过、或存坏了，都返回空表而不是抛异常（不能因为暂存坏了考不了试）', () async {
    expect(await service.load('never-saved'), isEmpty);

    SharedPreferences.setMockInitialValues({'exam.draft:bad': '这不是 JSON'});
    expect(await service.load('bad'), isEmpty);

    SharedPreferences.setMockInitialValues({'exam.draft:weird': '[1,2,3]'});
    expect(await service.load('weird'), isEmpty);
  });

  test('空作答存下来就是空，不会读出一个已作答的题', () async {
    await service.save('attempt-1', {});
    expect(await service.load('attempt-1'), isEmpty);
  });
}
