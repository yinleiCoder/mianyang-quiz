// 入口。只做两件事：启动装配、挂根组件。
//
// 其他一切（主题、依赖、路由表、页面）都在各自的文件里，这里刻意保持极短——
// 入口文件一旦开始长东西，就说明有依赖没有被正确归位。

import 'package:flutter/widgets.dart';
import 'package:mianyang_quiz/app.dart';
import 'package:mianyang_quiz/bootstrap.dart';

Future<void> main() async {
  // 装配失败不抛：配置缺失、后端不可达都应当显示成界面上的提示页
  final startup = await bootstrap();
  runApp(MianyangQuizApp(startup: startup));
}
