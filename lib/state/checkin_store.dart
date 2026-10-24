// 云端打卡状态：连续天数、累计天数、今日目标。
//
// 为什么进全局 Store：首页（打卡区）与「我的」（改目标）都要读同一份数字。
// 各处各拉一次会出现"首页显示 7 天、我的页显示 6 天"的漂移。
//
// 打卡在**进入软件时**触发（AppShell 的 DailyCheckinTracker），不是"练过题才算"——
// 用户口径见迁移 0107 的头注。记录失败静默保留本地默认值：打卡是激励，不是门槛，
// 断网时不该把首页变成一个错误页。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class CheckinStore extends ChangeNotifier {
  CheckinStore(this._repository);

  final CheckinRepository _repository;

  CheckinStatus? _data;
  bool _recording = false;
  String? _error;

  /// 当前打卡状态；null = 还没成功记录过（首页应回落到看板的练习天数）。
  CheckinStatus? get data => _data;

  bool get recording => _recording;

  /// 最近一次记录失败的中文说明（成功后清空）。首页不展示它，设置页可用来提示。
  String? get error => _error;

  int get streakDays => _data?.streakDays ?? 0;

  /// 今日目标题数。未取到云端值时用 **20**（用户 2026-10-24 定的默认值）。
  int get dailyGoal => _data?.dailyGoal ?? 20;

  /// 本地先改目标：设置页保存后立即反映在首页，不必等一次 RPC 回来再刷新。
  void setGoalLocally(int goal) {
    _data = (_data ?? const CheckinStatus()).copyWith(dailyGoal: goal);
    notifyListeners();
  }

  /// 进入软件时记一次打卡（幂等）。同一进程内成功一次就不再重复请求。
  Future<void> recordToday({bool silent = true}) async {
    if (_recording) return;
    if (_data != null && _data!.day.isNotEmpty) {
      final today = _todayKey();
      if (_data!.day == today) return;
    }
    _recording = true;
    if (!silent) notifyListeners();
    try {
      _data = await _repository.recordToday();
      _error = null;
    } catch (error) {
      _error = error is AppException ? error.message : '打卡记录失败';
    } finally {
      _recording = false;
      notifyListeners();
    }
  }

  /// 保存目标（服务端校验 5~200）。失败时抛给调用方去弹提示，本地值不先改。
  Future<void> saveGoal(int goal) async {
    final value = await _repository.setDailyGoal(goal);
    setGoalLocally(value);
  }

  /// 北京时间（UTC+8）的 `YYYY-MM-DD`。库里按北京时间切日，客户端判断"今天是否已记"
  /// 必须用同一个日界，否则东八区凌晨会被判成新的一天而重复请求（幂等，不致命）。
  static String _todayKey() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }

  void clear() {
    _data = null;
    _error = null;
    _recording = false;
    notifyListeners();
  }
}
