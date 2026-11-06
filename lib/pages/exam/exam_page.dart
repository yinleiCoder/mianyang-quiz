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
//
// **计时（0144）**：离开本页 = 暂停（dispose 里发一次 pause_exam_attempt），
// 下次进来读考试时服务端把剩余时间接回去。**切后台不停表**，时间照走。

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/exam/state/exam_runner.dart';
import 'package:mianyang_quiz/pages/exam/widgets/exam_stage.dart';
import 'package:provider/provider.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key, required this.attemptId, this.snapshot});

  final String attemptId;

  /// 开考时刚拿到的快照；为 null 时按 [attemptId] 现拉（续考、深链）。
  final ExamSnapshot? snapshot;

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
  ExamRunner? _runner;
  AsyncValue<void> _load = const AsyncLoading();

  /// 提前取好：dispose 时 context 已经不能 read 了，而退出考试页要暂停计时。
  late final PaperRepository _repository;
  late final ExamDraftService _draftService;

  @override
  void initState() {
    super.initState();
    _repository = context.read<PaperRepository>();
    _draftService = context.read<ExamDraftService>();
    WidgetsBinding.instance.addObserver(this);
    _loadAttempt();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 切后台 / 窗口最小化：把节流窗口里的草稿推上去。
    // **计时不暂停**（用户 2026-11-06 口径）：切到后台时间照走，
    // 只有"离开考试页"才停表。
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _runner?.flushDrafts();
    }
  }

  Future<void> _loadAttempt() async {
    setState(() => _load = const AsyncLoading());
    try {
      final snapshot =
          widget.snapshot ?? await _repository.fetchAttempt(widget.attemptId);
      if (!mounted) return;

      // 已经交卷了（列表页的数据可能是几分钟前的）：答题页对它没有意义
      if (!snapshot.attempt.statusValue.isOpen) {
        context.pushReplacement(AppRoutes.examResultOf(widget.attemptId));
        return;
      }

      // 上次是中途退出/切后台的：服务端读考试时**顺手把剩余时间接回去了**
      // （0144 的 _resume_exam_attempt_if_paused），所以这份 snapshot 里的
      // deadline_at 已经是新的。旧客户端不会调 resume，也靠这一条兜住。

      // 两条草稿通道并行取：本机（断网兜底）与服务端（0144，跨设备续考）。
      // 取不到都按空处理——草稿只是辅助，不能因为草稿坏了考不了试。
      final (local, server) = await (
        _draftService.loadWithTime(widget.attemptId),
        _fetchServerDrafts(),
      ).wait;
      if (!mounted) return;

      // 两份都有时按写入时刻判新旧：本机更晚才让它覆盖服务端，
      // 否则以服务端为准（另一台设备刚写的答案不能被这台设备的旧缓存盖掉）。
      final localAt = local.savedAt;
      final serverAt = server.updatedAt;
      final localWins =
          localAt != null && (serverAt == null || localAt.isAfter(serverAt));

      _runner = ExamRunner(
        repository: _repository,
        snapshot: snapshot,
        draftService: _draftService,
        localDrafts: local.answers,
        serverDrafts: server.answers,
        localDraftsWin: localWins,
      );
      setState(() => _load = const AsyncData(null));
      _notifyIfResumed(snapshot);
    } catch (error) {
      if (!mounted) return;
      setState(() => _load = AsyncFailure(mapError(error)));
    }
  }

  /// 服务端草稿（0144）。迁移没跑或断网都只记一行日志，不挡考试。
  Future<ExamDraftBundle> _fetchServerDrafts() async {
    try {
      return await _repository.fetchExamDrafts(widget.attemptId);
    } catch (error) {
      debugPrint('读取考试草稿失败（按空处理）：${mapError(error).message}');
      return ExamDraftBundle.empty;
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
          expired ? '这场考试的时间已经到了，正在为你交卷' : '接着上次继续答，剩余时间从上次离开时接着走',
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final runner = _runner;
    // **离开考试页 = 暂停计时**（0144）：剩余时间保留，下次进来接着考。
    // 切后台不算离开（见 didChangeAppLifecycleState），所以这里才是唯一的暂停点。
    // 交卷成功后不动：那场已经结束了。不 await——页面正在销毁。
    if (runner != null && !runner.submitted) {
      unawaited(
        _repository.pauseAttempt(widget.attemptId).catchError((Object error) {
          // 没冻上也不要紧：回来时读考试拿到的是原截止时刻，等于没暂停
          debugPrint('离开考试页时暂停计时失败：$error');
        }),
      );
    }
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
          // AsyncView<void> 的 value 没有信息量，真正要用的是 _loadSession
          // 成功时建好的 runner（AsyncData 分支必然已有它）。
          builder: (_) => ExamStage(runner: _runner!),
        ),
      ),
    );
  }
}
