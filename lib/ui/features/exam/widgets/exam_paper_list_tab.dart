// 试卷库页签：老师已入库的卷子，挑一套开考。
//
// 开考是一个**有分量**的动作（一旦开始就开始计时），所以点一下不直接进考场，
// 先过一个确认框把时长与"离开不暂停"讲清楚。
//
// 开考的往返放在这里而不是答题页：答题页需要一个 attemptId 才能进路由，
// 而 attemptId 只有服务端给了才有。代价是这一小段等待要有反馈——
// ExamPaperTile 的 starting 就是干这个的。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/exam/paper_brief.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_confirm_sheet.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_paper_tile.dart';
import 'package:provider/provider.dart';

class ExamPaperListTab extends StatefulWidget {
  const ExamPaperListTab({super.key});

  @override
  State<ExamPaperListTab> createState() => _ExamPaperListTabState();
}

class _ExamPaperListTabState extends State<ExamPaperListTab>
    with PagedListState<PaperBrief, ExamPaperListTab> {
  /// 正在开考的那一份（版本 id）。只是禁用按钮 + 转圈，不拦其他操作。
  String? _starting;

  @override
  String get loadingMessage => '正在加载试卷…';

  @override
  Future<List<PaperBrief>> fetchPage({
    required int limit,
    required int offset,
  }) => context.read<PaperRepository>().fetchPapers(
    limit: limit,
    offset: offset,
  );

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
    icon: Icons.assignment_outlined,
    title: '还没有试卷',
    message: '老师把试卷提交入库后，这里就能看到。\n在那之前，先去题库刷几道题吧。',
    action: DuoButton(
      label: '去题库',
      icon: Icons.menu_book_outlined,
      expand: false,
      onPressed: () => context.go(AppRoutes.bankPath),
    ),
  );

  @override
  Widget buildRow(BuildContext context, PaperBrief row) => ExamPaperTile(
    paper: row,
    starting: _starting == row.versionId,
    onTap: () => _start(row),
    // 卷名随 extra 带过去，榜页的标题就不用等一次加载
    onLeaderboard: () =>
        context.push(AppRoutes.paperLeaderboardOf(row.paperId), extra: row.title),
  );

  @override
  Widget build(BuildContext context) => buildPagedList(context);

  Future<void> _start(PaperBrief paper) async {
    final minutes = paper.durationMinutes;
    final ok = await showExamConfirmSheet(
      context,
      title: '开始考试？',
      message: '《${paper.title}》'
          '${minutes != null && minutes > 0 ? '限时 $minutes 分钟，' : ''}'
          '开始后计时不会暂停，到时间会自动交卷。\n'
          '中途离开可以从「我的考试」接着答。',
      confirmLabel: '开始考试',
      cancelLabel: '再等等',
    );
    if (!ok || !mounted) return;

    setState(() => _starting = paper.versionId);
    try {
      final snapshot = await context.read<PaperRepository>().startAttempt(
        paper.versionId,
      );
      if (!mounted) return;
      setState(() => _starting = null);
      // 同一份卷同时只能有一场进行中：服务端会把没答完的那场原样还回来，
      // 于是"开考"与"续考"在这里是同一条路径。
      await context.push(
        AppRoutes.examAttemptOf(snapshot.attempt.id),
        extra: snapshot,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _starting = null);
      // 报错文案已经是中文（试卷没入库 / 已下线 / 试卷是空的）
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapError(error).message)));
    }
  }
}
