// 错题本 Tab。
//
// 职责：分页拉取错题（最近一次作答为错，按作答时间倒序），提供「开始练习」入口。
// 分页状态机在 ui/core/list/paged_list.dart，本文件只回答三个问题：
// 怎么拉一页、空的时候显示什么、一行怎么画。
// 不负责：行怎么画（WrongQuestionTile）、组卷页怎么定题（服务端自己定，客户端只送来源）。
//
// 「开始练习」前必须把 PracticeDraftStore 的来源置为 wrong：
// 组卷页是四个入口共用的，它只能从 store 知道这次是「练错题」还是「随便练练」。
// 空错题本**不给**练习入口——服务端会因为抽不到题报错，这时候应该引导去题库。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/state/practice_entry.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/tab_action_bar.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/wrong_question_tile.dart';
import 'package:provider/provider.dart';

class WrongQuestionsTab extends StatefulWidget {
  const WrongQuestionsTab({super.key});

  @override
  State<WrongQuestionsTab> createState() => _WrongQuestionsTabState();
}

class _WrongQuestionsTabState extends State<WrongQuestionsTab>
    with AutomaticKeepAliveClientMixin, PagedListState<WrongQuestion, WrongQuestionsTab> {
  /// TabBarView 切走会销毁页面；错题不会自己变，保活更顺手。
  @override
  bool get wantKeepAlive => true;

  @override
  Future<List<WrongQuestion>> fetchPage({required int limit, required int offset}) =>
      context.read<ListRepository>().fetchWrongQuestions(limit: limit, offset: offset);

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
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
  );

  @override
  Widget? buildHeader(BuildContext context) => TabActionBar(
    hint: '按最近答错时间排序',
    actionLabel: '开始练习',
    onAction: () => startPracticeFrom(context, PracticeSource.wrong),
  );

  @override
  Widget buildRow(BuildContext context, WrongQuestion row) => WrongQuestionTile(
    row: row,
    onTap: () => context.push(AppRoutes.questionDetailOf(row.questionId)),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildPagedList(context);
  }
}
