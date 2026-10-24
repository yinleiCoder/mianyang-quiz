// 版本更新半屏：当前版本 / 最新版本 / 去下载 / 重新检查。
//
// 单独成文件只是因为 version_update_section.dart 顶到 200 行上限。
// 与本文件配套的是 VersionUpdateTile（入口 + 红点），二者共用 UpdateStore。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开版本更新半屏。
Future<void> showVersionUpdateSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _VersionSheet(),
    );

class _VersionSheet extends StatefulWidget {
  const _VersionSheet();

  @override
  State<_VersionSheet> createState() => _VersionSheetState();
}

class _VersionSheetState extends State<_VersionSheet> {
  @override
  void initState() {
    super.initState();
    // 已经查过就用缓存结果；没查过（例如冷启动被跳过）才真正发请求。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<UpdateStore>().check();
    });
  }

  Future<void> _download(UpdateStore store) async {
    final url = store.downloadUrl;
    if (url == null) return;
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('打不开下载页，请稍后再试')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final store = context.watch<UpdateStore>();
    final current = Env.appVersion.isEmpty ? '开发版' : Env.appVersion;
    final release = store.release;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppMetrics.gapLg.r,
          0,
          AppMetrics.gapLg.r,
          AppMetrics.gapXl.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本更新', style: theme.textTheme.titleLarge),
            SizedBox(height: AppMetrics.gapSm.r),
            Text(
              '当前版本 $current',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            if (store.checking)
              Row(
                children: [
                  SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: AppMetrics.gapSm.r),
                  const Text('正在检查…'),
                ],
              )
            else if (store.hasUpdate && release != null) ...[
              Text(
                '发现新版本 ${release.tag}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(
                '更新后题库与练习记录都会保留。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _download(store),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('去下载新版本'),
                ),
              ),
            ] else if (store.checked) ...[
              Text(
                release == null ? '暂时无法检查更新' : '已是最新版本',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Text(
                release == null
                    ? '暂时取不到版本清单（可能是网络问题），稍后可以再试。'
                    : '当前安装的就是最新版。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ] else
              const Text('还没有检查版本。'),
            SizedBox(height: AppMetrics.gapLg.r),
            Row(
              children: [
                TextButton.icon(
                  onPressed: store.checking
                      ? null
                      : () => context.read<UpdateStore>().check(force: true),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('重新检查'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
