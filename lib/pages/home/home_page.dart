// 工作台（首页）：学情总览 + 继续练习入口 + 平台规模 + 遗忘曲线。
//
// 数据全部来自 practice_dashboard 一次 RPC（DashboardStore 持有一份，练习与收藏会让它刷新）。
// 本页**不自己取数**，只读 Store —— 这样交卷后回到首页，数字已经是新的。
//
// 游戏化只做有数据支撑的部分：连续打卡、今日进度、累计正确率、近 12 周热力图。
// 不编造经验值/等级/体力——后端没有这些数据，编出来的数字不可信也不可比。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/home/widgets/active_session_card.dart';
import 'package:mianyang_quiz/pages/home/widgets/forgetting_curve_card.dart';
import 'package:mianyang_quiz/pages/home/widgets/learning_profile_section.dart';
import 'package:mianyang_quiz/pages/home/widgets/home_actions.dart';
import 'package:mianyang_quiz/pages/home/widgets/platform_scale_section.dart';
import 'package:mianyang_quiz/pages/home/widgets/science_note.dart';
import 'package:mianyang_quiz/pages/home/widgets/stat_grid.dart';
import 'package:mianyang_quiz/pages/home/widgets/streak_header.dart';
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
      if (!mounted) return;
      context.read<DashboardStore>().refresh(silent: true);
      // 外壳的 DailyCheckinTracker 已经记过一次；这里再试一次是兜底：
      // 冷启动时它可能比会话恢复更早，或者上一次正好断网。幂等，重复调用无害。
      context.read<CheckinStore>().recordToday();
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
    // 学习画像是学生数据（0128 student_learning_profile）：教师/待审核教师不显示，
    // 与「我的」页（profile_page.dart）同一口径。
    final isStudent = context.select<AuthStore, bool>(
      (auth) => auth.identity == Identity.student,
    );

    return Scaffold(
      body: SafeArea(
        // **不套 MaxWidthBox**：数据页要铺满窗口宽度。
        // 套上之后滚动视图只剩限宽那一条，滚动条就跑到内容区右边而不是窗口侧边，
        // 窗口越宽越明显。（专注型页面如刷题/背题仍限宽——1920px 宽的单道题更难读。）
        child: AsyncView<PracticeDashboard>(
          state: state,
          loadingMessage: '正在加载学情…',
          onRetry: () => context.read<DashboardStore>().refresh(),
          builder: (dashboard) => _DashboardBody(
            name: name,
            dashboard: dashboard,
            isStudent: isStudent,
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.name,
    required this.dashboard,
    required this.isStudent,
  });

  final String name;
  final PracticeDashboard dashboard;
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    final active = dashboard.activeSession;

    // 一屏几块内容依次落位（order 是错开顺序，封顶 6 档）。**只包内容块不包间距**：
    // 空隙本来就看不见，让它占一份错开延迟是白等。
    return ListView(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      children: [
        FadeSlideIn(child: StreakHeader(name: name, dashboard: dashboard)),
        if (active != null) ...[
          const SizedBox(height: AppMetrics.gapLg),
          FadeSlideIn(order: 1, child: ActiveSessionCard(session: active)),
        ],
        // 原理卡片排在热力图与连续打卡区域下方（用户 2026-11-03）；
        // 若有一场没交的练习，继续练习仍排在它前面。
        const SizedBox(height: AppMetrics.gapXl),
        const FadeSlideIn(order: 1, child: ScienceNote()),
        const SizedBox(height: AppMetrics.gapLg),
        const FadeSlideIn(order: 2, child: HomeActions()),
        const SizedBox(height: AppMetrics.gapXl),
        FadeSlideIn(order: 3, child: StatGrid(dashboard: dashboard)),
        const SizedBox(height: AppMetrics.gapXl),
        const FadeSlideIn(order: 4, child: PlatformScaleSection()),
        const SizedBox(height: AppMetrics.gapXl),
        // 学习画像（2026-11-05 用户要求从「我的」挪到首页，放在遗忘曲线上方）。
        // 只对学生显示；组件内部自己兜底加载失败，不拖累这一页的其他区块。
        if (isStudent) ...[
          const FadeSlideIn(order: 4, child: LearningProfileSection()),
          const SizedBox(height: AppMetrics.gapXl),
        ],
        // 与上面那张是同一个话题的两面：**练了多少** vs **记得多牢**。
        // 数据服务端早就在算（迁移 0067 给 practice_dashboard 加了 forgetting_curve），
        // 客户端一直没接——这张图就是把它接上。
        const FadeSlideIn(
          order: 5,
          child: SectionHeader(
            title: '遗忘曲线',
            subtitle: '你自己的保持率 vs 艾宾浩斯理论曲线',
          ),
        ),
        FadeSlideIn(
          order: 6,
          child: DuoCard(
            padding: const EdgeInsets.fromLTRB(
              AppMetrics.gapMd,
              AppMetrics.gapLg,
              AppMetrics.gapLg,
              AppMetrics.gapMd,
            ),
            child: ForgettingCurveCard(buckets: dashboard.forgettingCurve),
          ),
        ),
      ],
    );
  }
}
