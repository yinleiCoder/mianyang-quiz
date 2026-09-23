// 密码相关的全部操作：忘记密码的自助重置（走 RPC）、已登录时的改密（走 Auth SDK）。
//
// 为什么单独一个仓储而不是塞进 AuthService：① 本仓的分工是 **services 封装 Supabase
// Auth SDK、repositories 封装 PostgREST/RPC**；② 自助重置必须**在未登录状态下可用**
// （那时手里只有一个 anon key、没有 JWT），只能走服务端 RPC —— 与 feedback_repository
// 同口径。放在一起是因为它们是同一件事（改密码）的两条路，契约也共享。
//
// 为什么页面直接用它、不经过 AuthStore：与 feedback_page 用 FeedbackRepository 是同一模式，
// 表单页本来就自己管 _busy / _error。重置成功后的自动登录会触发 authStateChanges，
// AuthStore 自己会重拉档案 —— 不需要谁去通知它。
//
// 两条契约，改服务端之前先看 0072/0073/0074 的头注：
//   · 自助重置**返回 {ok, error} 而不是抛错** —— 0073 特意如此：raise 会回滚失败计数，
//     把「1 小时 5 次」的限流整个绕过去。所以必须判 ok，不能只看有没有异常。
//   · 失败也是 HTTP 200，`error` 字段是给用户看的中文，直接透出即可。

import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/phone.dart';
// hide AuthException：本文件里这个名字一律指**本项目的** AuthException
//（core/error/app_exception.dart，语义是「会话失效、踢回登录页」），不是 gotrue 的同名异常。
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class PasswordRepository {
  const PasswordRepository(this._client);

  final SupabaseClient _client;

  /// 自助重置（未登录）。[identifier] **原样上报**，不在端上折成合成邮箱：
  /// 归一化由 SQL 侧统一做（auth_identifier，口径对齐 lib/phone.js 与 core/utils/phone.dart），
  /// 端上再算一遍就变成两套口径。
  ///
  /// 通过校验时服务端会写新哈希、**踢掉该账号所有会话**、写审计日志。
  ///
  /// 返回 true = 已用新密码自动登录；false = 密码改好了但自动登录失败，
  /// 调用方应提示回登录页手登 —— **不是重置失败**。
  Future<bool> resetPassword({
    required String identifier,
    required String name,
    required String newPassword,
  }) async {
    final id = toAuthIdentifier(identifier);
    if (id.email == null) {
      throw const UnknownException(message: '请输入正确的手机号或邮箱');
    }

    final Map<String, dynamic> data;
    try {
      final result = await _client.rpc(
        'self_reset_password',
        params: {
          'p_identifier': identifier,
          'p_name': name,
          'p_new_password': newPassword,
        },
      );
      data = (result as Map).cast<String, dynamic>();
    } catch (error) {
      throw mapError(error);
    }

    if (data['ok'] != true) {
      // 用 UnknownException 而不是 AuthException：后者在本项目里是「会话失效、
      // 踢回登录页」的信号（见 core/router/app_router.dart），拿它做表单校验会触发
      // 一次语义错误的跳转。
      throw UnknownException(
        message: (data['error'] as String?) ?? '重置失败，请稍后再试',
      );
    }

    try {
      await _client.auth.signInWithPassword(
        email: id.email!,
        password: newPassword,
      );
      return true;
    } catch (_) {
      // 密码已经改好了，自动登录失败不改变结果：用户回登录页用新密码登即可
      return false;
    }
  }

  /// 已登录改密：**先验旧密码**再改。
  ///
  /// 验这一步不能省 —— Supabase 的 updateUser 不要求旧密码，不验就等于"拿到一台
  /// 已解锁的设备就能改密、把号主锁在门外"。
  ///
  /// 其他设备的会话**不受影响**（与忘记密码那条路不同，那条会全部踢掉）：主动改密的人
  /// 本来就掌握当前密码，在电脑上改密码不该把手机踢下线。
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _verifyCurrent(currentPassword);
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 拿当前账号的邮箱再登录一次，用来确认旧密码。手机号账号的邮箱是合成地址
  /// （见 core/utils/phone.dart），与登录走的是同一条路。
  Future<void> _verifyCurrent(String password) async {
    final email = _client.auth.currentUser?.email;
    if (email == null) {
      throw const UnknownException(message: '当前账号没有可用的登录标识，请重新登录');
    }
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (error) {
      final mapped = mapError(error);
      // 凭据不对 → 换成改密场景下更贴切的说法；**不能**原样抛 AuthException（语义见上）。
      // 网络/服务端异常原样透出 —— 别让"连不上"看起来像"密码打错了"。
      if (mapped is AuthException) {
        throw const UnknownException(message: '当前密码不正确');
      }
      throw mapped;
    }
  }
}
