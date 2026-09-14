// 错误状态：请求失败时的整屏占位。
//
// 职责：把 message（已经是给用户看的中文）与「重试」按钮摆好，告诉用户发生了什么、能不能重来。
// 不负责：把异常翻译成中文——那是数据层的事（AppException 已带好文案），
// 所以界面层永远不需要认识 Dio / PostgrestException。
//
// onRetry 传了才出现重试按钮：只读页面（如已结束的练习报告）没有可重试的动作。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  /// 面向用户的失败说明（来自数据层，不要塞异常堆栈）。
  final String message;

  /// 重试回调；为 null 时不显示重试按钮。
  final VoidCallback? onRetry;

  /// 标题，默认「出错了」。
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: MaxWidthBox(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(AppMetrics.gapXl.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DuoIconBadge(
                icon: Icons.error_outline_rounded,
                tone: DuoIconBadgeTone.danger,
                size: 64,
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              Text(
                // 默认文案写在这里是刻意的：等 core/constants/strings.dart 落地后
                // 把这两处（含下面的「重试」）搬过去即可，其余组件都不含文案。
                title ?? '出错了',
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle(context),
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(context)
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
              if (onRetry != null) ...[
                SizedBox(height: AppMetrics.gapXl.r),
                DuoButton(
                  label: '重试',
                  icon: Icons.refresh_rounded,
                  variant: DuoButtonVariant.outline,
                  expand: false,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
