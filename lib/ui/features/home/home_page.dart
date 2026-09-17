// 工作台（首页）：学情总览 + 继续练习入口 + 最近动态。
//
// 数据全部来自 practice_dashboard 一次 RPC（DashboardStore 持有一份，练习与收藏会让它刷新）。
// 本页**不自己取数**，只读 Store —— 这样交卷后回到首页，数字已经是新的。
//
// 游戏化只做有数据支撑的部分：连续天数、今日进度、累计正确率、近 14 天趋势。
// 不编造经验值/等级/体力——后端没有这些数据，编出来的数字不可信也不可比。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/ui/core/charts/daily_trend_chart.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_stat_tile.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/active_session_card.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/home_actions.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/recent_answers_section.dart';
import 'package:mianyang_quiz/ui/features/home/widgets/streak_header.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 进页面刷新一次；不阻塞首帧（Store 里有旧数据就先显示旧的）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DashboardStore>().refresh(silent: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // select 而不是 watch：两个 Store 都是全局的。watch 整店会让首页——连同里面的
    // 趋势图（fl_chart 是带 150ms 隐式动画的组件）——因为无关的状态变化重建一次，
    // 比如 AuthStore 每次 _run 都会通知两次（busy 置位、复位）。
    final state = context.select<DashboardStore, AsyncValue<PracticeDashboard>>(
      (store) => store.state,
    );
    final name = context.select<AuthStore, String>((auth) => auth.displayName);

    return Scaffold(
      body: SafeArea(
        // **不套 MaxWidthBox**：数据页要铺满窗口宽度。
        // 套上之后滚动视图只剩限宽那一条，滚动条就跑到内容区右边而不是窗口侧边，
        // 窗口越宽越明显。（专注型页面如刷题/背题仍限宽——1920px 宽的单道题更难读。）
        child: AsyncView<PracticeDashboard>(
          state: state,
          loadingMessage: '正在加载学情…',
          onRetry: () => context.read<DashboardStore>().refresh(),
          builder: (dashboard) => _DashboardBody(name: name, dashboard: dashboard),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.name, required this.dashboard});

  final String name;
  final PracticeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final active = dashboard.activeSession;

    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        StreakHeader(name: name, dashboard: dashboard),
        if (active != null) ...[
          const SizedBox(height: AppMetrics.gapLg),
          ActiveSessionCard(session: active),
        ],
        const SizedBox(height: AppMetrics.gapLg),
        const HomeActions(),
        const SizedBox(height: AppMetrics.gapXl),
        _StatGrid(dashboard: dashboard),
        const SizedBox(height: AppMetrics.gapXl),
        const SectionHeader(title: '最近做过的题'),
        RecentAnswersSection(answers: dashboard.recent),
        const SizedBox(height: AppMetrics.gapXl),
        const SectionHeader(
          title: '近两周练习',
          subtitle: '每天答对的题数越多，说明手感越稳',
        ),
        DuoCard(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.gapMd,
            AppMetrics.gapLg,
            AppMetrics.gapLg,
            AppMetrics.gapMd,
          ),
          child: DailyTrendChart(daily: dashboard.daily),
        ),
      ],
    );
  }
}

/// 三个累计数字。用 DuoStatTile 而不是自绘，保持与其他页的排版一致。
///
/// **按可用宽度决定并排还是竖排**：每个统计卡里有一个固定 44px 的图标徽标
/// 加上内边距，三个并排实际需要约 480px。窗口更窄时如果强行并排，
/// 标签会被压成一个字（「累计答题」→「累…」），看起来像坏了。
/// 宁可竖排也不截断——数字本身是重点，指标名不能省。
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.dashboard});

  static const double _minWidthForRow = 480;

  final PracticeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      DuoStatTile(
        label: '累计答题',
        value: '${dashboard.totalAnswers}',
        icon: Icons.task_alt,
      ),
      DuoStatTile(
        label: '正确率',
        value: Formatters.percent(dashboard.accuracy),
        icon: Icons.percent,
      ),
      DuoStatTile(
        label: '错题',
        value: '${dashboard.wrongCount}',
        icon: Icons.error_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _minWidthForRow) {
          return Column(
            children: [
              for (final tile in tiles) ...[
                tile,
                if (tile != tiles.last) const SizedBox(height: AppMetrics.gapSm),
              ],
            ],
          );
        }
        return Row(
          children: [
            for (final tile in tiles) ...[
              Expanded(child: tile),
              if (tile != tiles.last) const SizedBox(width: AppMetrics.gapMd),
            ],
          ],
        );
      },
    );
  }
}
