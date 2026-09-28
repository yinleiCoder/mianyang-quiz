// pages 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/pages/pages.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。
//
// 只导出各模块**顶层**的文件（页面与流程入口）。
// 模块私有组件与私有状态机在 pages/<模块>/widgets|state/ 下，
// 按设计不导出：既避免跨模块误用，也避免不同模块的同名组件撞车。

library pages;

export 'ai/ai_page.dart';
export 'analytics/my_standing_page.dart';
export 'analytics/paper_analysis_page.dart';
export 'analytics/paper_leaderboard_page.dart';
export 'auth/email_verify_page.dart';
export 'auth/forgot_password_page.dart';
export 'auth/login_page.dart';
export 'auth/register_page.dart';
export 'bank/bank_page.dart';
export 'bank/question_detail_page.dart';
export 'compose/compose_page.dart';
export 'compose/start_practice_flow.dart';
export 'exam/exam_list_page.dart';
export 'exam/exam_page.dart';
export 'exam/exam_result_page.dart';
export 'home/home_page.dart';
export 'materials/material_viewer_page.dart';
export 'materials/materials_page.dart';
export 'practice/practice_page.dart';
export 'practice/practice_result_page.dart';
export 'practice/recite_entry.dart';
export 'practice/recite_page.dart';
export 'profile/change_password_page.dart';
export 'profile/edit_profile_page.dart';
export 'profile/feedback_page.dart';
export 'profile/profile_page.dart';
export 'records/records_page.dart';
export 'records/session_review_page.dart';
export 'shell/app_shell.dart';
