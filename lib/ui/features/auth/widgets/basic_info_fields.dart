// 注册表单开头那三格：姓名 / 邮箱 / 密码。
//
// 职责：把它们总是一起出现的排版、键盘类型与校验收在一处，校验规则只定义一次。
// 不负责：取值与提交——三个 controller 由页面持有（页面要拿它们调 signUp）。
//
// 校验只做「明显不对就拦住」这一层：姓名非空、邮箱像样、密码不少于 6 位
// （6 位是服务端的下限，见 error_mapper 对 password should be at least 的处理）。
// 邮箱格式不写复杂正则：太严会把合法但少见的地址挡在门外，真正的判定在服务端。
//
// 外观不在这里描边：圆角与聚焦描边来自 AppTheme 的 inputDecorationTheme，
// 页面级样式一旦两处都写，换肤时必然打架。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

class BasicInfoFields extends StatelessWidget {
  const BasicInfoFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.enabled = true,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  /// 提交中置 false：输入框变灰，用户能立刻看出「正在处理，别再改了」。
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field(
          controller: nameController,
          label: '姓名',
          icon: Icons.badge_outlined,
          validator: _validateName,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _field(
          controller: emailController,
          label: '邮箱',
          icon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _field(
          controller: passwordController,
          label: '密码',
          hint: '至少 6 位',
          icon: Icons.lock_outline_rounded,
          obscure: true,
          action: TextInputAction.done,
          validator: _validatePassword,
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscure = false,
    TextInputAction action = TextInputAction.next,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    enabled: enabled,
    obscureText: obscure,
    textInputAction: action,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    ),
    validator: validator,
  );
}

String? _validateName(String? input) =>
    (input ?? '').trim().isEmpty ? '请输入姓名' : null;

String? _validatePassword(String? input) =>
    (input ?? '').length < 6 ? '密码长度至少 6 位' : null;

String? _validateEmail(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return '请输入邮箱';
  final at = value.indexOf('@');
  if (at <= 0 || at == value.length - 1 || !value.contains('.')) {
    return '邮箱格式不正确';
  }
  return null;
}
