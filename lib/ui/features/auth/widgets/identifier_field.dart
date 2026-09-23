// 账号标识输入框（手机号或邮箱）+ 校验规则。登录页与找回密码页共用这一份。
//
// 为什么单独成文件：这条校验的口径**必须两处一致** —— 少打一位手机号时要报
// 「手机号格式不正确」，而不是放过去让服务端当邮箱查、回来报「密码不正确」
// （用户根本想不到是自己号码打错了）。两处各写一遍必然漂移。
//
// 注册页那份没并进来：学生**只能**填手机号、不允许邮箱，是另一条口径，
// 见 ui/features/auth/widgets/basic_info_fields.dart。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/utils/phone.dart';

/// 登录 / 找回密码共用的账号输入框。
class IdentifierField extends StatelessWidget {
  const IdentifierField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    // 用 text 而不是 emailAddress：后者会弹带 @ 的键盘，而学生大多数时候要输的是
    // 纯数字；也不用 phone —— 那个键盘打不出字母，教师输邮箱会被卡住。
    keyboardType: TextInputType.text,
    textInputAction: textInputAction,
    // 不填 autofillHints: email —— 手机号账号占多数，填了会让系统优先弹邮箱自动填充。
    decoration: const InputDecoration(
      labelText: '手机号 / 邮箱',
      prefixIcon: Icon(Icons.person_outline_rounded),
    ),
    validator: validateIdentifier,
    onFieldSubmitted: onFieldSubmitted,
  );
}

/// 账号标识校验：手机号或邮箱，二选一。真正的判定在服务端。
///
/// 分流口径与 core/utils/phone.dart 的 looksLikePhone 一致：**含 @ 当邮箱，否则当手机号**。
String? validateIdentifier(String? input) {
  final value = input?.trim() ?? '';
  if (value.isEmpty) return '请输入手机号或邮箱';

  if (value.contains('@')) {
    // 邮箱只做最宽松的形状检查 —— 太严的正则会合法但少见的地址挡在门外。
    final at = value.indexOf('@');
    if (at <= 0 || at == value.length - 1 || !value.contains('.')) {
      return '邮箱格式不正确';
    }
    return null;
  }

  return normalizePhone(value) == null ? '手机号格式不正确' : null;
}
