// 剪贴板里的题目链接识别：复制了别人的分享链接、回到客户端时弹窗问要不要打开
// （与百度网盘"检测到分享链接"同一套交互）。
//
// 挂在应用外壳上（登录后的所有页面都在它下面），只做三件事：
//   1. 在**回到前台**时读一次剪贴板（AppLifecycleState.resumed）——不做轮询：
//      轮询既费电，又会在用户还在别的 app 里时就抢注意力；
//   2. 认出题目链接（ShareLinks.questionIdOf）且**与上次看到的内容不同**才弹窗
//      （同一条链接只打扰一次；用户重新复制一次会再弹，这是刻意的——
//      重新复制往往就是想再打开一次）；
//   3. 用户点「打开」→ 跳题目详情。
//
// 隐私边界：只读剪贴板、只在本地比对，不外传也不落库；上次看到的文本存在本地
// 偏好里（shared_preferences），仅用于"同一条不重复弹"。

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/config/share_links.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClipboardLinkListener extends StatefulWidget {
  const ClipboardLinkListener({super.key, required this.child});

  final Widget child;

  @override
  State<ClipboardLinkListener> createState() => _ClipboardLinkListenerState();
}

class _ClipboardLinkListenerState extends State<ClipboardLinkListener>
    with WidgetsBindingObserver {
  /// 上次"看过"的剪贴板内容（不是上次弹过的 id）：文本变了才处理。
  static const _seenKey = 'share.clipboard.seen';

  String? _seen;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 冷启动也要看一次：用户常常是"复制链接 → 打开 app"
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    if (_checking) return;
    _checking = true;
    try {
      // **只把读剪贴板包进 try**：它在部分平台会被拒绝（测试环境也没有通道），
      // 而"识别不出来"不该影响任何页面。后面的弹窗/跳转若出错要照常抛出来——
      // 用一个 catch-all 罩住全部，会把"没有 Navigator 所以弹不出窗"这类真问题
      // 静默吞掉，只剩一个"什么都没发生"。
      final String? text;
      try {
        text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      } catch (_) {
        return;
      }
      if (text == null || text.isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final seen = _seen ?? prefs.getString(_seenKey);
      if (text == seen) return; // 同一条内容只看一次
      // 先记账再处理：弹窗是异步的，期间若又收到一次 resumed，不该弹两遍
      _seen = text;
      await prefs.setString(_seenKey, text);

      final questionId = ShareLinks.questionIdOf(text);
      if (questionId == null || !mounted) return;
      await _confirmOpen(questionId);
    } finally {
      _checking = false;
    }
  }

  Future<void> _confirmOpen(String questionId) async {
    final open = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('检测到题目链接'),
        content: const Text('剪贴板里有一条题目分享链接，要打开看看吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('不用了'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('打开题目'),
          ),
        ],
      ),
    );
    if (open != true || !mounted) return;
    unawaited(context.push(AppRoutes.questionDetailOf(questionId)));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
