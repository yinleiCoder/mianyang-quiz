// 意见反馈：把用户的反馈提交到系统管理员（submit_feedback RPC，见 0033）。
//
// 客户端对 feedback 表没有 select 权限（策略只放行系统管理员），也没有 DML——
// 提交只能走这个 definer 函数。返回值是反馈 uuid，取前 8 位当短编号给用户留存，
// 便于线下跟进时对号；服务端的限流/校验文案由 mapError 原样透出。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackRepository {
  const FeedbackRepository(this._client);

  final SupabaseClient _client;

  /// 提交一条反馈，返回反馈 id（短号展示用）。
  /// [contact] 与 [clientVersion] 为空时不传（服务端默认 null）。
  Future<String> submit({
    required String category,
    required String content,
    required String platform,
    String? contact,
    String? clientVersion,
  }) async {
    try {
      return await _client.rpc<String>(
        'submit_feedback',
        params: {
          'p_category': category,
          'p_content': content,
          'p_contact': contact,
          'p_platform': platform,
          'p_client_version': clientVersion,
        },
      );
    } catch (error) {
      throw mapError(error);
    }
  }
}
