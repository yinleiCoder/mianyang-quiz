// 答卷 units 形状的解析容错（0139 之后的历史数据兜底）。
//
// 服务端有两种历史写法：自动判分题存 `[{ok, score}]`，人工判分题（简答）
// 在 0139 之前存的是裸布尔 `[false, false]`。客户端模型是 `List<ScoreUnit>`，
// 生成代码里写死 `e as Map<String, dynamic>` —— 碰到布尔会抛 TypeError，
// **整份答卷解析失败**，成绩单页只剩一句「操作失败，请稍后重试」。
//
// 服务端已统一（0139），这里兜的是修复前落库的旧数据：解析层的容错，
// 不改变任何判分口径（布尔只有"没给分"一种含义，`score` 恒为 0）。
//
// 单独一个文件，是为了不让 paper_repository.dart 顶到 200 行（架构检查）。

/// 把 `answers[].units` 的旧布尔形状就地改写成对象形状，返回原对象。
///
/// 提成顶层函数只为可测：它是"整页能不能打开"的事，值得一条回归
/// （见 test/apis/exam_units_normalize_test.dart）。
Map<String, dynamic> normalizeExamAnswerUnits(Map<String, dynamic> data) {
  final answers = data['answers'];
  if (answers is! List) return data;
  for (final record in answers) {
    if (record is! Map) continue;
    final units = record['units'];
    if (units is! List || !units.any((unit) => unit is bool)) continue;
    record['units'] = [
      for (final unit in units)
        unit is Map ? unit : <String, dynamic>{'ok': unit == true, 'score': 0},
    ];
  }
  return data;
}
