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

    final nodeList = nodes ?? await SubjectRepository(_client).fetchNodes();
    final pathOf = buildNodeIndex(nodeList);

    final tagsByVersion = await _tagsOf(versionIds);
    final schoolNames = await _schoolNames(schoolIds);

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
