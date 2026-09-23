// 修改密码（已登录）：验旧密码 → 设新密码。
//
// 走 Supabase 原生 updateUser（AuthService.updatePassword），不碰 auth.users 的哈希 ——
// 那条路是留给未登录自助重置的（0072）。两条路有一处**刻意**的差别：
// 这里不动其他设备的会话（在电脑上改密码不该把手机踢下线），忘记密码那条会全部踢掉。
//
// 「先验旧密码」这一步不能省：updateUser 本身不要求旧密码，不验就等于"拿到一台
// 已解锁的设备就能改密把号主锁在门外"。
//
// 页面级状态就够（不进 state/）：只有这一页用，进去一次改一次。

import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/repositories/password_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    final current = _current.text;
    final next = _next.text;

    // 逐条拦在最前面：这些都不必跑一趟网络（真正的下限由服务端兜底）
    if (current.isEmpty) return _toast('请输入当前密码');
    if (next.length < 6) return _toast('新密码长度至少 6 位');
    // 上界按**字节**：bcrypt 在 72 字节处截断，GoTrue 对超长密码直接报错
    if (utf8.encode(next).length > 72) {
      return _toast('新密码过长：最多 72 字节（约 24 个汉字）');
    }
    if (next != _confirm.text) return _toast('两次输入的新密码不一致');
    if (next == current) return _toast('新密码不能与当前密码相同');

    setState(() => _saving = true);
    final passwords = context.read<PasswordRepository>();
    try {
      await passwords.changePassword(
        currentPassword: current,
        newPassword: next,
      );
      if (!mounted) return;
      _toast('密码已修改，下次登录请用新密码');
      context.pop();
    } on AppException catch (error) {
      if (!mounted) return;
      _toast(error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption(context)
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: const Text('修改密码')),
      body: SafeArea(
        child: MaxWidthBox(
          child: ListView(
            padding: EdgeInsets.all(AppMetrics.pagePadding.r),
            children: [
              Text('为了确认是你本人，需要先输入当前密码。', style: muted),
              SizedBox(height: AppMetrics.gapXl.r),
              _field(
                controller: _current,
                label: '当前密码',
                icon: Icons.lock_outline_rounded,
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              _field(
                controller: _next,
                label: '新密码',
                hint: '至少 6 位',
                icon: Icons.lock_reset_rounded,
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              _field(
                controller: _confirm,
                label: '确认新密码',
                icon: Icons.lock_reset_rounded,
                action: TextInputAction.done,
              ),
              SizedBox(height: AppMetrics.gapXl.r),
              DuoButton(label: '修改密码', loading: _saving, onPressed: _submit),
              SizedBox(height: AppMetrics.gapSm.r),
              Text('改完后本机保持登录；忘记密码时可在登录页用「手机号/邮箱 + 姓名」自助重置。', style: muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputAction action = TextInputAction.next,
  }) => TextField(
    controller: controller,
    enabled: !_saving,
    obscureText: true,
    textInputAction: action,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    ),
  );
}
