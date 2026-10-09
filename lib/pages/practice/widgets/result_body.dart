// 结果页的主体：正确率环 + 分项数字 + 下一步入口。
//
// 从 practice_result_page.dart 拆出来：页面负责"取数 + 三态切换"，
// 这里负责"怎么把结算结果画出来"，两件事各自独立。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/practice/widgets/round_nav_buttons.dart';

class ResultBody extends StatelessWidget {
  const ResultBody({super.key, required this.summary, required this.sessionId});

  final FinishSummary summary;
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasWrong = summary.wrong > 0;

    // 交卷那一刻的"落位"：成绩卡先到，按钮组随后跟上。**只是入场**，
    // 不做数字滚动或庆祝特效——成绩是拿来读的，不是拿来炫的。
    //
    // 不计分的那一轮（课堂讲练 / 顺序练习）**只有两个按钮**，两个都换掉了：
    //   · 「逐题复盘」拉的是服务端那场会话——这一轮压根没往服务端写作答，
    //     打开会看到一道都没答的空复盘；
    //   · 「练这些错题」写的是 PracticeSource.wrong，而错题本来自服务端记录——
    //     点下去练的是学生**别处**的错题，跟刚才这几道毫无关系。
    // 与其给两个会误导人的入口，不如给一个"再来一轮"。
    final actions = <Widget>[
      if (summary.scored) ...[
        DuoButton(
          label: '逐题复盘',
          icon: Icons.fact_check_outlined,
          variant: DuoButtonVariant.outline,
          onPressed: () => context.push(AppRoutes.sessionReviewOf(sessionId)),
        ),
        const SizedBox(height: AppMetrics.gapMd),
      ],
      if (summary.scored && hasWrong) ...[
        DuoButton(
          label: '练这些错题',
          icon: Icons.replay,
          // 必须走 startPracticeFrom：直接 push 组卷页会漏掉"写来源"这一步，
          // 组卷页于是拿着上一次的来源抽题（想练错题，抽出来的是题库）。
          onPressed: () => startPracticeFrom(context, PracticeSource.wrong),
        ),
        const SizedBox(height: AppMetrics.gapMd),
      ],
      // 课堂讲练：一轮讲完接着讲哪一轮（0095）。原先这里只有一个「再来一轮」，
      // 而它每次都从第 1 道重新开始——第 101 道之后的题根本到不了。
      // 详细口径与"为什么只挪轮次不直接开练"见 round_nav_buttons.dart。
      if (!summary.scored) ...[
        const RoundNavButtons(),
        const SizedBox(height: AppMetrics.gapMd),
      ],
      DuoButton(
        label: '回到首页',
        variant: DuoButtonVariant.ghost,
        onPressed: () => context.go(AppRoutes.homePath),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        FadeSlideIn(
          child: DuoCard(
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
                    _Stat(
                      label: '用时',
                      value: Formatters.duration(summary.durationMs),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppMetrics.gapXl),
        // 课堂讲练（顺序练习）**不写服务端**：这一轮的对错只在本机算过，
        // 不进错题本、不进正确率、不占当天额度。不写这一句，学生会以为
        // 刚才错的题已经进了错题本，回头找不到。
        if (!summary.scored)
          Padding(
            padding: const EdgeInsets.only(bottom: AppMetrics.gapLg),
            child: Text(
              '本轮为课堂讲练（顺序练习），不计入错题本与学习统计。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
        FadeSlideIn(order: 1, child: Column(children: actions)),
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
