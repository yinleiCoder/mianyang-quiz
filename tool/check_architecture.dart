// 架构守卫：把 AGENTS.md 的硬约定变成可机器验收的检查。
//
// 为什么需要它：上一版客户端的练习页单文件涨到 1379 行，原因是"只有约定、没有检查"。
// 口头约定会在赶进度时第一个被牺牲，脚本不会。
//
// 用法：dart run tool/check_architecture.dart
// 退出码 0 = 全部通过；1 = 有违规（提交前都应跑）。

import 'dart:io';

/// 单文件行数上限。超过就必须拆，或显式加进下面的豁免名单并写明理由。
const _maxLines = 200;

/// 非界面层一个文件允许的 public class 上限（界面层恒为 1，见 checkSingleResponsibility）。
const _maxPublicClassesPerDataFile = 3;

/// 行数豁免名单：路径 → 理由。
/// 只应放"单一职责但天然很长"的文件（如全部中文文案的常量表）。
/// 每加一条都要问：这是真的不可拆，还是我没想清楚怎么拆？
const _lineLimitExemptions = <String, String>{
  'lib/router/app_router.dart': '所有路由的登记处，集中才看得出全貌',
  'lib/pages/practice/state/practice_runner.dart':
      '练习会话状态机：题目运行时列表、当前题号、计时起点都是私有字段，'
      '而 Dart 的私有是**库级**——换一个文件就再也改不动它们。'
      '真要拆只能把状态机改成"协作者 + 回调"的间接层，为行数换架构不划算；'
      '可拆的部分（题目运行时的构造、答题卡、版式）都已经拆出去了。',
};

/// 禁止出现的 import（精确匹配）。
const _forbiddenImports = <String, String>{
  'package:flutter/material.dart':
      'Material 已拆为独立包，必须用 package:material_ui/material_ui.dart；'
      '混用会让 go_router 18 的祖先查找静默失效（转场动画消失且不报错）',
};

/// 分层约束：(源路径前缀, 禁止 import 的前缀, 理由)
///
/// 依赖方向（自下而上，下层不认识上层）：
///
///   values/  ← 主题、常量、配置：谁都能用，它谁也不依赖
///   entity/  ← 数据模型（+ utils/ 的纯函数）
///   utils/   ← 纯 Dart：判分、作答编解码、格式化、异常
///   apis/    ← 仓储与服务
///   state/   ← 跨页 Store
///   widgets/ ← 共享组件（只"喂数据"）
///   pages/   ← 页面 + 各模块私有组件/状态机
///   router/  ← 路由表（唯一认识全部页面的地方）
///
/// 注意 entity/ 与 utils/ 是**互相**依赖的（模型用 formatters，判分用 SubjectNode），
/// 这是重构前就存在的结构，这里不禁止。
const _layerRules = <(String, String, String)>[
  // ── values/：最底层，谁也不依赖 ──
  ('lib/values/', 'package:mianyang_quiz/entity/', 'values 是最底层，不认识模型'),
  ('lib/values/', 'package:mianyang_quiz/utils/', 'values 是最底层，不认识工具'),
  ('lib/values/', 'package:mianyang_quiz/apis/', 'values 不认识数据层'),
  ('lib/values/', 'package:mianyang_quiz/state/', 'values 不认识状态层'),
  ('lib/values/', 'package:mianyang_quiz/widgets/', 'values 不认识界面层'),
  ('lib/values/', 'package:mianyang_quiz/pages/', 'values 不认识界面层'),

  // ── entity/：数据模型，不认识网络与界面 ──
  ('lib/entity/', 'package:material_ui/', '数据模型不认识界面'),
  ('lib/entity/', 'package:flutter/', '数据模型是纯 Dart，必须可独立单测'),
  ('lib/entity/', 'package:mianyang_quiz/apis/', '数据模型不得依赖仓储/服务'),
  ('lib/entity/', 'package:mianyang_quiz/state/', '数据模型不得依赖状态层'),
  ('lib/entity/', 'package:mianyang_quiz/widgets/', '数据模型不得依赖界面层'),
  ('lib/entity/', 'package:mianyang_quiz/pages/', '数据模型不得依赖界面层'),
  ('lib/entity/', 'package:mianyang_quiz/router/', '数据模型不得依赖路由'),

  // ── utils/：纯 Dart（判分镜像、编解码、格式化、异常映射） ──
  ('lib/utils/', 'package:flutter/', 'utils 是纯 Dart，必须能脱离 Flutter 单测'),
  ('lib/utils/', 'package:material_ui/', 'utils 是纯 Dart，必须能脱离 Flutter 单测'),
  ('lib/utils/', 'package:mianyang_quiz/apis/', '工具层不得依赖数据层'),
  ('lib/utils/', 'package:mianyang_quiz/state/', '工具层不得依赖状态层'),
  ('lib/utils/', 'package:mianyang_quiz/widgets/', '工具层不得依赖界面层'),
  ('lib/utils/', 'package:mianyang_quiz/pages/', '工具层不得依赖界面层'),

  // ── apis/：仓储与服务，不认识界面 ──
  ('lib/apis/', 'package:material_ui/', '数据层不认识界面'),
  ('lib/apis/', 'package:mianyang_quiz/state/', '数据层不得依赖状态层'),
  ('lib/apis/', 'package:mianyang_quiz/widgets/', '数据层不认识界面'),
  ('lib/apis/', 'package:mianyang_quiz/pages/', '数据层不认识界面'),

  // ── state/：跨页 Store，无 UI 依赖 ──
  ('lib/state/', 'package:material_ui/', 'Store 必须无 UI 依赖，否则无法在纯 Dart 测试里跑'),
  ('lib/state/', 'package:mianyang_quiz/widgets/', '状态层不得依赖界面层'),
  ('lib/state/', 'package:mianyang_quiz/pages/', '状态层不得依赖界面层'),

  // ── widgets/：共享组件只"喂数据"，不得自己取数 ──
  // 只禁"取数"的层，不禁 entity/ —— 共享组件当然要能引用 QuestionContent
  // 这类数据类型，否则它无法渲染任何东西。禁的是自己去查库。
  ('lib/widgets/', 'package:mianyang_quiz/apis/', '共享组件只能"喂数据"，不得自己取数'),
  ('lib/widgets/', 'package:mianyang_quiz/state/', '共享组件不得依赖全局状态'),
  ('lib/widgets/', 'package:mianyang_quiz/pages/', '共享组件不得依赖页面层'),
];

/// 允许的字重。中文字体普遍只有 Regular(400) 与 Bold(700) 两档，
/// 写其它值会被引擎合成伪粗体，且合成结果在不同字号/字形上不一致 ——
/// 表现是"有的标题很粗、有的该粗却发虚"，肉眼很难归因。
/// 例外：values/app_theme.dart 里定义了这两个常量，它自己当然要引用。
final _illegalFontWeightPattern = RegExp(
  r'FontWeight\.w(?:100|200|300|500|600|800|900)\b',
);
const _fontWeightExemptPaths = {'lib/values/app_theme.dart'};

final _importPattern = RegExp(r'''^\s*import\s+['"]([^'"]+)['"]''', multiLine: true);
/// 只允许代码生成用的 part（*.g.dart / *.freezed.dart）。
/// 手写的 `part 'other.dart';` 与 `part of` 都是"把多个东西塞进一个文件"的路子，禁止。
final _illegalPartPattern = RegExp(
  r'''^\s*(?:part\s+of\b|part\s+['"](?![^'"]*\.(?:g|freezed)\.dart['"])[^'"]+['"])''',
  multiLine: true,
);
final _classPattern = RegExp(
  r'^(?:abstract\s+|sealed\s+|base\s+|final\s+|mixin\s+)*class\s+([A-Za-z_]\w*)',
  multiLine: true,
);
final _sealedPattern = RegExp(r'^sealed\s+class\s', multiLine: true);

/// 模块隔离：pages/<模块>/ 之间不准互相 import ——
/// 跨模块复用的组件必须上提到 widgets/ 或 state/。
/// （各模块的私有组件在 pages/<模块>/widgets|state/ 下，pages 桶**不导出**它们，
/// 所以跨模块引用只能写成精确路径，这里就抓得到。）
final _pageModulePathPattern = RegExp(r'^lib/pages/([^/]+)/');
final _pageModuleImportPattern = RegExp(r'package:mianyang_quiz/pages/([^/]+)/');
/// pages 桶会导出全部页面，任何一个页面 import 它都会把整圈拉进来、模块隔离立刻失效。
const _pagesBarrelImport = 'package:mianyang_quiz/pages/pages.dart';

void main() {
  final root = Directory('lib');
  if (!root.existsSync()) {
    stderr.writeln('未找到 lib/ —— 请在 mianyang_quiz/ 目录下运行');
    exit(1);
  }

  final violations = <String>[];
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final path = file.path.replaceAll(r'\', '/');
    final content = file.readAsStringSync();
    checkLineCount(path, content.split('\n').length, violations);
    checkImports(path, content, violations);
    checkSingleResponsibility(path, content, violations);
    checkPageIsolation(path, content, violations);
    checkFontWeight(path, content, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('架构检查通过（${files.length} 个文件）');
    return;
  }

  stderr.writeln('架构检查未通过，共 ${violations.length} 项：\n');
  for (final v in violations) {
    stderr.writeln('  · $v');
  }
  exit(1);
}

void checkLineCount(String path, int lineCount, List<String> out) {
  if (_lineLimitExemptions.containsKey(path)) return;
  if (lineCount <= _maxLines) return;
  out.add(
    '$path: $lineCount 行，超过 $_maxLines 行上限。拆成更小的文件；'
    '确属单一职责且天然很长时，加进 tool/check_architecture.dart 的 '
    '_lineLimitExemptions 并写明理由。',
  );
}

void checkImports(String path, String content, List<String> out) {
  for (final m in _importPattern.allMatches(content)) {
    final imp = m.group(1)!;
    final line = lineOf(content, m.start);

    final forbiddenReason = _forbiddenImports[imp];
    if (forbiddenReason != null) {
      out.add('$path:$line: 禁止 import $imp —— $forbiddenReason');
    }

    for (final (source, forbidden, reason) in _layerRules) {
      if (path.startsWith(source) && imp.startsWith(forbidden)) {
        out.add('$path:$line: $source 不得 import $imp —— $reason');
      }
    }
  }
}

void checkSingleResponsibility(String path, String content, List<String> out) {
  if (_illegalPartPattern.hasMatch(content)) {
    out.add(
      '$path: 出现手写的 part / part of。一个文件只讲一件事；'
      '只有代码生成的 *.g.dart / *.freezed.dart 允许用 part。',
    );
  }

  // 一个文件一个 public class——但 sealed union 家族例外：
  // Dart 3 的 sealed class 与各变体本就应该同文件（封闭家族，不是上帝类）。
  final publicClasses = _classPattern
      .allMatches(content)
      .map((m) => m.group(1)!)
      .where((name) => !name.startsWith('_'))
      .toList();
  if (_sealedPattern.hasMatch(content)) return;

  // 界面层严格执行：一个文件一个组件。这正是"练习页 1379 行"要防的事。
  // 非界面层放宽到 3 个：紧密相关的小 DTO（如看板的四个统计行）同文件更好读，
  // 硬拆成一堆几行的碎片文件反而增加跳转成本。上限仍防止上帝类。
  final limit = isUiLayer(path) ? 1 : _maxPublicClassesPerDataFile;
  if (publicClasses.length > limit) {
    out.add(
      '$path: 有 ${publicClasses.length} 个 public class（${publicClasses.join(', ')}），'
      '上限 $limit。${limit == 1 ? '一个文件一个组件；第二个想 public 就必须搬到自己文件里。' : '超过上限说明这个文件承担了不止一件事，该拆了。'}',
    );
  }
}

/// 界面层 = 页面与共享组件。这两层恒为"一个文件一个组件"。
bool isUiLayer(String path) =>
    path.startsWith('lib/pages/') || path.startsWith('lib/widgets/');

void checkPageIsolation(String path, String content, List<String> out) {
  final self = _pageModulePathPattern.firstMatch(path)?.group(1);
  if (self == null) return;

  for (final m in _importPattern.allMatches(content)) {
    final imp = m.group(1)!;
    if (imp == _pagesBarrelImport) {
      out.add(
        '$path:${lineOf(content, m.start)}: 模块内不得 import pages 桶。'
        'pages 桶导出全部页面，引它等于把整圈拉进来，模块隔离立刻失效。'
        '模块之间要复用就上提到 widgets/ 或 state/。',
      );
      continue;
    }
    final target = _pageModuleImportPattern.firstMatch(imp)?.group(1);
    if (target != null && target != self) {
      out.add(
        '$path:${lineOf(content, m.start)}: 跨模块 import（$self → $target）。'
        '跨模块复用的组件必须上提到 widgets/ 或 state/，否则就是下一个 1379 行。',
      );
    }
  }
}

/// 字重白名单：只允许 400 与 700（见 _illegalFontWeightPattern 的说明）。
void checkFontWeight(String path, String content, List<String> out) {
  if (_fontWeightExemptPaths.contains(path)) return;
  for (final m in _illegalFontWeightPattern.allMatches(content)) {
    out.add(
      '$path:${lineOf(content, m.start)}: ${m[0]} —— 中文字体只有 400/700 两档，'
      '其余字重会被引擎合成伪粗体且结果不一致。改用 FontWeight.w400 或 w700。',
    );
  }
}

int lineOf(String content, int offset) =>
    '\n'.allMatches(content.substring(0, offset)).length + 1;
