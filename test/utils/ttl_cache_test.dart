// 保鲜期缓存的回归（2026-11-06）。
//
// 用在"全站同一份、变化极慢"的数据上（平台规模）。三条边界值得钉住：
// 没写过读不到、保鲜期内命中、过期后失效；以及 clear 之后不能复活。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';

void main() {
  late DateTime now;

  setUp(() => now = DateTime(2026, 11, 6, 9));

  TtlCache<int> cacheOf(Duration maxAge) =>
      TtlCache<int>(maxAge, now: () => now);

  test('没写过时读不到', () {
    expect(cacheOf(const Duration(minutes: 5)).read(), isNull);
  });

  test('保鲜期内命中，过期后失效', () {
    final cache = cacheOf(const Duration(minutes: 5));
    cache.write(42);

    now = now.add(const Duration(minutes: 4, seconds: 59));
    expect(cache.read(), 42);

    now = now.add(const Duration(seconds: 2)); // 累计 5 分 01 秒
    expect(cache.read(), isNull);
  });

  test('重新写入会重新计时', () {
    final cache = cacheOf(const Duration(minutes: 5));
    cache.write(1);
    now = now.add(const Duration(minutes: 4));
    cache.write(2);

    now = now.add(const Duration(minutes: 4)); // 距第二次写入 4 分钟
    expect(cache.read(), 2);
  });

  test('clear 之后不会复活旧值', () {
    final cache = cacheOf(const Duration(minutes: 5));
    cache.write(7);
    cache.clear();
    expect(cache.read(), isNull);
  });
}
