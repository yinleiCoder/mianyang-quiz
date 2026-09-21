// 「今天的题都练完了」面板 —— 抽题闸门（0069）挡住重复时弹的那个。
//
// 为什么要有这个面板，而不是直接报错、也不是直接放行：
//   · 直接放行 = 学生刚做完的题立刻又抽到（线上实测：53 分钟里同一批 19 道题发了 19 遍，
//     重复间隔中位数 3.5 分钟）。这正是学生反馈的"重复题目出现多次"。
//   · 直接报错 = 题库只有 152 道、一天能做 200+ 次作答，学生会在教室里撞墙，
//     而且没有出口。
// 所以：默认不发（保护"不重复"），但把放宽的决定权交给学生自己按。
//
// 返回 true = 学生选了「仍然加练」，调用方带 p_allow_same_day 再调一次即可。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/practice/start_outcome.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';

Future<bool> showNothingDueSheet(
  BuildContext context,
  PracticeNothingDue outcome,
) async {
  final again = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    isDismissible: true,
    builder: (context) {
      final theme = Theme.of(context);
      final due = outcome.nextDueAt;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.pagePadding,
            0,
            AppMetrics.pagePadding,
            AppMetrics.pagePadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '今天的题都练完了',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              Text(
                '符合条件的题今天已经练过 ${outcome.sameDayCount} 道了。'
                '按遗忘曲线，同一道题要隔一段时间再做才有复习效果'
                '${due == null ? '，下一批题目还没到复习时间' : '，下一批要到 '
                    '${Formatters.dateTime(due)} 才到期'}。',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapLg),
              DuoButton(
                label: '仍然加练（会重复今天练过的题）',
                icon: Icons.replay,
                onPressed: () => Navigator.of(context).pop(true),
              ),
              const SizedBox(height: AppMetrics.gapSm),
              DuoButton(
                label: '先不练了',
                variant: DuoButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              SizedBox(height: 4.r),
            ],
          ),
        ),
      );
    },
  );
  return again ?? false;
}
