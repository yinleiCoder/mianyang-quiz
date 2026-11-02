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
//
// **额外加超时（2026-11-02）**：Supabase 的 Dart SDK 自带 http 通道**没有超时**，
// 一次卡住（学校网络/运营商劫持/机场般的跨境路由）就是无限转圈——用户报的
// "数据加载不出来"正是这个形状。这里包住整个通道，超时抛 TimeoutException，
// 由仓储层的 mapError 翻成「网络连接失败，请检查网络后重试」，页面显示重试按钮。
//   · [responseTimeout] 从发出到**收到响应头**的上限。正常的 RPC 都在 1s 级，
//     20s 已经是很宽松的上限；再长就该让用户重试，而不是干等。
//   · [bodyIdleTimeout] 两个数据块之间的**空闲**上限（不是总时长）。大响应
//     （试卷快照、题库分页）只要还在持续吐字节就不会被腰斩。
// 上传走 StreamedRequest（流只能读一次），原样放行、不套超时——见下面的分支。

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthRefreshClient extends http.BaseClient {
  AuthRefreshClient(
    this._inner, {
    this.responseTimeout = const Duration(seconds: 20),
    this.bodyIdleTimeout = const Duration(seconds: 30),
  });

  final http.Client _inner;

  /// 收到响应头的上限。测试里传很小的值验证超时行为。
  final Duration responseTimeout;

  /// 响应体两个数据块之间的空闲上限。
  final Duration bodyIdleTimeout;

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

    final response = await _guarded(_inner.send(_copyOf(request, null)));
    if (response.statusCode != 401) return response;
    if (request.url.path.contains('/auth/v1/token')) return response;
    if (onExpired == null) return response;

    final token = await _refresh();
    if (token == null) return response; // 刷不动：把原始 401 交回上层
    return _guarded(_inner.send(_copyOf(request, token)));
  }

  /// 给一次 send 套上"响应头超时 + 响应体空闲超时"。
  ///
  /// 两层缺一不可：`.timeout` 只覆盖到 **headers 回来**为止；PostgREST 把 JSON
  /// 放在响应体里，body 读一半卡住时（弱网常见）光有外层 timeout 是拦不住的。
  /// 用 `Stream.timeout` 的空闲语义而不是总时长，避免把慢但正常的大响应误杀。
  Future<http.StreamedResponse> _guarded(
    Future<http.StreamedResponse> pending,
  ) async {
    final response = await pending.timeout(responseTimeout);
    return http.StreamedResponse(
      response.stream.timeout(bodyIdleTimeout),
      response.statusCode,
      contentLength: response.contentLength,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
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
