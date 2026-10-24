// 版本更新状态：最近一次检查结果 + 是否有新版本。
//
// 为什么抽成 Store：启动时的 UpdateChecker（弹一次窗）与「我的 → 版本更新」
// （红点 + 手动检查）要用同一份结果。两处各查一次会出现"角标还亮着、点进去说已是最新"
// 的漂移，也会让启动时多打一次 OSS。
//
// 不弹窗、不导航——这里只管"查到了什么"，怎么展示由页面决定。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class UpdateStore extends ChangeNotifier {
  UpdateStore(this._repository);

  final AppUpdateRepository _repository;

  AppRelease? _release;
  bool _checking = false;
  bool _checked = false;

  /// 最近一次查到的发布信息；null = 没查到（未发版、断网、清单没写）。
  AppRelease? get release => _release;

  bool get checking => _checking;

  /// 是否已经查过一次（手动检查与启动检查共用）。
  bool get checked => _checked;

  /// 当前平台（Android / Windows）。其它平台（含 widget 测试）不查更新。
  static String? get platform => switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.windows => 'windows',
    _ => null,
  };

  /// 服务端最新版本是否比当前安装的新。开发版（带 `-` 的 tag）不提示。
  bool get hasUpdate =>
      _release != null &&
      Env.appVersion.isNotEmpty &&
      !Env.appVersion.contains('-') &&
      hasNewerVersion(latest: _release!.tag, current: Env.appVersion);

  /// 去下载的地址：优先当前平台直链，没有就打开网页下载页。
  String? get downloadUrl => _release == null
      ? null
      : (_release!.assetUrl ?? _release!.pageUrl);

  /// 查一次。`force = false` 时同一进程内只查一次（启动检查与页面打开共用结果）。
  Future<void> check({bool force = false}) async {
    if (_checking) return;
    if (_checked && !force) return;
    final target = platform;
    if (target == null) {
      _checked = true;
      notifyListeners();
      return;
    }

    _checking = true;
    notifyListeners();
    try {
      // 仓储自己会吞掉网络异常并返回 null：这里不区分"没发版"与"查不到"，
      // 页面统一显示"暂时无法获取最新版本"比抛一个吓人的错误框合适。
      _release = await _repository.fetchLatest(platform: target);
    } catch (_) {
      // 万一仓储将来改成会抛，这里也兜住：检查更新绝不打断页面
      _release = null;
    } finally {
      _checking = false;
      _checked = true;
      notifyListeners();
    }
  }

  void clear() {
    _release = null;
    _checking = false;
    _checked = false;
    notifyListeners();
  }
}
