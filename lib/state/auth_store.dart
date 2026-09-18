// 登录态与当前用户档案。**全局唯一**，路由守卫与每个要显示身份的页面都读它。
//
// 为什么 Session 与 Profile 合并成一个 Store 而不是拆两个：
// 两者 1:1 且总是一起加载（有会话就要拉档案），拆开只会引入"先有谁"的启动顺序问题。
//
// 不 import material_ui：ChangeNotifier 来自 flutter/foundation，
// 这样本类可以在纯 Dart 测试里 await signIn() 而不必起一个 widget 树。

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/data/services/auth_service.dart';

class AuthStore extends ChangeNotifier {
  AuthStore(this._auth, this._users);

  final AuthService _auth;
  final UserRepository _users;
  // 用 Object? 而不是 supabase 的 AuthState：Store 不需要知道事件的具体形状，
  // 它只关心"变了就去重新拉档案"。这样也少一层对本类的包依赖。
  StreamSubscription<Object?>? _subscription;

  Profile? _profile;
  bool _ready = false;
  bool _busy = false;
  AppException? _error;

  /// 会话是否已恢复完毕。**为 false 时路由守卫必须挂起**——
  /// 否则冷启动瞬间会被判成"未登录"而闪一下登录页。
  bool get isReady => _ready;

  bool get isSignedIn => _auth.isSignedIn;

  Profile? get profile => _profile;

  String? get userId => _auth.currentUser?.id;

  bool get isBusy => _busy;

  AppException? get error => _error;

  Identity get identity => _profile?.identityValue ?? Identity.student;

  /// 是否具备教师权限（可出题）。学生仍可刷题，只是看不到出题入口。
  bool get isTeacher => _profile?.isTeacher ?? false;

  String get displayName => _profile?.name ?? '同学';

  /// 启动时调用一次：恢复会话、拉档案、并订阅后续的登录态变化。
  Future<void> bootstrap() async {
    // 拉档案失败也必须把 isReady 置起来：否则冷启动时一次网络抖动
    // 会让路由守卫永远等不到"就绪"，应用卡在加载态无法恢复。
    // 失败信息留在 error 里，由页面自行决定是提示还是重试。
    try {
      await _loadProfile();
    } catch (error) {
      _error = mapError(error);
    }
    _ready = true;
    notifyListeners();

    // 令牌过期被踢、或换账号时，档案必须跟着变，否则会拿旧档案渲染新会话
    _subscription = _auth.authStateChanges.listen((_) {
      // 必须自己接住异常：_loadProfile 抛错时 then 不执行，错误会变成
      // 未捕获的异步异常（只在控制台出现），而登录态已经变了、档案却停在旧值上。
      unawaited(
        _loadProfile().then(
          (_) {
            _error = null;
            notifyListeners();
          },
          onError: (Object error) {
            _error = mapError(error);
            notifyListeners();
          },
        ),
      );
    });
  }

  /// [identifier] 可以是手机号或邮箱（分流与换算在 AuthService 里，见 core/utils/phone.dart）。
  Future<void> signIn({required String identifier, required String password}) =>
      _run(() async {
        await _auth.signIn(identifier: identifier, password: password);
        await _loadProfile();
      });

  /// 返回 true 表示注册后还需邮箱验证（本项目已关闭邮箱验证，通常为 false）。
  /// 参数直接透传给 AuthService.signUp，键名与可选性都见那边的注释。
  Future<bool> signUp({
    required String identifier,
    required String password,
    required String name,
    Identity identity = Identity.student,
    String? schoolId,
    int? enrollYear,
    String? classId,
  }) async {
    var needsVerification = false;
    await _run(() async {
      needsVerification = await _auth.signUp(
        identifier: identifier,
        password: password,
        name: name,
        identity: identity,
        schoolId: schoolId,
        enrollYear: enrollYear,
        classId: classId,
      );
      if (!needsVerification) await _loadProfile();
    });
    return needsVerification;
  }

  Future<void> signOut() => _run(() async {
    await _auth.signOut();
    _profile = null;
  });

  /// 档案被改过之后调用（改姓名/头像/就读信息/申请教师身份）。
  Future<void> refreshProfile() async {
    await _loadProfile();
    notifyListeners();
  }

  Future<void> _loadProfile() async {
    if (!_auth.isSignedIn) {
      _profile = null;
      return;
    }
    _profile = await _users.fetchProfile();
  }

  /// 统一处理忙碌标志与错误归一，避免每个方法各写一遍 try/catch。
  Future<void> _run(Future<void> Function() action) async {
    _busy = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      _error = mapError(error);
      rethrow;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
