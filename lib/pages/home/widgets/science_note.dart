// 首页「科学抽题原理」四张卡片：科学抽题 / FSRS / BKT / 遗忘曲线。
//
// 用户 2026-11-03：把原理从打卡区里拿出来，做成卡片，排在热力图与连续打卡区域下方。
// 文案与「我的 → 学习计划」同源（values/science_notes.dart）；
// 宽屏两列、窄屏一列。
//
// 四张卡**等高**：先按当前宽度与字号量出最长正文，再给每张卡同一个高度。
// 不用固定 Grid 高，避免窄屏 / 系统字体放大时正文被裁掉。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class ScienceNote extends StatelessWidget {
  const ScienceNote({super.key});

  static const _items = [
    _ScienceItem(
      Icons.filter_alt_outlined,
      '科学抽题',
      ScienceNotes.selection,
    ),
    _ScienceItem(
      Icons.event_repeat_outlined,
      'FSRS 复习排期',
      ScienceNotes.fsrs,
    ),
    _ScienceItem(Icons.insights_rounded, 'BKT 掌握度', ScienceNotes.bkt),
    _ScienceItem(Icons.timeline_rounded, '遗忘曲线', ScienceNotes.forgetting),
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
        final titleWidth = math.max(
          0.0,
          textWidth - 18.r - AppMetrics.gapXs.r,
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
              child: _ScienceCard(item: item),
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

class _ScienceItem {
  const _ScienceItem(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

class _ScienceCard extends StatelessWidget {
  const _ScienceCard({required this.item});

  final _ScienceItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DuoCard(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 18.r, color: scheme.primary),
              SizedBox(width: AppMetrics.gapXs.r),
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Text(
            item.body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
