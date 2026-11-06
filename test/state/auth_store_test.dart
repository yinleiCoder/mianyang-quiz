// 冷启动只拉一次档案的回归（2026-11-06）。
//
// 线上日志里的形状：一次打开 App，同一条 profiles 查询连发两次（间隔 0.5~1 秒）——
// bootstrap() 拉一次，订阅 authStateChanges 后 SDK 又把当前会话事件化一次
//（initialSession / tokenRefreshed），监听器再拉一次。
//
// 这条测试守三件事：同账号事件不再拉、换账号要拉、登出要把档案清空。

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeUser implements User {
  _FakeUser(this.id);

  @override
  final String id;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuth implements AuthService {
  User? user;
  final _events = StreamController<AuthState>.broadcast();

  @override
  bool get isSignedIn => user != null;

  @override
  User? get currentUser => user;

  @override
  Stream<AuthState> get authStateChanges => _events.stream;

  void emit(AuthChangeEvent event) =>
      _events.add(AuthState(event, null));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUsers implements UserRepository {
  int calls = 0;
  String userId = 'u1';

  @override
  Future<Profile?> fetchProfile() async {
    calls += 1;
    return Profile.fromJson({'user_id': userId});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late DateTime now;
  late _FakeAuth auth;
  late _FakeUsers users;
  late AuthStore store;

  setUp(() async {
    now = DateTime(2026, 11, 6, 9);
    auth = _FakeAuth()..user = _FakeUser('u1');
    users = _FakeUsers();
    store = AuthStore(auth, users, now: () => now);
    await store.bootstrap();
  });

  test('启动只拉一次档案', () {
    expect(users.calls, 1);
    expect(store.profile?.userId, 'u1');
  });

  test('同一账号、保鲜期内的会话事件不重拉（启动重复的那一次）', () async {
    auth.emit(AuthChangeEvent.initialSession);
    auth.emit(AuthChangeEvent.tokenRefreshed);
    await pumpEventQueue();
    expect(users.calls, 1, reason: '档案没变，重拉就是白白多一个往返');
  });

  test('保鲜期过了的 token 刷新会重拉（捡服务端变化）', () async {
    now = now.add(const Duration(minutes: 6));
    auth.emit(AuthChangeEvent.tokenRefreshed);
    await pumpEventQueue();
    expect(users.calls, 2);
  });

  test('换账号才重拉', () async {
    auth.user = _FakeUser('u2');
    users.userId = 'u2';
    auth.emit(AuthChangeEvent.signedIn);
    await pumpEventQueue();
    expect(users.calls, 2);
    expect(store.profile?.userId, 'u2');
  });

  test('登出把档案清空，且不必再打一次网络', () async {
    auth.user = null;
    auth.emit(AuthChangeEvent.signedOut);
    await pumpEventQueue();
    expect(store.profile, isNull);
    expect(users.calls, 1);
  });
}
