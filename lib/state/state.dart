// state 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/state/state.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library state;

export 'auth_store.dart';
export 'dashboard_store.dart';
export 'favorite_store.dart';
export 'practice_draft_store.dart';
export 'practice_entry.dart';
export 'practice_mode.dart';
