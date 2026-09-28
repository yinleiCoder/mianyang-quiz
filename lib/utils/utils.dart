// utils 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/utils/utils.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library utils;

export 'answer_grader.dart';
export 'app_exception.dart';
export 'app_version.dart';
export 'async_value.dart';
export 'error_mapper.dart';
export 'formatters.dart';
export 'like_escape.dart';
export 'node_accuracy.dart';
export 'option_order.dart';
export 'oss_url.dart';
export 'phone.dart';
export 'subject_tree.dart';
export 'submitted_answer.dart';
