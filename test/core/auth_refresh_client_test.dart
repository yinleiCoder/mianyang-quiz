// 令牌过期自愈的测试。
//
// 为什么值得测：学生试用时撞上的就是它——停留在答题页练久了，之后**每一次**提交都报
// jwt expired，整页用不了。修法是在 http 层收到 401 就刷新会话、换掉请求头再重放一次。
//
// **真机联调时这段代码第一版是错的**：重放时原样复制了请求头，里面还带着那个过期的
// Bearer，于是重放还是 401——"自愈"根本没生效，而当时的测试只数了调用次数，看不出来。
// 所以这里的断言全都盯着**重放的那份请求长什么样**，不只是"发了几次"。

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mianyang_quiz/core/network/auth_refresh_client.dart';

void main() {
  test('收到 401：刷新后带着**新令牌**重放，请求体原样', () async {
    final inner = _FakeClient([401, 200]);
    final client = AuthRefreshClient(inner)..onExpired = () async => 'new-token';

    final response = await client.post(
      Uri.parse('https://x.supabase.co/rest/v1/rpc/foo'),
      headers: {'Authorization': 'Bearer expired-token'},
      body: '{"p_answer":{"type":"choice","keys":["A"]}}',
    );

    expect(response.statusCode, 200);
    expect(inner.calls, 2, reason: '应当重放一次');
    expect(inner.bodies, [
      '{"p_answer":{"type":"choice","keys":["A"]}}',
      '{"p_answer":{"type":"choice","keys":["A"]}}',
    ], reason: '重放的请求体要与原来一致（丢了会变成一个静默的错误请求）');
    expect(inner.authHeaders, ['Bearer expired-token', 'Bearer new-token'],
        reason: '重放必须换掉过期的令牌，否则还是 401');
  });

  test('并发的 401 只刷新一次（刷新令牌是一次性的，刷两次会把会话刷没）', () async {
    final inner = _FakeClient([401, 401, 401, 200, 200, 200]);
    var refreshed = 0;
    final client = AuthRefreshClient(inner)
      ..onExpired = () async {
        refreshed++;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 'new-token';
      };

    final responses = await Future.wait([
      client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/a')),
      client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/b')),
      client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/c')),
    ]);

    expect(responses.map((r) => r.statusCode), [200, 200, 200]);
    expect(refreshed, 1, reason: '三个并发请求只该触发一次刷新');
  });

  test('刷新失败时把原始 401 交回上层，不吞异常也不无限重试', () async {
    final inner = _FakeClient([401, 401]);
    final client = AuthRefreshClient(inner)
      ..onExpired = () async => throw StateError('没有刷新令牌');

    final response = await client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/foo'));

    expect(response.statusCode, 401);
    expect(inner.calls, 1, reason: '刷新失败就不该再发一次请求');
  });

  test('刷新拿不到令牌（返回 null）时也不重放', () async {
    final inner = _FakeClient([401, 401]);
    final client = AuthRefreshClient(inner)..onExpired = () async => null;

    final response = await client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/foo'));

    expect(response.statusCode, 401);
    expect(inner.calls, 1);
  });

  test('刷新接口自己的 401 不再触发刷新（否则递归）', () async {
    final inner = _FakeClient([401]);
    var refreshed = 0;
    final client = AuthRefreshClient(inner)
      ..onExpired = () async {
        refreshed++;
        return 'new-token';
      };

    final response = await client.post(
      Uri.parse('https://x.supabase.co/auth/v1/token?grant_type=refresh_token'),
      body: '{}',
    );

    expect(response.statusCode, 401);
    expect(refreshed, 0);
    expect(inner.calls, 1);
  });

  test('非 401 原样返回，不刷新', () async {
    final inner = _FakeClient([200]);
    var refreshed = 0;
    final client = AuthRefreshClient(inner)
      ..onExpired = () async {
        refreshed++;
        return 'new-token';
      };

    final response = await client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/foo'));

    expect(response.statusCode, 200);
    expect(refreshed, 0);
    expect(inner.calls, 1);
  });

  test('没接刷新回调时（例如还没初始化完）原样返回 401', () async {
    final inner = _FakeClient([401]);
    final client = AuthRefreshClient(inner);

    final response = await client.get(Uri.parse('https://x.supabase.co/rest/v1/rpc/foo'));

    expect(response.statusCode, 401);
    expect(inner.calls, 1);
  });
}

/// 按顺序吐出预设状态码的假客户端，同时记下每次请求的 body 与 Authorization。
class _FakeClient extends http.BaseClient {
  _FakeClient(this.statuses);

  final List<int> statuses;
  final List<String> bodies = [];
  final List<String?> authHeaders = [];
  int calls = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    bodies.add(request is http.Request ? request.body : '');
    authHeaders.add(request.headers['Authorization']);
    final status = statuses[calls.clamp(0, statuses.length - 1)];
    calls++;
    final bytes = utf8.encode(status == 401 ? '{"message":"jwt expired"}' : '{}');
    return http.StreamedResponse(Stream.value(bytes), status);
  }
}
