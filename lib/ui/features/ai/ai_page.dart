// AI 答疑：把 duck.ai 嵌进应用内，学生遇到不会的题可以直接问。
//
// **平台实现已换成 flutter_inappwebview**（原先的官方 webview_flutter 只有 Android/iOS
// 实现，Windows 上没有任何官方 WebView，只能给一个"用浏览器打开"的降级入口）。
// 现在 Android 走系统 WebView、Windows 走 WebView2，两端都是应用内答疑。
//
// Windows 上有两件必须显式处理的事，不处理就是"装完打不开"：
//   1. **userDataFolder 一定要给**。不给的话插件把 nullptr 交给 WebView2，
//      它会默认把用户数据建在 **exe 旁边**；而安装器默认装到 Program Files，
//      普通用户不可写 —— WebView 直接创建失败。指到 %LOCALAPPDATA% 即可。
//   2. 目标机器要有 **WebView2 运行时**（Win11 自带；Win10 一般随 Edge 装上，
//      没有的话安装器可以另带 bootstrapper）。缺了的话 WebView 起不来，
//      此时给一块说明 + 出口，而不是一个永远转圈的白屏。
//
// 顶栏常驻"用浏览器打开"：duck.ai 有 Cloudflare 校验，撞上验证页、或 WebView2 缺失时，
// 用户始终有出口。

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:url_launcher/url_launcher.dart';

const _url = 'https://duck.ai/';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  /// 只有 Windows 需要它（且必须等它建好才渲染 WebView，理由见文件头）。
  WebViewEnvironment? _environment;
  bool _loading = true;

  /// WebView 起不来（多半是缺 WebView2 运行时）——这时给说明与浏览器出口。
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.windows) {
      _prepareWindowsEnvironment();
    }
  }

  /// 建一个把用户数据放进 %LOCALAPPDATA% 的 WebView2 环境。
  ///
  /// 先探一次运行时版本：**没有 WebView2 的机器上，直接 create 的失败方式不一定是个异常**
  ///（底层是异步回调拿到错误 HRESULT），等到那时页面只会一直转圈。
  /// 主动问一句版本号是唯一确定的判据。
  /// LOCALAPPDATA 取不到时退回 null（插件默认行为），总比整个页面挂掉强。
  Future<void> _prepareWindowsEnvironment() async {
    try {
      final version = await WebViewEnvironment.getAvailableVersion();
      if (version == null) {
        if (mounted) {
          setState(() {
            _failed = true;
            _loading = false;
          });
        }
        return;
      }
      final localAppData = Platform.environment['LOCALAPPDATA'];
      final environment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder:
              localAppData == null ? null : '$localAppData\\mianyang_quiz\\webview',
        ),
      );
      if (mounted) setState(() => _environment = environment);
    } catch (_) {
      // 探版本或建环境抛了异常，同样按"这台机器用不了内嵌浏览器"处理
      if (mounted) {
        setState(() {
          _failed = true;
          _loading = false;
        });
      }
    }
  }

  Future<void> _openInBrowser() =>
      launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 答疑'),
        actions: [
          IconButton(
            onPressed: _openInBrowser,
            tooltip: '用浏览器打开',
            icon: const Icon(Icons.open_in_new),
          ),
        ],
      ),
      body: _failed ? _buildUnavailable(context) : _buildWebView(),
    );
  }

  Widget _buildWebView() {
    // Windows 上必须等环境建好再渲染：否则插件会退回默认的 userDataFolder
    //（exe 旁边），前面那一番设置等于白做。
    if (defaultTargetPlatform == TargetPlatform.windows && _environment == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        InAppWebView(
          webViewEnvironment: _environment,
          initialUrlRequest: URLRequest(url: WebUri(_url)),
          initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
          onLoadStop: (_, _) {
            if (mounted) setState(() => _loading = false);
          },
          onReceivedError: (_, request, _) {
            // 只认主文档的错误：子资源（广告、统计脚本）失败不该把整页判成打不开
            if (mounted && (request.isForMainFrame ?? false)) {
              setState(() => _loading = false);
            }
          },
        ),
        if (_loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  /// WebView 不可用（缺 WebView2 运行时）时的说明页。
  Widget _buildUnavailable(BuildContext themeContext) {
    final theme = Theme.of(themeContext);
    return Center(
      child: MaxWidthBox(
        child: Padding(
          padding: EdgeInsets.all(AppMetrics.gapXl.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.travel_explore_outlined,
                size: 56.r,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: AppMetrics.gapLg.r),
              Text('这台电脑打不开内嵌浏览器', style: theme.textTheme.titleMedium),
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                'Windows 上的内嵌浏览器需要 WebView2 运行时（Win11 自带，'
                'Win10 装过 Edge 一般也有）。点下面的按钮会用系统浏览器打开 duck.ai，'
                '登录后体验与手机端一致。',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppMetrics.gapXl.r),
              DuoButton(
                label: '打开 duck.ai',
                icon: Icons.open_in_new,
                onPressed: _openInBrowser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
