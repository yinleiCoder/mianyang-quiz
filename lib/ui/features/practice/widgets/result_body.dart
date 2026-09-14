// 结果页的主体：正确率环 + 分项数字 + 下一步入口。
//
// 从 practice_result_page.dart 拆出来：页面负责"取数 + 三态切换"，
// 这里负责"怎么把结算结果画出来"，两件事各自独立。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';

class ResultBody extends StatelessWidget {
  const ResultBody({super.key, required this.summary, required this.sessionId});

  final FinishSummary summary;
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasWrong = summary.wrong > 0;

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        DuoCard(
          padding: const EdgeInsets.all(AppMetrics.gapXl),
          child: Column(
            children: [
              Text(
                Formatters.percent(summary.accuracy),
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              Text(
                '正确率',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.gapLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Stat(label: '答对', value: '${summary.correct}'),
                  _Stat(label: '答错', value: '${summary.wrong}'),
                  _Stat(label: '未作答', value: '${summary.omitted}'),
                  _Stat(label: '用时', value: Formatters.duration(summary.durationMs)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppMetrics.gapXl),
        if (summary.omitted > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: AppMetrics.gapLg),
            child: Text(
              '正确率按总题数计算（含未作答的 ${summary.omitted} 道），与看板口径一致。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        DuoButton(
          label: '逐题复盘',
          icon: Icons.fact_check_outlined,
          variant: DuoButtonVariant.outline,
          onPressed: () => context.push(AppRoutes.sessionReviewOf(sessionId)),
        ),
        const SizedBox(height: AppMetrics.gapMd),
        if (hasWrong)
          DuoButton(
            label: '练这些错题',
            icon: Icons.replay,
            onPressed: () => context.push(AppRoutes.composePath),
          ),
        const SizedBox(height: AppMetrics.gapMd),
        DuoButton(
          label: '回到首页',
          variant: DuoButtonVariant.ghost,
          onPressed: () => context.go(AppRoutes.homePath),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 2.r),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
