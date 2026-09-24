// 试卷成绩榜的取数（paper_leaderboard，迁移 0077）。
//
// 为什么单独一个仓储：它与考试作答（PaperRepository 的 start/submit/get）生命周期不同——
// 这是一次纯读的聚合查询，首页/试卷库/成绩单三处都会拉，而作答是有副作用的写路径。
// 混在一起会让"哪些方法会改服务端状态"变得不明显（同 StatsRepository 与 PracticeRepository 的分工）。
//
// 服务端已经决定我能看谁：SECURITY DEFINER 里的 resolve_paper_scope 按调用者身份夹住范围
// （学生只能看自己班/自己学校；教师看班级要过 can_view_class）。客户端只传"我想看哪一档"，
// **不做任何权限判断**——UI 不是安全边界。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_leaderboard.dart';
import 'package:mianyang_quiz/data/models/analytics/paper_question_stats.dart';
import 'package:mianyang_quiz/domain/node_accuracy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 榜单口径：与 SQL 的 p_scope 一一对应。
enum LeaderboardScopeKey {
  classScope('class', '全班'),
  school('school', '全校'),
  city('city', '全市');

  const LeaderboardScopeKey(this.wire, this.label);

  final String wire;
  final String label;
}

class AnalyticsRepository {
  const AnalyticsRepository(this._client);

  final SupabaseClient _client;

  /// 一份卷子的成绩榜。
  ///
  /// [classId] 只在"全班"档且调用者是教师时需要（学生传了也会被服务端夹到自己班）；
  /// 教师看班级榜没给班级时服务端报 22023「查看班级榜需要先选择班级」，
  /// 界面据此出班级选择器——**不要**在这里替它兜底成"全班第一个"，
  /// 那会让"我到底在看哪个班"变得不可见。
  Future<PaperLeaderboard> fetchLeaderboard({
    required String paperId,
    LeaderboardScopeKey scope = LeaderboardScopeKey.classScope,
    String? classId,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'paper_leaderboard',
        params: {
          'p_paper_id': paperId,
          'p_scope': scope.wire,
          'p_class_id': classId,
        },
      );
      return PaperLeaderboard.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 一份卷子的逐题分析（每题正确率、选项分布、错答名单）。
  ///
  /// **门禁比榜单严一档**：学生必须自己已经出分（服务端抛 42501），
  /// 否则选项分布 + 标准答案合起来就是答案本身。页面据此显示"出分后可见"。
  Future<PaperQuestionStats> fetchQuestionStats({
    required String paperId,
    LeaderboardScopeKey scope = LeaderboardScopeKey.classScope,
    String? classId,
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'paper_question_stats',
        params: {
          'p_paper_id': paperId,
          'p_scope': scope.wire,
          'p_class_id': classId,
        },
      );
      return PaperQuestionStats.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 本人最近 [days] 天的知识点掌握（课程层原始粒度）。
  ///
  /// 上卷到顶层由调用方用 `rollUpByTopNode` 做——服务端只回 node_id 与计数，
  /// 与网页端同一分工（见 lib/domain/node_accuracy.dart 的说明）。
  Future<List<NodeAccuracy>> fetchMyNodeAccuracy({int days = 30}) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'my_node_accuracy',
        params: {'p_days': days},
      );
      final rows = data['nodes'];
      if (rows is! List) return const [];
      return rows
          .whereType<Map<String, dynamic>>()
          .map(NodeAccuracy.fromJson)
          .toList(growable: false);
    } catch (error) {
      throw mapError(error);
    }
  }
}
