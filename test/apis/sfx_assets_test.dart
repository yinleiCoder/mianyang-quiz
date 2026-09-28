// 音效资源的存在性测试。
//
// 为什么值得测：文件名是**中文**，而且播放失败是**静默**的（SfxService 里 catch 掉了）——
// 名字打错、或 pubspec 的 assets 没覆盖到，表现是"点了没声音"，控制台一个字都不报。
// 这里直接把五个文件从 bundle 里 load 一遍：路径错了、没打进包，测试就红。

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// 「选择一个选项」等五个音效，与 SfxService 里的常量一一对应。
  const sounds = <String>[
    '选择一个选项',
    '答对',
    '答错',
    '测验全部结束',
    '退出答题',
  ];

  test('五个音效都真的在包里的 assets/sounds/ 下', () async {
    for (final name in sounds) {
      final data = await rootBundle.load('assets/sounds/$name.mp3');
      expect(
        data.lengthInBytes,
        greaterThan(1000),
        reason: '$name.mp3 没打进包、或名字对不上（播放失败是静默的，只能靠这里兜住）',
      );
    }
  });
}
