// 题库列表区：选题开关 + 题目列表 + 底部（分页条 或 选题确认条）。
//
// 从 bank_page.dart 抽出来有两个理由：
//   1. 单文件行数（AGENTS.md 三：≤200 行，由 check_architecture 强制）——
//      选题讲练加进来之后页面本体已经装不下；
//   2. 这三块本来就是**一个整体**：底部长什么，取决于上面在不在选题模式。
//      分在两个文件里改，很容易只改半边（比如取消了选题、底部却还留着确认条）。
//
// 它自己不认识数据来源：状态、回调、收藏判定都由页面给（与 BankBody 同一条口径）。
// 唯一自持的是**勾选**——那是纯粹的行内交互，页面不必知道具体勾了哪几道，
// 只在开练时把整份 id 收回去（见 BankSelection）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/bank/bank_selection.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_body.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_pager.dart';

class BankListRegion extends StatelessWidget {
  const BankListRegion({
    super.key,
    required this.state,
    required this.accuracy,
    required this.filtered,
    required this.onClear,
    required this.onRetry,
    required this.onRefresh,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.selection,
    required this.onStartPicked,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.onGoToPage,
  });

  /// 当前这一页的加载状态。
  final AsyncValue<QuestionPage> state;

  final Map<String, QuestionAccuracy> accuracy;
  final bool filtered;
  final VoidCallback onClear;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final bool Function(String questionId) isFavorite;

  /// 非选题模式下点一行：进题目详情。
  final ValueChanged<QuestionBrief> onOpen;
  final ValueChanged<QuestionBrief> onToggleFavorite;

  /// 勾选状态（本组件持有并直接改它，所以是 Listenable 而不是一份值）。
  final BankSelection selection;

  /// 开练：页面拿这份 id 去组卷页。**不在本组件里导航**——那是页面的职责。
  final ValueChanged<List<String>> onStartPicked;

  final int total;
  final int page;
  final int pageSize;
  final ValueChanged<int> onGoToPage;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: selection,
      builder: (context, _) {
        final selecting = selection.active;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 已经在选题模式里就不再给入口——再点一次没有意义
            if (total > 0 && !selecting)
              _SelectionToggle(onStart: selection.begin),
            SizedBox(height: AppMetrics.gapMd.r),
            Expanded(
              child: BankBody(
                state: state,
                accuracy: accuracy,
                filtered: filtered,
                onClear: onClear,
                onRetry: onRetry,
                onRefresh: onRefresh,
                isFavorite: isFavorite,
                selection: selecting ? selection.pickedIds!.toSet() : null,
                // 选题模式下点整行 = 勾选，不再跳详情：否则每勾一道就离开列表一次
                onOpen: selecting
                    ? (brief) => _toggle(context, brief.questionId)
                    : onOpen,
                onToggleFavorite: onToggleFavorite,
              ),
            ),
            if (selecting)
              _SelectionActions(
                count: selection.count,
                onCancel: selection.cancel,
                onStart: () {
                  final ids = selection.take();
                  if (ids.isNotEmpty) onStartPicked(ids);
                },
              )
            else if (total > 0)
              BankPager(
                page: page,
                pageSize: pageSize,
                total: total,
                onPrev: () => onGoToPage(page - 1),
                onNext: () => onGoToPage(page + 1),
              ),
          ],
        );
      },
    );
  }

  void _toggle(BuildContext context, String questionId) {
    if (selection.toggle(questionId)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(BankSelection.limitHint)),
    );
  }
}

/// 未进入选题模式时，列表上方右侧的那个入口。
class _SelectionToggle extends StatelessWidget {
  const _SelectionToggle({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onStart,
        icon: Icon(Icons.checklist_rounded, size: 18.r),
        label: const Text('选题讲练'),
      ),
    );
  }
}

/// 选题模式下的确认条（顶掉分页条的位置）。
class _SelectionActions extends StatelessWidget {
  const _SelectionActions({
    required this.count,
    required this.onCancel,
    required this.onStart,
  });

  final int count;
  final VoidCallback onCancel;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 竖着摆两行，不并排：390 宽下"已选 N 道" + 取消 + 一颗带文字的按钮会挤爆
    // （DuoButton 的中文标签不会自己缩，只会 RenderFlex 溢出）。
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppMetrics.gapMd.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  count == 0
                      ? '点题目右侧的圈勾选'
                      : '已选 $count 道（一轮最多 ${BankSelection.maxPicked} 道）',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(onPressed: onCancel, child: const Text('取消')),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          DuoButton(
            label: count == 0 ? '讲练勾选的题' : '讲练这 $count 道',
            icon: Icons.play_arrow,
            onPressed: count == 0 ? null : onStart,
          ),
        ],
      ),
    );
  }
}
