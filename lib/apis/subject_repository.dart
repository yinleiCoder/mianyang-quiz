// 参考数据：科目树与知识点标签。
//
// 与 QuestionRepository 分开是因为两者生命周期不同：
// 参考数据在一次会话里几乎不变（进题库页取一次即可跨页复用），
// 而题目列表随筛选与翻页频繁变化。混在一起会让"该不该缓存"变得难以回答。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectRepository {
  const SubjectRepository(this._client);

  final SupabaseClient _client;

  /// 全量科目节点，按 sort_order、name 排序。
  /// 树结构由 utils/subject_tree.dart 的纯函数在客户端拼装——
  /// 数据库返回的是一张扁平表（parent_id 自引用），没有层级字段。
  Future<List<SubjectNode>> fetchNodes() async {
    try {
      final rows = await _client
          .from('subject_nodes')
          .select('id, parent_id, scope, kind, name, sort_order, is_frozen')
          .order('sort_order')
          .order('name');
      return rows.map(SubjectNode.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 知识点标签（0096 起带学科与层级）。
  ///
  /// 排序与服务端同义：先 sort_order 再 name，让同一父级下的兄弟保持人工排定的顺序。
  /// **未归类的（subject_node_id 为空）也一并取回**：题库筛选那边要能看到它们，
  /// 由调用方决定要不要按学科收口（见 filters 里的 tagScope）。
  Future<List<QuestionTag>> fetchTags() async {
    try {
      final rows = await _client
          .from('tags')
          .select('id, name, parent_id, subject_node_id, sort_order')
          .order('sort_order')
          .order('name');
      return rows.map(QuestionTag.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }
}
