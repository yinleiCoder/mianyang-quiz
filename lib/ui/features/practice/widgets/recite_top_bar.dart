// 背题页顶栏：进度 + 上一题/下一题。
//
// 与刷题页顶栏的差别：背题不判题、不交卷，所以没有"退出确认"的负担，
// 重点是"我在这一批题里的哪个位置"以及快速翻页。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';

class ReciteTopBar extends StatelessWidget {
  const ReciteTopBar({
    super.key,
    required this.index,
    required this.total,
    this.onPrev,
    this.onNext,
  });

  /// 当前序号，从 1 开始。
  final int index;
  final int total;

  /// 为 null 表示到边界，按钮置灰（不是隐藏——隐藏会让布局跳动）。
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.gapSm,
        vertical: AppMetrics.gapSm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrev,
            icon: Icon(Icons.chevron_left, size: 28.r),
            tooltip: '上一题',
          ),
          Expanded(
            child: Text(
              '$index / $total',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: Icon(Icons.chevron_right, size: 28.r),
            tooltip: '下一题',
          ),
        ],
      ),
    );
  }
}
