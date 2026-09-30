// 艾宾浩斯理论曲线：数值契约。
//
// 为什么值得测：这条线是**参照物**。它的值一旦漂了，图上"你掉得比理论快还是慢"
// 这个结论就跟着错，而错得很隐蔽——曲线还是那条形状熟悉的下降线，
// 没人会盯着 1 天那个点是不是 33%。
//
// 锚点取自被引用最广的那组实测数（无意义音节）：1 天 33%、2 天 28%、6 天 25%、
// 31 天 21%。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/forgetting_curve.dart';

void main() {
  group('ebbinghausRetention 的锚点', () {
    test('0 天是 1.0（刚学完）', () {
      expect(ebbinghausRetention(0), closeTo(1.0, 1e-9));
    });

    test('1 天 33%、2 天 28%、6 天 25%、31 天 21%', () {
      expect(ebbinghausRetention(1), closeTo(0.33, 1e-9));
      expect(ebbinghausRetention(2), closeTo(0.28, 1e-9));
      expect(ebbinghausRetention(6), closeTo(0.25, 1e-9));
      expect(ebbinghausRetention(31), closeTo(0.21, 1e-9));
    });

    test('20 分钟 58%、1 小时 44%、9 小时 36%', () {
      expect(ebbinghausRetention(20 / 1440), closeTo(0.58, 1e-9));
      expect(ebbinghausRetention(1 / 24), closeTo(0.44, 1e-9));
      expect(ebbinghausRetention(9 / 24), closeTo(0.36, 1e-9));
    });
  });

  group('ebbinghausRetention 的边界', () {
    test('31 天之后走平在 21%，不会掉到 0 或变成负数', () {
      for (final days in [31.0, 60.0, 365.0, 10000.0]) {
        expect(ebbinghausRetention(days), closeTo(0.21, 1e-9));
      }
    });

    test('负数按 0 处理，不抛也不返回怪值', () {
      expect(ebbinghausRetention(-5), closeTo(1.0, 1e-9));
    });

    test('曲线单调不升（遗忘只会往一个方向走）', () {
      var prev = ebbinghausRetention(0);
      for (var i = 1; i <= 400; i++) {
        final current = ebbinghausRetention(i / 10);
        expect(
          current,
          lessThanOrEqualTo(prev + 1e-12),
          reason: '${i / 10} 天处比前一个采样点高了：$prev → $current',
        );
        prev = current;
      }
    });

    test('全程落在 0~1 之间', () {
      for (var i = 0; i <= 1000; i++) {
        final v = ebbinghausRetention(i / 10);
        expect(v, inInclusiveRange(0, 1), reason: '${i / 10} 天处是 $v');
      }
    });
  });

  group('ebbinghausSamples', () {
    test('给 count+1 个点，覆盖 0 到 maxDays', () {
      final samples = ebbinghausSamples(maxDays: 30, count: 60);
      expect(samples.length, 61);
      expect(samples.first.$1, 0);
      expect(samples.last.$1, closeTo(30, 1e-9));
    });

    test('每个点的 y 都等于该天数的理论值', () {
      for (final (day, retention) in ebbinghausSamples(maxDays: 30, count: 12)) {
        expect(retention, closeTo(ebbinghausRetention(day), 1e-12));
      }
    });
  });
}
