// 一次练习的复盘页。
//
// 职责：按 sessionId 取回完整快照（题面 + 当时的作答），依次摆出汇总与逐题回顾。
// 不负责：作答与提交（这里是只读的）、记录列表（RecordsPage 的第一个 Tab）。
//
// 为什么复盘要重新拉一次完整快照而不是把列表里的记录带过来：
// 列表（PracticeSessionRecord）里没有题面，而题面必须用**当时的版本快照**——
// 题目后来被改版或下线都不该影响这次复盘看到的东西。这是服务端 get_practice_session
// 的语义，客户端只管照用。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/review_question_card.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/review_summary.dart';
import 'package:provider/provider.dart';

class SessionReviewPage extends StatefulWidget {
  const SessionReviewPage({super.key, required this.sessionId});

  final String sessionId;

  @override
  State<SessionReviewPage> createState() => _SessionReviewPageState();
}

class _SessionReviewPageState extends State<SessionReviewPage> {
  AsyncValue<PracticeSessionSnapshot> _state =
      const AsyncLoading<PracticeSessionSnapshot>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final snapshot = await context.read<PracticeRepository>().fetchSession(
        widget.sessionId,
      );
      if (!mounted) return;
      setState(() => _state = AsyncData(snapshot));
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('练习复盘')),
      body: SafeArea(
        child: AsyncView<PracticeSessionSnapshot>(
          state: _state,
          loadingMessage: '正在取回这次练习…',
          onRetry: _load,
          builder: (snapshot) => _ReviewBody(snapshot: snapshot),
        ),
      ),
    );
  }
}

/// 复盘正文：概览 + 逐题。
class _ReviewBody extends StatelessWidget {
  const _ReviewBody({required this.snapshot});

  final PracticeSessionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final items = snapshot.items;
    final answers = snapshot.answersByQuestion;

    return ListView.separated(
            padding: EdgeInsets.all(AppMetrics.pagePadding.r),
            // 第 0 项是头部（概览），其后才是题目。
            itemCount: items.length + 1,
            separatorBuilder: (_, _) => SizedBox(height: AppMetrics.gapMd.r),
            itemBuilder: (context, index) {
              if (index == 0) return _header(context);
              final item = items[index - 1];
              return ReviewQuestionCard(
                index: index - 1,
                item: item,
                record: answers[item.questionId],
              );
            },
          );
  }

  Widget _header(BuildContext context) {
    final status = _statusLabel(snapshot.status);
    final subtitle =
        '${snapshot.sourceValue.label} · $status'
        ' · ${Formatters.dateTime(snapshot.startedAt)}'
        // 未交卷的会话照样能看：但要把「这不是最终成绩」说清楚。
        '${snapshot.isActive ? '（未交卷，以下为当前进度）' : ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: '成绩概览', subtitle: subtitle),
        ReviewSummary(snapshot: snapshot),
        SizedBox(height: AppMetrics.gapXl.r),
        SectionHeader(title: '逐题回顾', subtitle: '共 ${snapshot.totalCount} 题'),
      ],
    );
  }
}

/// 数据库里的状态字符串 → 中文。不直接用 SessionStatus 的 label 是因为
/// 快照这边的 status 是裸字符串，多一层查表比在页面里 switch 更耐脏数据。
String _statusLabel(String status) {
  for (final value in SessionStatus.values) {
    if (value.wire == status) return value.label;
  }
  return status;
}
