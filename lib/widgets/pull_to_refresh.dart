// 下拉刷新容器：把"下拉 → 重查"这件事收口到一处。
//
// 两种形态（[fill]）：
//   · fill = false：直接包住调用方给的列表（列表自己带 AlwaysScrollableScrollPhysics）；
//   · fill = true ：把 child 撑满一屏再包起来 —— 给**空态**用。
//
// 为什么空态要单独一种形态：EmptyState 只会占满父级给的空间、本身不可滚动，
// 直接塞进 RefreshIndicator 是拉不动的（手势没有可滚动的东西）。而"列表空着的时候"
// 恰恰是最想拉一下看看有没有新内容的时候，所以不能不管。
//
// 列表那条分支自己不设 physics：物理特性属于滚动视图（调用方建的那个），
// 在这里塞会被里层的滚动视图覆盖，反而让人以为设过了。

import 'package:material_ui/material_ui.dart';

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.fill = false,
  });

  /// 重查动作。RefreshIndicator 会等它完成再收起指示器。
  final Future<void> Function() onRefresh;

  final Widget child;

  /// true：把 child 放进一个占满一屏、可滚动的容器里（空态专用）。
  final bool fill;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: fill
        ? CustomScrollView(
            // 内容不足一屏时也要能下拉，靠的就是这句
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
          )
        : child,
  );
}
