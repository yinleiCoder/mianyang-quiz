// 错题本的取数状态机：排序、搜索、分页、请求去重。
//
// 从 wrong_questions_tab.dart 拆出来只是因为那个文件顶到 200 行上限；
// 边界也很自然：本文件管"什么时候查、查到什么"，页面只管"长什么样"。
//
// 排序与搜索都在服务端（迁移 0111）：只对当前页排序会给出"第 1 页的第 1 名"，
// 不是全库第 1 名；搜索也必须扫全库，不能只筛已加载的行。

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';

class WrongQuestionsController extends ChangeNotifier {
  WrongQuestionsController(this._repository);

  final ListRepository _repository;

  static const int pageSize = 30;

  final List<WrongQuestion> _rows = [];
  List<WrongQuestion> get rows => _rows;

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;
  String _sortKey = 'recent';
  bool _ascending = false;
  String _keyword = '';

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get sortKey => _sortKey;
  bool get ascending => _ascending;
  String get keyword => _keyword;

  Timer? _debounce;

  /// 请求序号：搜索/排序在飞行中再次变化时，旧响应直接丢弃。
  int _requestSeq = 0;

  String get _sortParam => '${_sortKey}_${_ascending ? 'asc' : 'desc'}';

  Future<void> reload() async {
    final seq = ++_requestSeq;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final page = await _repository.fetchWrongQuestions(
        limit: pageSize,
        offset: 0,
        sort: _sortParam,
        keyword: _keyword.isEmpty ? null : _keyword,
      );
      if (seq != _requestSeq) return;
      _rows
        ..clear()
        ..addAll(page);
      _loading = false;
      _hasMore = page.length == pageSize;
      notifyListeners();
    } catch (error) {
      if (seq != _requestSeq) return;
      _loading = false;
      _error = mapError(error).message;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    final seq = _requestSeq;
    _loadingMore = true;
    notifyListeners();
    try {
      final page = await _repository.fetchWrongQuestions(
        limit: pageSize,
        offset: _rows.length,
        sort: _sortParam,
        keyword: _keyword.isEmpty ? null : _keyword,
      );
      if (seq != _requestSeq) return;
      _rows.addAll(page);
      _hasMore = page.length == pageSize;
      _loadingMore = false;
      notifyListeners();
    } catch (error) {
      if (seq != _requestSeq) return;
      _loadingMore = false;
      _error = mapError(error).message;
      notifyListeners();
    }
  }

  void setSort(int column, bool ascending) {
    _sortKey = column == 1 ? 'wrong' : 'recent';
    _ascending = ascending;
    reload();
  }

  /// 搜索防抖：每敲一个字都查一次既浪费又会让列表闪烁。
  void search(String raw) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final keyword = raw.trim();
      if (keyword == _keyword) return;
      _keyword = keyword;
      reload();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
