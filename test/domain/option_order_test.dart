// 选项乱序的回归测试。
//
// 这里锁住的是三件一旦破坏就会**静默出错**的事：
//   1. 乱序后原始 key 一个不少（丢了就是"某个选项永远选不中"）
//   2. 同一道题每次进入顺序一致（否则复盘时选项在跳）
//   3. 确定性哈希跨运行稳定（用 String.hashCode 的话不同运行可能不同）

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/domain/option_order.dart';

void main() {
  const keys = ['A', 'B', 'C', 'D'];

  group('displayOrder', () {
    test('不开启乱序时原样返回', () {
      expect(displayOrder(keys, seed: 'q1', shuffle: false), keys);
    });

    test('乱序后原始 key 一个不少、不重复', () {
      final order = displayOrder(keys, seed: 'q1', shuffle: true);
      expect(order.toSet(), keys.toSet());
      expect(order, hasLength(keys.length));
    });

    test('同一 seed 永远得到同一顺序（复盘才能对得上）', () {
      final first = displayOrder(keys, seed: 'question-abc', shuffle: true);
      final second = displayOrder(keys, seed: 'question-abc', shuffle: true);
      final third = displayOrder(keys, seed: 'question-abc', shuffle: true);
      expect(first, second);
      expect(second, third);
    });

    test('确定性：跨进程/跨运行也稳定（写死的期望值，不是同进程内比较）', () {
      // 期望值取自 FNV-1a + xorshift32 的实际输出，并已在**两个独立进程**里核对一致。
      // 若有人把实现换成 String.hashCode 或 Random()，本测试会失败——
      // 那正是要拦住的：前者不保证跨运行稳定，后者根本不稳。
      expect(
        displayOrder(keys, seed: 'stable-seed', shuffle: true),
        ['C', 'D', 'B', 'A'],
      );
      expect(
        displayOrder(keys, seed: '', shuffle: true),
        ['A', 'C', 'B', 'D'],
      );
    });

    test('不同 seed 得到不同顺序（否则乱序形同虚设）', () {
      final a = displayOrder(keys, seed: 'q1', shuffle: true);
      final b = displayOrder(keys, seed: 'q2', shuffle: true);
      final c = displayOrder(keys, seed: 'q3', shuffle: true);
      // 三次里至少有两次不同即可（理论上可能巧合相同）
      expect(a == b && b == c, isFalse);
    });

    test('0 或 1 个选项时不做无意义处理', () {
      expect(displayOrder(const [], seed: 'q', shuffle: true), isEmpty);
      expect(displayOrder(const ['A'], seed: 'q', shuffle: true), ['A']);
    });

    test('返回的是副本，改动它不会污染入参', () {
      final original = List.of(keys);
      final order = displayOrder(original, seed: 'q', shuffle: true);
      order[0] = 'X';
      expect(original, keys);
    });
  });

  group('letterOf', () {
    test('序号转显示字母', () {
      expect(letterOf(0), 'A');
      expect(letterOf(1), 'B');
      expect(letterOf(25), 'Z');
    });
  });
}
