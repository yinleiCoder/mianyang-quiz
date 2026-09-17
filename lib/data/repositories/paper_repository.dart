// 考试：挑卷子、开考/续考、交卷、查成绩（0045 的 list_papers + 0052 的考试三件套
// + 0056 的两个只读入口）。
//
// 与练习的分界：考试的作答**不在本地判分**，一次也不判——判分权威完全在服务端
// （0051 的 grade_exam_units 是按计分点给的，本地那套布尔镜像在这里只会给出错的分数）。
// 所以这里没有 PracticeRepository 那种"本地抢先显示、提交后对账"的戏份。
//
// 卷面只能从 start_exam_attempt / get_my_exam_attempt 拿：服务端在那个关口把
// content.answer 剥掉了（考试中），客户端不许、也读不到 paper_items。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/exam/exam_records.dart';
import 'package:mianyang_quiz/data/models/exam/paper_brief.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaperRepository {
  const PaperRepository(this._client);

  final SupabaseClient _client;

  /// 组卷库：已入库、在线、且当前版本的那一份份卷子。
  ///
  /// [nodeId] 传专业节点时会**含其整棵子树**（服务端递归），不是只匹配该节点本身。
  /// [keyword] 是大小写不敏感的包含匹配（服务端用 strpos，不是 LIKE），
  /// 所以搜「100%」不会变成通配符。
  Future<List<PaperBrief>> fetchPapers({
    String? nodeId,
    String? keyword,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'list_papers',
        params: {
          'p_node': nodeId,
          'p_kw': keyword,
          'p_limit': limit,
          'p_offset': offset,
        },
      );
      final rows = data['papers'] as List? ?? const [];
      return [
        for (final row in rows)
          PaperBrief.fromJson(Map<String, dynamic>.from(row as Map)),
      ];
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 我的考试记录，**含进行中那一场**——它是「继续答题」的入口。
  ///
  /// 不直查 exam_attempts：卷名在 paper_versions 上，而那张表的 RLS 只放行
  /// "仍是当前入库版"的那一版，试卷一改版历史记录就查不到卷名了（见 0056）。
  Future<List<ExamAttemptRecord>> fetchMyAttempts({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'list_my_exam_attempts',
        params: {'p_limit': limit, 'p_offset': offset},
      );
      final rows = data['attempts'] as List? ?? const [];
      return [
        for (final row in rows)
          ExamAttemptRecord.fromJson(Map<String, dynamic>.from(row as Map)),
      ];
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 开考。同一份卷同时只能有一场进行中：
  /// 已有未交卷的那场时，服务端**把那一场原样还回来**（连同已作答的记录），
  /// 于是"开考"与"续考"是同一条代码路径，调用方不必先查有没有在途的考试。
  ///
  /// 可能的报错（都是给用户看的中文）：试卷不存在 / 还没有入库 / 已下线 / 试卷是空的。
  Future<ExamSnapshot> startAttempt(String paperVersionId) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'start_exam_attempt',
        params: {'p_paper_version_id': paperVersionId},
      );
      return ExamSnapshot.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 按 id 取回一场考试（续考或看成绩单）。
  ///
  /// 卷面**带不带答案取决于状态**：出分后（graded）服务端换成完整快照，
  /// 学生这时才看得到标准答案；待阅卷期间与考试中都是剥掉答案的。
  /// 客户端不做判断，只看 content.answer 在不在。
  Future<ExamSnapshot> fetchAttempt(String attemptId) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'get_my_exam_attempt',
        params: {'p_attempt_id': attemptId},
      );
      return ExamSnapshot.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 交卷。**整个卷子一次提交**，服务端逐题判分（客观题当场给分，主观题置 pending）。
  ///
  /// [answers] 是 题项id → 作答：键必须是 `paper_items.id`（ExamItem.id），
  /// 不是 question_id。没作答的题**不要**放进来——服务端对缺项的题按空作答处理，
  /// 硬塞一个空答案反而会把"没答"写成一条记录。
  ///
  /// 交卷后客观分立刻出来，主观题要等教师阅卷，所以返回的 total 不是最终成绩。
  Future<ExamSubmitSummary> submitAttempt({
    required String attemptId,
    required Map<String, SubmittedAnswer> answers,
    int? durationMs,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'submit_exam_attempt',
        params: {
          'p_attempt_id': attemptId,
          'p_answers': [
            for (final entry in answers.entries)
              {
                'paper_item_id': entry.key,
                'answer': entry.value.toJson(),
              },
          ],
          'p_duration_ms': durationMs,
        },
      );
      return ExamSubmitSummary.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }
}
