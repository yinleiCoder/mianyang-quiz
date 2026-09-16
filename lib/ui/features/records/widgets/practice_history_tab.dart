// 练习记录 Tab。
//
// 职责：分页拉取本人的练习会话（按开始时间倒序），把空态与两个跳转摆好：
// 进行中→练习页续练、已结束→复盘页。
// 分页状态机在 ui/core/list/paged_list.dart，本文件只回答三个问题：
// 怎么拉一页、空的时候显示什么、一行怎么画。
// 不负责：行怎么画（SessionRecordTile）、复盘页怎么展示。
//
// 记录随时在变，换个页面再回来重拉一次反而是对的，所以本页不缓存。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
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
        PagedListState<PracticeSessionRecord, PracticeHistoryTab> {
  /// TabBarView 切走会销毁页面；记录重拉一次不必要，保活更顺手。
  @override
  bool get wantKeepAlive => true;

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
