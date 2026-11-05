// 「为什么推这道题」：把 BKT 掌握度 + FSRS 复习间隔 + 配额压成一句人话。
//
// 只在服务端返回 reason 时渲染（旧会话 / 0137 未执行时整块不出现）。
// 卡片默认折叠，不打断答题；展开后才显示知识点、掌握度与计划复习日期。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class PracticeReasonCard extends StatelessWidget {
  const PracticeReasonCard({super.key, required this.reason});

  final PracticeReason reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = practiceReasonDetail(reason);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: EdgeInsets.symmetric(horizontal: 12.r),
        childrenPadding: EdgeInsets.fromLTRB(12.r, 0, 12.r, 10.r),
        leading: Icon(Icons.auto_awesome_outlined, size: 18.r),
        title: Text('为什么推这道题', style: theme.textTheme.labelLarge),
        subtitle: Text(
          practiceReasonLabel(reason.reasonCode),
          style: theme.textTheme.bodySmall,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(detail, style: theme.textTheme.bodySmall),
          ),
          SizedBox(height: 4.r),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '排序由 BKT 掌握度、FSRS 到期时间与 40/30/10 配额共同决定；当天练过的题不会重复发。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
