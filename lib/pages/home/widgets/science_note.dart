// 首页「科学抽题原理」四张卡片：科学抽题 / FSRS / BKT / 遗忘曲线。
//
// 用户 2026-11-03：把原理从打卡区里拿出来，做成卡片，排在热力图与连续打卡区域下方。
// 用户 2026-11-05：四张卡可点击，用 url_launcher 打开网页端对应章节的动画演示。
// 文案与「我的 → 学习计划」同源（values/science_notes.dart）；
// 宽屏两列、窄屏一列。
//
// 四张卡**等高**：先按当前宽度与字号量出最长正文，再给每张卡同一个高度。
// 不用固定 Grid 高，避免窄屏 / 系统字体放大时正文被裁掉。
//
// 卡片本身在 science_card.dart（本文件只做布局与测量）。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_card.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_item.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:url_launcher/url_launcher.dart';

/// 打开链接的方式。测试注入假实现，线上走 url_launcher。
typedef ScienceLinkOpener = Future<void> Function(String url);

class ScienceNote extends StatelessWidget {
  const ScienceNote({super.key, this.onOpen});

  /// 为 null 时用系统浏览器打开。
  final ScienceLinkOpener? onOpen;

  static const _items = [
    ScienceItem(Icons.filter_alt_outlined, '科学抽题', ScienceNotes.selection, 'mix'),
    ScienceItem(Icons.event_repeat_outlined, 'FSRS 复习排期', ScienceNotes.fsrs, 'fsrs'),
    ScienceItem(Icons.insights_rounded, 'BKT 掌握度', ScienceNotes.bkt, 'bkt'),
    ScienceItem(Icons.timeline_rounded, '遗忘曲线', ScienceNotes.forgetting, 'curve'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final scaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppMetrics.gapMd.r;
        // 两张卡片并排需要约 720 的逻辑宽度；再窄就单列，避免正文被挤成窄条。
        final twoColumns = constraints.maxWidth >= 720;
        final itemWidth = twoColumns
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;
        final textWidth = math.max(0.0, itemWidth - gap * 2);
        // 标题行两侧各一个图标（左：分类；右：可点提示），都要从标题宽度里扣掉。
        final titleWidth = math.max(
          0.0,
          textWidth - (18.r + AppMetrics.gapXs.r) * 2,
        );

        // 用与卡片内完全相同的样式量文字：取最长正文，四张卡统一高度。
        final bodyStyle = theme.textTheme.bodySmall!.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.5,
        );
        final titleStyle = theme.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w700,
        );
        var bodyMax = 0.0;
        var titleMax = 0.0;
        for (final item in _items) {
          bodyMax = math.max(
            bodyMax,
            _measure(context, item.body, bodyStyle, textWidth, scaler),
          );
          titleMax = math.max(
            titleMax,
            _measure(context, item.title, titleStyle, titleWidth, scaler),
          );
        }
        final cardHeight =
            bodyMax +
            math.max(titleMax, 18.r) +
            AppMetrics.gapSm.r +
            gap * 2 +
            2; // 边框

        final cards = [
          for (final item in _items)
            SizedBox(
              height: cardHeight,
              child: ScienceCard(
                item: item,
                onTap: () => _open(context, item),
              ),
            ),
        ];

        if (!twoColumns) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) SizedBox(height: gap),
              ],
            ],
          );
        }
        return Column(
          children: [
            for (var i = 0; i < cards.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[i]),
                  SizedBox(width: gap),
                  Expanded(child: cards[i + 1]),
                ],
              ),
              if (i + 2 < cards.length) SizedBox(height: gap),
            ],
          ],
        );
      },
    );
  }

  Future<void> _open(BuildContext context, ScienceItem item) async {
    final url = scienceUrlFor(item);
    final opener = onOpen;
    if (opener != null) {
      await opener(url);
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    // await 之后 context 可能已经失效（用户切走了），必须先判 mounted
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开浏览器，请检查系统是否有可用的默认程序')),
      );
    }
  }

  static double _measure(
    BuildContext context,
    String text,
    TextStyle style,
    double maxWidth,
    TextScaler scaler,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: scaler,
      maxLines: null,
    )..layout(maxWidth: maxWidth);
    return painter.height;
  }
}

/// 卡片对应的网页地址：站点域名 + 动画页 + 章节。
///
/// `shareBaseUrl` 与分享链接同源（生产 `https://myquiz.cn`）；末尾斜杠要削掉，
/// 否则会拼出 `//showcase`。
String scienceUrlFor(ScienceItem item) {
  final base = Env.shareBaseUrl.endsWith('/')
      ? Env.shareBaseUrl.substring(0, Env.shareBaseUrl.length - 1)
      : Env.shareBaseUrl;
  return '$base/showcase/scheduler?scene=${item.scene}';
}
