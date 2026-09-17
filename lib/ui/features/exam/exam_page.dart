// 答题页。
//
// 本文件只做三件事：取回这场考试、创建/销毁 ExamRunner、把舞台放进 Scaffold。
// **不含任何作答与交卷逻辑**——那些在 ExamRunner 里（同练习页的分工）。
//
// 两条入口共用它：
//   · 试卷库开考：带上刚拿到的快照（extra），不再往返一次；
//   · 我的考试 → 继续答题：只给 attemptId，这里现拉。
//
// 已经交过卷的考试不该再进答题页（可能是列表页拿了过期数据），发现即转成绩单。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/services/exam_draft_service.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/exam/state/exam_runner.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_stage.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key, required this.attemptId, this.snapshot});

  final String attemptId;

  /// 开考时刚拿到的快照；为 null 时按 [attemptId] 现拉（续考、深链）。
  final ExamSnapshot? snapshot;

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  ExamRunner? _runner;
  AsyncValue<void> _load = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _loadAttempt();
  }

  Future<void> _loadAttempt() async {
    setState(() => _load = const AsyncLoading());
    try {
      final repository = context.read<PaperRepository>();
      final draftService = context.read<ExamDraftService>();

      final snapshot =
          widget.snapshot ?? await repository.fetchAttempt(widget.attemptId);
      if (!mounted) return;

      // 已经交卷了（列表页的数据可能是几分钟前的）：答题页对它没有意义
      if (!snapshot.attempt.statusValue.isOpen) {
        context.pushReplacement(AppRoutes.examResultOf(widget.attemptId));
        return;
      }

      // 本机暂存：服务端在交卷前不存任何作答，一场 90 分钟的考试中途退出就只剩它了
      final localDrafts = await draftService.load(widget.attemptId);
      if (!mounted) return;

      _runner = ExamRunner(
        repository: repository,
        snapshot: snapshot,
        draftService: draftService,
        localDrafts: localDrafts,
      );
      setState(() => _load = const AsyncData(null));
      _notifyIfResumed(snapshot);
    } catch (error) {
      if (!mounted) return;
      setState(() => _load = AsyncFailure(mapError(error)));
    }
  }

  /// 续考时说一句。判据是"起考时刻明显早于现在"——服务端不区分开考与续考
  /// （同一份卷有在途的那场就直接还回来），客户端只能从时间上认。
  void _notifyIfResumed(ExamSnapshot snapshot) {
    final startedAt = snapshot.attempt.startedAt;
    if (startedAt == null) return;
    final elapsed = DateTime.now().difference(startedAt);
    if (elapsed < const Duration(minutes: 1)) return;

    final expired = snapshot.attempt.remainingFrom(DateTime.now()) == Duration.zero;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          expired ? '这场考试的时间已经到了，正在为你交卷' : '接着上次继续答，时间没有暂停',
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Runner 是本页私有状态，页面的生命周期就是它的生命周期
    // （dispose 里会把还没落盘的暂存补写一次）
    _runner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AsyncView<void>(
          state: _load,
          loadingMessage: '正在准备试卷…',
          onRetry: _loadAttempt,
          // AsyncView<void> 的 value 没有信息量，真正要用的是加载成功后建好的 runner
          builder: (_) => ExamStage(runner: _runner!),
        ),
      ),
    );
  }
}
