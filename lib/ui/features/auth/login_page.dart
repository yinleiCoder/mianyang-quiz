// 登录页。
//
// 职责：收邮箱与密码、调 AuthStore.signIn、成功后回首页。
// 不负责：会话恢复（AuthStore.bootstrap 在启动时做过）与登录后的界面分支
// （那由路由守卫按 profile.identity 决定）。
//
// 失败原因显示在**表单上方的错误条**里而不是只弹 toast：用户点完按钮视线还在
// 输入框附近，toast 几秒后消失，错过就只剩「点了没反应」；错误条会一直留到下次提交。
//
// 字段外观全部来自 AppTheme 的 inputDecorationTheme（大圆角、聚焦时加粗变色的描边），
// 这里不重新描一遍边——否则换肤时两处会打架。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/auth_scaffold.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 提交中直接吞掉重复点击：按钮虽然已被 DuoButton 的 loading 挡住，
    // 键盘上的「完成」键仍会再打一次。
    if (_busy || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await context.read<AuthStore>().signIn(
        email: _email.text,
        password: _password.text,
      );
      if (!mounted) return;
      context.go(AppRoutes.homePath);
    } catch (error) {
      // _run 里已经 mapError 过一次，这里再走一遍是为了兜住参数校验之类的本地异常
      // （mapError 对 AppException 是幂等的）。
      if (!mounted) return;
      setState(() => _error = mapError(error).message);
    } finally {
      // 成功时页面已经被替换掉，这里必须判 mounted，否则 setState 会抛。
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '登录',
      subtitle: '用注册时的邮箱和密码继续刷题',
      error: _error,
      footer: _footer(context),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              enabled: !_busy,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: '邮箱',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: _validateEmail,
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            TextFormField(
              controller: _password,
              enabled: !_busy,
              obscureText: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(
                labelText: '密码',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
              // 密码不做长度校验：老账号的密码规则由服务端说了算，
              // 客户端拦长度只会把能登录的账号拦在门外。
              validator: (input) =>
                  (input == null || input.isEmpty) ? '请输入密码' : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            SizedBox(height: AppMetrics.gapXl.r),
            DuoButton(label: '登录', loading: _busy, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  /// 底部次要动作。主按钮只有一个，这里要的是「顺手点一下」，所以用文字按钮。
  /// 第二行是给「登不上」的人留的人工通道——站内的意见反馈要登录后才够得着，
  /// 而这批人恰恰最需要找到管理员。
  Widget _footer(BuildContext context) => Column(
    children: [
      TextButton(
        onPressed: _busy ? null : () => context.go(AppRoutes.registerPath),
        child: const Text('还没有账号？去注册'),
      ),
      Text(
        '登录不上或账号有问题？请联系你所在学校的管理员或任课教师。',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption(
          context,
        ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ],
  );
}

/// 邮箱校验。只做「像不像邮箱」这一层，真正的判定在服务端。
/// 太严的本地正则会把合法但少见的地址挡在门外，得不偿失。
String? _validateEmail(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return '请输入邮箱';
  final at = value.indexOf('@');
  if (at <= 0 || at == value.length - 1 || !value.contains('.')) {
    return '邮箱格式不正确';
  }
  return null;
}
