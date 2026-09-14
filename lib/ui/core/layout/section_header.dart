// 区块标题：页面里「标题 + 副标题 + 右侧动作」的一行。
//
// 职责：统一分组标题的字号层级与下方间距（自带宽 gapMd 下边距，紧跟的内容不用再补）。
// 不负责：滚动吸顶（要吸顶请用 SliverPersistentHeader 自己包）、也不负责页面大标题——
// 大标题是 AppTextStyles.pageTitle，一屏一个，不走这里。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;

  /// 副标题：一句说明或计数（如「共 12 题」）。
  final String? subtitle;

  /// 右侧动作，通常是 DuoButton(ghost) 或一行小字。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = AppTextStyles.caption(context)
        .copyWith(color: scheme.onSurfaceVariant);

    return Padding(
      padding: EdgeInsets.only(bottom: AppMetrics.gapMd.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.sectionTitle(context)),
                if (subtitle != null) ...[
                  SizedBox(height: AppMetrics.gapXs.r),
                  Text(subtitle!, style: muted),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: AppMetrics.gapMd.r),
            trailing!,
          ],
        ],
      ),
    );
  }
}
