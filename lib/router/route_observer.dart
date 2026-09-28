// 全局路由观察者：给"从子页面返回时该刷新"的页面用。
//
// 为什么需要它：错题本这类列表**会因别的页面而变** —— 学生从错题本点「开始练习」、
// 答对几道再返回，那些题就该从列表里消失。但列表页被推入的练习页盖住时并没有销毁，
// 回来时 initState 不会重跑，于是显示的还是进练习之前那份数据。
//
// RouteAware 的 didPopNext() 正是这个时机。要订阅就必须让 GoRouter 带上这个 observer
// （见 app_router.dart 的 observers）。
//
// 只给**真的会因他处而变**的页面用。绝大多数列表不需要 ——
// 每多一个订阅就多一次无谓的重拉。

import 'package:flutter/widgets.dart';

/// 全局单例。GoRouter 与各页面都引用这一个实例，别各建各的。
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
