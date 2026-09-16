// 就读信息四件套：入学年份 / 专业大类 / 专业 / 班级（只在学生身份下出现）。
//
// 职责：把四个字段摆成一段。注册页与档案页共用同一套——**专业大类与专业只让选、不让填**。
// 不负责：取数与提交；选中值与班级控制器由页面持有，提交时页面直接读。
//
// 为什么专业这两个字段改成下拉（原来是自由输入）：
//   学生手输的「计算机应用」和科目树里维护的「计算机」对不上，后续就无法把学生与课程关联
//   （树里的专业大类 → 专业 → 课程是三级结构，学生必须落在同一条链上）。
//   数据源是 subject_nodes 的专业目录（vocational）：category 即专业大类，它的子节点 major 即专业。
//   注册时还没登录，所以表对 anon 开了只读（迁移 0039）。
//
// 拉不到树时不阻断注册：两个下拉禁用并给出说明，注册后可在「我的」里补全（字段本来就可空）。
//
// 年份用下拉而不是手输：这个范围的年份不多，选比敲快，也免了「2O26」这种手滑。
// 班级保持手输——班级名是学校自己排的，树里没有，也不该有。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';

class EnrollmentFields extends StatelessWidget {
  const EnrollmentFields({
    super.key,
    required this.enrollYear,
    required this.onEnrollYearChanged,
    required this.majorCategory,
    required this.onMajorCategoryChanged,
    required this.major,
    required this.onMajorChanged,
    required this.classNameController,
    required this.nodes,
    this.nodesLoading = false,
    this.enabled = true,
  });

  /// 入学年份；null = 暂不填。
  final int? enrollYear;

  final ValueChanged<int?> onEnrollYearChanged;

  /// 专业大类（树里 category 节点的名称）；null = 暂不选。
  final String? majorCategory;
  final ValueChanged<String?> onMajorCategoryChanged;

  /// 专业（所选大类下 major 节点的名称）；null = 暂不选。
  final String? major;
  final ValueChanged<String?> onMajorChanged;

  /// 班级仍然手输。
  final TextEditingController classNameController;

  /// 科目树全量节点（页面取来后原样传进来，本组件自己挑专业目录那两级的名字）。
  final List<SubjectNode> nodes;

  /// 树还在加载：下拉先禁用，避免出现"看起来没专业可选"的误会。
  final bool nodesLoading;

  final bool enabled;

  /// 班级的长度上限（与 update_my_enrollment 一致）。
  static const int _classMaxLength = 20;

  /// 可选年份，从近到远排——绝大多数用户要选的那一年就在最前面。
  static final List<int> _years = List.generate(101, (i) => 2100 - i);

  /// 专业目录里的大类（按维护顺序）。
  static List<SubjectNode> categoriesOf(List<SubjectNode> nodes) {
    final list = nodes
        .where((n) => n.scope == SubjectScope.vocational.wire && n.kind == SubjectKind.category.wire)
        .toList();
    list.sort((a, b) => a.sortOrder != b.sortOrder
        ? a.sortOrder.compareTo(b.sortOrder)
        : a.name.compareTo(b.name));
    return list;
  }

  /// 某个大类下的专业。
  ///
  /// 按**名字**找大类：档案里存的是名字（profiles.major_category 是 text），
  /// 不是节点 id。树里同级重名在实践中不会出现（管理员维护），真重名时取第一个。
  static List<SubjectNode> majorsOf(List<SubjectNode> nodes, String? categoryName) {
    if (categoryName == null || categoryName.trim().isEmpty) return const [];
    SubjectNode? parent;
    for (final n in categoriesOf(nodes)) {
      if (n.name == categoryName) {
        parent = n;
        break;
      }
    }
    if (parent == null) return const [];
    final list = nodes.where((n) => n.parentId == parent!.id && n.kind == SubjectKind.major.wire).toList();
    list.sort((a, b) => a.sortOrder != b.sortOrder
        ? a.sortOrder.compareTo(b.sortOrder)
        : a.name.compareTo(b.name));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15.sp);
    final categories = categoriesOf(nodes);
    final majors = majorsOf(nodes, majorCategory);
    final pickersReady = enabled && !nodesLoading && categories.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: '就读信息', subtitle: '可先跳过，注册后在「我的」里补全'),
        DropdownButtonFormField<int>(
          initialValue: enrollYear,
          isExpanded: true,
          style: body,
          decoration: const InputDecoration(
            labelText: '入学年份',
            prefixIcon: Icon(Icons.event_outlined),
          ),
          items: [
            const DropdownMenuItem<int>(value: null, child: Text('暂不选择')),
            for (final year in _years)
              DropdownMenuItem<int>(value: year, child: Text('$year 年')),
          ],
          onChanged: enabled ? onEnrollYearChanged : null,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        DropdownButtonFormField<String>(
          initialValue: categories.any((n) => n.name == majorCategory) ? majorCategory : null,
          isExpanded: true,
          style: body,
          decoration: const InputDecoration(
            labelText: '专业大类',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: [
            const DropdownMenuItem<String>(value: null, child: Text('暂不选择')),
            for (final c in categories)
              DropdownMenuItem<String>(value: c.name, child: Text(c.name)),
          ],
          onChanged: pickersReady
              ? (value) {
                  // 换大类要清掉专业：旧专业很可能不属于新大类，留着就是脏数据
                  if (value != majorCategory) onMajorChanged(null);
                  onMajorCategoryChanged(value);
                }
              : null,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        DropdownButtonFormField<String>(
          initialValue: majors.any((n) => n.name == major) ? major : null,
          isExpanded: true,
          style: body,
          decoration: const InputDecoration(
            labelText: '专业',
            prefixIcon: Icon(Icons.architecture_outlined),
          ),
          items: [
            const DropdownMenuItem<String>(value: null, child: Text('暂不选择')),
            for (final m in majors)
              DropdownMenuItem<String>(value: m.name, child: Text(m.name)),
          ],
          onChanged: pickersReady && majors.isNotEmpty ? onMajorChanged : null,
        ),
        if (nodesLoading || categories.isEmpty) ...[
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            nodesLoading
                ? '正在加载专业目录…'
                : '暂时拉不到专业目录（可能是网络问题）：可以先跳过这两项，注册后在「我的 → 修改就读信息」里补选。',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        SizedBox(height: AppMetrics.gapLg.r),
        TextFormField(
          controller: classNameController,
          enabled: enabled,
          maxLength: _classMaxLength,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: '班级',
            hintText: '如：23 数控 1 班',
            prefixIcon: Icon(Icons.groups_outlined),
          ),
        ),
      ],
    );
  }
}

/// 表单文本 → 入库值。去空白；空串归一成 null——服务端按 nullif(trim()) 落库，两者同义。
String? optionalText(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
