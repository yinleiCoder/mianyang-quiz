// 「今天该练的都练完了」空态卡：说明下一道到期时间，并给出去题库加练的出口。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class NothingDueCard extends StatelessWidget {
  const NothingDueCard({super.key, required this.plan});

  final LearningPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = plan.nextDueAt;
    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今天该练的都练完了',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            next == null
                ? '明天再来，或者去题库自己挑几道加练。'
                : '下一道到期复习在 ${next.month} 月 ${next.day} 日。也可以去题库自己挑几道加练。',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
