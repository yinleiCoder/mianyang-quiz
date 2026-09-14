// 分页列表的尾巴：还有下一页就是「加载更多」，到底了就是一句收尾。
//
// 职责：把「加载更多 / 没有更多了」统一成一个组件——三个 Tab 的尾巴长得一样，
// 各写一遍迟早会有一处忘了显示 loading，用户连点出两次重复请求。
// 不负责：分页逻辑本身（页码、offset、去重都在页面的 State 里）。
//
// 刻意不用无限滚动：记录类列表通常只想看最近几条，自动加载会让人在滚动时
// 突然被推着往前走；按一下「加载更多」是明确意图。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

class ListFooter extends StatelessWidget {
  const ListFooter({
    super.key,
    required this.hasMore,
    required this.loading,
    required this.onLoadMore,
  });

  /// 还有下一页。
  final bool hasMore;

  /// 正在加载下一页（按钮转圈）。
  final bool loading;

  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppMetrics.gapMd.r),
        child: Text(
          '没有更多了',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption(context)
              .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    return DuoButton(
      label: '加载更多',
      variant: DuoButtonVariant.outline,
      loading: loading,
      onPressed: onLoadMore,
    );
  }
}
