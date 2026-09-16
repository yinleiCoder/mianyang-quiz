// 刷题页。
//
// 本文件只做三件事：加载会话、创建/销毁 PracticeRunner、把舞台放进 Scaffold。
// **不含任何判分、提交、切题逻辑**——那些都在 PracticeRunner 里。
// 上一版客户端的练习页涨到 1379 行，正是因为状态机与渲染挤在同一个文件里。
//
// 单屏单题（学多邻国）：一屏一道题，底部固定操作区，题干过长时只在题干区滚动。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_stage.dart';
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

class _PracticePageState extends State<PracticePage> {
  PracticeRunner? _runner;
  AsyncValue<void> _load = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    setState(() => _load = const AsyncLoading());
    try {
      final snapshot = await context.read<PracticeRepository>().fetchSession(
        widget.sessionId,
      );
      if (!mounted) return;
      _runner = PracticeRunner(
        repository: context.read<PracticeRepository>(),
        snapshot: snapshot,
        mode: widget.mode,
        shuffleOptions: widget.shuffleOptions,
      );
      setState(() => _load = const AsyncData(null));
    } catch (error) {
      if (!mounted) return;
      setState(() => _load = AsyncFailure(mapError(error)));
    }
  }

  @override
  void dispose() {
    // Runner 是本页私有状态，页面的生命周期就是它的生命周期
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
