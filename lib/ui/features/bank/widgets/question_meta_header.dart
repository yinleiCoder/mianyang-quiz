// 题目详情的元信息条：题型、难度、版本号、入库时间、科目路径、题源学校、标签、署名。
//
// 职责：把"这道题是什么、从哪来、谁做的"的信息按固定层级摆好——
// 先一排徽标（题型/难度/版本/时间），再一行来源（科目路径 · 题源学校），
// 最后一行**两端对齐**：左边标签、右边作者与审核人（谁做的在谁审的旁边最省眼）。
// 不负责：题干与选项（QuestionView）、取数（QuestionDetailPage）。
//
// 拆成独立组件是为了单文件行数，也因此它只认两个纯数据入参、没有任何状态。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/repositories/query/question_credits.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_credits_row.dart';

class QuestionMetaHeader extends StatelessWidget {
  const QuestionMetaHeader({
    super.key,
    required this.brief,
    this.credits = const [],
  });

  final QuestionBrief brief;

  /// 作者 + 两级审核通过人。为空（取不到或已注销）时这一行只剩标签。
  final List<QuestionCredit> credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);
    // 路径与校名任一为空就不留孤零零的分隔点。校名带「题源：」前缀，
    // 与网页端题库详情同一个写法——光写一个校名读不出它是什么
    final source = [
      brief.nodePath,
      if (brief.schoolName.isNotEmpty) '题源：${brief.schoolName}',
    ].where((part) => part.isNotEmpty).join(' · ');
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
        // 标签与署名同一行、两端对齐（左标签 / 右署名）。
        // 两个 Flexible 是必须的：窄屏上各自最多占一半、内部换行，不会撑破布局；
        // 宽屏上两者都取自身宽度，剩下的空间被 spaceBetween 推到中间——
        // 这正是"两端对齐"想要的观感（用 Expanded 会把署名挤到中间而不是右端）。
        if (brief.tags.isNotEmpty || credits.isNotEmpty) ...[
          SizedBox(height: AppMetrics.gapSm.r),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (brief.tags.isNotEmpty)
                Flexible(
                  child: Text('标签：${brief.tags.join('、')}', style: muted),
                ),
              if (brief.tags.isNotEmpty && credits.isNotEmpty)
                SizedBox(width: AppMetrics.gapMd.r),
              if (credits.isNotEmpty)
                Flexible(child: QuestionCreditsRow(credits: credits)),
            ],
          ),
        ],
      ],
    );
  }
}
