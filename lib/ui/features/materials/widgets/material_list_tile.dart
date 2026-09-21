// 资料列表里的一行。
//
// 署名与下载次数**不折叠、不进二级页**：那是老师最在意的一行
//（用户原话：标注上传人是谁、所处的学校、下载次数，以此尊重教师的付出），
// 藏起来等于没做。
//
// 纯展示 + 一个回调，不持状态（ui/core 组件的写法，虽然它住在 feature 里）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';

class MaterialListTile extends StatelessWidget {
  const MaterialListTile({
    super.key,
    required this.material,
    required this.nodePath,
    required this.onTap,
  });

  final MaterialBrief material;

  /// 学科 / 专业大类的可读路径；没有归属时是空串。
  final String nodePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = material.type;

    return DuoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppMetrics.gapMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppMetrics.gapSm.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(type.icon, size: 22.r, color: theme.colorScheme.primary),
          ),
          SizedBox(width: AppMetrics.gapMd.r),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        material.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: AppMetrics.gapSm.r),
                    Text(
                      type.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if ((material.description ?? '').isNotEmpty) ...[
                  SizedBox(height: 2.r),
                  Text(
                    material.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                SizedBox(height: AppMetrics.gapSm.r),
                Row(
                  children: [
                    if (nodePath.isNotEmpty) ...[
                      Flexible(
                        child: Text(
                          nodePath,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: AppMetrics.gapSm.r),
                    ],
                    Text(
                      material.sizeLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppMetrics.gapSm.r),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${material.creatorName ?? '上传人已注销'}'
                        '${material.schoolName == null ? '' : ' · ${material.schoolName}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.download_outlined,
                      size: 12.r,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.r),
                    Text(
                      '${material.downloadCount}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
