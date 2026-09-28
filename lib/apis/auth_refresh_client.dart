// 令牌过期自愈的 http 客户端。
//
// 学生试用时反馈：「停留在答题页练久了，之后每提交一题都提示 jwt expired」。
// 这是**每个请求都必然踩到**的坑，所以修在最底下一层——包住整个 http 通道，
// 任何一处请求（RPC、PostgREST、Storage）都自动受益，不必在十几个仓储里各写一遍。
//
// 为什么令牌会过期：访问令牌只有一小时。SDK 本来会定时刷新，但刷新是**定时器驱动**的，
// 应用被挂起、系统节流、刷新请求刚好赶上断网，都会让它没发生；而请求照样带着
// 已经过期的令牌发出去，服务端只能回 401 jwt expired。
//
// 这里做的：**收到 401 就刷新会话，把新的 access token 换进请求头，再重放一次**。
// 两个细节是踩过才知道的：
//   · **重放必须换掉 Authorization 头**。头是 SDK 在构造请求时就写死的，
//     原样复制等于又一次拿着过期令牌去问，结果还是 401——那样这个"自愈"根本不生效。
//   · **刷新要串行**。首页一进来就是好几个并发请求，令牌一过期它们会同时收到 401；
//     而 GoTrue 的刷新令牌是**一次性的**，并发刷新只有一个能成，其余会把会话刷没。
//     所以同一时刻只允许一次刷新，后来者等同一个 Future。
//
// 其余边界：只重放一次（刷新也救不回来就把原始 401 交给上层）；刷新接口自己
// （/auth/v1/token）的 401 不再触发刷新，否则递归；不解析响应体判断"是不是过期"——
// 读流会把调用方的响应吃掉，而 401 在本项目里只有"令牌不对"这一种来源。

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthRefreshClient extends http.BaseClient {
  AuthRefreshClient(this._inner);

  final http.Client _inner;

  /// 刷新会话并返回**新的 access token**（拿不到就返回 null）。
  /// 由 bootstrap 在 Supabase 初始化之后接上。
  ///
  /// 之所以是回调而不是直接持有 SupabaseClient：SupabaseClient 要拿这个客户端去构造，
  /// 直接持有就成了循环依赖。
  Future<String?> Function()? onExpired;

  /// 正在进行的刷新。并发的 401 共用它，避免把一次性的刷新令牌用两遍。
  Future<String?>? _refreshing;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 只有**请求体已经在内存里**的请求能重放。RPC / PostgREST / Auth 都是 http.Request；
    // 上传走的是 StreamedRequest（流只能读一次），直接放行——那种请求本来就带着刚取到的令牌。
    if (request is! http.Request) return _inner.send(request);

    final response = await _inner.send(_copyOf(request, null));
    if (response.statusCode != 401) return response;
    if (request.url.path.contains('/auth/v1/token')) return response;
    if (onExpired == null) return response;

    final token = await _refresh();
    if (token == null) return response; // 刷不动：把原始 401 交回上层
    return _inner.send(_copyOf(request, token));
  }

  Future<String?> _refresh() {
    return _refreshing ??= _runRefresh().whenComplete(() => _refreshing = null);
  }

  Future<String?> _runRefresh() async {
    try {
      return await onExpired!.call();
    } catch (error) {
      // 刷不动（没有刷新令牌/断网）：原始 401 照常返回，由路由守卫处理登录态
      debugPrint('会话刷新失败，按原样返回 401：$error');
      return null;
    }
  }

  /// 按原样复制一份请求：`BaseRequest` 被 send 过之后不能再发第二次。
  /// [token] 非空时用它替换 Authorization（**这才是自愈的关键**）。
  http.Request _copyOf(http.Request source, String? token) {
    final copy = http.Request(source.method, source.url)
      ..headers.addAll(source.headers)
      ..bodyBytes = source.bodyBytes;
    if (token != null) copy.headers['Authorization'] = 'Bearer $token';
    return copy;
  }
}
