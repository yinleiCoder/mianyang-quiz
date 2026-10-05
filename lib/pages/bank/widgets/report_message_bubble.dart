// 往来消息的一个气泡（「我的反馈」卡的 ReportThread 里用）。
//
// 单独一个文件是为了行数（AGENTS.md 第三条），不是为了复用 —— 它只有一处调用点。
// 纯展示：消息体 + "我 / 对方" + 时间，颜色从主题取。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class ReportMessageBubble extends StatelessWidget {
  const ReportMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  final QuestionReportMessage message;

  /// 我发的（按 uid 比）。客户端没有 people 加载器，所以只有这两种身份。
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppTextStyles.caption(
      context,
    ).copyWith(color: theme.colorScheme.onSurfaceVariant);

    return Container(
      padding: EdgeInsets.all(AppMetrics.gapSm.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isMine ? '我' : '对方',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(Formatters.dateTime(message.createdAt), style: muted),
            ],
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          Text(message.body, style: AppTextStyles.body(context)),
        ],
      ),
    );
  }
}
