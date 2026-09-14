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
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/features/bank/favorite_action.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_body.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_filter_bar.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_filter_sheet.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_pager.dart';
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

  /// 参考数据（科目树、标签）在一次会话里几乎不变，进页面取一次，翻页不再重复请求。
  List<SubjectNode> _nodes = const [];
  List<QuestionTag> _tags = const [];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final subjects = context.read<SubjectRepository>();
    try {
      final nodes = await subjects.fetchNodes();
      final tags = await subjects.fetchTags();
      if (!mounted) return;
      setState(() {
        _nodes = nodes;
        _tags = tags;
      });
    } on AppException {
      // 参考数据失败不阻断列表：筛选面板会退化成"只有关键词与题型"，
      // 题目本身仍能正常浏览，比整页报错合理。
    }
    await _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final page = await context.read<QuestionRepository>().listQuestions(
        filter: _filter,
        page: _page,
        pageSize: _pageSize,
        nodes: _nodes.isEmpty ? null : _nodes,
      );
      if (!mounted) return;
      setState(() => _state = AsyncData(page));
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
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
      nodes: _nodes,
      tags: _tags,
    );
    if (picked == null || !mounted) return; // null = 取消，保持原条件
    _applyFilter(picked);
  }

  /// 已选科目的名称链；科目树未就绪时退化为空串（chip 不显示）。
  String get _nodePath => buildNodeIndex(_nodes)(_filter.nodeId);

  String get _tagName {
    for (final tag in _tags) {
      if (tag.id == _filter.tagId) return tag.name;
    }
    return '';
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text('题库', style: AppTextStyles.pageTitle(context)),
                ),
                if (total > 0)
                  Text(
                    '共 $total 题',
                    style: AppTextStyles.caption(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            BankFilterBar(
              filter: _filter,
              nodePath: _nodePath,
              tagName: _tagName,
              onOpenSheet: _openSheet,
              onClear: _clearFilter,
            ),
            SizedBox(height: AppMetrics.gapMd.r),
            Expanded(
              child: BankBody(
                state: _state,
                filtered: _filter.hasAny,
                onClear: _clearFilter,
                onRetry: _load,
                isFavorite: favorites.isFavorite,
                onOpen: (brief) =>
                    context.push(AppRoutes.questionDetailOf(brief.questionId)),
                onToggleFavorite: (brief) =>
                    toggleFavoriteWithToast(context, brief.questionId),
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
