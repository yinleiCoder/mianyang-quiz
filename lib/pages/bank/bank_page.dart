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

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/bank/bank_reference.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_body.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_header.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_filter_sheet.dart';
import 'package:mianyang_quiz/pages/bank/widgets/bank_pager.dart';
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

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // read 先取出来再用：把 context 的使用留在 await 之前（否则触发
    // use_build_context_synchronously —— 这个仓库的老写法也是这么做的）
    final subjects = context.read<SubjectRepository>();
    final ref = await BankReference.load(subjects);
    if (!mounted) return;
    setState(() => _ref = ref);
    await _load();
  }

  /// 这一页的题目 + 全站作答统计。两个请求串行（统计要拿题目 id），
  /// 但它是附加信息，取不到就退化成空表（fetchAccuracyOrEmpty），不影响列表。
  Future<(QuestionPage, Map<String, QuestionAccuracy>)> _fetchPage() async {
    // 两个仓储都在 await 之前取好：第二次 context.read 落在 await 之后会触发
    // use_build_context_synchronously（widget 在第一段 await 里被卸载就危险了）
    final questions = context.read<QuestionRepository>();
    final lists = context.read<ListRepository>();
    final page = await questions.listQuestions(
      filter: _filter,
      page: _page,
      pageSize: _pageSize,
      nodes: _ref.nodes.isEmpty ? null : _ref.nodes,
    );
    final accuracy = await lists.fetchAccuracyOrEmpty(
      page.rows.map((row) => row.questionId).toList(),
    );
    return (page, accuracy);
  }

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

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteStore>();
    final total = _state.valueOrNull?.total ?? 0;

    return SafeArea(
      // **不套 MaxWidthBox**：数据页铺满窗口宽度。限宽会让滚动视图只剩中间那一条，
      // 滚动条就跑到内容区右边而不是窗口侧边，窗口越宽越明显。
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppMetrics.pagePadding.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BankHeader(
              total: total,
              filter: _filter,
              nodes: _ref.nodes,
              tags: _ref.tags,
              onOpenSheet: _openSheet,
              onClear: _clearFilter,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            Expanded(
              child: BankBody(
                state: _state,
                accuracy: _accuracy,
                filtered: _filter.hasAny,
                onClear: _clearFilter,
                onRetry: _load,
                onRefresh: _refresh,
                isFavorite: favorites.isFavorite,
                onOpen: (brief) =>
                    context.push(AppRoutes.questionDetailOf(brief.questionId)),
                onToggleFavorite: (brief) => toggleFavoriteWithToast(
                  context,
                  questionId: brief.questionId,
                  toggle: context.read<FavoriteStore>().toggle,
                ),
              ),
            ),
            if (total > 0)
              BankPager(
                page: _page,
                pageSize: _pageSize,
                total: total,
                onPrev: () => _goToPage(_page - 1),
                onNext: () => _goToPage(_page + 1),
              ),
          ],
        ),
      ),
    );
  }

  void _clearFilter() => _applyFilter(const QuestionFilter());
}
