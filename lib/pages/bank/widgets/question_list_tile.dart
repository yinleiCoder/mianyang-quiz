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
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class QuestionListTile extends StatelessWidget {
  const QuestionListTile({
    super.key,
    required this.brief,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.accuracyAttempts = 0,
    this.accuracyCorrect = 0,
    this.selected,
  });

  final QuestionBrief brief;

  /// 是否已收藏。由调用方从 FavoriteStore 读出——卡片自己不去查，也不缓存。
  final bool isFavorite;

  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  /// 选题讲练模式下这一行是否被选中；**null = 不在选题模式**。
  ///
  /// 放在这里只是为了让卡片长得不一样（勾选框 + 选中底色）：点了之后干什么
  /// 由调用方通过 [onTap] 决定——页面在选题模式下把它接成"切换选中"。
  /// 不新增回调是有意的：多一条回调就多一处可能忘记接线的分支。
  final bool? selected;

  /// 全站作答统计（question_accuracy）。没数据时是 0/0 —— 那时**不渲染**统计标签
  /// （「0 次作答 ≠ 0% 错误率」，摆一个 0% 会被读成"大家都做对了"）。
  final int accuracyAttempts;
  final int accuracyCorrect;

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

    final selected = this.selected;

    return DuoCard(
      onTap: onTap,
      // 白卡（用户 2026-09-24：题库列表卡片、题目详情、记录页都改白，复盘页不动）。
      // 选题模式下选中的行换成 primaryContainer：一屏扫过去能直接数出选了哪几道。
      color: selected == true
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
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
                    // 全站错误率 / 易错标识。没作答记录时整枚不渲染（Wrap 的空孩子
                    // 也会占一个 spacing 的宽度，所以这里必须条件渲染，不能靠内部返回空）。
                    if (accuracyAttempts > 0)
                      AccuracyChip(
                        attempts: accuracyAttempts,
                        correct: accuracyCorrect,
                      ),
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
          // 选题模式下收藏心形让位给勾选框：两个都是"点右边这一小块"，摆一起必然点错。
          // 收藏在选题时也用不上（讲练不写收藏），所以不是"暂时藏起来"而是"换掉"。
          if (selected == null)
            _FavoriteButton(isFavorite: isFavorite, onToggle: onToggleFavorite)
          else
            _SelectionMark(selected: selected),
        ],
      ),
    );
  }
}

/// 选题模式的勾选标记。与行点击是同一个动作（点整张卡也能选中），
/// 所以它本身**不是**按钮——摆在这里只为让"这行能不能选、选没选"一眼可见。
class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Icon(
      selected ? Icons.check_circle : Icons.circle_outlined,
      size: 22.r,
      color: selected ? scheme.primary : scheme.onSurfaceVariant,
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
