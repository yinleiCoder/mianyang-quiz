// 组卷草稿的题量边界。
//
// 为什么值得测：上下限是**服务端契约的镜像**（start_practice_session 里 1~100，见 0043），
// 客户端这道 clamp 是"用户拖到底也不会被服务端顶回来"的保证。两边一旦漂移，
// 表现是用户选了 100 却收到「题量需在 1~100 之间」——只在真机上点得出来。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';

void main() {
  test('题量上限是 100', () {
    expect(PracticeDraftStore.maxLimit, 100);
    expect(PracticeDraftStore.minLimit, 1);
  });

  test('越界被夹住，不抛错也不静默截断成 0', () {
    final store = PracticeDraftStore();

    store.setLimit(150);
    expect(store.limit, 100);

    store.setLimit(0);
    expect(store.limit, 1);

    store.setLimit(-7);
    expect(store.limit, 1);
  });

  test('默认题量仍是 20', () {
    expect(PracticeDraftStore().limit, PracticeDraftStore.defaultLimit);
    expect(PracticeDraftStore.defaultLimit, 20);
  });

  group('顺序讲练的轮次（0095）', () {
    test('轮次区间与"还有没有下一轮"按 offset/limit/total 算', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 200, totalAvailable: 380);

      expect(store.round, 3, reason: 'offset 200、每轮 100 → 第 3 轮');
      expect(store.roundFrom, 201);
      expect(store.roundTo, 300);
      expect(store.hasPrevRound, isTrue);
      expect(store.hasNextRound, isTrue, reason: '还有 301–380');
    });

    test('最后一轮：区间被总数截住，且不再有下一轮', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 300, totalAvailable: 380);

      expect(store.round, 4);
      expect(store.roundTo, 380, reason: '只有 80 道，不能显示到 400');
      expect(store.hasNextRound, isFalse);
    });

    test('总数未知时不给「下一轮」', () {
      final store = PracticeDraftStore()..setLimit(100);

      // 还没开过一次，服务端没告诉过我们符合条件的题有多少
      expect(store.totalAvailable, isNull);
      expect(store.hasNextRound, isFalse, reason: '宁可少了这个入口，也不要点下去才被拒');
    });

    test('第 1 轮没有上一轮', () {
      final store = PracticeDraftStore()
        ..setLimit(50)
        ..setRoundInfo(offset: 0, totalAvailable: 120);

      expect(store.round, 1);
      expect(store.hasPrevRound, isFalse);
      expect(store.hasNextRound, isTrue);
    });

    test('上一轮退到第 1 轮为止，下一轮到头就不再动', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 0, totalAvailable: 380);

      store.prevRound();
      expect(store.offset, 0, reason: '已经在第 1 轮，再往前不该变成负数');

      store.nextRound();
      store.nextRound();
      store.nextRound();
      expect(store.offset, 300, reason: '380 道题、每轮 100 → 最多到 offset 300');

      store.nextRound();
      expect(store.offset, 300, reason: '最后一轮再点"下一轮"不该越界');
    });

    test('改筛选条件/来源/轮大小都会把轮次清回去', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 200, totalAvailable: 380);

      store.setLimit(50);
      expect(store.offset, 0, reason: '轮大小变了，原来的 offset 已经没有意义');
      expect(store.totalAvailable, isNull, reason: '旧的题目总数同样过期了');

      store.setRoundInfo(offset: 100, totalAvailable: 380);
      store.setSource(PracticeSource.wrong);
      expect(store.offset, 0);

      store.setRoundInfo(offset: 100, totalAvailable: 380);
      store.updateFilter(const QuestionFilter(keyword: 'excel'));
      expect(store.offset, 0);

      store.setRoundInfo(offset: 100, totalAvailable: 380);
      store.setMode(PracticeMode.sequential);
      expect(store.offset, 0);
    });

    test('从入口进来（startFrom）回到第 1 轮', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 200, totalAvailable: 380);

      store.startFrom(source: PracticeSource.all);
      expect(store.offset, 0, reason: '从错题本进来不该落在"第 3 轮"');
    });

    test('非顺序模式返回的默认值会把轮次清干净', () {
      final store = PracticeDraftStore()
        ..setLimit(100)
        ..setRoundInfo(offset: 200, totalAvailable: 380);

      // 即时/批量练习的响应里没有 offset / total_available，模型给的是 0 / null
      store.setRoundInfo(offset: 0, totalAvailable: null);
      expect(store.offset, 0);
      expect(store.totalAvailable, isNull);
      expect(store.hasNextRound, isFalse);
    });
  });

  group('批量选题讲练（0095）', () {
    test('勾选之后：来源回到题库、筛选被清掉、题量等于勾选数', () {
      final store = PracticeDraftStore()
        ..setSource(PracticeSource.wrong)
        ..setLimit(20);
      store.startFrom(
        source: PracticeSource.all,
        filter: const QuestionFilter(keyword: 'excel', difficulty: 2),
      );

      store.setPickedQuestions(['q1', 'q2', 'q3']);

      expect(store.questionIds, ['q1', 'q2', 'q3']);
      expect(store.hasPickedQuestions, isTrue);
      expect(store.source, PracticeSource.all, reason: '勾选只对 all 分支生效');
      expect(
        store.filter.hasAny,
        isFalse,
        reason: '服务端把 p_question_ids 与筛选条件 AND 起来，留着旧条件会把勾选的题再筛一遍',
      );
      expect(store.limit, 3, reason: '题量就是勾选数，不必让用户再设一次');
      expect(store.offset, 0);
    });

    test('勾选数超过服务端上限时被夹到 100', () {
      final store = PracticeDraftStore();
      store.setPickedQuestions([for (var i = 0; i < 150; i++) 'q$i']);

      expect(store.limit, 100);
      expect(store.questionIds!.length, 150, reason: '勾选本身留着——界面上挡超限，不在这里截');
    });

    test('改筛选条件 / 换来源 / 从入口进来，都会把勾选清掉', () {
      final store = PracticeDraftStore()..setPickedQuestions(['q1']);

      store.updateFilter(const QuestionFilter(keyword: 'word'));
      expect(store.hasPickedQuestions, isFalse);

      store.setPickedQuestions(['q1']);
      store.setSource(PracticeSource.wrong);
      expect(store.hasPickedQuestions, isFalse);

      store.setPickedQuestions(['q1']);
      store.startFrom(source: PracticeSource.all);
      expect(store.hasPickedQuestions, isFalse);
    });

    test('空勾选等于没勾选，不会被当成"练 0 道"', () {
      final store = PracticeDraftStore()..setPickedQuestions(const []);
      expect(store.questionIds, isNull);
      expect(store.hasPickedQuestions, isFalse);
    });
  });
}
