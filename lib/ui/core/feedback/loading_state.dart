// 加载中：整屏或整块的等待态。
//
// 职责：居中一个转圈，可选一句说明（如「正在批改…」），让等待有上下文。
// 不负责：骨架屏（列表骨架另行实现）、也不负责超时重试（ErrorState 的事）。
// 转圈颜色来自主题的 progressIndicatorTheme，这里不指定颜色。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});

  /// 可选的说明文案；不传就只显示转圈（短请求别写废话）。
  final String? message;

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
              SizedBox(
                width: 32.r,
                height: 32.r,
                child: const CircularProgressIndicator(strokeWidth: 3),
              ),
              if (message != null) ...[
                SizedBox(height: AppMetrics.gapLg.r),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
