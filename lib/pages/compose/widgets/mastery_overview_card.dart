// 掌握度画像卡：总体掌握度 + 课程节点 + 有足够样本的知识点。
// 每个节点/标签都可以直接"专项练题"——走现有 QuestionFilter 的 nodeId/tagId，
// 不是另一套抽题逻辑。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class MasteryOverviewCard extends StatelessWidget {
  const MasteryOverviewCard({
    super.key,
    required this.profile,
    this.previousOverall,
    this.onPracticeNode,
    this.onPracticeTag,
  });

  final BktProfile profile;

  /// 上一次加载时的总体掌握度（练习回来刷新时用来显示 "+3%"）。
  final double? previousOverall;
  final ValueChanged<String>? onPracticeNode;
  final ValueChanged<String>? onPracticeTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);
    final nodes = profile.nodes.take(4).toList();
    final tags = profile.tags.where((tag) => !tag.insufficient).take(4).toList();
    final overall = profile.overallMastery;
    final delta = overall != null && previousOverall != null
        ? overall - previousOverall!
        : null;
    // BKT 在样本少时基本只有全局先验；少于 10 题就明说"样本不足"。
    final cold = profile.coldStart || profile.itemsCount < 10;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '掌握度画像',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                masteryPercent(overall),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          DuoProgressBar(value: overall ?? 0, showLabel: true),
          SizedBox(height: AppMetrics.gapXs.r),
          Text('${masteryLabel(overall)} · 已练 ${profile.itemsCount} 题', style: caption),
          if (delta != null && delta.abs() >= 0.005)
            Text(
              '较上次 ${delta >= 0 ? '+' : ''}${(delta * 100).round()}%',
              style: caption.copyWith(
                color: delta >= 0 ? theme.colorScheme.primary : theme.colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (cold) ...[
            SizedBox(height: AppMetrics.gapSm.r),
            Text(
              '已练 ${profile.itemsCount} 题，样本不足 10 题；推荐以起步诊断和全局先验为主，掌握度会随作答更新。',
              style: caption,
            ),
          ],
          if (nodes.isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapMd.r),
            Text('课程节点', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            ...nodes.map((node) => _NodeRow(node: node, onPractice: onPracticeNode)),
          ],
          if (tags.isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapMd.r),
            Text(
              '知识点（样本 ≥5 次）',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            ...tags.map((tag) => _TagRow(tag: tag, onPractice: onPracticeTag)),
          ],
          SizedBox(height: AppMetrics.gapSm.r),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppMetrics.gapSm.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 怎么判断',
                  style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppMetrics.gapXs.r),
                Text(
                  '每答一题，用贝叶斯公式更新这道题的掌握概率：答对升、答错降，再乘学习转移 p_T=0.15。',
                  style: caption,
                ),
                Text(
                  'p_S=0.10 是失误率；G 是猜对概率（选择题 1/选项数、判断题 0.5）。',
                  style: caption,
                ),
                Text(
                  '推荐同时看：掌握度（薄弱）、期望正确率（最近发展区）、信息增益（最能区分会/不会）。',
                  style: caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NodeRow extends StatelessWidget {
  const _NodeRow({required this.node, this.onPractice});

  final BktNode node;
  final ValueChanged<String>? onPractice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: AppMetrics.gapSm.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(node.nodeName, style: theme.textTheme.bodyMedium)),
              Text(
                masteryPercent(node.mastery),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (onPractice != null)
                TextButton(
                  onPressed: () => onPractice!(node.nodeId),
                  child: const Text('专项练题'),
                ),
            ],
          ),
          DuoProgressBar(value: node.mastery ?? 0, height: 8),
          Text(
            '已练 ${node.attemptedItems}/${node.totalItems} 题 · ${masteryLabel(node.mastery)}',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tag, this.onPractice});

  final BktTag tag;
  final ValueChanged<String>? onPractice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: AppMetrics.gapSm.r),
      child: Row(
        children: [
          Expanded(child: Text(tag.tagName, style: theme.textTheme.bodyMedium)),
          Text(
            '${masteryPercent(tag.mastery)} · ${tag.attempts} 次',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          if (onPractice != null)
            TextButton(
              onPressed: () => onPractice!(tag.tagId),
              child: const Text('专项练题'),
            ),
        ],
      ),
    );
  }
}
