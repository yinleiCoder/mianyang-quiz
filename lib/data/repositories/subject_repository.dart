// 参考数据：科目树与知识点标签。
//
// 与 QuestionRepository 分开是因为两者生命周期不同：
// 参考数据在一次会话里几乎不变（进题库页取一次即可跨页复用），
// 而题目列表随筛选与翻页频繁变化。混在一起会让"该不该缓存"变得难以回答。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/bank/question_tag.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectRepository {
  const SubjectRepository(this._client);

  final SupabaseClient _client;

  /// 全量科目节点，按 sort_order、name 排序。
  /// 树结构由 domain/subject_tree.dart 的纯函数在客户端拼装——
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

  Future<List<QuestionTag>> fetchTags() async {
    try {
      final rows = await _client.from('tags').select('id, name').order('name');
      return rows.map(QuestionTag.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }
}
