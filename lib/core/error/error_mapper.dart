// 把各家 SDK 的异常统一翻译成 AppException。
//
// 职责：**只在仓储/服务层的边界调一次**，往上一层就只见 AppException。
// 不负责：重试、上报。失败就是失败，交给调用方决定是重试还是提示。
//
// 为什么值得单独一层：数据库 raise exception 的中文文案本身就是给用户看的
// （例如「仅审核通过的教师可执行该操作」「本次练习已结束，无法继续作答」），
// 直接丢掉换成"操作失败"是浪费。而网络层的英文异常又不能原样给用户看。
// 这个判断只有在这里做一次，才不会散落到每个调用点。

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

/// 任意异常 → AppException。（已是 AppException 则原样返回。）
AppException mapError(Object error, [StackTrace? stack]) {
  if (error is AppException) return error;

  if (error is sb.PostgrestException) {
    // 数据库的 raise exception 是中文，可直接展示；
    // 约束冲突之类没写中文的，给一句兜底。
    final message = error.message.trim();
    return ServerException(
      message.isEmpty ? '服务端拒绝了这次操作' : message,
      cause: error,
    );
  }

  if (error is sb.AuthException) {
    return AuthException(message: _authMessage(error), cause: error);
  }

  if (error is DioException) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        NetworkException(message: '网络超时，请检查网络后重试', cause: error),
      DioExceptionType.connectionError =>
        NetworkException(cause: error),
      DioExceptionType.badResponse => ServerException(
          _httpMessage(error.response?.statusCode),
          cause: error,
        ),
      _ => UnknownException(cause: error),
    };
  }

  if (error is SocketException || error is TimeoutException) {
    return NetworkException(cause: error);
  }

  return UnknownException(cause: error);
}

String _authMessage(sb.AuthException error) {
  // Supabase 的鉴权错误文案是英文，挑常见的翻一下，其余原样透传（便于排查）。
  final raw = error.message;
  final lower = raw.toLowerCase();
  if (lower.contains('invalid login credentials')) return '邮箱或密码不正确';
  if (lower.contains('email not confirmed')) return '邮箱尚未验证，请先完成验证';
  if (lower.contains('user already registered')) return '该邮箱已被注册';
  if (lower.contains('password should be at least')) return '密码长度至少 6 位';
  if (lower.contains('signups not allowed')) return '当前不允许自助注册，请联系管理员';
  if (lower.contains('token has expired') || lower.contains('invalid token')) {
    return '验证码已失效，请重新获取';
  }
  return raw;
}

String _httpMessage(int? status) => switch (status) {
  null => '请求失败',
  400 => '请求参数有误',
  401 || 403 => '没有权限执行该操作',
  404 => '请求的资源不存在',
  413 => '文件过大',
  >= 500 => '服务端开小差了，请稍后重试',
  _ => '请求失败',
};
