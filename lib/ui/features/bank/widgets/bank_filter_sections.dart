// 筛选面板的五个维度：关键词、科目、题型、难度、标签。
//
// 职责：只负责把给定的当前值画出来，并把用户的每一次改动原样上报——
// 它自己**不持任何状态**，草稿在 BankFilterSheet 的 State 里。
// 拆出来的原因只有一个：面板文件会超过 200 行；顺带让"渲染"与"状态"两件事分开看。
//
// 为什么参数这么多：它就是一张表单，每个字段的"值 + 变更回调"本就该成对出现，
// 少传一个字段就等于少画一行控件。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/ui/core/design/filter_chip_group.dart';
import 'package:mianyang_quiz/ui/core/subject/subject_picker_row.dart';

class BankFilterSections extends StatelessWidget {
  const BankFilterSections({
    super.key,
    required this.keywordController,
    required this.onKeywordSubmitted,
    required this.nodePath,
    required this.onPickNode,
    required this.qtypes,
    required this.onToggleQtype,
    required this.difficulty,
    required this.onToggleDifficulty,
    required this.tags,
    required this.tagId,
    required this.onToggleTag,
  });

  /// 未知题型不会出现在库里，列出来只会让人困惑。
  static final _qtypeOptions = QuestionType.values
      .where((type) => type != QuestionType.unknown)
      .toList();

  final TextEditingController keywordController;

  /// 键盘上按"搜索"：等同于点「查看结果」。
  final VoidCallback onKeywordSubmitted;

  /// 已选科目的名称链；空串显示为「不限」。
  final String nodePath;

  final VoidCallback onPickNode;

  final Set<QuestionType> qtypes;
  final ValueChanged<QuestionType> onToggleQtype;

  final int? difficulty;
  final ValueChanged<int> onToggleDifficulty;

  final List<QuestionTag> tags;
  final String? tagId;
  final ValueChanged<QuestionTag> onToggleTag;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _section(
        context,
        '关键词',
        TextField(
          controller: keywordController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onKeywordSubmitted(),
          decoration: const InputDecoration(
            hintText: '按题干内容搜索',
            prefixIcon: Icon(Icons.search_rounded),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      _section(
        context,
        '科目',
        SubjectPickerRow(path: nodePath, onTap: onPickNode),
      ),
      _section(
        context,
        '题型（可多选）',
        FilterChipGroup<QuestionType>(
          items: _qtypeOptions,
          labelOf: (type) => type.label,
          selectedOf: qtypes.contains,
          onToggle: onToggleQtype,
        ),
      ),
      _section(
        context,
        '难度',
        FilterChipGroup<int>(
          items: kDifficultyValues,
          labelOf: difficultyLabel,
          selectedOf: (value) => difficulty == value,
          onToggle: onToggleDifficulty,
        ),
      ),
      // 题库还没打标签时整节不出现，免得空着一个标题
      if (tags.isNotEmpty)
        _section(
          context,
          '标签',
          FilterChipGroup<QuestionTag>(
            items: tags,
            labelOf: (tag) => tag.name,
            selectedOf: (tag) => tagId == tag.id,
            onToggle: onToggleTag,
            // 标签可能上百个，限高后可滚动
            maxHeight: 140,
          ),
        ),
    ],
  );
}

/// 每个维度一节：小标题 + 控件。
Widget _section(BuildContext context, String title, Widget child) => Padding(
  padding: EdgeInsets.only(bottom: AppMetrics.gapLg.r),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.label(context)),
      SizedBox(height: AppMetrics.gapSm.r),
      child,
    ],
  ),
);
