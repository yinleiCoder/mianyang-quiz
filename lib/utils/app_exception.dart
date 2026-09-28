// 全应用统一的异常类型。
//
// 职责：把三种来源的失败（网络、鉴权、数据库）归一成一种可展示、可区分处理的东西。
// 不负责：把异常翻译成中文文案——那是 error_mapper.dart 的事。
//
// 为什么不直接用原始异常：Supabase/Dio 抛出的类型在 UI 层处理起来很别扭，
// 而且我们**必须区分**「会话过期要踢回登录」与「数据库拒绝了这次操作」——
// 前者要跳转，后者只需弹一句话。两者的原始类型都是 Exception，区分不了。
//
// sealed：调用方 switch 时必须穷举，新增一种错误来源会立刻在编译期暴露所有未处理的分支。

sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  /// 可直接展示给用户的中文文案。数据库 raise exception 的消息本身就是中文，直接透传。
  final String message;

  /// 原始异常，仅用于日志，不展示。
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// 网络不可达、超时、DNS 失败等。可重试。
final class NetworkException extends AppException {
  const NetworkException({String? message, super.cause})
    : super(message ?? '网络连接失败，请检查网络后重试');
}

/// 未登录或会话已过期。**收到这个一律踢回登录页**，不要只弹 toast。
final class AuthException extends AppException {
  const AuthException({String? message, super.cause})
    : super(message ?? '登录状态已过期，请重新登录');
}

/// 服务端明确拒绝（RPC 里的 raise exception、RLS 拒绝、参数校验）。
/// 消息通常可直接展示，例如「仅审核通过的教师可执行该操作」。
final class ServerException extends AppException {
  const ServerException(super.message, {super.cause});
}

/// 其余未能归类的失败。保留原始信息以便排查。
final class UnknownException extends AppException {
  const UnknownException({String? message, super.cause})
    : super(message ?? '操作失败，请稍后重试');
}
