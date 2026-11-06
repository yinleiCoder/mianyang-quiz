// 跨设备续练的作答草稿（0144）。
//
// 单独一个文件，是为了不让 practice_repository.dart 顶到 200 行（架构检查）；
// 仓库类只保留一行委托。
//
// 它只写 practice_sessions.draft_answers，**不写 practice_answers**：
// 统计口径（错题本 / 正确率 / 遗忘曲线 / 今日已练）一个字都没变。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 合并一批作答草稿，顺带可以登记练习方式。
///
/// [mode] 是 `PracticeMode.wire`（apis 层不依赖 state/）；
/// [answers] 形状：question_id → {answer, is_correct, self_mastered}，
/// 值为空 Map 表示这道题被清空。**只传改过的题**，服务端逐题合并。
Future<void> savePracticeProgress(
  SupabaseClient client, {
  required String sessionId,
  String? mode,
  Map<String, Map<String, dynamic>> answers = const {},
}) async {
  try {
    await client.rpc<void>(
      'save_practice_progress',
      params: {
        'p_session_id': sessionId,
        'p_mode': mode,
        'p_answers': answers,
      },
    );
  } catch (error) {
    throw mapError(error);
  }
}
