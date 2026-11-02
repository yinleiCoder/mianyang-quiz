// ABI 识别与「ABI → 资产名」映射的单元测试。
//
// 为什么值得测：这份映射错了，后果是**更新推的包在用户机器上装不上**
// （32 位设备装不了 arm64；64 位-only 的系统装不了只有 armv7 的包），
// 而用户看到的就是「应用未安装」，根本不会联想到是更新包选错了。
// 另外 ABI 目录名拼错（arm64-v8a 写成 arm64）同样是这个后果。
//
// 真机上的 /proc/self/maps 没法在测试里造，所以解析逻辑单独拆成
// abiFromMaps（纯函数）再测。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';

void main() {
  group('abiFromMaps', () {
    test('从 /proc/self/maps 的映射路径里认出 ABI', () {
      const maps = '''
b6f00000-b6f28000 r-xp 00000000 103:04 12345 /data/app/~~abc==/com.mianyang.quiz-def==/lib/arm64-v8a/libflutter.so
b6f29000-b6f30000 r-xp 00000000 103:04 12345 /data/app/~~abc==/com.mianyang.quiz-def==/lib/arm64-v8a/libapp.so
''';
      expect(AndroidAbi.abiFromMaps(maps), 'arm64-v8a');
    });

    test('32 位与 x86_64 目录名也要认对', () {
      expect(
        AndroidAbi.abiFromMaps('/data/app/x/lib/armeabi-v7a/libapp.so'),
        'armeabi-v7a',
      );
      expect(
        AndroidAbi.abiFromMaps('/data/app/x/lib/x86_64/libflutter.so'),
        'x86_64',
      );
    });

    test('解包出来是 arm64 / armeabi 的镜像要归一', () {
      // 认成 'arm64' 会在 assetByAbi 里查不到 → 退到兜底 → 推的包装不上。
      expect(
        AndroidAbi.abiFromMaps('/data/app/x/lib/arm64/libapp.so'),
        'arm64-v8a',
      );
      expect(
        AndroidAbi.abiFromMaps('/data/app/x/lib/armeabi/libapp.so'),
        'armeabi-v7a',
      );
    });

    test('文件里没有 Dart/引擎的映射时返回 null（走兜底，不抛异常）', () {
      expect(AndroidAbi.abiFromMaps(''), isNull);
      expect(
        AndroidAbi.abiFromMaps('/system/lib64/libc.so\n/data/app/x/lib/arm/libfoo.so'),
        isNull,
      );
    });
  });

  group('assetForAbi', () {
    test('三个 ABI 各自对应哪个资产', () {
      expect(AndroidAbi.assetForAbi('arm64-v8a'), 'mianyang_quiz-android.apk');
      expect(
        AndroidAbi.assetForAbi('armeabi-v7a'),
        'mianyang_quiz-android-armv7.apk',
      );
      expect(
        AndroidAbi.assetForAbi('x86_64'),
        'mianyang_quiz-android-x86_64.apk',
      );
    });

    test('认不出来的 ABI 与 null 都退到兜底那份', () {
      expect(AndroidAbi.assetForAbi(null), AndroidAbi.fallbackAsset);
      expect(AndroidAbi.assetForAbi('mips'), AndroidAbi.fallbackAsset);
      expect(AndroidAbi.assetForAbi(''), AndroidAbi.fallbackAsset);
    });

    test('兜底那份与网页端默认下发的一致（arm64-v8a）', () {
      // 两边口径必须一样：认不出 ABI 时跟着网页端走，
      // 不然会出现"新装拿的是 arm64、更新推的是 armv7"。
      expect(AndroidAbi.fallbackAsset, 'mianyang_quiz-android.apk');
    });
  });
}
