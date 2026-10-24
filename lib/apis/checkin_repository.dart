// 每日打卡与今日目标（迁移 0107）。
//
// 打卡、连续天数、目标题数都存云端：换设备/重装后应当还是同一个连续天数。
// 仓储只做"调 RPC + 解析"，失败抛 mapError 后的中文 AppException（与全站一致）。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckinRepository {
  const CheckinRepository(this._client);

  final SupabaseClient _client;

  /// 进入软件时调一次：幂等地记下"今天已打卡"，返回连续天数/累计天数/目标。
  Future<CheckinStatus> recordToday() async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>('record_daily_checkin');
      return CheckinStatus.fromJson(Map<String, dynamic>.from(data));
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 修改今日目标题数（服务端会校验 5~200），返回落库后的值。
  Future<int> setDailyGoal(int goal) async {
    try {
      final value = await _client.rpc<int>('set_my_daily_goal', params: {
        'p_goal': goal,
      });
      return value;
    } catch (error) {
      throw mapError(error);
    }
  }
}
