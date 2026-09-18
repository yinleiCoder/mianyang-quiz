// 题库页头部：筛选条 + 「共 N 题」。
//
// **标题「题库」已去掉**：底部导航已经标了这是题库，页面顶部再写一遍是重复。
// 但题量数留着 —— 它是学生判断"这个筛选条件命中多少"的唯一依据。
// 位置放在筛选条**下方**：它描述的正是下面那个列表，紧挨着才读得通。
//
// 从 BankPage 里抽出来：一是单文件行数（AGENTS.md 第三条），二是"当前筛选条件显示成
// 什么文案"（科目路径链、标签名）本来就只服务于这块界面，放在一起才读得通。
// 不持状态、不发请求：筛选条件与两个回调都由页面给。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_filter_bar.dart';

class BankHeader extends StatelessWidget {
  const BankHeader({
    super.key,
    required this.total,
    required this.filter,
    required this.nodes,
    required this.tags,
    required this.onOpenSheet,
    required this.onClear,
  });

  /// 命中总数；0 时不显示计数（空题库还标「共 0 题」很刺眼）。
  final int total;

  final QuestionFilter filter;

  /// 参考数据：用来把筛选条件翻译成人看得懂的文案。未就绪时传空集即可（退化为不显示）。
  final List<SubjectNode> nodes;
  final List<QuestionTag> tags;

  final VoidCallback onOpenSheet;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BankFilterBar(
          filter: filter,
          nodePath: _nodePath,
          tagName: _tagName,
          onOpenSheet: onOpenSheet,
          onClear: onClear,
        ),
        // 0 时不显示计数：空题库还标「共 0 题」很刺眼
        if (total > 0) ...[
          SizedBox(height: AppMetrics.gapSm.r),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '共 $total 题',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ],
    );
  }

  /// 已选科目的名称链；科目树未就绪时退化为空串（chip 不显示）。
  String get _nodePath => buildNodeIndex(nodes)(filter.nodeId);

  String get _tagName {
    for (final tag in tags) {
      if (tag.id == filter.tagId) return tag.name;
    }
    return '';
  }
}
