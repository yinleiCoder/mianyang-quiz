// 登录态与当前用户档案。**全局唯一**，路由守卫与每个要显示身份的页面都读它。
//
// 为什么 Session 与 Profile 合并成一个 Store 而不是拆两个：
// 两者 1:1 且总是一起加载（有会话就要拉档案），拆开只会引入"先有谁"的启动顺序问题。
//
// 不 import material_ui：ChangeNotifier 来自 flutter/foundation，
// 这样本类可以在纯 Dart 测试里 await signIn() 而不必起一个 widget 树。

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class AuthStore extends ChangeNotifier {
  AuthStore(this._auth, this._users, {DateTime Function() now = DateTime.now})
    // 私有字段做不了命名参数（下划线开头的参数名非法），只能这样赋值
    // ignore: prefer_initializing_formals
    : _now = now;

  final AuthService _auth;
  final UserRepository _users;

  final DateTime Function() _now;

  /// 档案的保鲜期：同一账号的事件若发生在上一次拉取后的这个窗口内，就不再重拉。
  ///
  /// 要挡的是**启动时的重复**：bootstrap() 拉一次，订阅后 SDK 又把当前会话
  /// 事件化一次（initialSession / tokenRefreshed），线上日志里就是同一条
  /// profiles 查询连发两次、间隔 0.5~1 秒。
  ///
  /// 但窗口不能取消：token 刷新是小时级的，那时重拉一次能捡到服务端的变化
  /// （典型场景：管理员把"待审核教师"批成正式教师）。5 分钟兼顾两头。
  static const profileFreshAfter = Duration(minutes: 5);

  DateTime? _profileLoadedAt;
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
    _subscription = _auth.authStateChanges.listen(
      (_) {
        // 2026-11-06：**启动时的同一账号事件不重拉档案**。
        //
        // Supabase 在订阅/启动恢复会话时会把当前会话再事件化一次
        //（initialSession / tokenRefreshed），而上面 bootstrap() 刚刚已经拉过。
        // 线上日志里能直接看到冷启动时同一条 profiles 查询连发两次（间隔 0.5~1 秒）。
        //
        // 判据用"同账号 + 档案还在保鲜期内"，而不是简单的同账号：token 小时级刷新
        // 时仍要重拉一次，才能捡到服务端的变化（如待审核教师被批准）。
        final sameUser = _profile?.userId == _auth.currentUser?.id;
        final loadedAt = _profileLoadedAt;
        if (sameUser &&
            loadedAt != null &&
            _now().difference(loadedAt) < profileFreshAfter) {
          return;
        }

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
      },
      // 流上的错误必须接住，否则 Dart 会把它直接抛给 zone，控制台出现
      // "Unhandled Exception: AuthRetryableFetchException(...)"——看着像崩溃。
      //
      // 来源是 gotrue 的 notifyException：**可重试**的刷新失败（刷新时断网、
      // TLS 握手被打断、令牌接口 5xx）会走这里。它**不改变会话**——会话被清掉时
      // gotrue 发的是 signedOut 事件（走上面那条 data 分支），所以这里不重拉档案：
      // 档案没变，重拉只会在断网时再失败一次。失败本身也会抛给每个等着的请求，
      // 由各页面按 NetworkException 自己提示。
      onError: (Object error) => debugPrint('会话刷新失败，会话未变，忽略：$error'),
    );
  }

  /// [identifier] 可以是手机号或邮箱（分流与换算在 AuthService 里，见 utils/phone.dart）。
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
      _profileLoadedAt = null;
      return;
    }
    _profile = await _users.fetchProfile();
    _profileLoadedAt = _now();
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
