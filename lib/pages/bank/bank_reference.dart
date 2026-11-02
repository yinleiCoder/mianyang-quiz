// 题库页的参考数据（科目树、标签）：一次会话里几乎不变，进页面取一次，翻页不再重复请求。
//
// 单独一个文件而不是继续堆在 BankPage 里：这是**取数**的事，与页面状态机（第几页、
// 筛选条件、加载三态）不是一回事；而且失败策略也不同 —— 这个失败**不阻断列表**，
// 筛选面板退化成"只有关键词与题型"，题目照常浏览，比整页报错合理。
//
// 两条数据现在**并行取**：它们互不依赖，串行 await 会让页面等两个来回的和。
// 跨境网络下（2026-11-02 实测用户到 Supabase 边缘节点要绕美国）一次往返约 0.5~1.5s，
// 串行与并行在这里差整整一倍。SubjectRepository 自己还有 10 分钟缓存，第二次进页即取即回。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class BankReference {
  const BankReference({this.nodes = const [], this.tags = const []});

  final List<SubjectNode> nodes;
  final List<QuestionTag> tags;

  /// 取一次；任何 AppException 都当作"没有参考数据"（见文件头）。
  static Future<BankReference> load(SubjectRepository subjects) async {
    try {
      // Future.wait 而不是 record 的 .wait：任一失败时它保留原始异常，
      // 仓储边界的 mapError 才接得住（与 QuestionEnricher 同一口径）。
      final results = await Future.wait<Object>([
        subjects.fetchNodes(),
        subjects.fetchTags(),
      ]);
      return BankReference(
        nodes: results[0] as List<SubjectNode>,
        tags: results[1] as List<QuestionTag>,
      );
    } on AppException {
      return const BankReference();
    }
  }
}
