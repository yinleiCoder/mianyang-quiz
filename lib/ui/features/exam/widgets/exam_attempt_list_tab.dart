// 我的考试页签：进行中的那场接着答，已交卷的看成绩。
//
// 这一页**必须存在**：主观题要等老师阅卷，学生交完卷当场看不到最终分，
// 没有这一页，"待阅卷"的卷子就永远不知道什么时候出了分。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_attempt_tile.dart';
import 'package:provider/provider.dart';

class ExamAttemptListTab extends StatefulWidget {
  const ExamAttemptListTab({super.key});

  @override
  State<ExamAttemptListTab> createState() => _ExamAttemptListTabState();
}

class _ExamAttemptListTabState extends State<ExamAttemptListTab>
    with PagedListState<ExamAttemptRecord, ExamAttemptListTab> {
  @override
  String get loadingMessage => '正在加载考试记录…';

  @override
  Future<List<ExamAttemptRecord>> fetchPage({
    required int limit,
    required int offset,
  }) => context.read<PaperRepository>().fetchMyAttempts(
    limit: limit,
    offset: offset,
  );

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
    icon: Icons.history_edu_outlined,
    title: '还没考过试',
    message: '去「试卷库」挑一套卷子开始吧。',
    action: DuoButton(
      label: '看试卷库',
      icon: Icons.assignment_outlined,
      expand: false,
      onPressed: () => context.go(AppRoutes.examsOf(AppRoutes.examsTabLibrary)),
    ),
  );

  @override
  Widget buildRow(BuildContext context, ExamAttemptRecord row) {
    return ExamAttemptTile(record: row, onTap: () => _open(row));
  }

  /// 进答题页或成绩单，回来后**重新拉一次列表**。
  ///
  /// 不重拉的话，刚交完卷回到这一页会看见它还写着「进行中」——这一页是 push 出来的
  /// 路由的**下层**，从考试页返回时它不会重建，状态停在你进去之前那一刻
  /// （切页签会重建，所以只有"从本页进考试再返回"这一条路径会踩到）。
  Future<void> _open(ExamAttemptRecord row) async {
    final target = row.statusValue.isOpen
        ? AppRoutes.examAttemptOf(row.attemptId)
        : AppRoutes.examResultOf(row.attemptId);
    await context.push(target);
    if (!mounted) return;
    await refresh();
  }

  @override
  Widget build(BuildContext context) => buildPagedList(context);
}
