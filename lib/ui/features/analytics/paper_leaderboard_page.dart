// 试卷成绩榜：全班 / 全校 / 全市三档。
//
// 全屏页（在 StatefulShellRoute 之外，与考试页同款）：入口在成绩单与试卷库列表，
// 不占底部导航的位置（5 个 tab 已满，与考试/复习资料同一个判断）。
//
// 数据一次取齐（paper_leaderboard 一个 RPC 回全部：榜单、我的位置、统计、附近段），
// 切档 = 换 p_scope 重新取一次 —— 服务端按调用者身份夹范围（0077 的 resolve_paper_scope），
// 客户端不做任何权限判断。
//
// 数据页**不套 MaxWidthBox**（同题库/记录页）：榜单要铺满窗口宽度，
// 窄屏时它本来就是全宽，宽屏上多出来的宽度给"学校/用时"那一列。
//
// 排版拆成三个文件（页面本体只负责取数与编排）：抬头、我的位置、榜单主体。
// 这是架构守卫的 200 行上限逼出来的拆分——顺带也让每块各管一摊。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/repositories/analytics_repository.dart';
import 'package:mianyang_quiz/ui/core/design/filter_chip_group.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/leaderboard_headline.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/leaderboard_list.dart';
import 'package:mianyang_quiz/ui/features/analytics/widgets/my_rank_card.dart';
import 'package:provider/provider.dart';

class PaperLeaderboardPage extends StatefulWidget {
  const PaperLeaderboardPage({super.key, required this.paperId, this.paperTitle});

  final String paperId;

  /// 卷名（从上一页带过来，省一次往返）：加载期间标题不空着。
  final String? paperTitle;

  @override
  State<PaperLeaderboardPage> createState() => _PaperLeaderboardPageState();
}

class _PaperLeaderboardPageState extends State<PaperLeaderboardPage> {
  AsyncValue<PaperLeaderboard> _state = const AsyncLoading();
  LeaderboardScopeKey _scope = LeaderboardScopeKey.classScope;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final data = await context.read<AnalyticsRepository>().fetchLeaderboard(
        paperId: widget.paperId,
        scope: _scope,
      );
      if (!mounted) return;
      setState(() => _state = AsyncData(data));
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  void _switchScope(LeaderboardScopeKey key) {
    if (key == _scope) return;
    setState(() => _scope = key);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.paperTitle ?? '成绩排行')),
      body: AsyncView<PaperLeaderboard>(
        state: _state,
        loadingMessage: '正在取榜单…',
        onRetry: _load,
        builder: (board) => ListView(
          padding: EdgeInsets.all(AppMetrics.pagePadding.r),
          children: [
            FilterChipGroup<LeaderboardScopeKey>(
              items: LeaderboardScopeKey.values,
              labelOf: (k) => k.label,
              selectedOf: (k) => k == _scope,
              onToggle: _switchScope,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            LeaderboardHeadline(board: board),
            SizedBox(height: AppMetrics.gapMd.r),
            MyRankCard(
              viewer: board.viewer,
              stats: board.stats,
              scopeLabel: board.scope.label,
              viewerNote: board.viewerNote,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            LeaderboardList(board: board),
          ],
        ),
      ),
    );
  }
}
