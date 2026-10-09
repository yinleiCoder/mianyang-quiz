// 组卷条件草稿。**全局唯一**，因为组卷页可以从四个地方进入
// （首页、题库列表、错题本、收藏），每处要预填不同的来源与筛选，
// 而且用户退出再进来时期望上次的条件还在。
//
// 只装"用户改过的组卷条件"，不装题目数据——那是练习会话自己的事。

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/entity/entity.dart';
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
  int _offset = 0;
  int? _totalAvailable;
  List<String>? _questionIds;

  QuestionFilter get filter => _filter;

  PracticeSource get source => _source;

  PracticeMode get mode => _mode;

  int get limit => _limit;

  /// 顺序练习（课堂讲练）本轮的起点：题库顺序里第几道开始，0 起（见 0095）。
  /// 轮大小就是 [limit]，所以第 N 轮 = offset (N-1)*limit。
  int get offset => _offset;

  /// 符合当前条件的题目**总数**（不是本轮题数）。来自上一次 start_sequential_practice
  /// 的 total_available；null = 还没问过服务端，这时界面不显示轮次、也不给「下一轮」。
  int? get totalAvailable => _totalAvailable;

  /// 当前是第几轮（1 起）。只用于显示。
  int get round => _offset ~/ _limit + 1;

  /// 本轮第一题在题库顺序里的序号（1 起）。
  int get roundFrom => _offset + 1;

  /// 本轮最后一题的序号（1 起）。还不知道总数时按本轮应发题数算。
  int get roundTo {
    final end = _offset + _limit;
    final total = _totalAvailable;
    return total != null && total < end ? total : end;
  }

  /// 有没有上一轮。第 1 轮就没有。
  bool get hasPrevRound => _offset > 0;

  /// 有没有下一轮。总数未知时一律**不给**——宁可少了这个入口，
  /// 也不要让教师点下去才被服务端告知"已经是最后一轮了"。
  bool get hasNextRound {
    final total = _totalAvailable;
    return total != null && _offset + _limit < total;
  }

  /// 教师在题库里逐题勾选的题目 id（批量选题讲练）。null = 按筛选条件抽题。
  ///
  /// 它和 [filter] 是**互斥**的：服务端 practice_candidates 把 p_question_ids 与
  /// 其它条件**并列 AND**，带着一个过期的筛选条件去练勾选题，轻则少几道、重则一道不剩。
  /// 所以勾选之后一律把筛选条件清掉（见 setPickedQuestions），改了筛选也会把它清掉。
  List<String>? get questionIds => _questionIds;

  bool get hasPickedQuestions => _questionIds != null && _questionIds!.isNotEmpty;

  /// 选项乱序。默认开启：同一道题反复练时，记住"A 是对的"没有意义。
  bool get shuffleOptions => _shuffleOptions;

  /// 来源决定了哪些筛选条件生效——错题本与收藏两条分支服务端会忽略筛选。
  /// 界面据此禁用无效的筛选项，而不是让用户改了却没反应。
  bool get filterApplies => _source == PracticeSource.all;

  void updateFilter(QuestionFilter value) {
    _filter = value;
    // 改了筛选条件 = 重新按条件挑题，之前勾选的那几道不再作数
    _questionIds = null;
    _resetRound();
    notifyListeners();
  }

  void setSource(PracticeSource value) {
    if (_source == value) return;
    _source = value;
    _questionIds = null;
    _resetRound();
    notifyListeners();
  }

  void setMode(PracticeMode value) {
    if (_mode == value) return;
    _mode = value;
    _resetRound();
    notifyListeners();
  }

  void setLimit(int value) {
    final clamped = value.clamp(minLimit, maxLimit);
    if (_limit == clamped) return;
    _limit = clamped;
    // 轮大小变了，轮次边界整体平移——停在原来的 offset 上会让本轮范围莫名其妙。
    _resetRound();
    notifyListeners();
  }

  /// 记下服务端刚给的轮次信息（0095）。每次开一场顺序练习后调用。
  void setRoundInfo({required int offset, int? totalAvailable}) {
    if (_offset == offset && _totalAvailable == totalAvailable) return;
    _offset = offset;
    _totalAvailable = totalAvailable;
    notifyListeners();
  }

  /// 下一轮（教师讲练）：本轮往后挪一个轮大小。
  void nextRound() {
    if (!hasNextRound) return;
    _offset += _limit;
    notifyListeners();
  }

  /// 上一轮：往前挪一个轮大小，退到第 1 轮为止。
  void prevRound() {
    if (!hasPrevRound) return;
    _offset = (_offset - _limit).clamp(0, _offset);
    notifyListeners();
  }

  /// 批量选题：直接指定要讲练的题目（题干右侧勾选出来的）。
  ///
  /// 一次把四件事定死，因为它们必须同时成立，分开调迟早漏一个：
  ///   · 来源回到"题库"（勾选只对 all 分支生效）；
  ///   · **筛选条件清空**（服务端把 p_question_ids 与筛选条件 AND 起来，
  ///     留着旧条件会把勾选的题再筛一遍）；
  ///   · 题量 = 勾选数（上限仍是服务端的 100，勾选时已挡过）；
  ///   · 轮次回到第 1 轮——勾选是"就讲这几道"，谈不上第几轮。
  void setPickedQuestions(List<String> ids) {
    _source = PracticeSource.all;
    _filter = const QuestionFilter();
    _questionIds = ids.isEmpty ? null : List.unmodifiable(ids);
    _limit = ids.length.clamp(minLimit, maxLimit);
    _resetRound();
    notifyListeners();
  }

  /// 清掉勾选，回到"按筛选条件抽题"。
  void clearPickedQuestions() {
    if (_questionIds == null) return;
    _questionIds = null;
    notifyListeners();
  }

  /// 回到第 1 轮。
  void resetRound() {
    if (_offset == 0) return;
    _resetRound();
    notifyListeners();
  }

  /// 换了筛选条件/来源/轮大小之后，原来的 offset 已经没有意义了。
  ///
  /// 注意 [totalAvailable] 一并清掉：它属于**旧条件**的题目总数，
  /// 留着一个过期总数会让「下一轮」按钮按错误的边界亮起来。
  void _resetRound() {
    _offset = 0;
    _totalAvailable = null;
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
    // 从入口进来是"重新选一遍练什么"：勾选题与轮次都跟着清零，
    // 否则从错题本进来会莫名其妙地落在"第 3 轮"或"上次勾的那几道"。
    _questionIds = null;
    _resetRound();
    notifyListeners();
  }
}
