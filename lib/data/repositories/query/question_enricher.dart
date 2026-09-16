// 题库行的「装配」：把 PostgREST 返回的版本行摊平成 QuestionBrief，
// 并补齐它自己没有的展示字段（科目路径、题源学校名、标签）。
//
// 单独成一层的原因：列表（一页 10 行）与详情（1 行）用的是同一套补齐逻辑，
// 而补齐需要额外的两次小查询。放在这里两处共用，口径不会漂移——
// 否则很容易出现"列表里有标签、详情里没有"这类不一致。
//
// 输入行必须是列表查询的形状：版本列 + 内嵌的 question 对象。

import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/domain/subject_tree.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionEnricher {
  const QuestionEnricher(this._client);

  final SupabaseClient _client;

  /// [nodes] 通常由调用方（题库页/组卷页）已经取过并传入，避免每次列表请求都重拉科目树。
  Future<List<QuestionBrief>> enrich(
    List<Map<String, dynamic>> versions, {
    List<SubjectNode>? nodes,
  }) async {
    if (versions.isEmpty) return const [];

    final versionIds = versions.map((v) => v['id'] as String).toList();
    final schoolIds = <String>{};
    for (final version in versions) {
      final question = version['question'];
      if (question is Map && question['school_id'] != null) {
        schoolIds.add(question['school_id'] as String);
      }
    }

    // 三次查询互不依赖，先一起发出再统一等待：串行 await 会把三个网络往返
    // 叠加进同一次列表加载，页面等的是它们的和而不是最大值。
    //
    // 用 Future.wait 而不是 Dart 3 record 的 `.wait`：后者任一失败时抛
    // ParallelWaitError，会把仓储边界的 mapError 挡在外面 —— 原始的网络/数据库
    // 异常认不出来，用户看到的从「网络连接失败，请检查网络后重试」退化成
    // 「操作失败，请稍后重试」。Future.wait 保留原始异常，也会替我们接住其余
    // future 的错误（逐个 await 则可能在第一个失败后留下无人处理的异步异常）。
    final results = await Future.wait<Object>([
      nodes != null
          ? Future<List<SubjectNode>>.value(nodes)
          : SubjectRepository(_client).fetchNodes(),
      _tagsOf(versionIds),
      _schoolNames(schoolIds),
    ]);
    final nodeList = results[0] as List<SubjectNode>;
    final tagsByVersion = results[1] as Map<String, List<String>>;
    final schoolNames = results[2] as Map<String, String>;
    final pathOf = buildNodeIndex(nodeList);

    return versions.map((version) {
      final question = Map<String, dynamic>.from(version['question'] as Map);
      final content = QuestionContent.fromJson(
        Map<String, dynamic>.from(version['content'] as Map? ?? const {}),
      );
      final versionId = version['id'] as String;
      final nodeId = question['course_node_id'] as String?;
      return QuestionBrief(
        questionId: question['id'] as String,
        versionId: versionId,
        qtype: version['qtype'] as String,
        difficulty: version['difficulty'] as int?,
        courseNodeId: nodeId,
        schoolId: question['school_id'] as String?,
        stemText: content.stemText,
        versionNo: version['version_no'] as int?,
        publishedAt: DateTime.tryParse('${version['published_at']}'),
        tags: tagsByVersion[versionId] ?? const [],
        nodePath: pathOf(nodeId),
        schoolName: schoolNames[question['school_id']] ?? '',
      );
    }).toList();
  }

  /// 标签是多对多，且**存的是打标时的名称快照**（tag_name），
  /// 所以这里取 tag_name 而不是去 join tags 表——历史版本要显示当时的名字。
  Future<Map<String, List<String>>> _tagsOf(List<String> versionIds) async {
    final rows = await _client
        .from('version_tags')
        .select('version_id, tag_name')
        .inFilter('version_id', versionIds);
    final result = <String, List<String>>{};
    for (final row in rows) {
      result.putIfAbsent(row['version_id'] as String, () => [])
          .add(row['tag_name'] as String);
    }
    return result;
  }

  Future<Map<String, String>> _schoolNames(Set<String> ids) async {
    if (ids.isEmpty) return const {};
    final rows = await _client
        .from('schools')
        .select('id, name')
        .inFilter('id', ids.toList());
    return {for (final row in rows) row['id'] as String: row['name'] as String};
  }
}

/// LIKE 通配符转义，让关键词里的 % _ \ 按字面匹配（与网页端 lib/question-model 同规则）。
String escapeLikeKeyword(String input) =>
    input.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');
