// 学情看板：practice_dashboard 一次取全（累计、近 14 天、题型分布、错题/收藏数、
// 连续天数、进行中会话、最近 10 条作答）。
//
// 为什么与 PracticeRepository 分开：这是一次纯读的聚合查询，与练习会话的写路径
// 生命周期完全不同（首页每次进入都刷，练习则是有副作用的操作）。混在一起会让
// 「哪些方法会改服务端状态」这件事变得不明显。
//
// 口径提醒：看板的 accuracy 分母是**已答数**，交卷结算用的是**总题数**（见 AGENTS.md）。
// 两个数字对不上不是 bug，不要在这里「修正」。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsRepository {
  const StatsRepository(this._client);

  final SupabaseClient _client;

  /// 拉取本人看板数据。
  ///
  /// 返回体里 daily 已由数据库补零并按日期升序（近 14 天），图表直接用，不要重排；
  /// activeSession 非空表示有进行中的练习——**开始新练习会把它静默作废**，
  /// 所以首页要拿它做「继续练习」入口，进组卷页前先问用户。
  /// 未登录时服务端报错。
  Future<PracticeDashboard> fetchDashboard() async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>('practice_dashboard');
      return PracticeDashboard.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }
}
