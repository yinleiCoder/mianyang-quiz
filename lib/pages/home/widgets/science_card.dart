// 首页「科学抽题原理」的卡片与数据项。
//
// 从 science_note.dart 拆出来：那个文件负责布局与等高测量（200 行架构检查），
// 卡片本身连同样式一起搬到这儿。四张卡都可点 —— 点开网页端的对应动画章节
//（/showcase/scheduler?scene=…），章节 id 与 lib/showcase-scheduler.js 的 FLUTTER_SCENES 同源。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_item.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class ScienceCard extends StatelessWidget {
  const ScienceCard({super.key, required this.item, this.onTap});

  final ScienceItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DuoCard(
      onTap: onTap,
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 18.r, color: scheme.primary),
              SizedBox(width: AppMetrics.gapXs.r),
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // 可点的视觉提示。**只有真能点时才画**，纯展示时不留这个箭头。
              if (onTap != null) ...[
                SizedBox(width: AppMetrics.gapXs.r),
                Icon(
                  Icons.open_in_new,
                  size: 16.r,
                  color: scheme.onSurfaceVariant,
                  semanticLabel: item.linkLabel ?? '查看动画演示',
                ),
              ],
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Text(
            item.body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
