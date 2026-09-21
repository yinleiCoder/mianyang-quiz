// 复习资料的筛选条件。
//
// 纯值对象，不做 JSON 反序列化（不对应任何一次网络响应），所以没有 .g.dart。
// 与 QuestionFilter 同构：一个共享值对象 + hasAny + 取数参数转换，
// 页面只持有一个实例，筛选弹层改的是它的草稿副本。
//
// **筛选在服务端做**（PostgREST 查询条件），不是在客户端过滤已取回的那一页——
// 资料是全市共享的，未来会有几百上千份，客户端过滤只会筛出"当前这一页里符合条件的"。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/material_meta.dart';

part 'material_filter.freezed.dart';

@freezed
abstract class MaterialFilter with _$MaterialFilter {
  const factory MaterialFilter({
    /// 关键词，匹配标题 + 简介（服务端列是 search_text，已 lower）。
    @Default('') String keyword,

    /// 学科 / 专业大类节点。选中父节点时要不要含后代由页面的取数逻辑决定
    ///（PostgREST 直查做不了子树展开，所以这里只按精确节点筛）。
    String? nodeId,

    /// 类型多选。空集合表示不限。
    @Default(<MaterialKind>{}) Set<MaterialKind> kinds,
  }) = _MaterialFilter;
}

extension MaterialFilterX on MaterialFilter {
  bool get hasAny =>
      keyword.trim().isNotEmpty || nodeId != null || kinds.isNotEmpty;

  /// 传给仓储的参数。未设置的条件传 null，语义是"不限"。
  Map<String, Object?> toQueryParams() => {
    'keyword': keyword.trim().isEmpty ? null : keyword.trim(),
    'node_id': nodeId,
    'kinds': kinds.isEmpty ? null : kinds.map((k) => k.wire).toList(),
  };
}
