// 题库筛选条：已选条件回显 + 打开筛选面板 + 一键清除。
//
// 职责：把 QuestionFilter 里的每个条件渲染成一枚 chip，让用户一眼看到"现在按什么在筛"，
// 并给出两个动作——打开筛选面板、清除全部条件。
// 不负责：条件的选择与编辑（BankFilterSheet）、列表加载（BankPage）；
// 它是个纯展示 + 两个回调的组件，自己不持状态。
//
// chips 横向滚动而不是换行：筛选条高度固定，列表区就不会因为多选了两个条件而上下跳。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class BankFilterBar extends StatelessWidget {
  const BankFilterBar({
    super.key,
    required this.filter,
    required this.onOpenSheet,
    required this.onClear,
    this.nodePath = '',
    this.tagName = '',
  });

  final QuestionFilter filter;

  /// 已选科目节点的名称链（由调用方用 buildNodeIndex 合成）；
  /// 空串表示未选或科目树还没取回来——两种情况下都只是不显示这枚 chip。
  final String nodePath;

  /// 已选标签名，空串表示未选。
  final String tagName;

  final VoidCallback onOpenSheet;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = _chips();
    final hasAny = chips.isNotEmpty;

    return Row(
      children: [
        DuoButton(
          label: '筛选',
          icon: Icons.tune_rounded,
          variant: hasAny
              ? DuoButtonVariant.primary
              : DuoButtonVariant.outline,
          expand: false,
          compact: true,
          onPressed: onOpenSheet,
        ),
        SizedBox(width: AppMetrics.gapSm.r),
        Expanded(
          child: hasAny
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < chips.length; i++) ...[
                        if (i > 0) SizedBox(width: AppMetrics.gapSm.r),
                        chips[i],
                      ],
                    ],
                  ),
                )
              : Text(
                  '未设置筛选条件',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
        ),
        if (hasAny) ...[
          SizedBox(width: AppMetrics.gapSm.r),
          DuoButton(
            label: '清除',
            icon: Icons.close_rounded,
            variant: DuoButtonVariant.ghost,
            expand: false,
            compact: true,
            onPressed: onClear,
          ),
        ],
      ],
    );
  }

  /// 一个条件一枚 chip。顺序固定：关键词 → 科目 → 题型 → 难度 → 标签。
  List<Widget> _chips() {
    final keyword = filter.keyword.trim();
    return [
      if (keyword.isNotEmpty)
        _chip('关键词：$keyword', Icons.search_rounded),
      if (nodePath.isNotEmpty)
        _chip('科目：$nodePath', Icons.account_tree_outlined),
      if (filter.qtypes.isNotEmpty)
        _chip(
          '题型：${filter.qtypes.map((type) => type.label).join('、')}',
          Icons.category_outlined,
        ),
      if (filter.difficulty != null)
        _chip('难度：${difficultyLabel(filter.difficulty)}', Icons.speed_rounded),
      if (tagName.isNotEmpty) _chip('标签：$tagName', Icons.sell_outlined),
    ];
  }

  Widget _chip(String label, IconData icon) =>
      DuoChip(label: label, tone: DuoChipTone.brand, icon: icon, dense: true);
}
