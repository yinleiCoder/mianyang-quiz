// 一道题的作答统计卡：摘要一行（题号/分值/正确率/作答人数），点开看选项分布与错答名单。
//
// 为什么默认折叠：一份卷子二三十题，全展开要滚很久；而学生真正想看的是"哪几道题全班都错了"。
// 摘要里正确率低于门槛的会标红（门槛与题库页同一条线，见 lib/accuracy.js 的 HIGH_ERROR_RATE）。
//
// 题干不在这里：服务端不下发题干（返回体只有计数与姓名），学生对着题号去成绩单看原题即可。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/analytics/option_stats.dart';
import 'package:mianyang_quiz/data/models/analytics/question_stats.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';

/// 正确率低于它就算"这道题要讲"——与 lib/accuracy.js 的 HIGH_ERROR_RATE（错误率 ≥ 60%）同一条线。
const double _lowCorrectRate = 0.4;

class QuestionStatCard extends StatefulWidget {
  const QuestionStatCard({super.key, required this.stat, required this.qtypeLabel});

  final QuestionStat stat;

  /// 题型中文名（调用方从 qtype_meta 取，避免这里再认一遍题型）。
  final String qtypeLabel;

  @override
  State<QuestionStatCard> createState() => _QuestionStatCardState();
}

class _QuestionStatCardState extends State<QuestionStatCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stat = widget.stat;
    final answered = stat.total - stat.blank;
    final rate = stat.correctRate;
    // null = 还没有判分的作答：显示「—」而不是 0%（0 次作答 ≠ 全错）
    final rateText = rate == null ? '—' : Formatters.percent(rate);
    final rateColor = rate == null
        ? scheme.onSurfaceVariant
        : (rate <= _lowCorrectRate ? scheme.error : context.semantic.success);

    return DuoCard(
      onTap: () => setState(() => _open = !_open),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '第 ${stat.seq} 题',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Text(
                '${widget.qtypeLabel} · ${Formatters.score(stat.score)} 分',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                rateText,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: rateColor,
                ),
              ),
              Icon(
                _open ? Icons.expand_less : Icons.expand_more,
                size: 18.r,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
          Text(
            [
              '作答 $answered/${stat.total}',
              if (stat.blank > 0) '未答 ${stat.blank}',
              if (stat.pending > 0) '待阅卷 ${stat.pending}',
            ].join(' · '),
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          if (_open) ...[
            SizedBox(height: AppMetrics.gapSm.r),
            for (final o in stat.options) _OptionRow(option: o),
            if (stat.textCounts.isNotEmpty) ...[
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                '学生填的内容（只统计频次，不显示是谁填的）',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              for (final t in stat.textCounts.take(6))
                Text(
                  '${t.count} 人 · ${t.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
            ],
            if (stat.wrongStudents.isNotEmpty) ...[
              SizedBox(height: AppMetrics.gapSm.r),
              Text(
                '答错的 ${stat.wrongTotal} 人',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
              SizedBox(height: AppMetrics.gapXs.r),
              Wrap(
                spacing: AppMetrics.gapXs.r,
                runSpacing: AppMetrics.gapXs.r,
                children: [
                  for (final s in stat.wrongStudents)
                    Text(
                      s.label == null ? s.name : '${s.name}（${s.label}）',
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 一个选项：字母 + 文本 + 人数，下面一行是选它的人。
class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final QuestionOptionStat option;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final names = option.students.map((s) => s.name).where((n) => n.isNotEmpty).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: AppMetrics.gapXs.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                option.key,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: option.isAnswer ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: Text(
                  option.text.isEmpty ? '（无文本）' : option.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${option.count} 人',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: option.isAnswer ? scheme.primary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (names.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16.r),
              child: Text(
                names.take(8).join('、') + (names.length > 8 ? ' 等 ${option.count} 人' : ''),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
