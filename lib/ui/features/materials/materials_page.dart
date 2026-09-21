// 复习资料：全市教师共享，学生在这里搜索、筛选、查看、保存。
//
// 分页用 ui/core 的 PagedListState（"按一下加载更多"），不是题库页那种页码器 ——
// 资料是**翻着找**的场景，看到哪算哪，页码器反而多一层决策（list_footer 里写了这条取舍）。
//
// 页面状态（筛选条件、下拉刷新）留在本页 State，不进全局 Store：
// 离开即弃的页面级状态塞进 Store 只会让别的页面也看得见一份无意义的数据
//（bank_page 头部同款判断）。
//
// 入口在首页工作台，不做底部导航的第 6 个 tab（理由见 routes.dart 复习资料那段）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/data/models/material/material_filter.dart';
import 'package:mianyang_quiz/data/repositories/material_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/list/paged_list.dart';
import 'package:mianyang_quiz/ui/features/materials/widgets/material_filter_bar.dart';
import 'package:mianyang_quiz/ui/features/materials/widgets/material_filter_sheet.dart';
import 'package:mianyang_quiz/ui/features/materials/widgets/material_list_tile.dart';
import 'package:provider/provider.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage>
    with PagedListState<MaterialBrief, MaterialsPage> {
  MaterialFilter _filter = const MaterialFilter();

  /// 学科树的参考数据。取一次缓存住——筛选面板每次打开都要用，
  /// 而它几乎不变（题库页也是这么处理的）。
  List<SubjectNode> _nodes = const [];

  @override
  void initState() {
    super.initState();
    _loadNodes();
  }

  Future<void> _loadNodes() async {
    try {
      final nodes = await context.read<SubjectRepository>().fetchNodes();
      if (mounted) setState(() => _nodes = nodes);
    } catch (_) {
      // 只是筛选用的参考数据，取不到就不显示学科选项，不该让整页失败
      //（与题库详情页"附加信息失败不抛"同款取舍）
    }
  }

  @override
  Future<List<MaterialBrief>> fetchPage({required int limit, required int offset}) async {
    // 选了父级节点要连它下面的资料一起给：老师挂在「信息技术」（课程）上的资料，
    // 学生点「计算机」（专业大类）时也该看得到（与题库页的子树口径一致）。
    // 节点树还没到手时按精确匹配退让——取回来之后下拉刷新即可纠正。
    final nodeId = _filter.nodeId;
    final nodeIds = nodeId == null
        ? null
        : (_nodes.isEmpty ? [nodeId] : subtreeIds(_nodes, nodeId));

    final page = (offset ~/ limit) + 1;
    final result = await context.read<MaterialRepository>().listMaterials(
      filter: _filter,
      nodeIds: nodeIds,
      page: page,
      pageSize: limit,
    );
    return result.rows;
  }

  @override
  Widget buildEmpty(BuildContext context) => EmptyState(
    icon: Icons.folder_open_outlined,
    title: _filter.hasAny ? '没有符合条件的资料' : '还没有复习资料',
    message: _filter.hasAny
        ? '换个关键词、或清掉筛选再看看。'
        : '老师上传后这里就会出现。',
  );

  @override
  Widget buildRow(BuildContext context, MaterialBrief row) => MaterialListTile(
    material: row,
    nodePath: row.courseNodeId == null
        ? ''
        : buildNodeIndex(_nodes)(row.courseNodeId),
    onTap: () => context.push(AppRoutes.materialViewOf(row.id), extra: row),
  );

  Future<void> _openSheet() async {
    final picked = await MaterialFilterSheet.show(
      context,
      initial: _filter,
      nodes: _nodes,
    );
    if (picked == null || !mounted) return;
    setState(() => _filter = picked);
    // 条件变了必须从头拉：否则会拿着旧条件取回的第二页拼在新筛选结果后面
    await loadFirstPage();
  }

  Future<void> _clear() async {
    setState(() => _filter = const MaterialFilter());
    await loadFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('复习资料'),
        actions: [
          IconButton(
            onPressed: _openSheet,
            tooltip: '筛选',
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            MaterialFilterBar(
              filter: _filter,
              nodePath: _filter.nodeId == null || _nodes.isEmpty
                  ? ''
                  : buildNodeIndex(_nodes)(_filter.nodeId),
              onOpenSheet: _openSheet,
              onClear: _clear,
            ),
            SizedBox(height: AppMetrics.gapSm.r),
            Expanded(child: buildPagedList(context)),
          ],
        ),
      ),
    );
  }
}
