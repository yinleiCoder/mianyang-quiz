// 分页列表的状态机（mixin），给「错题本 / 收藏 / 练习记录」这类列表页共用。
//
// **为什么要它**：这三个 Tab 改造前各自抄了一份几乎逐字相同的分页逻辑
// （`_pageSize`、`_loadingMore`、`_hasMore`、"rows.length == pageSize 就算还有下一页"、
// 续页失败弹 SnackBar），连注释都一样。抄写不致命，致命的是**边界行为会漂移**——
// 比如有一份忘了在续页失败后清掉 `_loadingMore`，按钮就永久停在转圈上。
//
// 为什么是 mixin 而不是 ChangeNotifier / 全局 Store：
//   · 这是**单页状态**，离开即弃，塞进 Store 只会让别的页面也看得见一份无意义的数据；
//   · 分页状态必须能被页面就地改写（收藏页取消收藏后要删掉那一行），
//     自己持有 Controller 反而要多一层转发；
//   · mixin 落在页面自己的 State 上，`setState` / `mounted` / `context` 都是现成的。
//
// 子类只要回答三个问题：怎么拉一页、空的时候显示什么、一行怎么画。
//
// 本文件在 ui/core/ 下但**不 import 任何仓储**：拉数据的方式由子类的 fetchPage 给出，
// 共享层只管"什么时候拉、拉回来怎么攒"。这既满足 ui/core 的分层约束，
// 也让同一套分页能用在三种不同的数据源上。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/core/list/list_footer.dart';
import 'package:mianyang_quiz/ui/core/list/pull_to_refresh.dart';

mixin PagedListState<T, W extends StatefulWidget> on State<W> {
  /// 每页条数。
  ///
  /// 写成 getter 而不是 `static const`：静态成员不参与重写，子类要改就只能
  /// 各自再定义一个常量，那正是这套 mixin 想消掉的重复。
  int get pageSize => 20;

  /// 首屏加载中的说明文案；不传就只显示转圈。
  String? get loadingMessage => null;

  AsyncValue<List<T>> _listState = const AsyncLoading();
  bool _loadingMore = false;
  bool _hasMore = true;

  /// 已加载的行；首屏还没回来时为 null。
  List<T>? get rows => _listState.valueOrNull;

  bool get hasMore => _hasMore;

  bool get loadingMore => _loadingMore;

  // ---------- 子类实现 ----------

  /// 拉一页。[offset] 从 0 开始；返回条数不足 [limit] 即视为到底。
  Future<List<T>> fetchPage({required int limit, required int offset});

  /// 空列表时显示什么（"没有收藏"与"没有错题"要去的地方不一样）。
  Widget buildEmpty(BuildContext context);

  /// 一行怎么画。
  Widget buildRow(BuildContext context, T row);

  /// 列表顶部（如「开始练习」那一行）；不需要就返回 null。
  Widget? buildHeader(BuildContext context) => null;

  /// 每拉到一页回调一次。收藏页用它给 FavoriteStore.seed —— 不喂的话
  /// 会出现「收藏页里明明有、详情页却显示未收藏」。
  void onPageLoaded(List<T> page) {}

  // ---------- 可覆盖的排版 ----------

  EdgeInsets get listPadding => EdgeInsets.fromLTRB(
    AppMetrics.pagePadding.r,
    AppMetrics.gapSm.r,
    AppMetrics.pagePadding.r,
    AppMetrics.pagePadding.r,
  );

  double get rowGap => AppMetrics.gapMd.r;

  // ---------- 状态机 ----------

  @override
  void initState() {
    super.initState();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    setState(() => _listState = const AsyncLoading());
    await _reload();
  }

  /// 下拉刷新：与 [loadFirstPage] 是同一条取数路径，只差"不切加载态"——
  /// RefreshIndicator 自己会转圈，再把内容换成居中转圈只会让人以为数据没了。
  Future<void> refresh() => _reload();

  Future<void> _reload() async {
    try {
      final page = await fetchPage(limit: pageSize, offset: 0);
      if (!mounted) return;
      onPageLoaded(page);
      setState(() {
        _listState = AsyncData(page);
        _hasMore = page.length == pageSize;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      // 首次加载失败 → 错误页（有"重试"可点）；已有内容时（下拉刷新失败）
      // → 只弹一句、保留用户正在看的内容，与 loadMore 口径一致
      if (rows == null) {
        setState(() => _listState = AsyncFailure(error));
        return;
      }
      showLoadMoreError(error);
    }
  }

  /// 续页：把新行接到已有列表后面。
  ///
  /// 续页失败**不清空已加载的内容**：用户已经读到的行与滚动位置都该留着，
  /// 只弹一句提示。整页翻成错误态等于把"看了一半"变成"什么都没了"。
  Future<void> loadMore() async {
    final current = rows;
    if (current == null || _loadingMore || !_hasMore) return;

    setState(() => _loadingMore = true);
    try {
      final page = await fetchPage(limit: pageSize, offset: current.length);
      if (!mounted) return;
      onPageLoaded(page);
      setState(() {
        _listState = AsyncData([...current, ...page]);
        _hasMore = page.length == pageSize;
        _loadingMore = false;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      showLoadMoreError(error);
    }
  }

  /// 续页失败时的提示；默认弹一句，子类可覆盖。
  void showLoadMoreError(AppException error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
  }

  /// 就地改写已加载的行（如取消收藏后删掉那一行）。
  ///
  /// 刻意不重查列表：重查会让刚点的行闪一下，还会打乱滚动位置。
  void updateRows(List<T> Function(List<T> current) transform) {
    final current = rows;
    if (current == null) return;
    setState(() => _listState = AsyncData(transform(current)));
  }

  /// 三态 + 空态 + 分页尾巴的完整列表。页面的 build 直接返回它即可。
  Widget buildPagedList(BuildContext context) => AsyncView<List<T>>(
    state: _listState,
    loadingMessage: loadingMessage,
    onRetry: loadFirstPage,
    builder: (loaded) {
      // 空态也要能下拉：错题本/收藏多半是空的，那正是最想拉一下的时候
      if (loaded.isEmpty) {
        return PullToRefresh(
          onRefresh: refresh,
          fill: true,
          child: buildEmpty(context),
        );
      }

      final list = PullToRefresh(
        onRefresh: refresh,
        child: ListView.separated(
          // 列表短于一屏时也要能下拉（否则只有一两条数据就刷不动了）
          physics: const AlwaysScrollableScrollPhysics(),
          padding: listPadding,
          // 多一项：尾巴上那个「加载更多 / 没有更多了」
          itemCount: loaded.length + 1,
          separatorBuilder: (_, _) => SizedBox(height: rowGap),
          itemBuilder: (context, index) => index == loaded.length
              ? ListFooter(hasMore: _hasMore, loading: _loadingMore, onLoadMore: loadMore)
              : buildRow(context, loaded[index]),
        ),
      );

      final header = buildHeader(context);
      // 没有顶栏就直接返回列表：多包一层 Column 会让 ListView 失去
      // "自己是滚动根"的身份（要再套 Expanded 才不报错），纯属自找麻烦。
      if (header == null) return list;
      return Column(
        children: [
          header,
          Expanded(child: list),
        ],
      );
    },
  );
}
