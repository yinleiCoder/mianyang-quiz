// 练习会话：组卷、续练、提交单题、交卷、放弃（0029/0030 的 5 个 RPC）。
//
// 会话的状态全在服务端：题面快照与判分都由 RPC 决定，客户端只负责把作答原样送回去。
// 本地判分（domain/answer_grader.dart）只用于抢先显示，提交后一律以返回的
// SubmitResult.isCorrect 覆盖。
//
// 与「背题模式」的分界：背题**不建会话**，纯 PostgREST 查题 + 本地翻题，不走这里。
// 因为这批方法都有副作用（会写 practice_sessions / practice_answers）。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/models/practice/session_record.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PracticeRepository {
  const PracticeRepository(this._client);

  final SupabaseClient _client;

  /// 组卷并开始一次练习，返回**完整题面快照**（items 已带 content，不必再查题库）。
  ///
  /// 调用方必须知道两件事：
  ///   · 服务端每人同时只允许一套 active 会话，本方法会**静默作废**旧的 active 会话，
  ///     旧进度不可恢复也不报错。进练习前先看 practice_dashboard 的 active_session，
  ///     非空时问用户「继续练习 / 重新开始（当前进度将作废）」。
  ///   · [limit] 服务端限制 1~50，越界直接报错；抽不到题时报「没有符合条件的题目」，
  ///     此时服务端已把刚建的空会话删掉，不必再收拾。
  ///
  /// [filter] 与 [questionIds] 只在 [source] 为 all 时生效——错题/收藏两条分支由服务端
  /// 自己定题，不看筛选条件。参数名与类型统一由 QuestionFilter.toRpcParams() 给出
  /// （题型传的是线格式字符串，不是枚举名）。
  Future<PracticeSessionSnapshot> startSession({
    QuestionFilter filter = const QuestionFilter(),
    int limit = 20,
    PracticeSource source = PracticeSource.all,
    List<String>? questionIds,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'start_practice_session',
        params: {
          ...filter.toRpcParams(),
          'p_limit': limit,
          'p_source': source.wire,
          'p_question_ids': questionIds,
        },
      );
      return PracticeSessionSnapshot.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 续练：按 id 取回会话（题面快照 + 已作答记录，用 answersByQuestion 还原每题状态）。
  /// 会话不存在或不属于本人时服务端直接报错，不会返回 null；已交卷/已作废的会话照样能读，
  /// 由调用方看 status 决定是继续作答还是只展示成绩。
  ///
  /// **"看 status"不是可选项**：非 active 的会话再提交，服务端每一次都拒
  /// （「本次练习已结束，无法继续作答」），而本地判分照样显示对错，用户会白答一整场。
  /// 练习页的落点是 PracticeRunner.ended / PracticeEndedView。
  Future<PracticeSessionSnapshot> fetchSession(String sessionId) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'get_practice_session',
        params: {'p_session_id': sessionId},
      );
      return PracticeSessionSnapshot.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 提交单题作答（可改答：同一题重复提交按最后一次算，不叠加记录）。
  ///
  /// [answer] 必须用 SubmittedAnswer.toJson() 的形状——它由 0029 的 grade_answer 定义，
  /// 手拼 map 的表现是「提交成功但永远判错」。
  /// 主观题（short_answer）必须传 [selfMastered]，否则服务端报「主观题请先自评是否掌握」；
  /// 复合题的**主观子题**不同：自评写在 subs[i] 里（SubMasteredAnswer），不走本参数。
  /// 返回的 correctAnswer 对复合题是 **null**（答案在 content.sub[].answer，顶层没有），
  /// 这是服务端行为，不要在这里补全。
  Future<SubmitResult> submitAnswer({
    required String sessionId,
    required String questionId,
    required SubmittedAnswer answer,
    int durationMs = 0,
    bool? selfMastered,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'submit_practice_answer',
        params: {
          'p_session_id': sessionId,
          'p_question_id': questionId,
          'p_answer': answer.toJson(),
          'p_duration_ms': durationMs,
          'p_self_mastered': selfMastered,
        },
      );
      return SubmitResult.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 交卷结算。返回的 accuracy 分母是**总题数**（含未作答），
  /// 与看板的「已答数」口径不同——那是服务端的定义，客户端照实展示，不要换算。
  /// [durationMs] 传 null 时由服务端按 started_at 推算整卷用时。
  ///
  /// **幂等**（0068）：会话已经交过卷时返回上一次的结算，不报错——交卷可能被重发
  /// （弱网重试、用户连点），报错会让用户以为白考一场。只有已作废的会话才报
  /// 「本次练习已作废，无法交卷」。
  Future<FinishSummary> finishSession({
    required String sessionId,
    int? durationMs,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'finish_practice_session',
        params: {'p_session_id': sessionId, 'p_duration_ms': durationMs},
      );
      return FinishSummary.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 放弃练习：把 active 置为 abandoned，**已作答的记录仍留在库里**（会计进统计）。
  /// 幂等——会话不是 active 时什么都不做，不报错，可以放心在退出页面时调用。
  Future<void> abandonSession(String sessionId) async {
    try {
      await _client.rpc<void>(
        'abandon_practice_session',
        params: {'p_session_id': sessionId},
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 练习记录列表。
  ///
  /// 走 PostgREST 直查而不是 RPC——服务端没有为"历史列表"提供函数，
  /// 而 practice_sessions 对本人有 SELECT 策略（RLS 自动限定为本人数据，
  /// 不必也不该再手工加 user_id 过滤；手工加反而会在将来换策略时出错）。
  Future<List<PracticeSessionRecord>> fetchHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final rows = await _client
          .from('practice_sessions')
          .select(
            'id, source, status, started_at, submitted_at, duration_ms, '
            'total_count, answered_count, correct_count',
          )
          .order('started_at', ascending: false)
          .range(offset, offset + limit - 1);
      return rows.map(PracticeSessionRecord.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }
}
