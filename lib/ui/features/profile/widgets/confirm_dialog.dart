// 二次确认弹窗：标题 + 说明 + 取消/确认。
//
// 职责：把「申请教师身份」「退出登录」这类不可随手撤销的动作统一成同一个确认框；
// 危险动作（退出登录）用 error 色标出确认按钮，别让人顺手点过去。
// 不负责：动作本身。返回 true 才算确认——点外面关掉与点「取消」都是 false，
// 调用方不必区分这两种"没确认"。

import 'package:material_ui/material_ui.dart';

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool danger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: danger
                ? TextButton.styleFrom(foregroundColor: scheme.error)
                : null,
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
