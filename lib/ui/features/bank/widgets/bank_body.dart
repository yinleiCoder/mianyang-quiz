// 题库列表区的主体：把加载三态翻译成对应的界面。
//
// 职责：三态分发（转圈 / 出错重试 / 有数据），有数据时再分「空」与「有行」。
// 它不持状态、不发请求——状态与回调都由页面给，所以列表页的状态机一眼能读完。
// 不负责：取数与分页（BankPage），也不负责空态文案（BankEmptyState）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_empty_state.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_list_view.dart';

class BankBody extends StatelessWidget {
  const BankBody({
    super.key,
    required this.state,
    required this.filtered,
    required this.onClear,
    required this.onRetry,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  /// 当前这一页的加载状态。
  final AsyncValue<QuestionPage> state;

  /// 是否设了筛选条件（决定空态说哪句话）。
  final bool filtered;

  final VoidCallback onClear;
  final VoidCallback onRetry;

  final bool Function(String questionId) isFavorite;
  final ValueChanged<QuestionBrief> onOpen;
  final ValueChanged<QuestionBrief> onToggleFavorite;

  @override
  Widget build(BuildContext context) => switch (state) {
    AsyncLoading() => const LoadingState(),
    AsyncFailure(:final error) => ErrorState(
      message: error.message,
      onRetry: onRetry,
    ),
    AsyncData(:final value) => value.rows.isEmpty
        ? BankEmptyState(filtered: filtered, onClear: onClear)
        : QuestionListView(
            rows: value.rows,
            isFavorite: isFavorite,
            onOpen: onOpen,
            onToggleFavorite: onToggleFavorite,
          ),
  };
}
