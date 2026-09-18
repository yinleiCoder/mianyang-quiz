// 跑法：flutter test test/core/phone_test.dart
//
// **这是与网页端 `lib/phone.js` 的对齐测试**（那边是仓库根 scripts/test-phone.mjs）。
// 两边的用例一一对应，改一边必须改另一边 —— 换算规则不一致的表现是
// 「同一个手机号在网页和 App 落到两个不同账号」，线上排查极费劲。
//
// 这些边界值不是凑数的：手机号规范化最容易在"带不带国家码"上写错。
import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/core/utils/phone.dart';

void main() {
  group('normalizePhone：合法写法都要能认出来', () {
    test('裸 11 位', () => expect(normalizePhone('13800138000'), '13800138000'));
    test('带空格', () => expect(normalizePhone('138 0013 8000'), '13800138000'));
    test('带连字符', () => expect(normalizePhone('138-0013-8000'), '13800138000'));
    test('带括号', () => expect(normalizePhone('(138)0013-8000'), '13800138000'));
    test('+86 前缀', () => expect(normalizePhone('+8613800138000'), '13800138000'));
    test('86 前缀（无加号）', () => expect(normalizePhone('8613800138000'), '13800138000'));
    test('+86 带空格', () => expect(normalizePhone('+86 138 0013 8000'), '13800138000'));
  });

  group('normalizePhone：不合法的必须返回 null，不能"尽力而为"猜', () {
    test('位数不足', () => expect(normalizePhone('1380013800'), isNull));
    test('位数过多', () => expect(normalizePhone('138001380001'), isNull));
    test('第二位是 2（非法号段）', () => expect(normalizePhone('12800138000'), isNull));
    test('开头不是 1', () => expect(normalizePhone('23800138000'), isNull));
    test('含字母', () => expect(normalizePhone('1380013800a'), isNull));
    test('空串', () => expect(normalizePhone(''), isNull));
    test('null', () => expect(normalizePhone(null), isNull));
    // 这条是关键：861380013800 去掉 86 后只剩 10 位，不能被当成合法号码
    test('86 开头但总长不够', () => expect(normalizePhone('861380013800'), isNull));
  });

  group('往返一致：这是网页与 App 落到同一账号的前提', () {
    test('phone → email → phone', () {
      for (final raw in const ['13800138000', '+8613800138000', '138 0013 8000']) {
        final p = normalizePhone(raw)!;
        expect(emailToPhone(phoneToEmail(p)), p);
        expect(phoneToEmail(raw), '$p@$phoneEmailDomain');
      }
    });
  });

  group('emailToPhone：只认自己的域名', () {
    test('真实邮箱不是手机号账号', () => expect(emailToPhone('teacher@qq.com'), isNull));
    test(
      '同前缀的别的域名不认',
      () => expect(emailToPhone('13800138000@phone.evil.com'), isNull),
    );
    test(
      '域名大小写不敏感',
      () => expect(emailToPhone('13800138000@PHONE.MYQUIZ.CN'), '13800138000'),
    );
    test(
      '合成域名但本地部分不合法',
      () => expect(emailToPhone('abc@$phoneEmailDomain'), isNull),
    );
  });

  group('looksLikePhone：分流只看"有没有 @"，不判格式', () {
    test('纯数字算手机号路子', () => expect(looksLikePhone('13800138000'), isTrue));
    test(
      '少一位也仍算手机号路子（要报格式错，不能当邮箱查）',
      () => expect(looksLikePhone('1380013800'), isTrue),
    );
    test('含 @ 算邮箱路子', () => expect(looksLikePhone('a@b.com'), isFalse));
  });

  group('toAuthIdentifier：表单真正调用的那个', () {
    test('手机号输入 → 合成邮箱 + phone', () {
      final r = toAuthIdentifier('138 0013 8000');
      expect(r.email, '13800138000@$phoneEmailDomain');
      expect(r.phone, '13800138000');
    });
    test('邮箱输入 → 原样（小写）+ 无 phone', () {
      final r = toAuthIdentifier('Teacher@QQ.com');
      expect(r.email, 'teacher@qq.com');
      expect(r.phone, isNull);
    });
    test('手机号格式错 → 两个都 null（调用方据此报错）', () {
      final r = toAuthIdentifier('1380013');
      expect(r.email, isNull);
      expect(r.phone, isNull);
    });
    test('空输入 → 两个都 null', () {
      final r = toAuthIdentifier('   ');
      expect(r.email, isNull);
      expect(r.phone, isNull);
    });
    test('null → 两个都 null', () {
      final r = toAuthIdentifier(null);
      expect(r.email, isNull);
      expect(r.phone, isNull);
    });
  });

  group('展示', () {
    test('formatPhone 分组', () => expect(formatPhone('13800138000'), '138 0013 8000'));
    test('formatPhone 非手机号原样返回', () => expect(formatPhone('abc'), 'abc'));
    test('formatPhone null → 空串', () => expect(formatPhone(null), ''));

    test(
      'displayIdentifier 优先手机号',
      () => expect(
        displayIdentifier(phone: '13800138000', email: 'x@y.com'),
        '138 0013 8000',
      ),
    );
    test(
      'displayIdentifier 退回邮箱',
      () => expect(
        displayIdentifier(phone: null, email: 'teacher@qq.com'),
        'teacher@qq.com',
      ),
    );
    test(
      'displayIdentifier 合成邮箱也显示成手机号',
      () => expect(
        displayIdentifier(phone: null, email: '13800138000@$phoneEmailDomain'),
        '138 0013 8000',
      ),
    );
    test('displayIdentifier 空入参不炸', () => expect(displayIdentifier(), ''));
    test(
      'displayIdentifier phone 为空串时退回邮箱',
      () => expect(
        displayIdentifier(phone: '', email: 'teacher@qq.com'),
        'teacher@qq.com',
      ),
    );

    // displayEmail：合成邮箱绝不能露给用户 —— 这是「手机号、邮箱区分显示」的地基
    test(
      '合成邮箱折叠成空串',
      () => expect(displayEmail('13800138000@$phoneEmailDomain'), ''),
    );
    test('真实邮箱原样返回', () => expect(displayEmail('teacher@qq.com'), 'teacher@qq.com'));
    test(
      '同前缀的别的域名不算合成邮箱',
      () => expect(displayEmail('13800138000@phone.evil.com'), '13800138000@phone.evil.com'),
    );
    test('null 折叠成空串', () => expect(displayEmail(null), ''));
  });
}
