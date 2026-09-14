// 题库底部翻页条：上一页 / 第 N/M 页 / 下一页。
//
// 职责：把「当前第几页、共几页」显示清楚，并在首页禁用「上一页」、末页禁用「下一页」——
// 禁用的表现就是按钮变灰，用户不用点一下才知道到底了。
// 不负责：翻页后的取数（BankPage 的 onPrev/onNext），也不决定页大小（由页面的 pageSize 算页数）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

class BankPager extends StatelessWidget {
  const BankPager({
    super.key,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  /// 当前页，从 1 开始。
  final int page;

  final int pageSize;

  /// 满足条件的总条数（服务端返回的 count）。
  final int total;

  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageCount = total == 0 ? 1 : (total + pageSize - 1) ~/ pageSize;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppMetrics.gapMd.r),
      child: Row(
        children: [
          DuoButton(
            label: '上一页',
            icon: Icons.chevron_left_rounded,
            variant: DuoButtonVariant.outline,
            expand: false,
            compact: true,
            onPressed: page > 1 ? onPrev : null,
          ),
          Expanded(
            child: Text(
              '第 $page / $pageCount 页',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          DuoButton(
            label: '下一页',
            icon: Icons.chevron_right_rounded,
            variant: DuoButtonVariant.outline,
            expand: false,
            compact: true,
            onPressed: page < pageCount ? onNext : null,
          ),
        ],
      ),
    );
  }
}
