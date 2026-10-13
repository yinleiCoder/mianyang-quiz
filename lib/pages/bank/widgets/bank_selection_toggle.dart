// 题库列表上方那一行：左边「共 N 题」，右边「选题讲练」入口。
//
// 为什么单独成文件：bank_list_region.dart 已经贴着 200 行上限
//（tool/check_architecture.dart 强制），而这一行是自成一体的展示件。
//
// 两件事摆同一行是刻意的（用户 2026-10-12 反馈）：都是"这一屏有什么、能做什么"，
// 原来题量单独占一行、入口又在另一处，中间隔着空行，读起来是两件事。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

class BankSelectionToggle extends StatelessWidget {
  const BankSelectionToggle({
    super.key,
    required this.onStart,
    required this.total,
  });

  /// 进入选题模式。
  final VoidCallback onStart;

  /// 当前筛选条件下的题目总数。
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '共 $total 题',
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onStart,
          icon: Icon(Icons.checklist_rounded, size: 18.r),
          label: const Text('选题讲练'),
        ),
      ],
    );
  }
}
