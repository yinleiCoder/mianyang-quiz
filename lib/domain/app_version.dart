// 版本号比较（纯函数，不 import Flutter）：判断"远端那个版本是不是比本机新"。
//
// 只认数字段：`v1.2.3` / `1.2.3` / `1.2` 都行，`-dev`、`+1`（build number）之类的后缀忽略。
// 段数不同时短的按 0 补齐（1.2 == 1.2.0），所以 `1.2` 不比 `1.2.0` 新。
//
// 为什么不引 pub 上的升级包（upgrader / new_version_plus / in_app_update）：
// 它们默认对接应用商店（Play / App Store），而本应用走的是 GitHub Releases 分发；
// 商店渠道真要内更新时再换 in_app_update 也不迟（那时弹窗文案与下载动作都要重写）。

/// 版本号 → 数字段。解析不出任何数字时返回空列表（调用方据此判定"无法比较"）。
List<int> parseVersion(String? raw) {
  if (raw == null) return const [];
  final cleaned = raw.trim().replaceFirst(RegExp(r'^[vV]'), '');
  return [
    for (final part in cleaned.split('.'))
      // 段里可能带后缀（1.2.3-dev、1.2.3+4），取开头的数字部分
      int.tryParse(RegExp(r'^\d+').stringMatch(part) ?? '') ?? -1,
  ].where((v) => v >= 0).toList();
}

/// [a] 比 [b] 新返回正数，相同返回 0，更旧返回负数。
///
/// 任一侧解析不出数字（比如 'dev'）时返回 0：**"不知道"按"不提示更新"处理** ——
/// 开发构建（APP_VERSION=dev）绝不该天天提示用户升级。
int compareVersions(String? a, String? b) {
  final va = parseVersion(a);
  final vb = parseVersion(b);
  if (va.isEmpty || vb.isEmpty) return 0;
  final len = va.length > vb.length ? va.length : vb.length;
  for (var i = 0; i < len; i++) {
    final x = i < va.length ? va[i] : 0;
    final y = i < vb.length ? vb[i] : 0;
    if (x != y) return x - y;
  }
  return 0;
}

/// [latest] 是否比 [current] 新（同版本或解析不出都算"没有新版本"）。
bool hasNewerVersion({required String? latest, required String? current}) =>
    compareVersions(latest, current) > 0;
