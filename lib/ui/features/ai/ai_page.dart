// AI 答疑：把 duck.ai 嵌进应用内，学生遇到不会的题可以直接问。
//
// **平台差异（刻意的，不是没做完）**：官方 webview_flutter 只实现 Android/iOS，
// Windows 上没有官方 WebView；能在 Windows 上跑的 flutter_inappwebview 要求构建机装
// NuGet CLI（本机没有，CI 也要额外装），而且 duck.ai 有 Cloudflare 校验，嵌入式 WebView
// 里经常直接弹验证页。所以在非 Android 平台给一个"在浏览器打开"的入口，而不是塞一个
// 打不开的 WebView 进去假装能用。
//
// 顶栏常驻"用浏览器打开"：Android 上万一撞到 Cloudflare 验证，用户还有出口。

import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _url = 'https://duck.ai/';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  /// 只有 Android 用得上 WebView（见文件头）。其它平台直接给浏览器入口。
  bool get _canEmbed => defaultTargetPlatform == TargetPlatform.android;

  WebViewController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (!_canEmbed) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // 保持登录态：duck.ai 不登录也能用，但登录后聊天记录跟着账号走
      ..setOnConsoleMessage((_) {})
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (mounted && error.isForMainFrame == true) {
              setState(() => _loading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  Future<void> _openInBrowser() =>
      launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: _canEmbed ? _buildWebView() : _buildBrowserFallback(theme),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  /// 非 Android：说明为什么不在应用内打开，并给一个明确的出口。
  Widget _buildBrowserFallback(ThemeData theme) {
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
              Text('AI 答疑在浏览器里打开', style: theme.textTheme.titleMedium),
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                '桌面端没有可用的内嵌浏览器（官方 WebView 只支持手机端），'
                '点下面的按钮会用系统浏览器打开 duck.ai，登录后体验与手机端一致。',
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
