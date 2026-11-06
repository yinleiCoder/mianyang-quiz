// 学情看板数据。**全局唯一**：首页读它，而练习交卷、收藏取关、错题增减都会让它过期，
// 所以写它的是别处、读它的是首页，天然跨页。
//
// 刻意不做增量更新：看板是一次 RPC 取全（含 14 天趋势），重新拉一次比维护
// "哪几个数字该 +1" 的增量逻辑可靠得多——后者一旦漏掉某个入口就会显示错数字。
//
// **但保留了一份很短的内存缓存（2026-11-06）**：`practice_dashboard` 是全站
// 调用量最大的 RPC（11,584 次），而首页每次进入都会刷一次。45 秒内重复打开
// 直接复用内存里的那份，省掉一整轮跨境往返；超过就照常拉。
// 判据见 [staleAfter] 与 [refresh] 的 force 参数。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class DashboardStore extends ChangeNotifier {
  DashboardStore(this._repository, {DateTime Function() now = DateTime.now})
    // 私有字段做不了命名参数（下划线开头的参数名非法），只能这样赋值
    // ignore: prefer_initializing_formals
    : _now = now;

  final StatsRepository _repository;

  /// 取时钟。测试里替换它来验证保鲜期，生产里就是 `DateTime.now`。
  final DateTime Function() _now;

  /// 内存里这份看板最多用多久。
  ///
  /// 60 秒：线上实测同一台设备两次打开首页的间隔常见在 50 秒上下（11-06 的
  /// edge 日志里抓到一次 48 秒），45 秒会正好错过。首页数字最多旧 1 分钟。
  ///
  /// **凡是会改数据的入口都传 force: true**（交卷、放弃练习、开始新一轮），
  /// 所以"我刚做完题回来"看到的仍是新数字；只有"来回切到首页看看"才会命中缓存。
  static const staleAfter = Duration(seconds: 60);

  /// 上一次成功拉到数据的时刻；null = 没有可复用的数据。
  DateTime? _fetchedAt;

  AsyncValue<PracticeDashboard> _state = const AsyncLoading();

  AsyncValue<PracticeDashboard> get state => _state;

  PracticeDashboard? get data => _state.valueOrNull;

  bool get isLoading => _state.isLoading;

  /// 正在进行的请求。启动预取与首页首帧各会触发一次 refresh，去重后只发一条。
  Future<void>? _inFlight;

  /// 拉取（或重新拉取）看板。
  ///
  /// [silent] 为 true 时不进入 loading 态——用于"交卷后顺手刷新"这类场景：
  /// 界面上已有旧数据，闪一下骨架屏比晚半秒更新更难受。
  ///
  /// **并发去重（2026-11-02）**：`startSession()` 会预取一次，首页 post-frame
  /// 又刷一次；跨境网络下一来一回 0.5~1.5s，重复发就是白白多等一个来回。
  /// 两次调用共享同一个 Future，后到的那个不会另发请求。
  ///
  /// **保鲜期（2026-11-06）**：不传 [force] 时，[staleAfter] 内直接返回。
  /// 会改数据的入口（交卷、放弃、开始新一轮）要传 `force: true`。
  Future<void> refresh({bool silent = false, bool force = false}) {
    final pending = _inFlight;
    if (pending != null) return pending;
    final fetchedAt = _fetchedAt;
    if (!force &&
        fetchedAt != null &&
        _state.valueOrNull != null &&
        _now().difference(fetchedAt) < staleAfter) {
      return Future.value();
    }
    return _inFlight = _refresh(silent: silent).whenComplete(
      () => _inFlight = null,
    );
  }

  Future<void> _refresh({required bool silent}) async {
    if (!silent) {
      _state = const AsyncLoading();
      notifyListeners();
    }
    try {
      final dashboard = await _repository.fetchDashboard();
      _state = AsyncData(dashboard);
      // 只在成功时记账：失败后下一次调用应当重试，而不是拿旧数据再撑 45 秒
      _fetchedAt = _now();
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
    _fetchedAt = null;
    notifyListeners();
  }

  /// 供页面直接取错误文案（避免每个页面都做一次 switch）。
  AppException? get error => switch (_state) {
    AsyncFailure(:final error) => error,
    _ => null,
  };
}
