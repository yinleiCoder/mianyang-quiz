// entity 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/entity/entity.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library entity;

export 'block.dart';
export 'forgetting_curve.dart';
export 'exam_answer.dart';
export 'exam_attempt.dart';
export 'exam_paper.dart';
export 'exam_records.dart';
export 'leaderboard_entry.dart';
export 'leaderboard_stats.dart';
export 'material_brief.dart';
export 'material_filter.dart';
export 'option_stats.dart';
export 'oss_sign_result.dart';
export 'paper_brief.dart';
export 'paper_leaderboard.dart';
export 'paper_question_stats.dart';
export 'practice_dashboard.dart';
export 'practice_results.dart';
export 'practice_session.dart';
export 'profile.dart';
export 'question_brief.dart';
export 'question_content.dart';
export 'question_filter.dart';
export 'question_option.dart';
export 'question_report.dart';
export 'question_row.dart';
export 'question_stats.dart';
export 'question_tag.dart';
export 'recent_answer.dart';
export 'school.dart';
export 'school_class.dart';
export 'server_answer.dart';
export 'session_record.dart';
export 'start_outcome.dart';
export 'sub_question.dart';
export 'subject_node.dart';
