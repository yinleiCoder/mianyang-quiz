// 练习记录 Tab。
//
// 职责：分页拉取本人的练习会话（按开始时间倒序），把空态与两个跳转摆好：
// 进行中→练习页续练、已结束→复盘页。
// 分页状态机在 ui/core/list/paged_list.dart，本文件只回答三个问题：
// 怎么拉一页、空的时候显示什么、一行怎么画。
// 不负责：行怎么画（SessionRecordTile）、复盘页怎么展示。
//
// **记录随时在变，所以回来时重拉一次**（didPopNext）。这不是"顺手刷新"：
// 一场练习作废/交卷之后，列表里那一行还标着「进行中 · 继续练习」，
// 而它下面的按钮会把用户送回一场答不了题的练习（线上"本次练习已结束"的主要来路）。
// 保活（wantKeepAlive）让页面在 Tab 切走时不销毁，也就不会重跑 initState，
// 于是这个刷新只能靠 RouteAware —— 与错题本同一个理由，见 wrong_questions_tab.dart。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/route_observer.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/state/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/session_record_tile.dart';
import 'package:provider/provider.dart';

class PracticeHistoryTab extends StatefulWidget {
  const PracticeHistoryTab({super.key});

  @override
  State<PracticeHistoryTab> createState() => _PracticeHistoryTabState();
}

class _PracticeHistoryTabState extends State<PracticeHistoryTab>
    with
        AutomaticKeepAliveClientMixin,
        PagedListState<PracticeSessionRecord, PracticeHistoryTab>,
        RouteAware {
  /// TabBarView 切走会销毁页面；保活留住滚动位置 —— 但**每行的状态会变**，
  /// 正确性由下面的 RouteAware 兜（从练习页返回时重拉）。
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // 只有真正的 PageRoute 才能订阅；拿不到就放弃订阅，不能因此崩掉整页
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  /// 从练习页/复盘页返回时重拉第一页：那一行的状态很可能已经不是「进行中」了。
  @override
  void didPopNext() => refresh();

  /// 本页四周都要留白（没有顶栏，不必给上面少留）。
  @override
  EdgeInsets get listPadding => EdgeInsets.all(AppMetrics.pagePadding.r);

  @override
  Future<List<PracticeSessionRecord>> fetchPage({
    required int limit,
    required int offset,
  }) => context.read<PracticeRepository>().fetchHistory(limit: limit, offset: offset);

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
    icon: Icons.history_rounded,
    title: '还没有练习记录',
    message: '组一套题练完，成绩与复盘会留在这里',
    action: DuoButton(
      label: '去组卷',
      icon: Icons.edit_note_rounded,
      expand: false,
      // 与其他入口一样先重置草稿来源，否则会沿用上次的「练错题/练收藏」。
      onPressed: () => startPracticeFrom(context, PracticeSource.all),
    ),
  );

  @override
  Widget buildRow(BuildContext context, PracticeSessionRecord record) =>
      SessionRecordTile(
        record: record,
        onContinue: () => context.push(AppRoutes.practiceOf(record.id)),
        onOpen: () => context.push(AppRoutes.sessionReviewOf(record.id)),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildPagedList(context);
  }
}
