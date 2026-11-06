// 考试「进行中」的两件事：作答草稿与倒计时暂停/恢复（0144）。
//
// 单独一个文件，是为了不让 paper_repository.dart 顶到 200 行（架构检查）；
// 仓库类只保留一行委托。
//
// 草稿通道只服务**还在进行中**的考试：交卷之后读的是 exam_answers（判分记录），
// 服务端对已交卷/已作废的场次一律返回空草稿。
//
// 计时口径（2026-11-06 用户定）：**离开考试页 = 暂停**，下次进来接着剩余时间考；
// **切后台不停表**，时间照走。暂停时服务端冻结剩余毫秒，恢复发生在读考试的路径上
// （get_my_exam_attempt / start_exam_attempt 顺手调 _resume_exam_attempt_if_paused），
// 所以客户端这边只有 pause 一个动作。

import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 取回一场考试尚未交卷的作答，附带服务端写入时刻（用于与本机暂存比新旧）。
Future<ExamDraftBundle> fetchExamDraftsFrom(
  SupabaseClient client,
  String attemptId,
) async {
  try {
    final data = await client.rpc<Map<String, dynamic>>(
      'get_exam_drafts',
      params: {'p_attempt_id': attemptId},
    );
    final raw = data['draft_answers'];
    return ExamDraftBundle(
      answers: {
        if (raw is Map)
          for (final entry in raw.entries)
            if (entry.value is Map)
              '${entry.key}': Map<String, dynamic>.from(entry.value as Map),
      },
      updatedAt: DateTime.tryParse('${data['draft_updated_at']}'),
    );
  } catch (error) {
    throw mapError(error);
  }
}

/// 写回几道题的作答草稿。**只传改过的题**，服务端逐题合并——
/// 整卷覆盖会让两台设备互相盖掉对方刚写的答案。
///
/// 空 Map 表示这道题被清空了，服务端会把该题从草稿里移除。
Future<void> saveExamDraftsTo(
  SupabaseClient client, {
  required String attemptId,
  required Map<String, Map<String, dynamic>> answers,
}) async {
  try {
    await client.rpc<void>(
      'save_exam_answers',
      params: {'p_attempt_id': attemptId, 'p_answers': answers},
    );
  } catch (error) {
    throw mapError(error);
  }
}

/// 暂停倒计时：把剩余毫秒冻结在服务端。**离开考试页**时调，幂等。
///
/// 恢复由服务端的读路径负责（get_my_exam_attempt / start_exam_attempt 读到
/// in_progress 会调 _resume_exam_attempt_if_paused），客户端不用再发一次。
Future<void> pauseExamAttempt(
  SupabaseClient client,
  String attemptId,
) async {
  try {
    await client.rpc<void>(
      'pause_exam_attempt',
      params: {'p_attempt_id': attemptId},
    );
  } catch (error) {
    throw mapError(error);
  }
}
