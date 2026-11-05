// AI 学习路径的取数（my_bkt_profile / my_recommended_practice，0122）。
//
// 与其它仓储一样：只负责调 RPC、解析实体、把异常转成 AppException；
// 权限与算法都在服务端（只读本人数据，不返回题干/答案）。
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';

class LearningRepository {
  const LearningRepository(this._client);

  final SupabaseClient _client;

  /// 我的掌握度画像。失败抛 AppException（页面用 mapError 显示中文提示）。
  Future<BktProfile> fetchProfile({int days = 365, int maxItems = 600}) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'my_bkt_profile',
        params: {'p_days': days, 'p_max_items': maxItems},
      );
      return BktProfile.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 我的学习画像（0128）。只回六轴与计数，persona/summary 在客户端拼装。
  Future<LearningProfile> fetchLearningProfile({int days = 90}) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'student_learning_profile',
        params: {'p_student_id': null, 'p_days': days},
      );
      return LearningProfile.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// AI 推荐练习。[mode] 与服务端白名单一致：balanced / weak / review / challenge。
  Future<LearningPlan> fetchRecommendedPractice({
    int limit = 20,
    String? nodeId,
    String mode = 'balanced',
  }) async {
    try {
      final data = await _client.rpc<Map<String, dynamic>>(
        'my_recommended_practice',
        params: {
          'p_limit': limit,
          'p_node_id': nodeId,
          'p_mode': mode,
        },
      );
      return LearningPlan.fromJson(data);
    } catch (error) {
      throw mapError(error);
    }
  }
}
