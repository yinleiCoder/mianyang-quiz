// 题库读取：已入库题目的列表与详情。
//
// 为什么走 PostgREST 而不是 RPC：服务端**没有**题库列表的 RPC
// （0029-0032 只提供了练习相关的那批）。查询形状直接复用网页端
// app/(app)/bank/page.jsx 已验证的那一条。
//
// 可见性：只取 status=published 且其题目 state=live 的**当前版本**。
// 注意 RLS 的 select_version 策略还额外放行"作者本人的所有版本"，
// 所以必须显式带上这两个过滤，否则教师账号会看到自己已被替换的旧版本。
//
// 行的装配（补科目路径/学校名/标签）在 query/question_enricher.dart，与详情页共用。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/repositories/query/question_enricher.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 一页题目 + 总数（分页需要总数才能算页数）。
typedef QuestionPage = ({List<QuestionBrief> rows, int total});

/// 题目详情：展示用的元信息 + 作答/展示用的内容，一次取回。
typedef QuestionDetail = ({QuestionBrief brief, QuestionContent content});

class QuestionRepository {
  const QuestionRepository(this._client);

  final SupabaseClient _client;

  /// 列表查询用到的列。**外键 hint 必须带**：
  /// questions ↔ question_versions 是双外键，不带会让 PostgREST 返回 300。
  static const _versionColumns =
      'id, question_id, version_no, qtype, difficulty, content, published_at, '
      'question:questions!question_versions_question_id_fkey!inner('
      'id, school_id, course_node_id, state)';

  /// 分页查询已入库题目。[page] 从 1 开始。
  Future<QuestionPage> listQuestions({
    QuestionFilter filter = const QuestionFilter(),
    int page = 1,
    int pageSize = 10,
    List<SubjectNode>? nodes,
  }) async {
    try {
      final nodeList = nodes ?? await SubjectRepository(_client).fetchNodes();

      // 科目筛选 = 选中节点及其全部后代（题库挂在学科/课程上）
      final nodeIds = filter.nodeId == null
          ? null
          : subtreeIds(nodeList, filter.nodeId!);

      // 标签是多对多，PostgREST 无法在过滤层直接 join，先取命中的版本 id
      final tagVersionIds = filter.tagId == null
          ? null
          : (await _client
                    .from('version_tags')
                    .select('version_id')
                    .eq('tag_id', filter.tagId!))
                .map((row) => row['version_id'] as String)
                .toSet();

      // 条件必然为空集时直接短路，不必发请求
      if (nodeIds != null && nodeIds.isEmpty) {
        return (rows: <QuestionBrief>[], total: 0);
      }
      if (tagVersionIds != null && tagVersionIds.isEmpty) {
        return (rows: <QuestionBrief>[], total: 0);
      }

      var query = _client
          .from('question_versions')
          .select(_versionColumns)
          .eq('status', 'published')
          .eq('question.state', 'live');

      if (filter.qtypes.isNotEmpty) {
        query = query.inFilter('qtype', filter.qtypes.map((t) => t.wire).toList());
      }
      if (filter.difficulty != null) {
        query = query.eq('difficulty', filter.difficulty!);
      }
      final keyword = filter.keyword.trim();
      if (keyword.isNotEmpty) {
        query = query.ilike('search_text', '%${escapeLikeKeyword(keyword)}%');
      }
      if (nodeIds != null) {
        query = query.inFilter('question.course_node_id', nodeIds);
      }
      if (tagVersionIds != null) {
        query = query.inFilter('id', tagVersionIds.toList());
      }

      // .count() 必须放在链尾——它把返回类型从"数据"变成"数据 + 总数"
      // （postgrest 2.9.1 的 select() 没有 count 参数）
      final response = await query
          .order('published_at', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1)
          .count(CountOption.exact);

      final rows = await QuestionEnricher(_client)
          .enrich(response.data, nodes: nodeList);
      return (rows: rows, total: response.count);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 按题目 id 取**当前已发布版本**的元信息与内容。题目不可见（已下线/不存在）时返回 null。
  ///
  /// 两个必须的细节：
  ///   · 反向嵌入的外键 hint 是 `fk_questions_current_version`
  ///     （走 questions.current_published_version_id → question_versions.id），
  ///     与列表页那个正向的 `question_versions_question_id_fkey` **不是同一个**，写错就是 300。
  ///   · `!inner` 与显式 `version.status=published` 都不能省：
  ///     前者让内嵌过滤能剔除主行，后者抵消 RLS 对"作者本人旧版本"的额外放行。
  Future<QuestionDetail?> fetchDetail(
    String questionId, {
    List<SubjectNode>? nodes,
  }) async {
    try {
      final row = await _client
          .from('questions')
          .select(
            'id, school_id, course_node_id, state, '
            'version:question_versions!fk_questions_current_version!inner('
            'id, version_no, qtype, difficulty, content, published_at, status)',
          )
          .eq('id', questionId)
          .eq('state', 'live')
          .eq('version.status', 'published')
          .maybeSingle();
      if (row == null) return null;

      final version = Map<String, dynamic>.from(row['version'] as Map);
      // 摊成列表查询的形状后复用同一套装配，避免详情与列表的补齐口径漂移
      final brief = (await QuestionEnricher(_client).enrich([
        {
          'id': version['id'],
          'question_id': row['id'],
          'version_no': version['version_no'],
          'qtype': version['qtype'],
          'difficulty': version['difficulty'],
          'content': version['content'],
          'published_at': version['published_at'],
          'question': row,
        },
      ], nodes: nodes)).single;

      return (
        brief: brief,
        content: QuestionContent.fromJson(
          Map<String, dynamic>.from(version['content'] as Map? ?? const {}),
        ),
      );
    } catch (error) {
      throw mapError(error);
    }
  }
}
