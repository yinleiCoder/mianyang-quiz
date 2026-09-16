// 收藏列表的一行。
//
// 职责：题干摘要 + 题型/难度 + 收藏时间，右侧一个「取消收藏」。
// 不负责：收藏的写入（回调交给页面去调 FavoriteStore，组件不认识 store）。
//
// 与错题本一致：题目下线/删除后是 available=false 的占位行，显示「题目已不可用」、
// 不可点击，但**取消收藏按钮仍要能用**——否则用户没法把一条没用的收藏清掉。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/core/design/difficulty_chip.dart';

class FavoriteQuestionTile extends StatelessWidget {
  const FavoriteQuestionTile({
    super.key,
    required this.row,
    this.onTap,
    this.onRemove,
    this.removing = false,
  });

  final FavoriteQuestion row;

  /// 点整行进题目详情；available == false 的行会忽略它。
  final VoidCallback? onTap;

  /// 「取消收藏」。为 null 时不显示按钮。
  final VoidCallback? onRemove;

  /// 该行正在请求中（按钮转圈），避免连点两次把收藏又切回来。
  final bool removing;

  @override
  Widget build(BuildContext context) {
    final available = row.available;
    final type = row.type;

    return DuoCard(
      onTap: available ? onTap : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DuoIconBadge(
            icon: available ? type.icon : Icons.block_outlined,
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
                Wrap(
                  spacing: AppMetrics.gapXs.r,
                  runSpacing: AppMetrics.gapXs.r,
                  children: [
                    if (available) DuoChip(label: type.label, dense: true),
                    DifficultyChip(difficulty: row.difficulty),
                    if (row.createdAt != null)
                      DuoChip(
                        label: '${Formatters.relative(row.createdAt)}收藏',
                        tone: DuoChipTone.neutral,
                        dense: true,
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          DuoButton(
            label: '取消收藏',
            icon: Icons.bookmark_remove_outlined,
            variant: DuoButtonVariant.ghost,
            compact: true,
            expand: false,
            loading: removing,
            // loading 时 DuoButton 自己不响应点击；置空 onPressed 会连配色一起变成禁用态。
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
