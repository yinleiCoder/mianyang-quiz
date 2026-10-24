// 「我的 → 版本更新」：有新版时显示红色角标，点开可检查/下载。
//
// 与启动时的 UpdateChecker 共用 UpdateStore（查到的结果只有一份）：
// 启动时已经查过就直接显示结果，不重复打 OSS；用户点「重新检查」才 force 再查。
//
// 当前版本号紧跟在入口下面（用户 2026-10-24 要求），不再放在整页最底部：
// 报"版本不对"时，手指就在这一行上，眼睛不用再翻到页尾。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/pages/profile/widgets/profile_entry_tile.dart';
import 'package:mianyang_quiz/pages/profile/widgets/version_update_sheet.dart';
import 'package:provider/provider.dart';

class VersionUpdateTile extends StatelessWidget {
  const VersionUpdateTile({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UpdateStore>();
    final scheme = Theme.of(context).colorScheme;
    final hasUpdate = store.hasUpdate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileEntryTile(
          icon: Icons.system_update_alt_rounded,
          label: '版本更新',
          subtitle: hasUpdate
              ? '发现新版本 ${store.release!.tag}'
              : store.checked && store.release != null
              ? '已是最新版本'
              : '检查有没有新版本',
          onTap: () => showVersionUpdateSheet(context),
          // 有新版时用红色角标替掉箭头：一眼能看出"这里有东西要处理"
          trailing: hasUpdate
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppMetrics.gapXs.r,
                        vertical: 2.r,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.error,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '新',
                        style: TextStyle(
                          color: scheme.onError,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: AppMetrics.gapXs.r),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 22.r,
                      color: scheme.onSurfaceVariant,
                    ),
                  ],
                )
              : null,
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppMetrics.gapLg.r,
            top: AppMetrics.gapXs.r,
          ),
          child: Text(
            Env.appVersion.isEmpty ? '当前版本：开发版' : '当前版本 ${Env.appVersion}',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
