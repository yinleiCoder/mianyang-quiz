// 收藏状态。**全局唯一**，因为收藏按钮出现在四个地方
// （题库列表、题目详情、练习反馈条、错题本），任意一处切换后其余三处必须立刻同步。
//
// 为什么不做成"每个页面各查各的"：那样用户在一处收藏后切到另一处仍显示未收藏，
// 是那种"看起来只是慢了一点"、实则让人不信任的 bug。
//
// 乐观更新：点击立刻改本地状态并通知界面，请求失败再回滚 + 抛错给调用方提示。
// 收藏是低风险高频操作，等一个网络往返会让按钮有明显延迟感。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';

class FavoriteStore extends ChangeNotifier {
  FavoriteStore(this._repository);

  final FavoriteRepository _repository;

  /// 已知被收藏的题目 id。由收藏列表页与题目详情页在拿到数据时喂进来。
  final Set<String> _favorited = {};

  /// 正在切换中的 id → 目标状态。用于在请求返回前就给出确定的表现。
  final Map<String, bool> _pending = {};

  bool isFavorite(String questionId) =>
      _pending[questionId] ?? _favorited.contains(questionId);

  /// 正在请求中（按钮可显示 loading 但**不要**禁用，禁用会让人以为点漏了）。
  bool isToggling(String questionId) => _pending.containsKey(questionId);

  /// 把一批"确定已收藏"的 id 并入本地状态。
  ///
  /// 只并入、不移除：收藏列表是分页的，某一页没出现不代表没收藏。
  /// 要移除请走 [markNotFavorite]（取消收藏时用）。
  void seed(Iterable<String> questionIds) {
    var changed = false;
    for (final id in questionIds) {
      if (_favorited.add(id)) changed = true;
    }
    if (changed) notifyListeners();
  }

  void markNotFavorite(String questionId) {
    if (_favorited.remove(questionId)) notifyListeners();
  }

  /// 切换收藏。返回切换后的状态；失败时回滚并抛出 AppException。
  Future<bool> toggle(String questionId) async {
    final target = !isFavorite(questionId);
    _pending[questionId] = target;
    notifyListeners();

    try {
      // 服务端返回的是切换后的真实状态（幂等切换），以它为准而不是以本地推算为准
      final actual = await _repository.toggleFavorite(questionId);
      if (actual) {
        _favorited.add(questionId);
      } else {
        _favorited.remove(questionId);
      }
      return actual;
    } catch (error) {
      throw mapError(error);
    } finally {
      _pending.remove(questionId);
      notifyListeners();
    }
  }
}
