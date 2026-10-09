// 题库列表页：分页浏览 + 筛选 + 收藏。
//
// 职责：持有这一页的**全部**状态（当前筛选、第几页、加载三态），负责取数、翻页、
// 空态与错误态，并把筛选面板与科目树面板的结果收回来。
// 不负责：筛选面板与科目树面板的内部交互（widgets/ 下的两个 sheet）、单行卡片的排版
// （QuestionListTile）、收藏状态的跨页同步（FavoriteStore）。
//
// 为什么状态放页面 State 而不进全局 Store：翻到第几页、按什么筛，都是"离开即弃"的
// 页面级状态，塞进 Store 只会让别的页面也看得见一份无意义的数据。
//
// 本页由 AppShell 的 Scaffold 承载（题库是底部导航的一个 tab），所以不自己建 Scaffold。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/pages/bank/bank_loader.dart';
import 'package:mianyang_quiz/pages/bank/bank_reference.dart';
import 'package:mianyang_quiz/pages/bank/bank_selection.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_filter_sheet.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_view.dart';
import 'package:provider/provider.dart';

class BankPage extends StatefulWidget {
  const BankPage({super.key});

  @override
  State<BankPage> createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  static const _pageSize = 10;

  QuestionFilter _filter = const QuestionFilter();
  int _page = 1;
  AsyncValue<QuestionPage> _state = const AsyncLoading();

  /// 全站作答统计（question_id → 作答/答对）。缺项 = 这道题还没人做过，不是错误。
  Map<String, QuestionAccuracy> _accuracy = const {};

  /// 参考数据（科目树、标签）：一次会话里几乎不变，进页面取一次（见 bank_reference.dart）。
  BankReference _ref = const BankReference();

  /// 选题讲练的勾选状态（0095）。跨页保留——选题天然要翻页凑，
  /// 翻一页就清空等于这个功能没法用；离开题库页才随本页一起丢掉。
  final _selection = BankSelection();

  /// 取数在 [BankLoader] 里；本页负责三态与把结果摆出来。
  /// 在这里建（而不是每次现取 context）：下面每个 await 之前就不必再 read 一次 context。
  late final BankLoader _loader = BankLoader(
    questions: context.read<QuestionRepository>(),
    lists: context.read<ListRepository>(),
    subjects: context.read<SubjectRepository>(),
  );

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final ref = await _loader.loadReference();
    if (!mounted) return;
    setState(() => _ref = ref);
    await _load();
  }

  Future<(QuestionPage, Map<String, QuestionAccuracy>)> _fetchPage() =>
      _loader.fetchPage(
        filter: _filter,
        page: _page,
        pageSize: _pageSize,
        nodes: _ref.nodes,
      );

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final (page, accuracy) = await _fetchPage();
      if (!mounted) return;
      setState(() {
        _state = AsyncData(page);
        _accuracy = accuracy;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
    }
  }

  /// 下拉刷新：重查当前这一页，**不切到加载态**。
  ///
  /// RefreshIndicator 自己会转圈；这里再 setState(AsyncLoading) 会把列表换成居中转圈，
  /// 用户正看着的内容整块消失——下拉刷新最不该有的表现。
  /// 失败也只提示、保留原内容（与 PagedListState.loadMore 同一口径）。
  Future<void> _refresh() async {
    try {
      final (page, accuracy) = await _fetchPage();
      if (!mounted) return;
      setState(() {
        _state = AsyncData(page);
        _accuracy = accuracy;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  void _applyFilter(QuestionFilter filter) {
    setState(() {
      _filter = filter;
      // 条件变了，第 3 页多半已经不存在，一律回到第一页
      _page = 1;
    });
    _load();
  }

  void _goToPage(int page) {
    setState(() => _page = page);
    _load();
  }

  Future<void> _openSheet() async {
    final picked = await BankFilterSheet.show(
      context,
      initial: _filter,
      nodes: _ref.nodes,
      tags: _ref.tags,
    );
    if (picked == null || !mounted) return; // null = 取消，保持原条件
    _applyFilter(picked);
  }

  /// 带着勾选的题去组卷页。**不在本页直接开练**：开练那一步（等看板、处理进行中的
  /// 会话、今天练完了的重试）在组卷页那一侧，而 pages/bank 不准 import
  /// pages/compose（跨模块复用必须上提，见 AGENTS.md 二）。
  /// 顺带也让教师在组卷页确认一遍"这次只讲这 N 道"，再按开始。
  void _startPicked(List<String> questionIds) {
    final draft = context.read<PracticeDraftStore>();
    draft.setMode(PracticeMode.sequential);
    draft.setPickedQuestions(questionIds);
    context.push(AppRoutes.composePath);
  }

  @override
  void dispose() {
    _selection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BankView(
    state: _state,
    accuracy: _accuracy,
    filter: _filter,
    reference: _ref,
    total: _state.valueOrNull?.total ?? 0,
    page: _page,
    pageSize: _pageSize,
    selection: _selection,
    onOpenSheet: _openSheet,
    onClearFilter: _clearFilter,
    onRetry: _load,
    onRefresh: _refresh,
    onGoToPage: _goToPage,
    onStartPicked: _startPicked,
    onOpen: (brief) =>
        context.push(AppRoutes.questionDetailOf(brief.questionId)),
  );

  void _clearFilter() => _applyFilter(const QuestionFilter());
}
