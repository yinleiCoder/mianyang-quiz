// 错题本 Tab：DataTable 展示 + 排序 + 搜索（迁移 0111）。
//
// 用户口径（2026-10-24）：要能按「最近练习时间」或「累计错误次数」排序，
// 并且能搜错题。取数/排序/搜索的状态机在 state/wrong_questions_controller.dart，
// 本文件只负责版式与交互。
//
// 从练习页返回时重拉（RouteAware）：答对的题会从错题本消失，不重拉会停在旧数据上。

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/records/state/wrong_questions_controller.dart';
import 'package:mianyang_quiz/pages/records/widgets/tab_action_bar.dart';
import 'package:mianyang_quiz/pages/records/widgets/wrong_questions_table.dart';
import 'package:provider/provider.dart';

class WrongQuestionsTab extends StatefulWidget {
  const WrongQuestionsTab({super.key});

  @override
  State<WrongQuestionsTab> createState() => _WrongQuestionsTabState();
}

class _WrongQuestionsTabState extends State<WrongQuestionsTab>
    with AutomaticKeepAliveClientMixin, RouteAware {
  late final WrongQuestionsController _controller;
  final _search = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = WrongQuestionsController(
      context.read<ListRepository>(),
    )..reload();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _search.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 从练习页返回：答对的题已经不该在错题本里了。
  @override
  void didPopNext() => _controller.reload();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => Column(
        children: [
          // 空错题本不给「开始练习」：服务端抽不到题会报错。
          // 搜索框仍然保留——空列表时更需要搜一下确认是不是被筛掉了。
          if (_controller.rows.isNotEmpty)
            TabActionBar(
              hint: _hint(_controller),
              actionLabel: '开始练习',
              onAction: () => startPracticeFrom(context, PracticeSource.wrong),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppMetrics.pagePadding.r,
              AppMetrics.gapSm.r,
              AppMetrics.pagePadding.r,
              0,
            ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _search,
              builder: (context, value, _) => TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onChanged: _controller.search,
                decoration: InputDecoration(
                  hintText: '搜索错题（题干关键词）',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: '清除搜索',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            _controller.search('');
                          },
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Expanded(child: _body(context, _controller)),
        ],
      ),
    );
  }

  static String _hint(WrongQuestionsController c) => c.sortKey == 'wrong'
      ? '按累计错误次数${c.ascending ? '从少到多' : '从多到少'}'
      : '按最近练习时间${c.ascending ? '从早到晚' : '从近到远'}';

  Widget _body(BuildContext context, WrongQuestionsController c) {
    if (c.loading && c.rows.isEmpty) {
      return const LoadingState(message: '正在加载错题…');
    }
    if (c.error != null && c.rows.isEmpty) {
      return ErrorState(message: c.error!, onRetry: c.reload);
    }
    if (c.rows.isEmpty) {
      return PullToRefresh(fill: true, onRefresh: c.reload, child: _empty(context));
    }

    return PullToRefresh(
      onRefresh: c.reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppMetrics.pagePadding.r,
          AppMetrics.gapSm.r,
          AppMetrics.pagePadding.r,
          AppMetrics.pagePadding.r,
        ),
        children: [
          if (c.error != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppMetrics.gapSm.r),
              child: Text(
                c.error!,
                style: AppTextStyles.caption(context).copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          WrongQuestionsTable(
            rows: c.rows,
            sortKey: c.sortKey,
            ascending: c.ascending,
            onSort: c.setSort,
            onOpen: (row) =>
                context.push(AppRoutes.questionDetailOf(row.questionId)),
            onLoadMore: c.loadMore,
            hasMore: c.hasMore,
            loadingMore: c.loadingMore,
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    final searching = _controller.keyword.isNotEmpty || _search.text.isNotEmpty;
    return EmptyState(
      icon: searching ? Icons.search_off_rounded : Icons.fact_check_outlined,
      title: searching ? '没有匹配的错题' : '还没有错题，继续保持',
      message: searching
          ? '换个关键词试试，或者清除搜索看全部错题。'
          : '做错的题会自动收进这里，随时可以重练',
      action: searching
          ? DuoButton(
              label: '清除搜索',
              icon: Icons.close_rounded,
              variant: DuoButtonVariant.outline,
              expand: false,
              onPressed: () {
                _search.clear();
                _controller.search('');
              },
            )
          : DuoButton(
              label: '去题库刷题',
              icon: Icons.library_books_outlined,
              variant: DuoButtonVariant.outline,
              expand: false,
              onPressed: () => context.push(AppRoutes.bankPath),
            ),
    );
  }
}
