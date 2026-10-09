// 题库「选题讲练」的勾选状态（0095）。
//
// 为什么不去 state/ 做跨页 Store：它是**离开题库即弃**的页面级状态（与翻到第几页同一类），
// 塞进全局 Store 只会让别的页面也看得见一份无意义的数据（见 bank_page.dart 文件头的同一条理由）。
// 单独成文件也不是为了复用，而是为了 bank_page.dart 不因为多一个功能就涨过 200 行
// （AGENTS.md 三，由 check_architecture 强制）。

import 'package:flutter/foundation.dart';

class BankSelection extends ChangeNotifier {
  /// 一轮最多 100 道——**服务端 start_sequential_practice 的硬上限**（0043 定的 100，
  /// 0090 沿用）。这里提前挡住，是因为"勾了 150 道、开练时被截成 100"说不清截掉了哪些。
  static const int maxPicked = 100;

  /// 勾满之后再勾时的提示。写成 getter 而不是让调用方拼字符串：
  /// 上限只有 [maxPicked] 一个来源，改一处就够（也别为了 const 把它写死成 100）。
  static String get limitHint => '一轮最多讲练 $maxPicked 道题，先取消几道再勾';

  /// null = 不在选题模式；空集 = 在选题但一道没勾。
  Set<String>? _picked;

  bool get active => _picked != null;

  int get count => _picked?.length ?? 0;

  /// 不在选题模式时一律 false —— 列表据此决定画不画勾选框。
  bool contains(String questionId) => _picked?.contains(questionId) ?? false;

  /// 已勾选的题目 id；不在选题模式时是 null（**与"勾了 0 道"不同**）。
  List<String>? get pickedIds => _picked?.toList();

  void begin() {
    if (_picked != null) return;
    _picked = <String>{};
    notifyListeners();
  }

  void cancel() {
    if (_picked == null) return;
    _picked = null;
    notifyListeners();
  }

  /// 切换勾选。返回 false = 已达上限、**什么都没改**，调用方据此说明原因。
  bool toggle(String questionId) {
    final picked = _picked;
    if (picked == null) return false;
    if (!picked.contains(questionId) && picked.length >= maxPicked) return false;
    picked.contains(questionId) ? picked.remove(questionId) : picked.add(questionId);
    notifyListeners();
    return true;
  }

  /// 开练：取走勾选的 id 并退出选题模式（勾选是一次性的，开完就收起）。
  List<String> take() {
    final ids = pickedIds ?? const <String>[];
    cancel();
    return ids;
  }
}
