// 密码输入框：带「显示 / 隐藏明文」的眼睛按钮。
//
// 登录、注册、找回密码、修改密码四处共用一份：这四页的密码框外观、提示语
// 与切换行为必须一致，各写一份迟早出现「这页能看明文、那页不能」。
//
// 只做展示层：取值、校验与提交仍由页面持有；toggle 只改 obscureText，
// 不碰 controller 的内容与光标位置。

import 'package:material_ui/material_ui.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = '密码',
    this.hint,
    this.enabled = true,
    this.prefixIcon = Icons.lock_outline_rounded,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;

  /// 提交中置 false：输入框与眼睛按钮一起变灰。
  final bool enabled;

  final IconData prefixIcon;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  void _toggle() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscured,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: IconButton(
          onPressed: widget.enabled ? _toggle : null,
          icon: Icon(
            _obscured
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          tooltip: _obscured ? '显示密码' : '隐藏密码',
        ),
      ),
    );
  }
}
