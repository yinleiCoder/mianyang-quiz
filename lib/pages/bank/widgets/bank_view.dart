// 题库页的排版：头部（筛选条 + 题量）+ 列表区。
//
// 从 bank_page.dart 抽出来的第三个、也是最后一个理由：单文件行数
// （AGENTS.md 三：≤200 行，由 check_architecture 强制）。页面本体负责"状态机"，
// 这里负责"把这些状态摆成什么样"，两件事各自独立——与 ResultBody/PracticeStage 同一分工。
//
// 收藏状态在**本文件**里读 FavoriteStore：它是 pages/bank 的私有组件，
// 允许认识全局状态（受限的是 lib/widgets/ 下的共享组件，见 check_architecture 的分层规则）。
// 这样页面那一侧就不必再为"收藏"多传两个参数。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/bank/bank_reference.dart';
import 'package:mianyang_quiz/pages/bank/bank_selection.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_header.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_list_region.dart';
import 'package:provider/provider.dart';

class BankView extends StatelessWidget {
  const BankView({
    super.key,
    required this.state,
    required this.accuracy,
    required this.filter,
    required this.reference,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.selection,
    required this.onOpenSheet,
    required this.onClearFilter,
    required this.onRetry,
    required this.onRefresh,
    required this.onGoToPage,
    required this.onStartPicked,
    required this.onOpen,
  });

  final AsyncValue<QuestionPage> state;
  final Map<String, QuestionAccuracy> accuracy;
  final QuestionFilter filter;
  final BankReference reference;
  final int total;
  final int page;
  final int pageSize;
  final BankSelection selection;

  final VoidCallback onOpenSheet;
  final VoidCallback onClearFilter;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onGoToPage;
  final ValueChanged<List<String>> onStartPicked;
  final ValueChanged<QuestionBrief> onOpen;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteStore>();

    return SafeArea(
      // **不套 MaxWidthBox**：数据页铺满窗口宽度。限宽会让滚动视图只剩中间那一条，
      // 滚动条就跑到内容区右边而不是窗口侧边，窗口越宽越明显。
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppMetrics.pagePadding.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BankHeader(
              total: total,
              filter: filter,
              nodes: reference.nodes,
              tags: reference.tags,
              onOpenSheet: onOpenSheet,
              onClear: onClearFilter,
            ),
            Expanded(
              child: BankListRegion(
                state: state,
                accuracy: accuracy,
                filtered: filter.hasAny,
                onClear: onClearFilter,
                onRetry: onRetry,
                onRefresh: onRefresh,
                isFavorite: favorites.isFavorite,
                onOpen: onOpen,
                onToggleFavorite: (brief) => toggleFavoriteWithToast(
                  context,
                  questionId: brief.questionId,
                  toggle: context.read<FavoriteStore>().toggle,
                ),
                selection: selection,
                onStartPicked: onStartPicked,
                total: total,
                page: page,
                pageSize: pageSize,
                onGoToPage: onGoToPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
