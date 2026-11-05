// 「为什么推这道题」的取数（0137）。
//
// 单独一个文件，是为了不让 practice_repository.dart 顶到 200 行（架构检查）；
// 仓库类只保留一行委托，调用方仍是 repository.fetchSessionReasons(...)。

import 'package:mianyang_quiz/entity/entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 解释性数据，**失败不挡练习**：旧会话没有原因、迁移未执行时 RPC 直接 404，
/// 一律返回空表，页面上那张卡不渲染。
Future<Map<String, PracticeReason>> querySessionReasons(
  SupabaseClient client,
  String sessionId,
) async {
  try {
    final data = await client.rpc<List<dynamic>>(
      'practice_session_reasons',
      params: {'p_session_id': sessionId},
    );
    final reasons = <String, PracticeReason>{};
    for (final row in data) {
      if (row is! Map) continue;
      final reason = PracticeReason.fromJson(Map<String, dynamic>.from(row));
      if (reason.questionId.isNotEmpty) reasons[reason.questionId] = reason;
    }
    return reasons;
  } catch (_) {
    return const {};
  }
}
