// 判分：服务端 `public.grade_answer` / `public.norm_answer_text` 的 Dart 镜像。
//
// 为什么必须镜像：这两个函数对客户端角色 `revoke` 了执行权限，客户端调不到；
// 而"选完立刻知道对错"是刷题的核心手感，等一个网络往返会毁掉它。
//
// 权威性：**服务端是唯一权威**。本地结果只用于抢先显示，
// submit_practice_answer 返回的 is_correct 会覆盖它（见 practice_runner）。
// 两者不一致就是本文件有 bug —— 差分测试（test/domain/answer_grader_test.dart）
// 用真实数据库函数逐条对照，就是为了在用户看到"答案翻转"之前抓到它。
//
// 本文件是纯 Dart：不 import Flutter，可独立单测。

/// 归一化答案文本。对应 SQL `norm_answer_text`，**顺序不可调换**：
/// 全角转半角 → 中文标点转半角 → 小写 → 删除全部空白。
///
/// 顺序有讲究：`Ａ`（全角 A）必须先转成 `A` 才能被 lower() 处理；
/// 若先 lower，`Ａ` 不在 a-z 区间，转不出 `a`。
String normAnswerText(String? input) {
  final buffer = StringBuffer();
  for (final rune in (input ?? '').runes) {
    if (_whitespaceCodePoints.contains(rune)) continue; // 空白直接丢弃
    final mapped = _halfWidth[rune] ?? _punctuation[rune] ?? rune;
    buffer.writeCharCode(mapped);
  }
  return buffer.toString().toLowerCase();
}

/// 判分。返回 null 表示"该题型不由本函数判定"——只有主观题（short_answer）走自评。
///
/// [qtype] 根题/子题题型；[content] 题目 content（含 answer）；[answer] 学生作答。
bool? gradeAnswer(String qtype, Map<String, dynamic> content, Map<String, dynamic> answer) {
  final type = answer['type'] as String? ?? '';

  // 不会 / 未作答
  if (type.isEmpty || type == 'unknown') return false;

  switch (qtype) {
    case 'single_choice':
    case 'multiple_choice':
      if (type != 'choice') return false;
      final got = _sortedKeys(answer['keys']);
      final expected = _sortedKeys(_sub(content, 'answer')['keys']);
      if (expected.isEmpty || got.isEmpty) return false;
      return _listEquals(got, expected);

    case 'true_false':
      if (type != 'tf') return false;
      // 对应 SQL 的 `p_answer ->> 'value'`：JSON 值先转文本再比。
      // 因此两边都做 '$value' 转换，true/false 与 "true"/"false" 都能对上。
      final got = answer['value'];
      final expected = _sub(content, 'answer')['value'];
      if (got == null || expected == null) return false;
      return '$got' == '$expected';

    case 'fill_blank':
      if (type != 'blank') return false;
      final got = _normalizedList(answer['values']);
      final expected = _normalizedList(_sub(content, 'answer')['values']);
      if (expected.isEmpty || got.length != expected.length) return false;
      for (var i = 0; i < expected.length; i++) {
        // 空答案（含"全是空白被归一成空串"）一律判错
        if (got[i].isEmpty || got[i] != expected[i]) return false;
      }
      return true;

    case 'short_answer':
      return null; // 交给自评

    case 'composite':
      if (type != 'composite') return false;
      final subs = content['sub'];
      if (subs is! List || subs.isEmpty) return false;
      final subAnswers = answer['subs'];
      for (var i = 0; i < subs.length; i++) {
        final sub = subs[i];
        if (sub is! Map) return false;
        final subContent = Map<String, dynamic>.from(sub);
        final rawSubAnswer = (subAnswers is List && i < subAnswers.length) ? subAnswers[i] : null;
        final subAnswer = rawSubAnswer is Map
            ? Map<String, dynamic>.from(rawSubAnswer)
            : <String, dynamic>{};
        final subType = subContent['type'] as String? ?? '';

        if (subType == 'short_answer') {
          // 子题主观题：由自评代入（对应 SQL 里 ->> 'mastered' = 'true'）
          final mastered = subAnswer['mastered'];
          if (mastered != true && mastered != 'true') return false;
        } else if (gradeAnswer(subType, subContent, subAnswer) != true) {
          return false;
        }
      }
      return true;
  }

  return false; // 未知题型
}

Map<String, dynamic> _sub(Map<String, dynamic> map, String key) {
  final value = map[key];
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

/// 对应 SQL 的 `array_agg(upper(btrim(x)) order by upper(btrim(x)))`。
///
/// 两个关键点，都是踩过的坑：
///   1. 排序后比较 → 多选顺序无关；
///   2. 是**数组不是集合** → `['A','A']` 与 `['A']` 不相等。
///      用 Set 实现会比服务端宽松，表现为"先显示答对、提交后被判错"。
List<String> _sortedKeys(Object? raw) {
  if (raw is! List) return const [];
  final keys = raw
      .map((e) => '$e'.trim().toUpperCase())
      .toList()
    ..sort();
  return keys;
}

List<String> _normalizedList(Object? raw) {
  if (raw is! List) return const [];
  return raw.map((e) => normAnswerText('$e')).toList();
}

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// 全角数字/字母 → 半角（对应 SQL 里第一个 translate）。
final Map<int, int> _halfWidth = {
  for (var i = 0; i < 10; i++) 0xFF10 + i: 0x30 + i, // ０-９
  for (var i = 0; i < 26; i++) 0xFF21 + i: 0x41 + i, // Ａ-Ｚ
  for (var i = 0; i < 26; i++) 0xFF41 + i: 0x61 + i, // ａ-ｚ
};

/// 中文标点 → 半角（对应 SQL 里第二个 translate，14 对，逐字符位置映射）。
const Map<int, int> _punctuation = {
  0x3002: 0x2E, // 。 → .
  0xFF0C: 0x2C, // ， → ,
  0xFF01: 0x21, // ！ → !
  0xFF1F: 0x3F, // ？ → ?
  0xFF1B: 0x3B, // ； → ;
  0xFF1A: 0x3A, // ： → :
  0xFF08: 0x28, // （ → (
  0xFF09: 0x29, // ） → )
  0x300A: 0x3C, // 《 → <
  0x300B: 0x3E, // 》 → >
  0x3010: 0x5B, // 【 → [
  0x3011: 0x5D, // 】 → ]
  0x3001: 0x2C, // 、 → ,
  0x2014: 0x2D, // — → -
};

/// 空白码位集合 —— **实测自本库**，不是照搬 Dart 的 `\s`。
///
/// 为什么不能直接用 `RegExp(r'\s')`：Dart 走 ECMAScript 规则，与 PostgreSQL 的
/// `[[:space:]]` 互不包含 ——
///   · Dart 多匹配 U+FEFF（BOM），而本库不匹配 → 本地会多删一个字符，判定与服务端不一致；
///   · Dart 少匹配 U+001C–U+001F 与 U+0085，而本库匹配。
/// 两个方向的偏差都会造成"本地判对、服务端判错"，所以这里用显式集合。
///
/// 测量方式（2026-09，本库 UTF-8）：
///   select cp, to_hex(cp) from generate_series(1, 65535) cp
///   where cp not between 55296 and 57343
///     and regexp_replace(chr(cp), '\s', '', 'g') = '';
/// 命中 29 个码位，即下面这些。
/// 注意：`\s` 的匹配范围**依数据库 locale 而定**；若将来库的 collation 变了，
/// 需要重跑上面的查询并更新本集合（差分测试会先失败，不会静默出错）。
final Set<int> _whitespaceCodePoints = {
  0x09, 0x0A, 0x0B, 0x0C, 0x0D, // \t \n \v \f \r
  0x1C, 0x1D, 0x1E, 0x1F, // 文件/分组/记录/单元分隔符
  0x20, // 空格
  0x85, // NEL
  0xA0, // 不换行空格
  0x1680, // 欧甘文空格
  for (var cp = 0x2000; cp <= 0x200A; cp++) cp, // 各种 em/en 空格
  0x2028, 0x2029, // 行/段分隔符
  0x202F, // 窄不换行空格
  0x205F, // 中等数学空格
  0x3000, // 全角空格
};
