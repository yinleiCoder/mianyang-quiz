// 收藏 Tab。
//
// 职责：分页拉取收藏（按收藏时间倒序），提供「开始练习」入口与「取消收藏」。
// 分页状态机在 ui/core/list/paged_list.dart，本文件只回答三个问题：
// 怎么拉一页、空的时候显示什么、一行怎么画。
// 不负责：行怎么画（FavoriteQuestionTile）、收藏状态的全局同步（FavoriteStore 的事）。
//
// 两个刻意的做法：
//   · 拉到数据后把 id 喂给 FavoriteStore.seed（见 onPageLoaded）——题目详情与题卡的
//     收藏按钮读的是那个 Store，不喂会出现「收藏页里明明有、详情页却显示未收藏」。
//   · 取消收藏就地删行（updateRows）而不是重查列表，重查会让刚点的行闪一下还打乱滚动位置。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/favorite_question_tile.dart';
import 'package:mianyang_quiz/state/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/tab_action_bar.dart';
import 'package:provider/provider.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab>
    with AutomaticKeepAliveClientMixin, PagedListState<FavoriteQuestion, FavoritesTab> {
  /// TabBarView 切走会销毁页面；收藏不会自己变，保活更顺手。
  @override
  bool get wantKeepAlive => true;

  /// 正在取消收藏的那一行。同一时刻只允许一行在切换：
  /// toggle 是「取反」语义，并发点两下会把状态翻回去。
  String? _removingId;

  FavoriteStore? _store;

  @override
  void initState() {
    super.initState();
    // 这一页是 keepAlive 的，而底部导航（StatefulShellRoute.indexedStack）不会销毁分支：
    // 用户在题库里收藏完再切回来，列表还是打开时的样子——「收藏了却不显示」就是这么来的。
    // 所以盯住全局收藏状态：多了列表里没有的 → 重查第一页；少了的（别处取消）→ 就地删行。
    _store = context.read<FavoriteStore>();
    _store!.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _store?.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (!mounted) return;
    final loaded = rows;
    // 首屏还在路上（AsyncLoading）：这一趟本来就会带上最新状态，别插队
    if (loaded == null) return;
    final known = _store!.knownIds;
    final loadedIds = loaded.map((row) => row.questionId).toSet();
    final gone = loadedIds.difference(known);
    final added = known.difference(loadedIds);

    if (added.isNotEmpty) {
      // 新收藏的行要拿题干等行数据，只能重查（重查后 onPageLoaded 会再 seed 一次，幂等）
      loadFirstPage();
      return;
    }
    if (gone.isNotEmpty) {
      // 别处取消了收藏：就地删行，不重查（重查会打乱滚动位置）
      updateRows(
        (current) => [
          for (final row in current)
            if (!gone.contains(row.questionId)) row,
        ],
      );
    }
  }

  @override
  Future<List<FavoriteQuestion>> fetchPage({required int limit, required int offset}) =>
      context.read<ListRepository>().fetchFavorites(limit: limit, offset: offset);

  @override
  void onPageLoaded(List<FavoriteQuestion> page) {
    // 只并入、不移除：分页没加载到的行不代表没收藏（FavoriteStore.seed 的约定）。
    context.read<FavoriteStore>().seed(page.map((row) => row.questionId));
  }

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
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
  );

  @override
  Widget? buildHeader(BuildContext context) => TabActionBar(
    hint: '按收藏时间排序',
    actionLabel: '开始练习',
    onAction: () => startPracticeFrom(context, PracticeSource.favorites),
  );

  @override
  Widget buildRow(BuildContext context, FavoriteQuestion row) => FavoriteQuestionTile(
    row: row,
    removing: _removingId == row.questionId,
    onTap: () => context.push(AppRoutes.questionDetailOf(row.questionId)),
    onRemove: () => _remove(row),
  );

  /// 取消收藏：写的是 FavoriteStore（它负责与题目详情同步），成功后把该行从列表里去掉。
  Future<void> _remove(FavoriteQuestion row) async {
    if (_removingId != null) return;
    setState(() => _removingId = row.questionId);
    try {
      await context.read<FavoriteStore>().toggle(row.questionId);
      if (!mounted) return;
      setState(() => _removingId = null);
      updateRows(
        (current) => [
          for (final item in current)
            if (item.questionId != row.questionId) item,
        ],
      );
      _toast('已取消收藏');
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _removingId = null);
      _toast(error.message);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildPagedList(context);
  }
}
