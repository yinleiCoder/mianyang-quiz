// 题库筛选条件。**题库列表**与**组卷**共用同一份筛选值对象——
// 两处的可选维度本就一致，各写一份迟早会漂移。
//
// 纯值对象，不做 JSON 反序列化（不对应任何一次网络响应），所以没有 .g.dart。
// toRpcParams() 是纯函数、可单测，保证传给 start_practice_session 的参数名与类型正确。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';

part 'question_filter.freezed.dart';

@freezed
abstract class QuestionFilter with _$QuestionFilter {
  const factory QuestionFilter({
    /// 关键词，按题干全文检索（服务端会对 % _ \ 做转义）。
    @Default('') String keyword,

    /// 科目节点。选中父节点时服务端会包含其全部后代课程。
    String? nodeId,

    /// 题型多选。空集合表示不限。
    @Default(<QuestionType>{}) Set<QuestionType> qtypes,

    /// 难度 1 易 / 2 中 / 3 难。null 表示不限（注意与"值为 0"不同）。
    int? difficulty,

    String? tagId,
  }) = _QuestionFilter;
}

extension QuestionFilterX on QuestionFilter {
  /// 是否设置了任何条件（用于显示"清除筛选"与"已按条件过滤"提示）。
  bool get hasAny =>
      keyword.trim().isNotEmpty ||
      nodeId != null ||
      qtypes.isNotEmpty ||
      difficulty != null ||
      tagId != null;

  /// 传给 start_practice_session 的参数。
  ///
  /// 要点：
  ///   · 题型传**线格式字符串**（single_choice…），不是枚举名
  ///   · 未设置的条件传 null，让 RPC 用它的默认值语义（"不限"）
  ///   · 关键词两端去空白；空串同样传 null，避免服务端把它当成 "" 去匹配
  Map<String, dynamic> toRpcParams() => {
    'p_node_id': nodeId,
    'p_qtypes': qtypes.isEmpty ? null : qtypes.map((t) => t.wire).toList(),
    'p_difficulty': difficulty,
    'p_tag_id': tagId,
    'p_keyword': keyword.trim().isEmpty ? null : keyword.trim(),
  };
}
