// 组卷草稿的题量边界。
//
// 为什么值得测：上下限是**服务端契约的镜像**（start_practice_session 里 1~100，见 0043），
// 客户端这道 clamp 是"用户拖到底也不会被服务端顶回来"的保证。两边一旦漂移，
// 表现是用户选了 100 却收到「题量需在 1~100 之间」——只在真机上点得出来。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';

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
}
