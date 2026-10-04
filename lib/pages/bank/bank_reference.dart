// 题库页的参考数据（科目树、标签）：一次会话里几乎不变，进页面取一次，翻页不再重复请求。
//
// 单独一个文件而不是继续堆在 BankPage 里：这是**取数**的事，与页面状态机（第几页、
// 筛选条件、加载三态）不是一回事；而且失败策略也不同 —— 这个失败**不阻断列表**，
// 筛选面板退化成"只有关键词与题型"，题目照常浏览，比整页报错合理。

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
      return BankReference(
        nodes: await subjects.fetchNodes(),
        tags: await subjects.fetchTags(),
      );
    } on AppException {
      return const BankReference();
    }
  }
}
