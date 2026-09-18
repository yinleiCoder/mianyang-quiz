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

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/bank/question_report.dart';
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
  /// 不 throws 之外的兜底：RLS 只会放行自己的行，所以这里拿到的必然是自己提的，
  /// 不需要再按 reporter_id 过滤一次。
  Future<QuestionReport?> fetchMyReport(String questionId) async {
    try {
      final row = await _client
          .from('question_reports')
          .select('id, status, category, content, resolve_note, resolved_at, created_at')
          .eq('question_id', questionId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return row == null ? null : QuestionReport.fromJson(row);
    } catch (error) {
      throw mapError(error);
    }
  }
}
