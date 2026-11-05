// 推荐练习的阶段卡：标题/说明/前几题的理由 + "开始这 N 道"。
// 阶段由服务端按掌握度与期望正确率划分，客户端只负责展示与启动。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

const _qtypeLabels = {
  'single_choice': '单选',
  'multiple_choice': '多选',
  'true_false': '判断',
  'fill_blank': '填空',
  'short_answer': '主观',
  'composite': '综合',
};

class LearningStageCard extends StatelessWidget {
  const LearningStageCard({super.key, required this.stage, required this.onStart});

  final LearningStage stage;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);
    final items = stage.items;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stage.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text('${items.length} 题', style: caption),
            ],
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          Text(stage.description, style: caption),
          SizedBox(height: AppMetrics.gapSm.r),
          ...items.take(5).map((item) => _ItemRow(item: item)),
          if (items.length > 5)
            Padding(
              padding: EdgeInsets.only(top: AppMetrics.gapXs.r),
              child: Text('还有 ${items.length - 5} 题…', style: caption),
            ),
          SizedBox(height: AppMetrics.gapSm.r),
          DuoButton(
            label: '开始这 ${items.length} 道',
            icon: Icons.play_arrow,
            onPressed: items.isEmpty ? null : onStart,
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final RecommendedItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);
    final qtype = _qtypeLabels[item.qtype] ?? item.qtype;
    final evidence = [
      '掌握 ${masteryPercent(item.pMastery)}',
      '期望正确率 ${masteryPercent(item.pCorrect)}',
      '信息增益 ${item.infoGain == null ? "—" : item.infoGain!.toStringAsFixed(3)}',
    ].join(' · ');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppMetrics.gapXs.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$qtype · ${difficultyShort(item.difficulty)} · ${item.nodeName}',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(reasonLabel(item.reasonCode), style: caption),
            ],
          ),
          Text(evidence, style: caption),
        ],
      ),
    );
  }
}
