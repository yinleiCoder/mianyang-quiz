// 刷题页。
//
// 本文件只做三件事：加载会话、创建/销毁 PracticeRunner、把舞台放进 Scaffold。
// **不含任何判分、提交、切题逻辑**——那些都在 PracticeRunner 里。
// 上一版客户端的练习页涨到 1379 行，正是因为状态机与渲染挤在同一个文件里。
//
// 单屏单题：一屏一道题，底部固定操作区，题干过长时只在题干区滚动。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/pages/practice/widgets/practice_stage.dart';
import 'package:provider/provider.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({
    super.key,
    required this.sessionId,
    this.mode = PracticeMode.instant,
    this.shuffleOptions = true,
  });

  final String sessionId;

  /// 子模式由组卷页决定；从"继续练习"进来时用默认值（即时）。
  final PracticeMode mode;

  final bool shuffleOptions;

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> with WidgetsBindingObserver {
  PracticeRunner? _runner;
  AsyncValue<void> _load = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 切后台 / 窗口最小化：800ms 节流窗口里可能还有没送出的草稿。
    // 硬杀进程不会走 dispose，这里是最后一道保险。
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _runner?.flushDrafts();
    }
  }

  Future<void> _loadSession() async {
    setState(() => _load = const AsyncLoading());
    try {
      final repository = context.read<PracticeRepository>();
      final snapshot = await repository.fetchSession(widget.sessionId);
      // 解释性数据：取不到就空表，绝不因为"为什么推这题"取不到而让孩子进不去练习。
      final reasons = await repository.fetchSessionReasons(widget.sessionId);
      if (!mounted) return;
      _runner = PracticeRunner(
        repository: repository,
        snapshot: snapshot,
        mode: _modeFor(snapshot),
        shuffleOptions: widget.shuffleOptions,
        reasons: reasons,
      );
      setState(() => _load = const AsyncData(null));
    } catch (error) {
      if (!mounted) return;
      setState(() => _load = AsyncFailure(mapError(error)));
    }
  }

  /// 会话自己说了它当时用的是什么模式（0144 的 practice_sessions.mode）。
  ///
  /// **续练必须沿用当时的模式**，不能信路由的默认值：「继续练习」有几个入口
  /// （首页卡片、练习记录）都是直接 push 不带 extra 的，路由于是按"即时练习"重开——
  /// 而即时练习**每答一题就往服务端提交**，正好把批量练习的草稿当成已判定的作答，
  /// 顺序讲练更违反 0090「一轮里一个答案都不提交」。
  /// 表现是静默的：错题本、正确率、遗忘曲线被灌进课堂讲练的作答，没有任何地方会报错。
  ///
  /// 三步兜底：
  ///   1. 服务端明确记过**非即时**模式（batch / sequential）→ 直接信它；
  ///   2. 否则看 scored：false 只能是课堂讲练（0090）；
  ///   3. 其余用路由给的模式——刚开的一轮带着 extra 进来，这时服务端还没记上
  ///      （或登记失败），路由才是对的。
  PracticeMode _modeFor(PracticeSessionSnapshot snapshot) {
    final saved = practiceModeFromWire(snapshot.mode);
    if (saved != null && saved != PracticeMode.instant) return saved;
    return snapshot.scored ? widget.mode : PracticeMode.sequential;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Runner 是本页私有状态，页面的生命周期就是它的生命周期
    // （dispose 里会把还没同步的草稿补推一次）
    _runner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AsyncView<void>(
          state: _load,
          loadingMessage: '正在准备练习…',
          onRetry: _loadSession,
          // AsyncView<void> 的 value 没有信息量，真正要用的是 _loadSession
          // 成功时建好的 runner（AsyncData 分支必然已有它）。
          builder: (_) => PracticeStage(runner: _runner!),
        ),
      ),
    );
  }
}
