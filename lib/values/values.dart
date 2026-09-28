// values 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/values/values.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library values;

export 'app_metrics.dart';
export 'app_navigation_bar_theme.dart';
export 'app_text_styles.dart';
export 'app_theme.dart';
export 'difficulty_meta.dart';
export 'env.dart';
export 'feedback_meta.dart';
export 'identity_meta.dart';
export 'material_meta.dart';
export 'qtype_meta.dart';
export 'report_meta.dart';
export 'semantic_colors.dart';
export 'share_links.dart';
