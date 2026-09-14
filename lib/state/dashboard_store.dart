// 学情看板数据。**全局唯一**：首页读它，而练习交卷、收藏取关、错题增减都会让它过期，
// 所以写它的是别处、读它的是首页，天然跨页。
//
// 刻意不做本地缓存与增量更新：看板是一次 RPC 取全（含 14 天趋势），
// 数据量很小，重新拉一次比维护"哪几个数字该 +1"的增量逻辑可靠得多——
// 后者一旦漏掉某个入口就会显示错数字，而且很难发现。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/stats/practice_dashboard.dart';
import 'package:mianyang_quiz/data/repositories/stats_repository.dart';

class DashboardStore extends ChangeNotifier {
  DashboardStore(this._repository);

  final StatsRepository _repository;

  AsyncValue<PracticeDashboard> _state = const AsyncLoading();

  AsyncValue<PracticeDashboard> get state => _state;

  PracticeDashboard? get data => _state.valueOrNull;

  bool get isLoading => _state.isLoading;

  /// 拉取（或重新拉取）看板。
  ///
  /// [silent] 为 true 时不进入 loading 态——用于"交卷后顺手刷新"这类场景：
  /// 界面上已有旧数据，闪一下骨架屏比晚半秒更新更难受。
  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      _state = const AsyncLoading();
      notifyListeners();
    }
    try {
      final dashboard = await _repository.fetchDashboard();
      _state = AsyncData(dashboard);
    } catch (error) {
      final mapped = mapError(error);
      // 静默刷新失败时保留旧数据：旧数字总好过一片错误页
      _state = silent && _state.valueOrNull != null
          ? AsyncData(_state.valueOrNull as PracticeDashboard)
          : AsyncFailure(mapped);
    }
    notifyListeners();
  }

  /// 登出时清空，避免下一个账号看到上一个账号的数字。
  void clear() {
    _state = const AsyncLoading();
    notifyListeners();
  }

  /// 供页面直接取错误文案（避免每个页面都做一次 switch）。
  AppException? get error => switch (_state) {
    AsyncFailure(:final error) => error,
    _ => null,
  };
}
