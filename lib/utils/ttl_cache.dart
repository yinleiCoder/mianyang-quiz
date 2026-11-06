// 极小的"保鲜期缓存"：给**全局、变化极慢**的数据用（平台规模那类）。
//
// 为什么值得单独一个类：同一个模式已经在 DashboardStore 里出现过一次（45 秒），
// 再来一份手写的 `DateTime? _at` 就该抽走了——判据（什么时候算过期）只写一遍，
// 测试也只写一遍。
//
// 边界：
//   · 只缓存**成功**的结果；失败不写，下一次照常重试；
//   · 不做容量控制（就存一份），多值缓存请直接用 Map 或别的东西；
//   · 时钟可注入，测试里不依赖真实时间。
class TtlCache<T> {
  TtlCache(this.maxAge, {DateTime Function() now = DateTime.now})
    // 私有字段做不了命名参数（下划线开头的参数名非法），只能这样赋值
    // ignore: prefer_initializing_formals
    : _now = now;

  /// 超过这个时长就算过期。
  final Duration maxAge;

  final DateTime Function() _now;

  T? _value;
  DateTime? _at;

  /// 命中的值；没有或已过期时返回 null（调用方据此重新拉取）。
  T? read() {
    final at = _at;
    final value = _value;
    if (at == null || value == null) return null;
    if (_now().difference(at) >= maxAge) return null;
    return value;
  }

  /// 写入并重新计时。
  void write(T value) {
    _value = value;
    _at = _now();
  }

  /// 登出等场景：丢掉，别让下一个账号看到上一份。
  void clear() {
    _value = null;
    _at = null;
  }
}
