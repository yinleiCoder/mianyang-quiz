// 试卷库的一行：卷名 + 考试名/科目 + 题数·时长·满分。
//
// 学生挑卷子时先看的是"这是哪场考试"，再看"多长、多少分"——
// 所以卷名最大，考试名紧跟其后（考试名常比卷名更能说明场景，比如"2026 春季期末"）。
//
// 不负责：开考（点击由列表页接、确认框也在那里）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/exam/paper_brief.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';

class ExamPaperTile extends StatelessWidget {
  const ExamPaperTile({
    super.key,
    required this.paper,
    required this.onTap,
    this.starting = false,
  });

  final PaperBrief paper;

  /// 点整张卡即开考。为 null 表示暂不可点（正在开考的那一张）。
  final VoidCallback? onTap;

  /// 正在开考：右侧显示转圈。开考要往返一次服务端，没有反馈会让人以为没点上。
  final bool starting;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DuoCard(
      onTap: starting ? null : onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  paper.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle(context),
                ),
                if (paper.subtitle.isNotEmpty) ...[
                  SizedBox(height: AppMetrics.gapXs.r),
                  Text(
                    paper.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context)
                        .copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
                SizedBox(height: AppMetrics.gapSm.r),
                Text(
                  [
                    '${paper.itemCount} 题',
                    if (paper.paperMeta.isNotEmpty) paper.paperMeta,
                  ].join(' · '),
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          if (starting)
            SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(strokeWidth: 2.4),
            )
          else
            Icon(
              Icons.chevron_right,
              size: 22.r,
              color: scheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
