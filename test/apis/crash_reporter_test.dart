import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/apis/apis.dart';

void main() {
  group('CrashReporter.scrub', () {
    test('手机号', () {
      expect(
        CrashReporter.scrub('用户 13800138000 登录失败'),
        '用户 [手机号] 登录失败',
      );
    });

    test('合成邮箱（手机号登录）整段擦掉', () {
      expect(
        CrashReporter.scrub('联系 13800138000@phone.myquiz.cn'),
        '联系 [邮箱]',
      );
    });

    test('普通邮箱', () {
      expect(
        CrashReporter.scrub('teacher@example.com 提交失败'),
        '[邮箱] 提交失败',
      );
    });

    test('JWT', () {
      expect(
        CrashReporter.scrub('token eyJhbGci.eyJzdWIi.c2ln'),
        'token [令牌]',
      );
    });

    test('null / 空串', () {
      expect(CrashReporter.scrub(null), '');
      expect(CrashReporter.scrub(''), '');
    });
  });
}
