// 异步三态的渲染器：AsyncValue<T> → 加载中 / 出错重试 / 有数据。
//
// **为什么值得单独一个组件**：这个 switch 在改造前被抄了 13 遍，每份都略有出入
// （有的写 LoadingState(message:)，有的裸调；有的忘了把 onRetry 传下去）。
// 抄写本身不致命，致命的是**行为会漂移**——某一次改动只补了其中一处，
// 于是"这个页面断网能重试、那个页面只能干瞪眼"，而且没有编译错误能发现它。
//
// 空态**不在这里**：`AsyncData([])` 该显示什么，是页面自己的事（"没有收藏"
// 和"没有错题"要引导去不同地方），交给 builder 判断即可。
//
// 与 async_value.dart 的分工：那边定义三态这个**类型**，这里负责把它画出来。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';

class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.state,
    required this.builder,
    this.loadingMessage,
    this.onRetry,
    this.errorTitle,
  });

  /// 要渲染的三态。
  final AsyncValue<T> state;

  /// 有数据时怎么画。
  final Widget Function(T value) builder;

  /// 加载中的说明文案；不传就只显示转圈（短请求别写废话）。
  final String? loadingMessage;

  /// 重试回调；为 null 时错误页不显示重试按钮（只读页面没有可重试的动作）。
  final VoidCallback? onRetry;

  /// 错误页标题，默认「出错了」。
  final String? errorTitle;

  @override
  Widget build(BuildContext context) => switch (state) {
    AsyncLoading<T>() => LoadingState(message: loadingMessage),
    AsyncFailure<T>(:final error) => ErrorState(
      message: error.message,
      title: errorTitle,
      onRetry: onRetry,
    ),
    AsyncData<T>(:final value) => builder(value),
  };
}
