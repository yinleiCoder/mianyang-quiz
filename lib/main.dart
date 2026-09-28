// 入口。只做三件事：挂错误钩子、启动装配、挂根组件。
//
// 其他一切（主题、依赖、路由表、页面）都在各自的文件里，这里刻意保持极短——
// 入口文件一旦开始长东西，就说明有依赖没有被正确归位。

import 'package:flutter/widgets.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/app.dart';
import 'package:mianyang_quiz/bootstrap.dart';
import 'package:mianyang_quiz/error_handling.dart';

Future<void> main() async {
  // **顺序不能动**，两条都是硬要求：
  //   1. 错误钩子要在最前面——bootstrap 里抛的错（配置读不出来、后端连不上）
  //      也该被接住，而那时候它们还没装。
  //   2. CrashReporter.init() 要在 installErrorHandling() **之后**——
  //      Sentry 那两个 integration 是链式的，会包住已装的 handler；
  //      顺序反了它链不上，钩子被顶掉。
  installErrorHandling();
  await CrashReporter.init();

  // 装配失败不抛：配置缺失、后端不可达都应当显示成界面上的提示页
  final startup = await bootstrap();
  runApp(MianyangQuizApp(startup: startup));
}
