// 找回密码（未登录自助重置）。
//
// 验证口径：手机号/邮箱 + 注册时填写的姓名，对上即可自己设新密码。
// 判定全在服务端 RPC self_reset_password（supabase/migrations/0072、0073），
// 本页只做格式前置校验 —— 前端能绕，服务端才是边界。
//
// 三个别改的地方：
//   · 标识符**原样**上报，不在端上折成合成邮箱：归一化由 SQL 侧统一做，
//     端上再算一遍就变成两套口径（网页端同样原样上报）。
//   · 服务端返回的是 `{ok, error}` 而**不是**抛错 —— 0073 特意如此：raise 会回滚
//     失败计数，把「1 小时 5 次」的限流整个绕过去。所以必须判 ok，不能只看有没有异常。
//   · 成功后服务端会踢掉该账号的所有会话；这里顺手用新密码登录一次，省得再输一遍。
//     登录失败不算失败：密码已经改好了，回登录页用新密码登即可。

import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/repositories/password_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/auth_scaffold.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/identifier_field.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _busy = false;
  String? _error;
  // 密码已改好但没能自动登录：此时再显示表单没有意义（密码已经不是原来那个了），
  // 给一个收尾状态。
  bool _done = false;

  @override
  void dispose() {
    _identifier.dispose();
    _name.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final signedIn = await context.read<PasswordRepository>().resetPassword(
        identifier: _identifier.text,
        name: _name.text,
        newPassword: _password.text,
      );
      if (!mounted) return;
      // 自动登录成功 → 直接进主页；失败 → 停在收尾态让用户去登录页
      if (signedIn) {
        context.go(AppRoutes.homePath);
      } else {
        setState(() => _done = true);
      }
    } catch (error) {
      // Store 的 _run 已经 mapError 过一次，这里再走一遍兜住本地参数异常（幂等）
      if (!mounted) return;
      setState(() => _error = mapError(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return AuthScaffold(
        title: '密码已重置',
        subtitle: '新密码已经生效，请用它登录。',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DuoButton(
              label: '去登录',
              onPressed: () => context.go(AppRoutes.loginPath),
            ),
          ],
        ),
      );
    }

    return AuthScaffold(
      title: '找回密码',
      subtitle: '用注册时的手机号（或邮箱）和姓名验证身份，然后设置新密码',
      error: _error,
      footer: TextButton(
        onPressed: _busy ? null : () => context.go(AppRoutes.loginPath),
        child: const Text('想起密码了？返回登录'),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IdentifierField(controller: _identifier, enabled: !_busy),
            SizedBox(height: AppMetrics.gapLg.r),
            _nameField(),
            SizedBox(height: AppMetrics.gapLg.r),
            _passwordField(
              controller: _password,
              label: '新密码',
              hint: '至少 6 位',
              validator: _validateNewPassword,
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            _passwordField(
              controller: _confirm,
              label: '确认新密码',
              action: TextInputAction.done,
              validator: (input) =>
                  input != _password.text ? '两次输入的密码不一致' : null,
            ),
            SizedBox(height: AppMetrics.gapXl.r),
            DuoButton(label: '重置密码', loading: _busy, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  /// 姓名必须与注册时填的一字不差（服务端 btrim + 忽略大小写后全等比对）。
  /// 特意不提供"忘记姓名怎么办"的自助路径：那等于把验证降级成"知道手机号即可"。
  Widget _nameField() => TextFormField(
    controller: _name,
    enabled: !_busy,
    decoration: const InputDecoration(
      labelText: '姓名',
      hintText: '注册时填写的姓名',
      prefixIcon: Icon(Icons.badge_outlined),
    ),
    validator: (input) => (input ?? '').trim().isEmpty ? '请输入姓名' : null,
  );

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    String? hint,
    TextInputAction action = TextInputAction.next,
  }) => TextFormField(
    controller: controller,
    enabled: !_busy,
    obscureText: true,
    textInputAction: action,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
    ),
    validator: validator,
  );
}

/// 新密码校验。下界按**字符**（与注册页「至少 6 位」同口径），上界按**字节** ——
/// bcrypt 是在 72 **字节**处截断的（0074），25 个汉字 = 75 字节，
/// 按字符判会放过去、到服务端才被拒。
String? _validateNewPassword(String? input) {
  final value = input ?? '';
  if (value.length < 6) return '密码长度至少 6 位';
  if (utf8.encode(value).length > 72) {
    return '新密码过长：最多 72 字节（约 24 个汉字）';
  }
  return null;
}
