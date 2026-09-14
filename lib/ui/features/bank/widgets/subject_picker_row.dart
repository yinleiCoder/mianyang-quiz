// 科目选择行：显示已选科目的名称链，点击打开科目树面板。
//
// 职责：把「当前选了什么科目」这件事显示清楚，并转达"要换一个"的意图。
// 不负责：科目树面板本身（SubjectTreeSheet）、名称链怎么算（domain/subject_tree.dart
// 的 buildNodeIndex）。
//
// 显示名称链而不是节点 id：用户认的是"专业目录 / 汽车运用"，不是 uuid。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

class SubjectPickerRow extends StatelessWidget {
  const SubjectPickerRow({super.key, required this.path, required this.onTap});

  /// 已选科目的名称链；空串表示未选（显示「不限」）。
  final String path;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: AppMetrics.gapLg.r),
      ),
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 20.r, color: muted),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(
              path.isEmpty ? '不限（全部科目）' : path,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20.r, color: muted),
        ],
      ),
    );
  }
}
