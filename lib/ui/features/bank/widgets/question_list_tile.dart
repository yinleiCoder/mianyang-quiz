// 题库列表的一行：一张可点的题卡。
//
// 职责：把 QuestionBrief 排成「题型徽标 + 难度 + 题干摘要 + 科目路径 + 题源学校 + 标签」，
// 右侧给一枚收藏心形按钮。
// 不负责：取数、筛选、翻页（都在 BankPage）；也不认识 FavoriteStore——
// 收藏状态与回调由调用方传入，卡片只负责画，以及上报"卡片被点了/心被点了"。
//
// 题干摘要固定最多两行：列表是扫读场景，不限行数会让卡片高度参差、一屏放不下几题。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/ui/core/design/difficulty_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';

class QuestionListTile extends StatelessWidget {
  const QuestionListTile({
    super.key,
    required this.brief,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final QuestionBrief brief;

  /// 是否已收藏。由调用方从 FavoriteStore 读出——卡片自己不去查，也不缓存。
  final bool isFavorite;

  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

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
    final tags = brief.tags.take(3);

    return DuoCard(
      onTap: onTap,
      // 白卡（用户 2026-09-24：题库列表卡片、题目详情、记录页都改白，复盘页不动）
      color: theme.colorScheme.surface,
      padding: EdgeInsets.all(AppMetrics.gapLg.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DuoIconBadge(
            icon: brief.type.icon,
            tone: DuoIconBadgeTone.neutral,
            filled: false,
            size: 40,
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brief.stemText.trim().isEmpty ? '（题干为空）' : brief.stemText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(context),
                ),
                SizedBox(height: AppMetrics.gapSm.r),
                Wrap(
                  spacing: AppMetrics.gapSm.r,
                  runSpacing: AppMetrics.gapXs.r,
                  children: [
                    DuoChip(
                      label: brief.type.label,
                      tone: DuoChipTone.brand,
                      dense: true,
                    ),
                    // 与错题本/收藏/复盘卡片共用同一个标签：以前这里自带一份
                    // 映射，结果「中」在本页是橙色、在其它三处是灰色。
                    DifficultyChip(difficulty: brief.difficulty),
                    for (final tag in tags) DuoChip(label: tag, dense: true),
                  ],
                ),
                if (source.isNotEmpty) ...[
                  SizedBox(height: AppMetrics.gapSm.r),
                  Text(
                    source,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: muted,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          _FavoriteButton(
            isFavorite: isFavorite,
            onToggle: onToggleFavorite,
          ),
        ],
      ),
    );
  }
}

/// 收藏心形。
///
/// 请求中**不禁用**：FavoriteStore 已经做了乐观更新，图标在点击瞬间就变，
/// 禁用只会让人以为点漏了。成功后由调用方 toast。
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onToggle});

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onToggle,
      iconSize: 22.r,
      tooltip: isFavorite ? '取消收藏' : '收藏',
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        // 已收藏才上品牌色；未收藏用中性色，不跟题干抢注意力
        color: isFavorite ? scheme.primary : scheme.onSurfaceVariant,
      ),
    );
  }
}
