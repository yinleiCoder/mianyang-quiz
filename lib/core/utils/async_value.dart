// 异步数据的三态表示。
//
// 职责：让"加载中 / 失败 / 有数据"成为**类型**而不是三个可能互相矛盾的布尔字段。
// 不负责：分页与刷新策略——那是各仓储与页面自己的事。
//
// 为什么不用 Result<T>：Result 只表达"成功或失败"，而 UI 还需要"还没开始/正在加载"这一态。
// 三者互斥且穷举，正好用 sealed 表达；配合 ui/core/feedback 的 AsyncView，
// 十来个列表页就不必各写一遍 if (loading) ... else if (error) ... 的分支。
//
// 注意：这里刻意**不叫** AsyncValue 之外的任何名字，也刻意不提供 fold/when 之类的
// 函数式辅助——Dart 3 的 switch 模式匹配已经足够，多一层抽象只会让调用点更难读。

import 'package:mianyang_quiz/core/error/app_exception.dart';

sealed class AsyncValue<T> {
  const AsyncValue();

  /// 有数据时返回它，否则 null。用于"有旧数据就先显示、后台继续加载"的场景。
  T? get valueOrNull => switch (this) {
    AsyncData<T>(:final value) => value,
    _ => null,
  };

  bool get isLoading => this is AsyncLoading<T>;
}

final class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

final class AsyncData<T> extends AsyncValue<T> {
  const AsyncData(this.value);
  final T value;
}

final class AsyncFailure<T> extends AsyncValue<T> {
  const AsyncFailure(this.error);
  final AppException error;
}
