// 题库列表区的主体：把加载三态翻译成对应的界面。
//
// 职责：三态分发（转圈 / 出错重试 / 有数据），有数据时再分「空」与「有行」。
// 它不持状态、不发请求——状态与回调都由页面给，所以列表页的状态机一眼能读完。
// 不负责：取数与分页（BankPage），也不负责空态文案（BankEmptyState）。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_empty_state.dart';
import 'package:mianyang_quiz/pages/bank/widgets/question_list_view.dart';

class BankBody extends StatelessWidget {
  const BankBody({
    super.key,
    required this.state,
    required this.filtered,
    required this.onClear,
    required this.onRetry,
    required this.onRefresh,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    this.accuracy = const {},
  });

  /// 当前这一页的加载状态。
  final AsyncValue<QuestionPage> state;

  /// 全站作答统计（question_id → 作答/答对次数），由页面取好传进来。
  final Map<String, QuestionAccuracy> accuracy;

  /// 是否设了筛选条件（决定空态说哪句话）。
  final bool filtered;

  final VoidCallback onClear;
  final VoidCallback onRetry;

  /// 下拉刷新（空态下同样可用：题库刚被别人入库了新题时，这一页正等着被拉）。
  final Future<void> Function() onRefresh;

  final bool Function(String questionId) isFavorite;
  final ValueChanged<QuestionBrief> onOpen;
  final ValueChanged<QuestionBrief> onToggleFavorite;

  @override
  Widget build(BuildContext context) => AsyncView<QuestionPage>(
    state: state,
    onRetry: onRetry,
    // 空态是"这一页没有行"的两种含义：筛过没结果、或题库本来就空。
    // 两者的引导动作不同，所以判断留在本组件而不是 AsyncView 里。
    builder: (page) => page.rows.isEmpty
        ? PullToRefresh(
            onRefresh: onRefresh,
            fill: true,
            child: BankEmptyState(filtered: filtered, onClear: onClear),
          )
        : QuestionListView(
            rows: page.rows,
            accuracy: accuracy,
            isFavorite: isFavorite,
            onOpen: onOpen,
            onToggleFavorite: onToggleFavorite,
            onRefresh: onRefresh,
          ),
  );
}
