// 题目详情的元信息条：题型、难度、版本号、入库时间、科目路径、题源学校、标签。
//
// 职责：把 QuestionBrief 里"这道题是什么、从哪来"的信息按固定层级摆好——
// 先一排徽标（题型/难度/版本/时间），再一行来源（科目路径 · 学校），最后标签。
// 不负责：题干与选项（QuestionView）、取数（QuestionDetailPage）。
//
// 拆成独立组件是为了单文件行数，也因此它只认 QuestionBrief 一个入参、没有任何状态。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class QuestionMetaHeader extends StatelessWidget {
  const QuestionMetaHeader({super.key, required this.brief});

  final QuestionBrief brief;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);
    // 路径与校名任一为空就不留孤零零的分隔点
    final source = [brief.nodePath, brief.schoolName]
        .where((part) => part.isNotEmpty)
        .join(' · ');
    final published = Formatters.dateTime(brief.publishedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppMetrics.gapSm.r,
          runSpacing: AppMetrics.gapSm.r,
          children: [
            DuoChip(
              label: brief.type.label,
              tone: DuoChipTone.brand,
              icon: brief.type.icon,
            ),
            if (brief.difficulty != null)
              DuoChip(label: '难度 ${difficultyLabel(brief.difficulty)}'),
            if (brief.versionNo != null) DuoChip(label: '第 ${brief.versionNo} 版'),
            if (published.isNotEmpty) DuoChip(label: '入库 $published'),
          ],
        ),
        if (source.isNotEmpty) ...[
          SizedBox(height: AppMetrics.gapSm.r),
          Text(source, style: muted),
        ],
        if (brief.tags.isNotEmpty) ...[
          SizedBox(height: AppMetrics.gapXs.r),
          Text('标签：${brief.tags.join('、')}', style: muted),
        ],
      ],
    );
  }
}
