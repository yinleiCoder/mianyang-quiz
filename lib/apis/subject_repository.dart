// 参考数据：科目树与知识点标签。
//
// 与 QuestionRepository 分开是因为两者生命周期不同：
// 参考数据在一次会话里几乎不变（进题库页取一次即可跨页复用），
// 而题目列表随筛选与翻页频繁变化。混在一起会让"该不该缓存"变得难以回答。
//
// **2026-11-02 起真的会缓存（10 分钟）**：用户反馈"刷题时数据加载卡顿"，
// 而科目树/标签在题库、组卷、资料、我的排名四处各拉一遍；每条请求在跨境网络上
// 是 0.5~1.5s，叠起来就是肉眼可见的卡。这两张表是全局参考数据，10 分钟的新鲜度
// 足够——老师改了科目/标签，最迟十分钟后各处都跟上。
//
// 缓存挂在 **SupabaseClient 对象**上（Expando），不是实例字段：题库详情、题目
// 装配、组卷筛选都会临时 `SubjectRepository(client)`，实例字段各自为政等于没缓存。
// Expando 是弱引用，client 被回收时缓存跟着走，不需要手工清理。
//
// 失败时的口径：**过期缓存比错误页有用**——网络抖一下不该让整个题库页变红；
// 但 `force: true`（用户明确点刷新）失败时必须抛错，不能拿旧数据糊弄。

import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubjectRepository {
  const SubjectRepository(this._client);

  final SupabaseClient _client;

  /// 参考数据的保鲜期。刻意短于"一节课"：老师新增科目/标签后不需要重装 App。
  static const Duration cacheTtl = Duration(minutes: 10);

  /// 每个 client 一份缓存。见文件头的说明。
  static final Expando<_RefCache> _caches = Expando<_RefCache>(
    'subject-repository-cache',
  );

  _RefCache get _cache => _caches[_client] ??= _RefCache();

  /// 测试与"换账号/换库"用：丢掉这个 client 的参考数据缓存。
  static void clearCacheFor(SupabaseClient client) {
    _caches[client] = _RefCache();
  }

  /// 全量科目节点，按 sort_order、name 排序。
  /// 树结构由 utils/subject_tree.dart 的纯函数在客户端拼装——
  /// 数据库返回的是一张扁平表（parent_id 自引用），没有层级字段。
  ///
  /// [force] 为 true 时跳过缓存重新取；取失败会抛错（调用方通常是"重试"按钮）。
  Future<List<SubjectNode>> fetchNodes({bool force = false}) {
    final cache = _cache;
    if (!force && cache.nodes != null && _fresh(cache.nodesAt)) {
      return Future<List<SubjectNode>>.value(cache.nodes!);
    }
    // 并发去重：同一页里两个 widget 同时要科目树时只发一条请求。
    return cache.nodesInFlight ??= _loadNodes(cache, force: force);
  }

  /// 知识点标签（0096 起带学科与层级）。
  ///
  /// 排序与服务端同义：先 sort_order 再 name，让同一父级下的兄弟保持人工排定的顺序。
  /// **未归类的（subject_node_id 为空）也一并取回**：题库筛选那边要能看到它们，
  /// 由调用方决定要不要按学科收口（见 filters 里的 tagScope）。
  Future<List<QuestionTag>> fetchTags({bool force = false}) {
    final cache = _cache;
    if (!force && cache.tags != null && _fresh(cache.tagsAt)) {
      return Future<List<QuestionTag>>.value(cache.tags!);
    }
    return cache.tagsInFlight ??= _loadTags(cache, force: force);
  }

  Future<List<SubjectNode>> _loadNodes(
    _RefCache cache, {
    required bool force,
  }) async {
    try {
      final rows = await _client
          .from('subject_nodes')
          .select('id, parent_id, scope, kind, name, sort_order, is_frozen')
          .order('sort_order')
          .order('name');
      final nodes = rows.map(SubjectNode.fromJson).toList();
      cache.nodes = nodes;
      cache.nodesAt = DateTime.now();
      return nodes;
    } catch (error) {
      if (!force && cache.nodes != null) return cache.nodes!;
      throw mapError(error);
    } finally {
      cache.nodesInFlight = null;
    }
  }

  Future<List<QuestionTag>> _loadTags(
    _RefCache cache, {
    required bool force,
  }) async {
    try {
      final rows = await _client
          .from('tags')
          .select('id, name, parent_id, subject_node_id, sort_order')
          .order('sort_order')
          .order('name');
      final tags = rows.map(QuestionTag.fromJson).toList();
      cache.tags = tags;
      cache.tagsAt = DateTime.now();
      return tags;
    } catch (error) {
      if (!force && cache.tags != null) return cache.tags!;
      throw mapError(error);
    } finally {
      cache.tagsInFlight = null;
    }
  }

  bool _fresh(DateTime? at) =>
      at != null && DateTime.now().difference(at) < cacheTtl;
}

/// 一个 client 的参考数据缓存。可空字段 = 还没成功取过。
class _RefCache {
  List<SubjectNode>? nodes;
  DateTime? nodesAt;
  Future<List<SubjectNode>>? nodesInFlight;

  List<QuestionTag>? tags;
  DateTime? tagsAt;
  Future<List<QuestionTag>>? tagsInFlight;
}
