// 分享题目：底部弹层，两条路——调系统分享（微信/QQ/邮件…）或复制链接。
//
// 为什么两条都给：share_plus 在桌面端（Windows）没有可用的系统分享面板，
// 只留"分享到其他应用"会让桌面用户点了没反应；"复制链接"三个平台都能用，
// 也是收链接的人最常走的路径（客户端能识别剪贴板里的题目链接，见 ClipboardLinkListener）。
//
// 复制成功给 toast，不静默——剪贴板是看不见的，用户需要确认。

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/config/share_links.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:share_plus/share_plus.dart';

/// 打开分享弹层。[stem] 只用于让系统分享的预览更可读。
Future<void> showShareQuestionSheet(
  BuildContext context, {
  required String questionId,
  String? stem,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => ShareQuestionSheet(questionId: questionId, stem: stem),
  );
}

class ShareQuestionSheet extends StatelessWidget {
  const ShareQuestionSheet({super.key, required this.questionId, this.stem});

  final String questionId;

  /// 题干摘要（可空）：拼进分享文案，收件人一眼知道是什么题。
  final String? stem;

  Future<void> _share(BuildContext context, String url) async {
    final trimmed = (stem ?? '').trim();
    final preview = trimmed.isEmpty
        ? ''
        : '《${trimmed.length > 40 ? '${trimmed.substring(0, 40)}…' : trimmed}》\n';
    try {
      await SharePlus.instance.share(
        ShareParams(text: '$preview${ShareLinks.shareText(questionId)}'),
      );
    } catch (error) {
      // 桌面端没有系统分享面板时会抛；退回复制，别让用户空手而归
      if (context.mounted) {
        await _copy(context, url, fallbackReason: '$error');
      }
    }
  }

  Future<void> _copy(BuildContext context, String url, {String? fallbackReason}) async {
    if (url.isEmpty) {
      _toast(context, '分享链接不可用（未配置站点地址）');
      return;
    }
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    _toast(
      context,
      fallbackReason == null ? '链接已复制' : '系统分享不可用，已复制链接',
    );
    Navigator.of(context).pop();
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = ShareLinks.ofQuestion(questionId);
    final preview = (stem ?? '').trim();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '分享这道题',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (preview.isNotEmpty) ...[
              const SizedBox(height: AppMetrics.gapXs),
              Text(
                preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppMetrics.gapLg),
            // 把要发出去的链接摆出来：一是让用户知道发的是什么，二是配置指错地方
            //（比如指向本机 dev server）时一眼就能看出来，不用等对方打不开才发现
            if (url.isNotEmpty) ...[
              SelectableText(
                url,
                maxLines: 2,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapMd),
            ],
            DuoButton(
              label: '分享到其他应用',
              icon: Icons.ios_share,
              onPressed: () => _share(context, url),
            ),
            const SizedBox(height: AppMetrics.gapSm),
            DuoButton(
              label: '复制链接',
              icon: Icons.link,
              variant: DuoButtonVariant.outline,
              onPressed: () => _copy(context, url),
            ),
            if (url.isEmpty) ...[
              const SizedBox(height: AppMetrics.gapSm),
              Text(
                '未配置站点地址（API_BASE_URL），链接暂时不可用',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
