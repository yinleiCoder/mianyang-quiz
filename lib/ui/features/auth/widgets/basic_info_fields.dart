// 注册表单开头那三格：姓名 / 登录账号 / 密码。
//
// 职责：把它们总是一起出现的排版、键盘类型与校验收在一处，校验规则只定义一次。
// 不负责：取值与提交——三个 controller 由页面持有（页面要拿它们调 signUp）。
//
// 校验只做「明显不对就拦住」这一层：姓名非空、账号像样、密码不少于 6 位
// （6 位是服务端的下限，见 error_mapper 对 password should be at least 的处理）。
// 邮箱格式不写复杂正则：太严会把合法但少见的地址挡在门外，真正的判定在服务端。
//
// 外观不在这里描边：圆角与聚焦描边来自 AppTheme 的 inputDecorationTheme，
// 页面级样式一旦两处都写，换肤时必然打架。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/phone.dart';

class BasicInfoFields extends StatelessWidget {
  const BasicInfoFields({
    super.key,
    required this.nameController,
    required this.identifierController,
    required this.passwordController,
    this.isStudent = true,
    this.enabled = true,
  });

  final TextEditingController nameController;
  final TextEditingController identifierController;
  final TextEditingController passwordController;

  /// 学生**必须**用手机号：他们大多没有邮箱、也记不住邮箱，用邮箱注册等于给自己
  /// 埋一个「找不回账号」的坑（何况现在是免短信方案，忘密码只能找管理员重置）。
  /// 教师两头都行 —— 不少老师的邮箱是学校统一发的。与网页端注册表单同口径。
  final bool isStudent;

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
          controller: identifierController,
          label: isStudent ? '手机号（登录账号）' : '手机号 / 邮箱（登录账号）',
          hint: isStudent ? '11 位手机号' : null,
          icon: isStudent
              ? Icons.smartphone_outlined
              : Icons.person_outline_rounded,
          // 学生确定只输数字，直接上数字键盘；教师可能要输邮箱，得留着字母。
          keyboardType: isStudent ? TextInputType.phone : TextInputType.text,
          validator: (input) =>
              _validateIdentifier(input, isStudent: isStudent),
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

/// 账号标识校验：手机号或邮箱。真正的判定在服务端。
///
/// 分流口径与 core/utils/phone.dart 的 looksLikePhone 一致：**含 @ 当邮箱，否则当手机号**。
String? _validateIdentifier(String? input, {required bool isStudent}) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return isStudent ? '请输入手机号' : '请输入手机号或邮箱';

  final phone = normalizePhone(value);

  // 学生走手机号这一条 —— 邮箱对学生是个坑（大多没邮箱，找回无门）
  if (isStudent) return phone == null ? '请输入 11 位手机号' : null;

  if (value.contains('@')) {
    // 邮箱只做最宽松的形状检查，太严会把合法但少见的地址挡在门外
    final at = value.indexOf('@');
    if (at <= 0 || at == value.length - 1 || !value.contains('.')) {
      return '邮箱格式不正确';
    }
    return null;
  }
  return phone == null ? '手机号格式不正确' : null;
}
