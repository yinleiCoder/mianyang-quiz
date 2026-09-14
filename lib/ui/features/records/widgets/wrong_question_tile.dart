// 错题本列表的一行。
//
// 职责：题干摘要 + 题型/难度 + 累计答错次数与最后答错时间。
// 不负责：取数与跳转（回调由页面给）、收藏状态（那是收藏页的事）。
//
// 题目下线/删除后服务端返回的是**占位行**（available=false、stem_text 为 null）：
// 这类行要显示「题目已不可用」并**不可点击**。不要把它们过滤掉——
// 用户会以为记录凭空消失，而错题本的价值恰恰在于「错过什么」这件事本身。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/difficulty_chip.dart';

class WrongQuestionTile extends StatelessWidget {
  const WrongQuestionTile({super.key, required this.row, this.onTap});

  final WrongQuestion row;

  /// 点整行进题目详情；available == false 的行会忽略它。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = AppTextStyles.caption(context)
        .copyWith(color: scheme.onSurfaceVariant);
    final available = row.available;

    return DuoCard(
      onTap: available ? onTap : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DuoIconBadge(
            icon: available ? row.type.icon : Icons.block_outlined,
            tone: available ? DuoIconBadgeTone.brand : DuoIconBadgeTone.neutral,
            size: 40,
            filled: false,
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  available ? (row.stemText ?? '') : '题目已不可用',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(context),
                ),
                SizedBox(height: AppMetrics.gapSm.r),
                if (row.hasMeta) ...[
                  Wrap(
                    spacing: AppMetrics.gapXs.r,
                    runSpacing: AppMetrics.gapXs.r,
                    children: [
                      DuoChip(label: row.type.label, dense: true),
                      DifficultyChip(difficulty: row.difficulty),
                    ],
                  ),
                  SizedBox(height: AppMetrics.gapSm.r),
                ],
                Text(
                  available
                      ? '累计答错 ${row.wrongCount} 次'
                            ' · ${Formatters.relative(row.answeredAt)}'
                      : '已下线或被删除，记录仍保留',
                  style: muted,
                ),
              ],
            ),
          ),
          if (available)
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: scheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
