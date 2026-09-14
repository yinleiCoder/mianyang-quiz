// 错题本、收藏列表，以及题卡的批量正确率。
//
// 与练习仓储分开：这里全是**只读**分页查询，不建会话、不改任何状态，
// 页面可以随便重试与下拉刷新；练习仓储的方法则都有副作用。
//
// 两个列表在题目已下线/删除时会返回**占位行**（available=false、stem_text 为 null），
// 界面要显示「题目已不可用」且不可点击——不要在这里把它们过滤掉，
// 否则用户会以为记录凭空消失（收藏行还要能取消收藏）。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/list/question_row.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 一道题的**全站**正确率。没有作答记录的题不会出现在结果里（见 fetchAccuracy）。
typedef QuestionAccuracy = ({int attempts, int correct});

class ListRepository {
  const ListRepository(this._client);

  final SupabaseClient _client;

  /// 错题本：最近一次作答为错的题，按作答时间倒序。
  /// 题目下线/删除后仍是列表成员（available=false 的占位行）。
  Future<List<WrongQuestion>> fetchWrongQuestions({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'list_my_wrong_questions',
        params: {'p_limit': limit, 'p_offset': offset},
      );
      return rows.map((row) => WrongQuestion.fromJson(_asMap(row))).toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 收藏列表：按收藏时间倒序，语义与错题本一致（含占位行，可取消收藏）。
  Future<List<FavoriteQuestion>> fetchFavorites({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'list_my_favorites',
        params: {'p_limit': limit, 'p_offset': offset},
      );
      return rows.map((row) => FavoriteQuestion.fromJson(_asMap(row))).toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 批量取全站正确率，键为 questionId，供题卡显示「正确率 xx%」。
  ///
  /// · 结果里**没有**某道题 = 全站还没人自动判分答过它，界面应留空而不是显示 0%
  ///   （0% 和「无数据」是两回事）。
  /// · 自评题（主观题）不计入，所以一道题可能只有自评记录而查不到。
  /// · **单次最多 200 个 id**，超出服务端直接报错；空列表不发请求。
  ///   列表页一页只有 10~20 条，正常用不到分批，但别把整库 id 攒起来一次传。
  Future<Map<String, QuestionAccuracy>> fetchAccuracy(
    List<String> questionIds,
  ) async {
    if (questionIds.isEmpty) return const {};
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'question_accuracy',
        params: {'p_question_ids': questionIds},
      );
      final accuracy = <String, QuestionAccuracy>{};
      for (final row in rows) {
        final item = _asMap(row);
        accuracy[item['question_id'] as String] = (
          attempts: _asInt(item['attempts']),
          correct: _asInt(item['correct']),
        );
      }
      return accuracy;
    } catch (error) {
      throw mapError(error);
    }
  }
}

/// PostgREST 返回的行是 `Map<String, dynamic>`，但静态类型是 dynamic——
/// 统一在这里收口，避免每个调用点各写一遍 cast。
Map<String, dynamic> _asMap(dynamic row) => Map<String, dynamic>.from(row as Map);

/// bigint 列在 JSON 里是数字；PostgREST 对超过 int 范围的聚合值可能给字符串，
/// 但这里 count 的规模（全站作答数）远不到那个量级，按 num 兜底即可。
int _asInt(dynamic value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;
