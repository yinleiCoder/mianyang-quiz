// 复习资料：列表（搜索 + 筛选 + 分页）与下载计数。
//
// 读走 PostgREST 直查而不是 RPC —— 与题库列表同一个理由：服务端没有为"列表"提供函数，
// 而 review_materials 对登录用户有 SELECT 策略（全市共享，未发布的只有作者与管理员看得到），
// RLS 自动限定范围，**不要也不该手工加可见性过滤**（手工加反而会在将来换策略时出错）。
//
// 写只有一处：下载计数走 RPC（客户端对表没有 INSERT/UPDATE 权限，AGENTS.md 硬约束 4）。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/like_escape.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/data/models/material/material_filter.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef MaterialPage = ({List<MaterialBrief> rows, int total});

class MaterialRepository {
  const MaterialRepository(this._client);

  final SupabaseClient _client;

  /// schools(name) 能直接嵌：review_materials.school_id 与 schools 之间有外键。
  /// creator_id 指向 auth.users，与 profiles 之间**没有外键**，嵌不了，只能另查一次
  /// （见下面的 fetchProfiles）——网页端 lib/materials.js 也是这么处理的。
  static const _columns =
      'id, object_key, bucket, size, mime, title, description, kind, '
      'course_node_id, creator_id, school_id, download_count, created_at, '
      'schools(name)';

  Future<MaterialPage> listMaterials({
    MaterialFilter filter = const MaterialFilter(),
    int page = 1,
    int pageSize = 20,
    /// 学科筛选展开后的节点 id 集合（含全部后代）。为 null 表示不按学科筛。
    ///
    /// **为什么要传集合而不是直接的 nodeId**：资料可以挂在任意层级，
    /// 而学生点「计算机」时想看的是这个专业下的**全部**资料，包括挂在
    /// 「信息技术」这类子节点上的。子树展开要用到整棵树，那是页面已经拿在手里的
    /// 参考数据，仓储不该再查一次（与题库页同样的分工）。
    List<String>? nodeIds,
  }) async {
    try {
      var query = _client.from('review_materials').select(_columns);

      if (nodeIds != null) {
        if (nodeIds.isEmpty) return (rows: <MaterialBrief>[], total: 0);
        query = query.inFilter('course_node_id', nodeIds);
      }
      if (filter.kinds.isNotEmpty) {
        query = query.inFilter('kind', filter.kinds.map((k) => k.wire).toList());
      }
      final keyword = filter.keyword.trim();
      if (keyword.isNotEmpty) {
        // search_text 是生成列（标题 + 简介，已 lower）
        query = query.ilike('search_text', '%${escapeLikeKeyword(keyword)}%');
      }

      // .count() 必须放在链尾——它把返回类型从"数据"变成"数据 + 总数"
      //（postgrest 2.9.1 的 select() 没有 count 参数）
      final response = await query
          .order('created_at', ascending: false)
          .range((page - 1) * pageSize, page * pageSize - 1)
          .count(CountOption.exact);

      final rows = await _withCreatorNames(response.data);
      return (rows: rows, total: response.count);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 学生把资料保存到本地之后调用，下载次数 +1。
  ///
  /// **是"保存到本地"才计数**，光是打开查看不算——用户要的是"下载次数"，
  /// 拿浏览数灌水会把这个数字变得没有意义（列注释里写死了这条口径）。
  ///
  /// 计数失败**不抛错**：它是附带效果，不该让"保存文件"这个动作看起来失败了。
  /// 服务端在资料不存在或已下架时返回 0。
  Future<int> countDownload(String materialId) async {
    try {
      return await _client.rpc<int>(
        'increment_material_download',
        params: {'p_id': materialId},
      );
    } catch (_) {
      return 0;
    }
  }

  /// 给每行补上上传人姓名（@关系嵌不出来，只能按 id 批量取一次）。
  /// 取不到就是账号已注销——UI 显示"上传人已注销"，内容仍然在（0021 口径）。
  Future<List<MaterialBrief>> _withCreatorNames(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return const [];

    final creatorIds = rows
        .map((row) => row['creator_id'])
        .whereType<String>()
        .toSet()
        .toList();
    final people = creatorIds.isEmpty
        ? const <String, Profile>{}
        : await UserRepository(_client).fetchProfiles(creatorIds);

    return [
      for (final row in rows)
        MaterialBrief.fromJson({
          ...row,
          'creator_name': people[row['creator_id']]?.name,
          'school_name': switch (row['schools']) {
            final Map<String, dynamic> school => school['name'],
            _ => null,
          },
        }),
    ];
  }
}
