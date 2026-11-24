// 题库列表的取数：参考数据（科目树/标签）、每页题目、全站作答统计。
//
// 抽出来的理由：bank_page.dart 加进选题讲练（0095）之后超过了 200 行
// （AGENTS.md 三，由 check_architecture 强制）。而"怎么取"与"取到之后怎么摆"
// 本来也是两件事——搬走的是前者。
//
// **只负责取数，不碰三态**：AsyncLoading / AsyncFailure / setState 仍归页面。
// 页面本来就是那个状态机，把它也搬走只会多一层来回传状态的回调。
//
// 仓储在构造时注入（而不是每次现取 context）：页面在 initState 里建它，
// 于是每个 await 之前都不必再 read 一次 context —— 那正是
// use_build_context_synchronously 的成因。

import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/pages/bank/bank_reference.dart';

class BankLoader {
  const BankLoader({
    required this.questions,
    required this.lists,
    required this.subjects,
  });

  final QuestionRepository questions;
  final ListRepository lists;
  final SubjectRepository subjects;

  /// 参考数据一次会话里几乎不变，进页面取一次（见 bank_reference.dart）。
  Future<BankReference> loadReference() => BankReference.load(subjects);

  /// 这一页的题目。
  ///
  /// **统计不在这条路径上**：它要用题目 id，天然排在题目之后，但它只是附加信息——
  /// 让列表等它，每次翻页都要多等一个网络往返（跨境网络下 0.5~1.5s）。
  Future<QuestionPage> fetchPage({
    required QuestionFilter filter,
    required int page,
    required int pageSize,
    required List<SubjectNode> nodes,
  }) => questions.listQuestions(
    filter: filter,
    page: page,
    pageSize: pageSize,
    nodes: nodes.isEmpty ? null : nodes,
  );

  /// 全站作答统计（question_accuracy）。取不到就退化空表，绝不影响列表。
  Future<Map<String, QuestionAccuracy>> fetchAccuracy(QuestionPage page) =>
      lists.fetchAccuracyOrEmpty(
        page.rows.map((row) => row.questionId).toList(),
      );
}
