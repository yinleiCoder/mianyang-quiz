// 题库空态：区分「筛没了」与「题库本来就空」——两种情况该说的话完全不同。
//
// 职责：给两种空态各自的文案与动作。有筛选条件时提供出口（清除筛选），
// 无条件时说明题目从哪来。空态要回答的是"为什么空、下一步做什么"。
// 不负责：判断是否设了条件（调用方算好 filtered 传进来）、清除后要做什么（onClear）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';

class BankEmptyState extends StatelessWidget {
  const BankEmptyState({
    super.key,
    required this.filtered,
    required this.onClear,
  });

  /// 当前是否有生效的筛选条件。
  final bool filtered;

  /// 清除全部筛选条件。
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (!filtered) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        title: '题库还是空的',
        message: '老师审核通过并入库的题目会出现在这里。',
      );
    }
    return EmptyState(
      icon: Icons.filter_alt_off_outlined,
      title: '没有符合条件的题目',
      message: '换个关键词，或放宽题型、难度与标签再试试。',
      action: DuoButton(
        label: '清除筛选',
        icon: Icons.restart_alt_rounded,
        variant: DuoButtonVariant.outline,
        expand: false,
        onPressed: onClear,
      ),
    );
  }
}
