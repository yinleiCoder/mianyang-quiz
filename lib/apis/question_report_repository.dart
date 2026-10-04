// 题目反馈：学生把"这题有问题"提交给**本题作者**（submit_question_report，见 0066）。
//
// 与 feedback_repository.dart 的区别要说清楚，两者长得像但不是一回事：
//   · feedback 提交给系统管理员，**没有回复闭环**（网页端文案原话"不在这里回复"）；
//   · 这边提交给本题作者，**有回复闭环** —— 作者处理时写的说明会回到学生眼前。
//   所以本仓库多一个 fetchMyReport：那是学生看到回音的入口。
//
// 两条不同的取数路径，别混用：
//   · 提交 → definer 函数（客户端对 question_reports 没有 insert 之外的写权限）
//   · 查自己那条 → **直接 select**。RLS 的 qr_select 放行 reporter_id = auth.uid() 的行；
//     而 list_question_reports 是给处理人用的，学生调会抛 42501。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionReportRepository {
  const QuestionReportRepository(this._client);

  final SupabaseClient _client;

  /// 提交一条题目反馈，返回反馈 id。
  ///
  /// [versionId] 必须是**学生实际看到的那个版本** —— 作者改版后，这条反馈在作者那边
  /// 会标成"针对 vN 的"，不会跟着漂移到新版本上。服务端会校验它与题目匹配。
  ///
  /// 同一道题已有未处理反馈时服务端会抛「你已经反馈过这道题了，作者还在处理中」
  /// （部分唯一索引拦的），文案由 mapError 原样透出。
  Future<String> submit({
    required String questionId,
    required String versionId,
    required String category,
    required String content,
  }) async {
    try {
      return await _client.rpc<String>(
        'submit_question_report',
        params: {
          'p_question_id': questionId,
          'p_version_id': versionId,
          'p_category': category,
          'p_content': content,
        },
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 我在某道题上提过的最近一条反馈；没提过返回 null。
  ///
  /// **必须显式按 reporter_id 过滤**（0084 起）：那条 RLS 策略以前只放行"自己的行"，
  /// 现在为了让审题人看见教师申诉，也放行了别人的行 —— 不加这一条，
  /// 处理过这道题的老师打开题目页会看到**别人的反馈**被当成"我的反馈"。
  /// （网页端 lib/question-reports.js 修的是同一个坑。）
  Future<QuestionReport?> fetchMyReport(String questionId) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;
    try {
      final row = await _client
          .from('question_reports')
          .select('id, status, category, content, resolve_note, resolved_at, created_at')
          .eq('question_id', questionId)
          .eq('reporter_id', uid)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return row == null ? null : QuestionReport.fromJson(row);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 一条反馈下的往来消息（0084 多方对话）。提交人 / 本题作者 / 本题审题人都能读。
  Future<List<QuestionReportMessage>> fetchMessages(String reportId) async {
    try {
      final rows = await _client.rpc<List<dynamic>>(
        'list_question_report_messages',
        params: {'p_report_id': reportId},
      );
      return rows
          .map((r) => QuestionReportMessage.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 在反馈下发一条消息。结案后服务端会拒（"无权在这条反馈下发言（或它已结案）"）。
  Future<void> postMessage(String reportId, String body) async {
    try {
      await _client.rpc<String>(
        'post_question_report_message',
        params: {'p_report_id': reportId, 'p_body': body},
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 撤回自己提的反馈（0084）。提错了的出口 —— 在此之前，部分唯一索引禁止同一人
  /// 对同一题同时开两条反馈，却没有撤销入口，提错了就再也提不了。
  Future<void> withdraw(String reportId) async {
    try {
      await _client.rpc<void>(
        'withdraw_question_report',
        params: {'p_report_id': reportId},
      );
    } catch (error) {
      throw mapError(error);
    }
  }
}
