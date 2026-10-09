// 顺序讲练（教师讲练）的轮次选择器（0095）。
//
// 为什么需要它：讲练按题库顺序连着过题，一次最多 100 道（0043 的上限），
// 而抽题原先**每次都从第 1 道开始**——"再来一轮"永远拿到同一批前 100 道，
// 题库里第 101 道之后的题根本到不了。轮次就是"这一遍从第几道开始"。
//
// 只给顺序练习用：即时/批量练习按遗忘曲线抽题，没有"第几轮"这回事。
//
// 总数还不知道时（还没问过服务端）**不给**「下一轮」按钮，只说明句：
// 与其让教师点下去被服务端告知"已经是最后一轮了"，不如先不亮那个按钮。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class RoundSelector extends StatelessWidget {
  const RoundSelector({
    super.key,
    required this.round,
    required this.from,
    required this.to,
    required this.total,
    required this.hasPrev,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
  });

  /// 第几轮，1 起。
  final int round;

  /// 本轮覆盖的题目序号区间（1 起，闭区间）。
  final int from;
  final int to;

  /// 符合条件的题目总数；null = 还不知道（这一次开练之后才知道）。
  final int? total;

  final bool hasPrev;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final total = this.total;

    return DuoCard(
      padding: const EdgeInsets.all(AppMetrics.gapMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DuoChip(
                label: '第 $round 轮',
                tone: DuoChipTone.brand,
                dense: true,
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: Text(
                  total == null
                      ? '开始一次后就知道共几轮'
                      : '第 $from–$to 题 · 符合条件的共 $total 道',
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          Row(
            children: [
              Expanded(
                child: DuoButton(
                  label: '上一轮',
                  icon: Icons.arrow_back,
                  variant: DuoButtonVariant.outline,
                  compact: true,
                  onPressed: hasPrev ? onPrev : null,
                ),
              ),
              SizedBox(width: AppMetrics.gapMd.r),
              Expanded(
                child: DuoButton(
                  label: '下一轮',
                  icon: Icons.arrow_forward,
                  variant: DuoButtonVariant.outline,
                  compact: true,
                  onPressed: hasNext ? onNext : null,
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Text(
            total == null
                ? '开始一次讲练后，「下一轮」才会亮起。'
                : '一轮最多 ${to - from + 1} 道题。讲练不计入错题本与学习统计。',
            style: AppTextStyles.caption(context)
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
