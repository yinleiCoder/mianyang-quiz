// 练习结果页：刚交卷的结算。
//
// 两种进入方式：
//   · 交卷后由练习页 pushReplacement 带 FinishSummary 过来（extra）
//   · 从记录页点"查看"时只带 sessionId，此时现场拉一次
//     （会话已 submitted，get_practice_session 仍可读，只是不能继续作答）
//
// 与复盘页的分工：结果页给**成绩**（正确率环 + 各题型表现 + 下一步），
// 复盘页给**逐题明细**。两页分开是因为交卷后用户最想看的是"考得怎么样"，
// 而不是立刻面对二十道题的列表。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/result_body.dart';
import 'package:provider/provider.dart';

class PracticeResultPage extends StatefulWidget {
  const PracticeResultPage({super.key, required this.sessionId, this.summary});

  final String sessionId;

  /// 交卷时已知的结算；为 null 时现场拉取。
  final FinishSummary? summary;

  @override
  State<PracticeResultPage> createState() => _PracticeResultPageState();
}

class _PracticeResultPageState extends State<PracticeResultPage> {
  AsyncValue<FinishSummary> _state = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    if (widget.summary != null) {
      _state = AsyncData(widget.summary!);
    } else {
      _load();
    }
    // 交卷后看板数字变了，回来时要是新的
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DashboardStore>().refresh(silent: true);
    });
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final snapshot =
          await context.read<PracticeRepository>().fetchSession(widget.sessionId);
      if (!mounted) return;
      // 交卷过的会话没有现成的汇总，用会话自带的计数拼一个等价视图
      setState(() {
        _state = AsyncData(
          FinishSummary(
            total: snapshot.totalCount,
            answered: snapshot.answeredCount,
            correct: snapshot.correctCount,
            wrong: snapshot.answeredCount - snapshot.correctCount,
            omitted: snapshot.totalCount - snapshot.answeredCount,
            accuracy:
                snapshot.totalCount == 0 ? 0 : snapshot.correctCount / snapshot.totalCount,
            durationMs: snapshot.durationMs,
          ),
        );
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(mapError(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('练习结果')),
      body: SafeArea(
        child: AsyncView<FinishSummary>(
          state: _state,
          loadingMessage: '正在结算…',
          onRetry: _load,
          builder: (summary) => ResultBody(
            summary: summary,
            sessionId: widget.sessionId,
          ),
        ),
      ),
    );
  }
}
