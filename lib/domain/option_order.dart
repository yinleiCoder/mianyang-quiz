// 选项显示顺序（乱序）。
//
// 为什么单独一个文件：这是全项目最容易"看起来能跑但答案全错"的地方。
//
// 核心规则：**显示字母与原始 key 必须分离**。
// 乱序后用户看到的 "A" 可能是原始 "C"。提交作答时只能送原始 key，
// 否则服务端按 key 匹配标准答案会全部判错——而且界面看起来完全正常。
//
// 因此本文件只回答一个问题：**原始 key 按什么顺序显示**。
// 界面上第 i 个选项显示字母是 letterOf(i)，它携带的原始 key 是 order[i]。
// 不存在第二条构造作答的路径。
//
// 稳定性：同一道题每次进入的顺序必须一致，否则复盘时对不上、用户会觉得"选项在跳"。
// 所以用**自己实现的确定性哈希**而不是 String.hashCode ——
// 后者在 Dart 里不保证跨运行、跨平台稳定（不同 VM 版本/平台可能不同）。

/// 原始 key 的显示顺序。
///
/// [shuffle] 为 false 时原样返回（题目原始顺序）。
List<String> displayOrder(
  List<String> originalKeys, {
  required String seed,
  required bool shuffle,
}) {
  if (!shuffle || originalKeys.length < 2) return List.of(originalKeys);

  final result = List.of(originalKeys);
  final random = _DeterministicRandom(seed);
  // Fisher–Yates：从后往前，每次与 [0, i] 中一个位置交换
  for (var i = result.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final tmp = result[i];
    result[i] = result[j];
    result[j] = tmp;
  }
  return result;
}

/// 序号 → 显示字母（0→A，1→B…）。与网页端的 optionLetter 同规则。
String letterOf(int index) => String.fromCharCode(0x41 + index);

/// 确定性伪随机（xorshift32 + FNV-1a 播种）。
///
/// 不是密码学安全的，也不需要——只要求"同一 seed 在同一平台与跨平台都产出同一序列"。
class _DeterministicRandom {
  _DeterministicRandom(String seed) : _state = _fnv1a(seed) | 1;

  int _state;

  static int _fnv1a(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      // FNV 质数 16777619；用 & 0xFFFFFFFF 保持在 32 位内
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  /// 返回 [0, max) 内的整数。
  int nextInt(int max) {
    // xorshift32
    _state ^= (_state << 13) & 0xFFFFFFFF;
    _state ^= _state >> 17;
    _state ^= (_state << 5) & 0xFFFFFFFF;
    return _state.abs() % max;
  }
}
