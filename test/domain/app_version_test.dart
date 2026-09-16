// 版本号比较的单元测试。
//
// 为什么值得测：比较错了的后果是**用户被反复骚扰**（永远提示有新版本）或者
// **永远收不到更新**，两种都很难从界面上看出原因。而这段逻辑的边界不少：
// tag 带 v 前缀、带 -dev 后缀、段数不同（1.2 vs 1.2.0）、段里有构建号（1.2.3+4）。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/domain/app_version.dart';

void main() {
  group('compareVersions', () {
    test('按段比较，v 前缀与后缀都忽略', () {
      expect(compareVersions('v1.0.1', 'v1.0.0'), greaterThan(0));
      expect(compareVersions('1.0.1', 'v1.0.0'), greaterThan(0));
      expect(compareVersions('v1.0.1-dev', 'v1.0.1'), 0);
      expect(compareVersions('1.0.1+3', '1.0.1+1'), 0, reason: '构建号不参与比较');
    });

    test('段数不同时短的补 0', () {
      expect(compareVersions('1.2', '1.2.0'), 0);
      expect(compareVersions('1.2.1', '1.2'), greaterThan(0));
      expect(compareVersions('1.10', '1.9'), greaterThan(0), reason: '按数字比，不是字典序');
      expect(compareVersions('2.0', '1.99.99'), greaterThan(0));
    });

    test('解析不出来的（dev / 空）一律按"一样新"处理', () {
      expect(compareVersions('dev', '1.0.0'), 0);
      expect(compareVersions('', '1.0.0'), 0);
      expect(compareVersions(null, '1.0.0'), 0);
    });
  });

  group('hasNewerVersion', () {
    test('只有远端更新时才为真', () {
      expect(hasNewerVersion(latest: 'v1.0.1', current: 'v1.0.0'), isTrue);
      expect(hasNewerVersion(latest: 'v1.0.0', current: 'v1.0.0'), isFalse);
      expect(hasNewerVersion(latest: 'v0.9.9', current: 'v1.0.0'), isFalse);
    });

    test('开发版（APP_VERSION=dev）永远不提示', () {
      // 这是刻意的：开发时天天弹"有新版本"毫无意义
      expect(hasNewerVersion(latest: 'v9.9.9', current: 'dev'), isFalse);
      expect(hasNewerVersion(latest: 'v9.9.9', current: ''), isFalse);
    });
  });

  test('parseVersion 只吃开头的数字', () {
    expect(parseVersion('v1.2.3'), [1, 2, 3]);
    expect(parseVersion('1.2.3-dev'), [1, 2, 3]);
    expect(parseVersion('abc'), isEmpty);
  });
}
