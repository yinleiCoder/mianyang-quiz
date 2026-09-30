// 遗忘曲线：**学生自己的实测保持率** vs **艾宾浩斯理论曲线**。
//
// 数据来自 practice_dashboard 的 forgetting_curve（迁移 0067 已经在算），
// 理论线由 utils/forgetting_curve.dart 现算——它是常量，不进数据库。
//
// 横轴是**距上次练同一道题的天数**，不是等距的：服务端按 0/1/2/3/5/7/14/30 分桶，
// 直接拿天数当 x 坐标才能画出真实的曲线形状（等距摆会把长间隔那几档挤在一起）。
//
// **纵轴从 0 起**：理论线会掉到 21%，只画实测线那一小段会让人以为"我掉得很厉害"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/pages/home/widgets/forgetting_curve_chart.dart';
import 'package:mianyang_quiz/values/values.dart';

class ForgettingCurveCard extends StatelessWidget {
  const ForgettingCurveCard({super.key, required this.buckets, this.height = 200});

  /// 服务端分好桶的实测点。可能为空（新手还没复习过任何题）。
  final List<ForgettingBucket> buckets;

  final double height;

  /// 门槛是**两个**可信桶（每桶至少 3 次作答），不是三个。
  ///
  /// 这个数不是拍的，是拿线上真实数据标定的：按「≥3 个可信桶」只有 **10%**
  /// （12/116）练过重复题的学生能看到图，把桶数降到 2 就是 **31%**（36/116）。
  /// 而每个点"至少 3 次作答"这条不动 —— 那是点本身可不可信的底线。
  ///
  /// 线上 7/14/30 天那三档**整库都没数据**（0069 的"当天不重复"刚上不久，
  /// 学生还没练到那些间隔）。所以现在画出来的多半只有前几档，这是数据成熟度
  /// 问题，不是界面问题 —— 会随练习量自己变好。
  List<ForgettingBucket> get _plottable =>
      buckets.where((b) => b.isReliable).toList()..sort((a, b) => a.days.compareTo(b.days));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reliable = _plottable;

    if (reliable.length < 2) {
      return _TooEarly(theme: theme, practiced: buckets.fold(0, (s, b) => s + b.attempts));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 只有 2 档时说明一下：点本身可信，但形状还看不出来。
        // 不说的话，学生会把两个点连成的直线当成"我的遗忘曲线就长这样"。
        if (reliable.length == 2) ...[
          Text(
            '目前只有 ${reliable.first.days} 天与 ${reliable.last.days} 天两档攒够了样本，'
            '曲线还看不出形状——继续练，间隔拉开后会补上后面的档。',
            style: AppTextStyles.caption(context).copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppMetrics.gapMd.r),
        ],
        ForgettingCurveChart(buckets: reliable, height: height),
        SizedBox(height: AppMetrics.gapMd.r),
        // 图注不是客套话：理论线用的是**无意义音节**的经典实验数据（1 天只剩 33%），
        // 而这里练的是有内容的专业课题目，实测线在上方是正常的。
        // 不写清楚，学生只会得出"我比艾宾浩斯强"这个没有信息量的结论。
        Text(
          '理论线是艾宾浩斯用无意义音节测出的基线（1 天后只剩 33%），你练的是有内容的题目，'
          '线在上方是正常的。真正要看的是**它掉得快不快**——某一档掉得特别狠，'
          '就是那一档的复习间隔该缩短。',
          style: AppTextStyles.caption(context).copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// 样本不足时的说明。**这不是空态，是新手的正常状态**：
/// 曲线只统计"同一道题练过两次以上"的间隔，练得少自然没有。
class _TooEarly extends StatelessWidget {
  const _TooEarly({required this.theme, required this.practiced});

  final ThemeData theme;
  final int practiced;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: AppMetrics.gapXl.r),
    child: Column(
      children: [
        Icon(
          Icons.timeline_rounded,
          size: 40.r,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        Text('还没法画出你的遗忘曲线', style: theme.textTheme.titleSmall),
        SizedBox(height: AppMetrics.gapSm.r),
        Text(
          practiced == 0
              ? '同一道题隔几天再练一次，就能看出你忘得有多快了。'
              : '已经有 $practiced 次"隔了一段时间又练"的作答，样本再多一些曲线才可信。',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption(context).copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}
