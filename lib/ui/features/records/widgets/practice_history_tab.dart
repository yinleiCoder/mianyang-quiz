// 练习记录 Tab。
//
// 职责：分页拉取本人的练习会话（按开始时间倒序），把三态、空态与「加载更多」摆好，
// 并给出两个跳转：进行中→练习页续练、已结束→复盘页。
// 不负责：行怎么画（SessionRecordTile）、复盘页怎么展示。
//
// 分页状态放在本页 State 里而不是全局 Store：这是单页状态，
// 而且记录随时在变，换个页面再回来重拉一次反而是对的。
// 首屏用 AsyncValue 表达三态，续页只把新行接到已有列表后面（失败的续页不清空已加载的内容）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/list_footer.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/session_record_tile.dart';
import 'package:provider/provider.dart';

class PracticeHistoryTab extends StatefulWidget {
  const PracticeHistoryTab({super.key});

  @override
  State<PracticeHistoryTab> createState() => _PracticeHistoryTabState();
}

class _PracticeHistoryTabState extends State<PracticeHistoryTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 20;

  AsyncValue<List<PracticeSessionRecord>> _state =
      const AsyncLoading<List<PracticeSessionRecord>>();
  bool _loadingMore = false;
  bool _hasMore = true;

  /// TabBarView 切走会销毁页面；记录重拉一次不必要，保活更顺手。
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final rows = await context.read<PracticeRepository>().fetchHistory(
        limit: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _state = AsyncData(rows);
        _hasMore = rows.length == _pageSize;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
    }
  }

  Future<void> _loadMore() async {
    final current = _state.valueOrNull;
    if (current == null || _loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);
    try {
      final rows = await context.read<PracticeRepository>().fetchHistory(
        limit: _pageSize,
        offset: current.length,
      );
      if (!mounted) return;
      setState(() {
        _state = AsyncData([...current, ...rows]);
        _hasMore = rows.length == _pageSize;
        _loadingMore = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return switch (_state) {
      AsyncLoading() => const LoadingState(),
      AsyncFailure(:final error) => ErrorState(
        message: error.message,
        onRetry: _load,
      ),
      AsyncData(:final value) =>
        value.isEmpty
            ? EmptyState(
                icon: Icons.history_rounded,
                title: '还没有练习记录',
                message: '组一套题练完，成绩与复盘会留在这里',
                action: DuoButton(
                  label: '去组卷',
                  icon: Icons.edit_note_rounded,
                  expand: false,
                  // 与其他入口一样先重置草稿来源，否则会沿用上次的「练错题/练收藏」。
                  onPressed: () =>
                      startPracticeFrom(context, PracticeSource.all),
                ),
              )
            : _list(value),
    };
  }

  Widget _list(List<PracticeSessionRecord> records) {
    return ListView.separated(
      padding: EdgeInsets.all(AppMetrics.pagePadding.r),
      itemCount: records.length + 1,
      separatorBuilder: (_, _) => SizedBox(height: AppMetrics.gapMd.r),
      itemBuilder: (context, index) {
        if (index == records.length) {
          return ListFooter(
            hasMore: _hasMore,
            loading: _loadingMore,
            onLoadMore: _loadMore,
          );
        }
        final record = records[index];
        return SessionRecordTile(
          record: record,
          onContinue: () => context.push(AppRoutes.practiceOf(record.id)),
          onOpen: () => context.push(AppRoutes.sessionReviewOf(record.id)),
        );
      },
    );
  }
}
