// 题目分享链接：拼出来、认出来。
//
// 链接指向**网页端**的题目详情页（`{SHARE_BASE_URL}/bank/{questionId}`，见 env.dart
// 里为什么它和 API_BASE_URL 是两项配置），不是 app 的私有 scheme：
// 收链接的人可能没装客户端，网页端打开就能看；装了客户端的则走"剪贴板识别"
// （用户复制链接 → 回到客户端时弹窗问要不要打开，见 ClipboardLinkListener）。
//
// 客户端不注册系统级的链接处理（Android intent-filter / iOS universal link）：
// 那要改两个平台的原生配置、且 Windows 端根本没有对应机制；
// 剪贴板这条路三个平台一套代码，和百度网盘的分（xiang）享（tong）方式一致。

import 'package:mianyang_quiz/core/config/env.dart';

abstract final class ShareLinks {
  /// `/bank/<uuid>`；uuid 限定为 36 位十六进制加连字符，避免把网页端别的路径误判成题目。
  static final _pattern = RegExp(
    r'/bank/([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})',
  );

  /// 题目分享链接。取的是 **shareBaseUrl**（不是 apiBaseUrl）：开发时后者是本机
  /// dev server，拿它拼出来的链接发给别人打不开。配置全空时返回空串，调用方据此禁用分享。
  static String ofQuestion(String questionId) {
    final base = Env.shareBaseUrl.trim();
    if (base.isEmpty) return '';
    final trimmed = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    return '$trimmed/bank/$questionId';
  }

  /// 从一段文本里认出题目 id：整条链接、或者"文案 + 链接"都行
  /// （转发时常常带着一句话，用户复制的是整条消息）。认不出返回 null。
  static String? questionIdOf(String? text) {
    if (text == null || text.isEmpty) return null;
    return _pattern.firstMatch(text)?.group(1);
  }

  /// 分享给别人的文案：一句话 + 链接。
  static String shareText(String questionId) => '这道题来自绵阳市中职共建题库：${ofQuestion(questionId)}';
}
