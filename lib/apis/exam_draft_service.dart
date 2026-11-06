// 考试作答的本机暂存 + 服务端草稿的本地凭据。
//
// 为什么需要它：服务端的考试**没有逐题保存**——exam_answers 只在交卷那一刻由
// submit_exam_attempt 一次写入（0052），start_exam_attempt 返回的 answers 在续考时
// 也永远是空的。也就是说，中途退出（误触返回、闪退、笔记本没电）会让已经答了几十分钟的
// 内容全部消失，而一场考试最长 90 分钟。
//
// **2026-11-06 起这条能力是双通道的**：
//   · 主通道是服务端（0144 的 exam_attempts.draft_answers，逐题合并），换台设备也能接着答；
//   · 本机这份是离线兜底——网络断着也能答，回到有网时再同步。
// 两份合并时靠 `exam.draftAt.<id>` 这个时刻判断谁更新：本机比服务端新才让本机覆盖，
// 否则以服务端为准、只补上服务端没有的题（见 ExamDraftBuffer.restore）。
//
// 存的形状与提交时**完全一致**（SubmittedAnswer.toJson），恢复时直接喂
// domain 的 submittedAnswerFrom 即可，不必再维护一套"草稿格式"。
//
// 它只是**暂存**：判分与最终记录都在服务端，这份丢了不影响任何已交卷的成绩。

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本机暂存的一份草稿：作答 + 写入时刻。
///
/// 时刻用于和服务端的 draft_updated_at 比较——两台设备都存过草稿时，
/// 不能一律"本机优先"（会把另一台刚写的答案盖掉），也不能一律"服务端优先"
/// （断网时在本机写的会白写）。
class ExamLocalDraft {
  const ExamLocalDraft({required this.answers, this.savedAt});

  final Map<String, Map<String, dynamic>> answers;
  final DateTime? savedAt;

  static const empty = ExamLocalDraft(answers: {});
}

class ExamDraftService {
  static const _prefix = 'exam.draft.';
  static const _atPrefix = 'exam.draftAt.';

  /// 读回某场考试的暂存作答：题项id → 作答 JSON。没存过或读不出来都返回空表
  /// （调用方按"全新作答"处理，绝不因为暂存坏了就拦着人考试）。
  Future<Map<String, Map<String, dynamic>>> load(String attemptId) async =>
      (await loadWithTime(attemptId)).answers;

  /// 同 [load]，多带一个写入时刻（用于与服务端草稿比对新旧）。
  Future<ExamLocalDraft> loadWithTime(String attemptId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$attemptId');
      if (raw == null) return ExamLocalDraft.empty;
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return ExamLocalDraft.empty;
      return ExamLocalDraft(
        answers: {
          for (final entry in decoded.entries)
            if (entry.value is Map)
              '${entry.key}': Map<String, dynamic>.from(entry.value as Map),
        },
        savedAt: DateTime.tryParse(prefs.getString('$_atPrefix$attemptId') ?? ''),
      );
    } catch (_) {
      return ExamLocalDraft.empty;
    }
  }

  Future<void> save(
    String attemptId,
    Map<String, Map<String, dynamic>> answers,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$attemptId', jsonEncode(answers));
      // 时刻单独存一个键：老版本的草稿没有它，读出来是 null，合并时按"服务端优先"处理
      await prefs.setString(
        '$_atPrefix$attemptId',
        DateTime.now().toIso8601String(),
      );
    } catch (_) {
      // 存不下只是"这次退出会丢"，不该打断答题
    }
  }

  /// 交卷成功后清掉。**必须清**：留着的话，同一份卷下次再考（补考）会把上一场的
  /// 答案当成草稿回填上去，学生一进来就看见上次写的东西。
  Future<void> clear(String attemptId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefix$attemptId');
      await prefs.remove('$_atPrefix$attemptId');
    } catch (_) {
      // 同上
    }
  }
}
