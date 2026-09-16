// 题库页头部：标题 + 「共 N 题」+ 筛选条。
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text('题库', style: AppTextStyles.pageTitle(context)),
            ),
            if (total > 0)
              Text(
                '共 $total 题',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
          ],
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        BankFilterBar(
          filter: filter,
          nodePath: _nodePath,
          tagName: _tagName,
          onOpenSheet: onOpenSheet,
          onClear: onClear,
        ),
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
