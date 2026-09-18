// Supabase Auth 的封装：登录、注册、登出、会话监听。
//
// 为什么不让页面直接用 Supabase.instance.client.auth：鉴权失败的文案要做一层翻译
// （见 core/error/error_mapper.dart），而且**会话过期必须能区分出来**（AppException
// 的 AuthException 专门用来把用户踢回登录页）。散在各个页面里就收不回来了。
//
// 登录态的唯一出口是 authStateChanges：App 根部听它决定显示登录页还是主框架，
// 页面不要各自轮询 currentSession。

import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  /// 当前会话；未登录为 null。[accessToken] 是调网页端 /api/oss/sign 用的凭据。
  Session? get session => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  bool get isSignedIn => _client.auth.currentSession != null;

  /// 登录状态变化（登录 / 登出 / token 刷新）。**记得 cancel 订阅**。
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// 邮箱密码登录。失败文案已由 mapError 翻成中文
  /// （「邮箱或密码不正确」「邮箱尚未验证，请先完成验证」…）。
  /// 邮箱两端去空白——用户从聊天工具里复制常带空格。
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 注册。返回 true 表示**还需要去邮箱点确认链接**（服务端没给会话），
  /// false 表示已直接登录（关闭了邮箱验证时）。
  ///
  /// 资料会随 user_metadata 一起提交，由数据库的 handle_new_user 触发器写进 profiles
  /// （0032 / 0063）。**这里并存两套契约**，改键名之前先认清自己动的是哪一套：
  ///   · 旧键 name / identity / school_id / enroll_year / major_category / major /
  ///     class_name —— 触发器仍照读（未升级的客户端还在传），**一个都不能改**；
  ///   · 新键 class_id（0063）—— 传了它，服务端就**忽略** major_category / major /
  ///     class_name 这三个派生值，改由所选班级算出来。所以新客户端只传
  ///     name / identity / school_id / enroll_year / class_id。
  /// 值一律传字符串：触发器是用 `->>` 取文本之后再 ::uuid / ::smallint。
  ///
  /// 过期的 class_id（班已停用、不属于所选学校、压根不存在）服务端**静默丢弃**，
  /// 注册照常成功，学生落成「未分班」——所以选班是可选项，端上也不做任何拦截：
  /// 学校可能还没建班，注册后再由学校管理员分配就是了。
  ///
  /// [identity] 只区分「学生 / 申请教师」两种意图：触发器只认字面量 'teacher'
  /// （其余一律落 student），所以这里把 teacherPending 也归一成 'teacher'，
  /// 避免调用方传 teacherPending 反而注册成学生。
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    Identity identity = Identity.student,
    String? schoolId,
    int? enrollYear,
    String? classId,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name.trim(),
          'identity': identity == Identity.student ? 'student' : 'teacher',
          // 空值整条不传：触发器对缺键与空串的处理一致（都落 null），
          // 但少传几个键能让 metadata 干净些。
          'school_id': ?schoolId,
          'enroll_year': ?enrollYear?.toString(),
          'class_id': ?classId,
        },
      );
      return response.session == null;
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 登出（默认 scope=global，撤销 refresh token）。
  /// 即使网络失败，本地会话也会被清掉；调用方不必为失败做额外处理，
  /// 但要知道此时服务端那条会话可能仍有效。
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw mapError(error);
    }
  }
}
