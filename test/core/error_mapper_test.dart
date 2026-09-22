// 异常翻译的测试。
//
// 为什么值得测：**AuthRetryableFetchException 继承自 AuthException**，
// 而本项目的约定是「收到 AuthException 就说明会话失效、踢回登录页」
// （见 core/error/app_exception.dart）。刷新令牌时断一次网就落入那个分支的话，
// 用户会被莫名其妙地登出，看到的还是英文的
// "HandshakeException: Connection terminated during handshake"。
//
// 这条分支只有真的断网时才会走到，靠手测几乎撞不上，所以锁在这里。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

void main() {
  test('刷新令牌时连不上（网络/TLS）：算网络错误，不算登录失效', () {
    final mapped = mapError(
      sb.AuthRetryableFetchException(
        message: 'HandshakeException: Connection terminated during handshake',
      ),
    );

    expect(mapped, isA<NetworkException>());
    expect(
      mapped.message,
      isNot(contains('HandshakeException')),
      reason: '英文原文不能直接给用户看',
    );
  });

  test('令牌接口 5xx：报服务端问题，不误导用户去查自己的网络', () {
    final mapped = mapError(
      sb.AuthRetryableFetchException(message: 'boom', statusCode: '500'),
    );

    expect(mapped, isA<ServerException>());
    expect(mapped.message, '服务端开小差了，请稍后重试');
  });

  test('真正的鉴权失败仍走 AuthException（新的分支没把它一起吞掉）', () {
    final mapped = mapError(const sb.AuthException('Invalid login credentials'));

    expect(mapped, isA<AuthException>());
    expect(mapped.message, '手机号/邮箱或密码不正确');
  });
}
