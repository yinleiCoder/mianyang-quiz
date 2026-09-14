// 错题本 Tab。
//
// 职责：分页拉取错题（最近一次作答为错，按作答时间倒序），提供「开始练习」入口。
// 不负责：行怎么画（WrongQuestionTile）、组卷页怎么定题（服务端自己定，客户端只送来源）。
//
// 「开始练习」前必须把 PracticeDraftStore 的来源置为 wrong：
// 组卷页是四个入口共用的，它只能从 store 知道这次是「练错题」还是「随便练练」。
// 空错题本**不给**练习入口——服务端会因为抽不到题报错，这时候应该引导去题库。

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
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/list_footer.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/tab_action_bar.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/wrong_question_tile.dart';
import 'package:provider/provider.dart';

class WrongQuestionsTab extends StatefulWidget {
  const WrongQuestionsTab({super.key});

  @override
  State<WrongQuestionsTab> createState() => _WrongQuestionsTabState();
}

class _WrongQuestionsTabState extends State<WrongQuestionsTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 20;

  AsyncValue<List<WrongQuestion>> _state =
      const AsyncLoading<List<WrongQuestion>>();
  bool _loadingMore = false;
  bool _hasMore = true;

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
      final rows = await context.read<ListRepository>().fetchWrongQuestions(
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
      final rows = await context.read<ListRepository>().fetchWrongQuestions(
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
                icon: Icons.emoji_events_outlined,
                title: '还没有错题，继续保持',
                message: '做错的题会自动收进这里，随时可以重练',
                action: DuoButton(
                  label: '去题库刷题',
                  icon: Icons.library_books_outlined,
                  variant: DuoButtonVariant.outline,
                  expand: false,
                  onPressed: () => context.push(AppRoutes.bankPath),
                ),
              )
            : _list(value),
    };
  }

  Widget _list(List<WrongQuestion> rows) {
    return Column(
      children: [
        TabActionBar(
          hint: '按最近答错时间排序',
          actionLabel: '开始练习',
          onAction: () => startPracticeFrom(context, PracticeSource.wrong),
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
              return WrongQuestionTile(
                row: row,
                onTap: () =>
                    context.push(AppRoutes.questionDetailOf(row.questionId)),
              );
            },
          ),
        ),
      ],
    );
  }
}
