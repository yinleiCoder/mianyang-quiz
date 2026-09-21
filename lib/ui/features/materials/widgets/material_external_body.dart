// 「这个格式不能在应用内看」的正文与出路。
//
// 覆盖 Office 四件套、音视频与其它的所有情况。给两块内容：
//   · 说清为什么不能内嵌（而不是含糊地说"暂不支持"，学生会以为是自己手机的问题）；
//   · 两条出路 —— 用其他程序打开 / 保存到本地。
//
// 提示里点明"手机要装了 WPS 之类的程序"，因为这是学生最常撞到的那堵墙：
// 没装的话点「用其他程序打开」会毫无反应，而他们通常归因成"这个 App 坏了"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class MaterialExternalBody extends StatelessWidget {
  const MaterialExternalBody({
    super.key,
    required this.material,
    required this.onOpen,
    required this.onSave,
  });

  final MaterialBrief material;

  /// 「用其他程序打开」。null 表示正在忙（保存中），按钮置灰。
  final VoidCallback? onSave;
  final Future<void> Function() onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = material.type;

    return Center(
      child: MaxWidthBox(
        child: Padding(
          padding: EdgeInsets.all(AppMetrics.gapXl.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppMetrics.gapLg.r),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(type.icon, size: 40.r, color: theme.colorScheme.primary),
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              Text(
                '${type.label} 需要下载后用其他程序打开',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                material.type.wire == 'audio' || material.type.wire == 'video'
                    ? '应用内不做音视频播放器（桌面端没有可用的官方播放器组件），'
                          '打开后会交给系统里的播放器。'
                    : '应用内只能直接看 PDF 与图片。打开后会交给系统里的程序 ——'
                          '手机上需要装 WPS 或 Office，电脑上需要装 Office 或 WPS。',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppMetrics.gapXl.r),
              DuoButton(
                label: '用其他程序打开',
                icon: Icons.open_in_new,
                onPressed: () => onOpen(),
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              DuoButton(
                label: '保存到本地',
                icon: Icons.download_outlined,
                variant: DuoButtonVariant.outline,
                onPressed: onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
