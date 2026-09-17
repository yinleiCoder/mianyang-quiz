// 考试页的两处确认：离开、交卷（以及交卷失败时的重试）。都用同一个面板。
//
// 为什么值得单独抽出来：这两件事都不该悄悄发生——离开会让倒计时继续走，
// 交卷之后就不能再改了。放在一个面板里是为了让"确认"这个动作在考试里长得一样，
// 学生第二次见到它就知道"点上面那个 = 就这么定了"。
//
// 返回 true = 用户点了确认（取消、下滑关闭都返回 false）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

Future<bool> showExamConfirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool danger = false,
}) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.pagePadding,
            0,
            AppMetrics.pagePadding,
            AppMetrics.pagePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapXl),
              DuoButton(
                label: confirmLabel,
                variant: danger
                    ? DuoButtonVariant.danger
                    : DuoButtonVariant.primary,
                onPressed: () => Navigator.of(sheetContext).pop(true),
              ),
              const SizedBox(height: AppMetrics.gapMd),
              DuoButton(
                label: cancelLabel,
                variant: DuoButtonVariant.ghost,
                onPressed: () => Navigator.of(sheetContext).pop(false),
              ),
            ],
          ),
        ),
      );
    },
  );
  return confirmed ?? false;
}
