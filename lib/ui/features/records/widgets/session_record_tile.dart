// 练习记录列表的一行。
//
// 职责：把一次会话的「来源 / 状态 / 题数 / 正确率 / 用时 / 开始时间」摆成固定版式，
// 并按状态给出不同的主动作——进行中给「继续练习」，已结束给「查看复盘」。
// 不负责：取数与跳转（回调由页面给），也不认识路由。
//
// 进行中的行**不显示正确率**：它的分母是总题数（与交卷结算同口径），
// 没交卷时这个数字会随每答一题往下掉，摆出来只会让人以为「越练越差」。改显示已答进度。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class SessionRecordTile extends StatelessWidget {
  const SessionRecordTile({
    super.key,
    required this.record,
    this.onOpen,
    this.onContinue,
  });

  final PracticeSessionRecord record;

  /// 点整行或「查看复盘」。
  final VoidCallback? onOpen;

  /// 进行中的会话点「继续练习」；为 null 时整行不可点。
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final active = !record.isFinished;
    final action = active ? onContinue : onOpen;

    return DuoCard(
      onTap: action,
      // 白卡（同题库列表；复盘页刻意不改，见 review_question_card.dart）
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppMetrics.gapXs.r,
                  runSpacing: AppMetrics.gapXs.r,
                  children: [
                    DuoChip(
                      label: record.sourceValue.label,
                      tone: DuoChipTone.brand,
                      dense: true,
                    ),
                    DuoChip(
                      label: record.statusValue.label,
                      tone: _statusTone(record.statusValue),
                      dense: true,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Text(
                Formatters.dateTime(record.startedAt),
                style: AppTextStyles.caption(context)
                    .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          Text(_summary(record), style: AppTextStyles.body(context)),
          SizedBox(height: AppMetrics.gapMd.r),
          Align(
            alignment: Alignment.centerRight,
            child: DuoButton(
              label: active ? '继续练习' : '查看复盘',
              icon: active ? Icons.play_arrow_rounded : Icons.receipt_long_outlined,
              variant: active ? DuoButtonVariant.primary : DuoButtonVariant.outline,
              compact: true,
              expand: false,
              onPressed: action,
            ),
          ),
        ],
      ),
    );
  }
}

/// 状态语气：进行中是「待办」、已完成是「成功」、已放弃是中性（不指责用户）。
DuoChipTone _statusTone(SessionStatus status) => switch (status) {
  SessionStatus.active => DuoChipTone.warning,
  SessionStatus.submitted => DuoChipTone.success,
  SessionStatus.abandoned => DuoChipTone.neutral,
};

String _summary(PracticeSessionRecord record) {
  if (!record.isFinished) {
    return '已答 ${record.answeredCount}/${record.totalCount} 题'
        ' · 已对 ${record.correctCount} 题';
  }
  return '共 ${record.totalCount} 题'
      ' · 正确率 ${Formatters.percent(record.accuracy)}'
      ' · 用时 ${Formatters.duration(record.durationMs)}';
}
