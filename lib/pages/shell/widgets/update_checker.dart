// 启动时检查更新：有新版本就弹一次弹窗，用户可去下载或稍后再说。
//
// 挂在应用外壳上（登录后的所有页面都在它下面），只在**冷启动后检查一次**：
// 轮询既没必要（一天最多发一版），又会在用户答题时突然弹窗。
//
// 三条不打扰原则：
//   · 调试构建 / 版本号是 dev 的包不检查（开发时天天提示升级毫无意义）；
//   · 同一个新版本只弹一次（记在本地偏好里，"稍后"之后不再烦）；
//   · 接口失败静默跳过（没发过版、限流、断网都算），绝不弹错误框。
//
// 版本清单读 OSS 上的 `client/latest.json`（与网页端下载页同源），
// 具体取数在 AppUpdateRepository；本组件只负责"启动时查一次、有新版本弹一次"。
// 查询结果同时进 UpdateStore，供「我的 → 版本更新」显示红点与手动检查。

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker extends StatefulWidget {
  const UpdateChecker({super.key, required this.child});

  final Widget child;

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  /// 已忽略的版本（用户点过「稍后」）。
  static const _skipKey = 'update.skippedTag';

  @override
  void initState() {
    super.initState();
    // 首帧之后再查：启动路径上不该多一个网络请求挡着
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  bool get _shouldCheck =>
      !kDebugMode &&
      // 版本清单与网页端下载页同源（OSS client/latest.json）
      Env.ossPublicHost.isNotEmpty &&
      !Env.appVersion.contains('-') && // dev 后缀（0.1.0-dev）不检查
      Env.appVersion.isNotEmpty;

  Future<void> _check() async {
    if (!_shouldCheck) return;
    // Store **用的时候才从 context 取**（AGENTS.md：页面不在 widget 里 new 仓储）：
    // 放在 build 里取会让外壳硬依赖这个 provider —— widget 测试跑在 debug 下、
    // 本来就跳过检查，却会因为在装配里少注册一个 provider 而整片红。
    try {
      final store = context.read<UpdateStore>();
      await store.check();
      if (!mounted) return;
      final release = store.release;
      if (release == null || !store.hasUpdate) return;

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString(_skipKey) == release.tag) return;
      // 上面几处 await 之后 context 可能已经失效（用户秒退了页面）
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('发现新版本'),
          content: Text(
            '${release.tag}（当前 ${Env.appVersion}）\n'
            '更新后题库与练习记录都会保留。',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // 记下来：同一个版本不再打扰
                await SharedPreferences.getInstance().then(
                  (p) => p.setString(_skipKey, release.tag),
                );
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('稍后再说'),
            ),
            FilledButton(
              onPressed: () async {
                final url = release.assetUrl ?? release.pageUrl;
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('去下载'),
            ),
          ],
        ),
      );
    } catch (_) {
      // 检查更新是锦上添花：provider 缺失、接口异常、弹窗时机不对……任何环节出问题都静默跳过，
      // 绝不因为它给用户弹错误框（这个 catch 也是"以后忘了注册 provider"的兜底）
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
