// 考试作答的本机暂存。
//
// 为什么需要它：服务端的考试**没有逐题保存**——exam_answers 只在交卷那一刻由
// submit_exam_attempt 一次写入（0052），start_exam_attempt 返回的 answers 在续考时
// 也永远是空的。也就是说，中途退出（误触返回、闪退、笔记本没电）会让已经答了几十分钟的
// 内容全部消失，而一场考试最长 90 分钟。服务端那条路要另加一个保存 RPC，本轮不动服务端，
// 于是用本机暂存把这段补上：退出时提示"已保存"，回来接着答。
//
// 存的形状与提交时**完全一致**（SubmittedAnswer.toJson），恢复时直接喂
// domain 的 submittedAnswerFrom 即可，不必再维护一套"草稿格式"。
//
// 它只是**暂存**：判分与最终记录都在服务端，这份丢了不影响任何已交卷的成绩，
// 换台设备也读不到（那是服务端该解决的事，不是这里）。

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ExamDraftService {
  static const _prefix = 'exam.draft.';

  /// 读回某场考试的暂存作答：题项id → 作答 JSON。没存过或读不出来都返回空表
  /// （调用方按"全新作答"处理，绝不因为暂存坏了就拦着人考试）。
  Future<Map<String, Map<String, dynamic>>> load(String attemptId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$attemptId');
      if (raw == null) return const {};
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const {};
      return {
        for (final entry in decoded.entries)
          if (entry.value is Map)
            '${entry.key}': Map<String, dynamic>.from(entry.value as Map),
      };
    } catch (_) {
      return const {};
    }
  }

  Future<void> save(
    String attemptId,
    Map<String, Map<String, dynamic>> answers,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$attemptId', jsonEncode(answers));
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
    } catch (_) {
      // 同上
    }
  }
}
