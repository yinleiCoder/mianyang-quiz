// 收藏开关。单个 RPC 单独成文件，是因为它的**写语义**与列表查询不同：
// 题卡上点一下就走一次，写失败不能让整个列表重查；而 ListRepository 全是只读分页。
// 按业务域拆而按方法多少拆——收藏（写）与收藏列表（读）本就是两件事。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  const FavoriteRepository(this._client);

  final SupabaseClient _client;

  /// 切换收藏，返回**切换后**的状态（true = 已收藏）。
  ///
  /// 注意语义是「切换」不是「置位」：重复调用会来回翻转，**界面不要拿它做失败重试**，
  /// 否则用户会看到状态莫名跳回。要置位得先知道当前状态（收藏列表能查，看板只有计数）。
  /// 只有「已入库且在线」的题能收藏，其余情况服务端报「只能收藏已入库且在线的题目」。
  /// 调用方拿到返回值后应就地更新 UI，不要再发一次列表查询。
  Future<bool> toggleFavorite(String questionId) async {
    try {
      final data = await _client.rpc<bool>(
        'toggle_favorite',
        params: {'p_question_id': questionId},
      );
      return data;
    } catch (error) {
      throw mapError(error);
    }
  }
}
