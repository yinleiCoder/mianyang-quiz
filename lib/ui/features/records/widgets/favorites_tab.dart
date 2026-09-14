// 收藏 Tab。
//
// 职责：分页拉取收藏（按收藏时间倒序），提供「开始练习」入口与「取消收藏」。
// 不负责：行怎么画（FavoriteQuestionTile）、收藏状态的全局同步（FavoriteStore 的事）。
//
// 两个刻意的做法：
//   · 拉到数据后把 id 喂给 FavoriteStore.seed——题目详情与题卡的收藏按钮读的是那个
//     Store，不喂会出现「收藏页里明明有、详情页却显示未收藏」。
//   · 取消收藏就地删行而不是重查列表，重查会让刚点的行闪一下还打乱滚动位置。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/favorite_question_tile.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/list_footer.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/tab_action_bar.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 20;

  AsyncValue<List<FavoriteQuestion>> _state =
      const AsyncLoading<List<FavoriteQuestion>>();
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _removingId;

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
      final rows = await context.read<ListRepository>().fetchFavorites(
        limit: _pageSize,
      );
      if (!mounted) return;
      // 只并入、不移除：分页没加载到的行不代表没收藏（FavoriteStore.seed 的约定）。
      context.read<FavoriteStore>().seed(rows.map((row) => row.questionId));
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
      final rows = await context.read<ListRepository>().fetchFavorites(
        limit: _pageSize,
        offset: current.length,
      );
      if (!mounted) return;
      context.read<FavoriteStore>().seed(rows.map((row) => row.questionId));
      setState(() {
        _state = AsyncData([...current, ...rows]);
        _hasMore = rows.length == _pageSize;
        _loadingMore = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      _toast(error.message);
    }
  }

  /// 取消收藏：写的是 FavoriteStore（它负责与题目详情同步），成功后把该行从列表里去掉。
  /// 同一时刻只允许一行在切换：toggle 是「取反」语义，并发点两下会把状态翻回去。
  Future<void> _remove(FavoriteQuestion row) async {
    if (_removingId != null) return;
    setState(() => _removingId = row.questionId);
    try {
      await context.read<FavoriteStore>().toggle(row.questionId);
      if (!mounted) return;
      final current = _state.valueOrNull ?? const <FavoriteQuestion>[];
      setState(() {
        _state = AsyncData([
          for (final item in current)
            if (item.questionId != row.questionId) item,
        ]);
        _removingId = null;
      });
      _toast('已取消收藏');
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _removingId = null);
      _toast(error.message);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                icon: Icons.bookmark_border_rounded,
                title: '还没有收藏的题',
                message: '在题库或题目详情里点收藏，题会收进这里',
                action: DuoButton(
                  label: '去题库看看',
                  icon: Icons.library_books_outlined,
                  variant: DuoButtonVariant.outline,
                  expand: false,
                  onPressed: () => context.push(AppRoutes.bankPath),
                ),
              )
            : _list(value),
    };
  }

  Widget _list(List<FavoriteQuestion> rows) {
    return Column(
      children: [
        TabActionBar(
          hint: '按收藏时间排序',
          actionLabel: '开始练习',
          onAction: () => startPracticeFrom(context, PracticeSource.favorites),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppMetrics.pagePadding.r,
              AppMetrics.gapSm.r,
              AppMetrics.pagePadding.r,
              AppMetrics.pagePadding.r,
            ),
            itemCount: rows.length + 1,
            separatorBuilder: (_, _) => SizedBox(height: AppMetrics.gapMd.r),
            itemBuilder: (context, index) {
              if (index == rows.length) {
                return ListFooter(
                  hasMore: _hasMore,
                  loading: _loadingMore,
                  onLoadMore: _loadMore,
                );
              }
              final row = rows[index];
              return FavoriteQuestionTile(
                row: row,
                removing: _removingId == row.questionId,
                onTap: () =>
                    context.push(AppRoutes.questionDetailOf(row.questionId)),
                onRemove: () => _remove(row),
              );
            },
          ),
        ),
      ],
    );
  }
}
