// 组卷条件草稿。**全局唯一**，因为组卷页可以从四个地方进入
// （首页、题库列表、错题本、收藏），每处要预填不同的来源与筛选，
// 而且用户退出再进来时期望上次的条件还在。
//
// 只装"用户改过的组卷条件"，不装题目数据——那是练习会话自己的事。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';

class PracticeDraftStore extends ChangeNotifier {
  /// 题量上下限由服务端 start_practice_session 决定（1~100，见 0043）。
  /// 客户端先挡一道：滑杆拖到底也是 100，越界由这里的 clamp 兜住。
  /// 申请量大于题库现有题数不算错——服务端有多少给多少。
  static const int minLimit = 1;
  static const int maxLimit = 100;
  static const int defaultLimit = 20;

  QuestionFilter _filter = const QuestionFilter();
  PracticeSource _source = PracticeSource.all;
  PracticeMode _mode = PracticeMode.instant;
  int _limit = defaultLimit;
  bool _shuffleOptions = true;

  QuestionFilter get filter => _filter;

  PracticeSource get source => _source;

  PracticeMode get mode => _mode;

  int get limit => _limit;

  /// 选项乱序。默认开启：同一道题反复练时，记住"A 是对的"没有意义。
  bool get shuffleOptions => _shuffleOptions;

  /// 来源决定了哪些筛选条件生效——错题本与收藏两条分支服务端会忽略筛选。
  /// 界面据此禁用无效的筛选项，而不是让用户改了却没反应。
  bool get filterApplies => _source == PracticeSource.all;

  void updateFilter(QuestionFilter value) {
    _filter = value;
    notifyListeners();
  }

  void setSource(PracticeSource value) {
    if (_source == value) return;
    _source = value;
    notifyListeners();
  }

  void setMode(PracticeMode value) {
    if (_mode == value) return;
    _mode = value;
    notifyListeners();
  }

  void setLimit(int value) {
    final clamped = value.clamp(minLimit, maxLimit);
    if (_limit == clamped) return;
    _limit = clamped;
    notifyListeners();
  }

  void setShuffleOptions(bool value) {
    if (_shuffleOptions == value) return;
    _shuffleOptions = value;
    notifyListeners();
  }

  /// 从某个入口进入组卷页时重置为"该入口的默认条件"。
  ///
  /// 明确重置而不是增量修改：用户在错题本点「练错题」时，
  /// 期望的是"练错题"，而不是"练上次选的科目里的错题"。
  void startFrom({required PracticeSource source, QuestionFilter? filter}) {
    _source = source;
    _filter = filter ?? const QuestionFilter();
    notifyListeners();
  }
}
