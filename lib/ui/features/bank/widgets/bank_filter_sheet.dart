// 题库筛选面板（底部弹出）。
//
// 职责：持有一份**草稿** QuestionFilter（关键词、科目、题型、难度、标签），
// 点「查看结果」把它整体 pop 回页面，点「重置」清空草稿。
// 不负责：五个维度怎么画（BankFilterSections）、科目树面板本身（SubjectTreeSheet）、
// 查询与分页（BankPage 拿到返回值后才发请求）、已选条件的回显（BankFilterBar）。
//
// 为什么是草稿而不是边改边查：每改一次就发一次请求既费流量，又会让面板背后的列表乱跳。
// 取消（下滑关闭 / 返回）返回 null —— 调用方保持原条件不变，这与「重置」是两回事。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/bank_filter_sections.dart';
import 'package:mianyang_quiz/ui/core/subject/subject_tree_sheet.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class BankFilterSheet extends StatefulWidget {
  const BankFilterSheet({
    super.key,
    required this.initial,
    required this.nodes,
    required this.tags,
  });

  /// 当前生效的条件，作为草稿初值。
  final QuestionFilter initial;

  /// 科目树与标签表：页面进页面时取一次后传入，面板打开不再发请求。
  final List<SubjectNode> nodes;
  final List<QuestionTag> tags;

  /// 底部弹出；返回 null 表示取消。
  static Future<QuestionFilter?> show(
    BuildContext context, {
    required QuestionFilter initial,
    required List<SubjectNode> nodes,
    required List<QuestionTag> tags,
  }) {
    return showModalBottomSheet<QuestionFilter>(
      context: context,
      isScrollControlled: true,
      // 拖动提示条交给框架画，两个 sheet 的顶部形态自然一致
      showDragHandle: true,
      builder: (_) =>
          BankFilterSheet(initial: initial, nodes: nodes, tags: tags),
    );
  }

  @override
  State<BankFilterSheet> createState() => _BankFilterSheetState();
}

class _BankFilterSheetState extends State<BankFilterSheet> {
  late final TextEditingController _keyword = TextEditingController(
    text: widget.initial.keyword,
  );
  late Set<QuestionType> _qtypes = {...widget.initial.qtypes};
  late int? _difficulty = widget.initial.difficulty;
  late String? _nodeId = widget.initial.nodeId;
  late String? _tagId = widget.initial.tagId;

  /// 节点 id → 名称链，用于把已选科目显示成「专业目录 / 汽车运用」。
  late final String Function(String?) _pathOf = buildNodeIndex(widget.nodes);

  @override
  void dispose() {
    _keyword.dispose();
    super.dispose();
  }

  void _reset() => setState(() {
    _keyword.clear();
    _qtypes = {};
    _difficulty = null;
    _nodeId = null;
    _tagId = null;
  });

  void _apply() => Navigator.of(context).pop(
    QuestionFilter(
      keyword: _keyword.text.trim(),
      nodeId: _nodeId,
      qtypes: _qtypes,
      difficulty: _difficulty,
      tagId: _tagId,
    ),
  );

  Future<void> _pickNode() async {
    final picked = await SubjectTreeSheet.show(
      context,
      nodes: widget.nodes,
      selectedId: _nodeId,
    );
    if (picked == null || !mounted) return; // null = 直接关掉，保持原值
    setState(() => _nodeId = picked.isEmpty ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // 顶到键盘之上：关键词输入框不能被输入法盖住
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('筛选题目', style: AppTextStyles.sectionTitle(context)),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppMetrics.pagePadding.r,
                    vertical: AppMetrics.gapMd.r,
                  ),
                  child: MaxWidthBox(
                    child: BankFilterSections(
                      keywordController: _keyword,
                      onKeywordSubmitted: _apply,
                      nodePath: _pathOf(_nodeId),
                      onPickNode: _pickNode,
                      qtypes: _qtypes,
                      // 再点一次已选中的项 = 取消
                      onToggleQtype: (type) => setState(() {
                        if (!_qtypes.remove(type)) _qtypes.add(type);
                      }),
                      difficulty: _difficulty,
                      onToggleDifficulty: (value) => setState(
                        () => _difficulty = _difficulty == value ? null : value,
                      ),
                      tags: widget.tags,
                      tagId: _tagId,
                      onToggleTag: (tag) =>
                          setState(() => _tagId = _tagId == tag.id ? null : tag.id),
                    ),
                  ),
                ),
              ),
              _footer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppMetrics.gapLg.r),
        child: MaxWidthBox(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: DuoButton(
                  label: '重置',
                  variant: DuoButtonVariant.outline,
                  icon: Icons.restart_alt_rounded,
                  compact: true,
                  onPressed: _reset,
                ),
              ),
              SizedBox(width: AppMetrics.gapMd.r),
              Expanded(
                flex: 3,
                child: DuoButton(
                  label: '查看结果',
                  icon: Icons.search_rounded,
                  compact: true,
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
