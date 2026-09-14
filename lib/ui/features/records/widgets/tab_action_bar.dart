// 列表 Tab 顶部的一行：左边一句说明、右边一个主动作。
//
// 职责：错题本与收藏两个 Tab 都用「开始练习」，把这一行的版式收在一处。
// 不负责：动作本身（点下去做什么由页面给）；空列表时不要用它——
// 那种情况应该整屏是空态，而不是留一个点了会报错的按钮。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

class TabActionBar extends StatelessWidget {
  const TabActionBar({
    super.key,
    required this.hint,
    required this.actionLabel,
    required this.onAction,
  });

  /// 左侧说明（如「按最近答错时间排序」）。
  final String hint;

  final String actionLabel;

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppMetrics.pagePadding.r,
        AppMetrics.gapMd.r,
        AppMetrics.pagePadding.r,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          DuoButton(
            label: actionLabel,
            icon: Icons.play_arrow_rounded,
            variant: DuoButtonVariant.secondary,
            compact: true,
            expand: false,
            onPressed: onAction,
          ),
        ],
      ),
    );
  }
}
