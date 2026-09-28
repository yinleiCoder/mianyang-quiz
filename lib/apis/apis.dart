// apis 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/apis/apis.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library apis;

export 'analytics_repository.dart';
export 'app_update_repository.dart';
export 'auth_refresh_client.dart';
export 'auth_service.dart';
export 'crash_reporter.dart';
export 'exam_draft_service.dart';
export 'favorite_repository.dart';
export 'feedback_repository.dart';
export 'list_repository.dart';
export 'material_download_service.dart';
export 'material_repository.dart';
export 'oss_upload_service.dart';
export 'paper_repository.dart';
export 'password_repository.dart';
export 'pdf_cjk_font.dart';
export 'practice_repository.dart';
export 'question_credits.dart';
export 'question_enricher.dart';
export 'question_pdf_service.dart';
export 'question_report_repository.dart';
export 'question_repository.dart';
export 'sfx_service.dart';
export 'stats_repository.dart';
export 'subject_repository.dart';
export 'user_repository.dart';
